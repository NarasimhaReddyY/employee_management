class Employee
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :email, type: String
  field :birthday, type: Date
  field :gender, type: String
  field :location, type: String
  field :phone_number, type: String
  field :email_verified, type: Boolean, default: false
  field :phone_number_verified, type: Boolean, default: false
  field :confirmation_token, type: String
  field :otp_code, type: String

  validates :name, :email, :phone_number, :gender, presence: true

  validates :email, email: true
  validates :phone_number, phone_number: true

  before_save :set_confirmation_token, if:-> { self.email_changed? }
  after_save :verify_contact_details

  def set_confirmation_token
    encoded_timestamp       = Base64.encode64(DateTime.now.to_s).gsub(/(=)/, '').gsub(/\n/, '')
    self.confirmation_token = SecureRandom.uuid.concat(encoded_email).concat(encoded_timestamp).gsub(/\n/, '')
  end

  #Generating a unique OTP.
  #By combining a random number with time last 4 digits of time stamps
  def set_otp_code
    otp = SecureRandom.random_number(100) + (Time.now.to_i % 10000)
    self.set(otp_code: otp.to_s)
  end

  def validate_otp_code(code)
    return (self.otp_code.to_i == code.to_i)
  end

  def verify_contact_details
    verify_email if self.email_changed?
    verify_phone_number if self.phone_number_changed?
  end

  #unsetting verified if email changed while updating employee
  #this should be done in background jobs. But lack of time i am doing in callsbacks.
  #TODO move this code to background jobs

  def verify_email
    self.set(email_verified: false)
    ::NotificationMailer.verify_email(id: self.id).deliver
  end

  #Unsetting verified if email changed while updating employee
  #This should be done in background jobs. But lack of time i am doing in callbacks.
  #TODO move this code to background jobs

  def verify_phone_number
    self.set(phone_number_verified: false)
    set_otp_code

    sms_msg = "Hey #{self.name}, #{self.otp_code.to_i} is the OTP to validate your phone number.".freeze
    ::TxtLocal::TransactionalService.new.send_sms!(sms_msg, self.phone_number)
  end

  def set_email_verified
    self.set(email_verified: true)
  end

  def set_phone_number_verified
    self.set(phone_number_verified: true)
  end

  private

  def encoded_email
    @encoded_email ||= Base64.encode64(self.email).gsub(/(=)/, '').gsub(/\n/, '')
  end
end
