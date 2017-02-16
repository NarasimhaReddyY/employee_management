class BirthdayValidator < ActiveModel::EachValidator

  def validate_each(record, attribute, value)
    return if value.blank?

    unless Date.parse(value) && value =~ /\A[0-3]{1}[0-9]{1}\/[0-1]{1}[0-9]{1}\/[1-3]{1}[0-9]{3}\z/
      record.errors[attribute] <<  message
    end
  rescue ArgumentError
      record.errors[attribute] << message
  end

  def self.kind; :custom end

  private

  def message
    "is invalid or should be in dd/mm/yyyy".freeze
  end
end
