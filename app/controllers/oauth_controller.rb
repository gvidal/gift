class OauthController < PublicController
  def redirect
    session[:access_token] = Koala::Facebook::OAuth.new("http://dev-machine.com:3000/").get_access_token(params[:code]) if params[:code]
     
    raise StandardError, "aa" unless session[:access_token]
#    redirect_to session[:access_token] ? success_path : failure_path
  end
end
