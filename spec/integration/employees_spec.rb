require "rails_helper"

RSpec.describe 'Employees Controller', type: :request do

  before do
    host! 'localhose:3000'

    allow_any_instance_of(::TxtLocal::TransactionalService).to receive(:send_sms!).and_return(:true)
    allow_any_instance_of(::NotificationMailer).to receive(:verify_email).and_return(:true)
  end

  describe 'GET#new' do
    it 'responds with sucuess' do
      get '/employees/new'

      expect(response.status).to eq(200)
    end
  end

  describe 'POST#create' do
    describe 'with all valid attributes' do
      before do
        post '/employees',{
          params: {
            employee: {
              "name" => "test employee",
              "email" => "test@testing.com",
              "phone_number" => "9123456789",
              "gender" => "male",
              "location" => "bangalore",
              "birthday(1i)" => "2017",
              "birthday(2i)" => "2",
              "birthday(3i)" => "17"
            }
          }
        }
      end

        it 'responds with success' do
          expect(response.status).to eq(302)
        end

        it 'creates a beacon' do
          employee = Employee.where(email: "test@testing.com").first

          expect(employee).to be_present
          expect(response).to redirect_to(employee_url(employee))
          expect(flash[:notice]).to be_present
        end
    end

    describe 'with invalid attributes' do
      it 'render new template' do
        post '/employees',{
          params: {
            employee: {
              "name" => "test employee",
              "email" => "invalid",
              "phone_number" => "invalid",
              "gender" => "male",
              "location" => "bangalore",
              "birthday(1i)" => "2017",
              "birthday(2i)" => "2",
              "birthday(3i)" => "17"
            }
          }
        }

        expect(response.status).to eq(200)
      end
    end
  end

  describe 'GET#edit' do
    before do
      @employee = create(:employee)
    end

    it 'responds with sucuess' do
      get "/employees/#{@employee.id}/edit"

      expect(response.status).to eq(200)
    end
  end

  describe 'PUT#Update' do
    before do
      @employee = create(:employee)
    end

    describe 'update employee details' do
      before do
        put "/employees/#{@employee.id}",{
          params: {
            employee: {
              "name" => "test employee",
              "email" => "name_changed@testing.com",
              "phone_number" => "9123456789",
              "gender" => "male",
              "location" => "bangalore",
              "birthday(1i)" => "2017",
              "birthday(2i)" => "2",
              "birthday(3i)" => "17"
            }
          }
        }
      end

        it 'responds with success' do
          expect(response.status).to eq(302)
        end

        it 'creates a beacon' do
          employee = Employee.where(email: "name_changed@testing.com").first

          expect(employee).to be_present
          expect(response).to redirect_to(employee_url(employee))
        end
    end
  end

  describe 'GET#confirm_email' do
    before do
      @employee = create(:employee, email_verified: false)
    end

    describe 'when email not verified' do
      it 'verify email' do
        get "/employees/#{@employee.confirmation_token}/confirm_email"

        expect(@employee.reload.email_verified).to be_truthy
        expect(flash[:notice]).to be_present
      end
    end

    describe 'when email already verified' do
      it 'render show page with notice' do
        employee = create(:employee, email_verified: true)

        get "/employees/#{@employee.confirmation_token}/confirm_email"

        expect(@employee.reload.email_verified).to be_truthy
        expect(flash[:notice]).to be_present
      end
    end
  end

  describe 'GET#confirm_phone_number' do
    before do
      @employee = create(:employee, email: "test_otp@gmail.com", phone_number_verified: false)
    end

    describe 'with valid OTP' do
      it 'verifies phone_number' do
        otp_code = Employee.where(email: "test_otp@gmail.com").first.otp_code

        post "/employees/#{@employee.id}/confirm_phone_number", {
          params: {
            otp: otp_code
          }
        }

        expect(@employee.reload.phone_number_verified).to be_truthy
        expect(flash[:notice]).to be_present
      end
    end
  end
end
