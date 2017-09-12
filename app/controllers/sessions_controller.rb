# -*- coding:utf-8 -*-
class SessionsController < ApplicationController
  def callback
p "sessions.callback"
    begin
      auth = request.env["omniauth.auth"]
      user = User.find_by_provider_and_uid(auth["provider"], auth["uid"]) || User.create_with_omniauth(auth)
      session[:user_id] = user.id
    rescue ActiveRecord::RecordInvalid
#      reset_session
      flash[:notice] = "login failed (既に名前が存在します)"
    else
      flash[:notice] = "login succeeded"
    ensure
      redirect_to root_url
    end

  end

  def destroy
p "sessions.destroy"
    session[:user_id] = nil
    redirect_to root_url, :notice => "logout succeeded"
  end

end
