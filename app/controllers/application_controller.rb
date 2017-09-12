class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :set_locale, :set_page_info

  helper_method :menu_item
  helper_method :current_user
  def error_404(e=nil)
    render :template => 'shared/error_404', :status => 404
  end
  def current_user
#p "application.current_user"
    begin
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
    rescue ActiveRecord::RecordNotFound
      reset_session
    end
  end

  private
  def set_page_info
    if params.key?("page")
      session[:page] = params["page"]
      if params["controller"] == "users"
        session[:users_page] = params["page"]
      elsif params["controller"] == "strategies"
        session[:strategies_page] = params["page"]
      end
    else
      session[:page] = "1"
      if params["controller"] == "users"
        session[:users_page] = "1"
      elsif params["controller"] == "strategies"
        session[:strategies_page] = "1"
      end
    end
    if params.key?("user_id")
      session[:user] = params["user_id"]
    end
  end

  def menu_item
    return request.params["controller"], request.params["action"]
  end
  def set_locale
    loc = params["locale"]
    if loc
      if (loc == "ja") || (loc == "en")
        I18n.locale = loc
      else
        I18n.locale = "ja"
      end
    else
      I18n.locale = "ja"
    end
  end
end
