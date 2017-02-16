require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
# require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
require "sprockets/railtie"
require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module EmployeeManagement
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    Mongoid.load!("#{Rails.root}/config/mongoid.yml")

    if Rails.env.development? || Rails.env.test?
      config.autoload_paths += %W(#{config.root}/lib/employee_management)
    end

    if Rails.env.production?
      config.eager_load_paths += %W(#{config.root}/lib/employee_management)
    end
  end
end
