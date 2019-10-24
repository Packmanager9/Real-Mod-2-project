class ApplicationController < ActionController::Base
    helper_method :logged_in?
    def logged_in?
        !!session[:god_id]
    end
    def redirect_god
        if !logged_in?
            redirect_to login_path
        end
    end

end
