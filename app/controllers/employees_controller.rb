class EmployeesController < ApplicationController

  before_action :set_birthday, only: [:create, :update]

  def new
    @employee = Employee.new
  end

  def create
    @employee = Employee.new(employee_params.merge(birthday: @birthday))

    if @employee.save
      redirect_to employee_url(@employee), notice: "You have registered, Please verify contact details"
    else
      render :new
    end
  end

  def edit
    @employee = Employee.find(params[:id])
  end

  def update
    @employee = Employee.find(params[:id])

    if @employee.update(employee_params)
      redirect_to employee_url(@employee)
    else
      render :new
    end
  end

  def show
    @employee = Employee.find(params[:id])
  end

  def confirm_email
    @employee = Employee.find_by(confirmation_token: params[:id])

    if @employee && !@employee.email_verified
       @employee.set_email_verified

      redirect_to employee_url(@employee), notice: 'Email Verified. Thank you'
    else
      redirect_to employee_url(@employee), notice: "Email Already Verified"
    end
  rescue Mongoid::Errors::DocumentNotFound => ex
    raise Errors::InvalidLink
  end

  def verify_phone_number
    @employee = Employee.find(params[:id])
  end

  def confirm_phone_number
    @employee = Employee.find(params[:id])

    if @employee.validate_otp_code(params[:otp])
       @employee.set_phone_number_verified

     redirect_to employee_url(@employee), notice: 'Your Phone Number Verified. Thank you'
    else
      render :verify_phone_number, notice: 'invalid OTP'
    end
  end

  private

  def employee_params
    params.require(:employee).permit(:name,
                                     :email,
                                     :phone_number,
                                     :gender,
                                     :location)
  end

  def set_birthday
    @birthday = Date.new(params[:employee]["birthday(1i)"].to_i,
                         params[:employee]["birthday(2i)"].to_i,
                         params[:employee]["birthday(3i)"].to_i)
  end

end
