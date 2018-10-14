module SessionsHelper
  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
    #以下の短縮系
    #if @current_user
    #  return @current_user
    #else
    #  @current_user = User.find_by(id: session[:user_id])
    #  session[:user_id]がないならnilが入る
    #  return @current_user
    #end
  end
  
  def logged_in?
    !!current_user
    #current_userあるならtrue,ないならfalse
  end
end
