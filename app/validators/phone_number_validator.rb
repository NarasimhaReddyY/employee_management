class PhoneNumberValidator < ActiveModel::EachValidator

  def validate_each(record, attribute, value)
    return if value.blank?
    unless value =~ /\A[1-9]{1}?[0-9]{9}\z/
      record.errors[attribute] << (options[:message] || "is invalid")
    end
  end

  def self.kind; :custom end

end
