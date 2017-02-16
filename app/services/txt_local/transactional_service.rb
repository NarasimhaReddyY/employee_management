class TxtLocal::TransactionalService  < TxtLocal::BaseService

  def send_sms!(message, number)
    handle_response do
      uri = URI.parse(API_ENDPOINTS[:send_sms])

      Net::HTTP.post_form(uri, username: USER_NAME,
                               hash: API_HASH,
                               message: message,
                               sender: SENDER_NAME,
                               numbers: number)
    end
  end

  private

  API_ENDPOINTS = {
    send_sms: 'http://api.textlocal.in/send/?'
  }

  USER_NAME   = Rails.application.secrets[:sms]['trxn']['user_name']
  API_HASH    = Rails.application.secrets[:sms]['trxn']['api_hash']
  SENDER_NAME = Rails.application.secrets[:sms]['trxn']['sender_name']

end
