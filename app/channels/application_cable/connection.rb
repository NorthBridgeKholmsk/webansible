module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      #@current_user = session[:user_id]
    end
  end
end
