class AuthenticationController < ApplicationController

	skip_before_action :authenticate

	def login
		@user = User.find_by(email: params[:email])
		if @user&.authenticate(params[:password])
			token = jwt_encode(user_id: @user.id)
			time = (Time.now + 24.hours)
			render json: {
				token: token,
				exp: time.strftime("%m-%d-%Y %H:%M"),
				username: @user.username
			}, status: :ok
		else
			render json: {error: 'unauthorized'}, status: :unauthorized
		end
	end

end
