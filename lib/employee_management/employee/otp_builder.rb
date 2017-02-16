class Employee::OtpBuilder

  def initialize(attributes = {})
    @employee = attributes[:employee]
  end

  def generate_otp
    @employee.set_otp_code
    @employee.save

    send_otp_code(@employee.otp_code)

    true
  end

  private

  def send_otp_code(code)
    sms_msg = "Hey #{@employee.name}, #{code} is the OTP to validate your phone number."
    ::TxtLocal::TransactionalService.new.send_sms!(sms_msg, @employee.phone_number)
  end
end
