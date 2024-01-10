class SettingsController < ApplicationController
  before_action :authenticate_user

  def app_settings
    render "home/settings/app_settings"
  end
  def integration
    render "home/settings/integration"
  end
  def general
    render "home/settings/_general"
  end
  def settings_apply
    
  end
end
