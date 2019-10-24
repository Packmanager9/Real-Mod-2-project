class AuthController < ApplicationController
    def signin
    end
    def verify
        # byebug
        @god = God.find_by(name: params[:auth][:name])
        if @god
            session[:god_id] = @god.id
            redirect_to worlds_path
        else
           flash[:message] = "Incorrect Info, please try again."
            render :signin
        end
    end
    def logout
        session.clear
        redirect_to login_path
    end
 end