class UsersController < ApplicationController

  def show 
  	User.find(params[:id])
  end
  def new
	@title = "SignUp"

  end

end
