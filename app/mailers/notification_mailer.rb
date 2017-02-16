class NotificationMailer < ActionMailer::Base

  def verify_email(params)
    @employee = Employee.find(params[:id])

    mail(to: @employee.email,
         from: "Employee Managemet<manager.employeeapp@gmail.com>",
         subject: 'Confirm your email')
  end
end
