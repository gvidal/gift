class AuthenticationsController < PublicController
  def index
    @current_user = User.new unless @current_user
    @authentications =  @current_user.authentications if @current_user  
  end  
    
  def create
    omniauth = request.env["omniauth.auth"]  
    authentication = Authentication.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'])
    session["uid"] = omniauth["uid"] 
    session["provider"] = omniauth["provider"]
    if authentication
      authentication.user.set_current_token(omniauth)
      authentication.save
      redirect_to :back, :notice => "Logged in successfully"
    else  
      user = User.new
      user.set_current_token(omniauth)
      user.apply_omniauth(omniauth)
      if user.save
        redirect :back, :notice => "Logged in successfully"
      else  
        redirect :back, :error => "Logged in error"
      end
    end
  end  
    
  def destroy
    @authentication = @current_user.authentications.find(params[:id])  
    @authentication.destroy  
    flash[:notice] = "Successfully destroyed authentication."  
    redirect_to authentications_url  
  end  
end
