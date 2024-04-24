class SettingsController < ApplicationController
  before_action :authenticate_user

  def app_settings
    render "home/settings/app_settings"
  end
  def general
    render "home/settings/_general"
  end
  def settings_apply
    config = "./config/webansible.conf"
    if File.file? config
      File.open(config, "w") do |f|
        params.each do |key, value|
          unless key == "authenticity_token" || key == "commit" || key == "controller" || key == "action"
            if key == "api_zabbix" || key == "api_passwd"
              encrypted_token = @crypt.encrypt_and_sign(value)
              f.print(key + "=" + encrypted_token + "\n")
            else
              f.print(key + "=" + value + "\n")
            end
          end
        end
        f.close
      end
    end
  end
end
