class AdminController < ApplicationController
  layout 'admin'
  before_filter :check_is_logged_in
  private
  def check_is_logged_in
    
  end
end
