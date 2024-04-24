class ApplicationController < ActionController::Base
  before_action :read_config

  def authenticate_user
    if session[:user_id]
      @current_user = User.find(session[:user_id])
      return true
    else
      redirect_to("/")
      return false
    end
  end
  def save_login_state
    if session[:user_id]
      redirect_to("/home")
      return false
    else
      return true
    end
  end

  private
  def read_config
    config = "./config/webansible.conf"
    vars = {"work_dir" => "/home/ansible", "port" => "3000", "api_zabbix" => "", "api_passwd" => ""}
    if File.file? config
      File.open(config, "r") do |f|
        f.each_line do |line|
          unless line.empty?
            var = line.split('=')
            if var[1][-2] == "/"
              var[1].chomp!
              var[1].chop!
            else
              var[1].chomp!
            end
            key = var[0]
            var.shift
            value = var.join("=")
            @crypt = ActiveSupport::MessageEncryptor.new(Rails.application.secrets.secret_key_base[0..31])
            if key == "api_zabbix" || key == "api_passwd"
              value.chop!
              decrypted_token = @crypt.decrypt_and_verify(value)
              vars[key] = decrypted_token
            else
              vars[key] = value
            end
          end
        end
      end
    else
      f = File.new(config, "a:UTF-8")
      vars.each do |key,value|
        f.print(key + "=" + value + "\n")
      end
      f.close
    end
    @work_dir = vars["work_dir"]
    unless Dir.exist?(@work_dir)
      FileUtils.mkdir_p(@work_dir)
    end
    @port = vars["port"]
    @api_zabbix = vars["api_zabbix"]
    @api_passwd = vars["api_passwd"]
  end
end
