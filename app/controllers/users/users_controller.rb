class Users::UsersController < ApplicationController


# 未登録でも個展一覧機能と詳細機能は使用可
before_action :authenticate_user!, except: [:index,:show]


	def show
		@user = User.find (params[:id])
		@gallery = Gallery.where(user_id: @user.id)
		@exhibitions = Exhibition.where(user_id: @user.id,is_active: true).order(updated_at: :desc).page(params[:active]).per(6)
		@exhibitions_f = Exhibition.where(user_id: @user.id,is_active: false).order(updated_at: :desc).page(params[:not_active]).per(6)
		# @folders = Folder.where(user_id: @user.id)
		@works = Work.where(user_id: @user.id)
	end

	def index
		@users = User.all.page(params[:page]).per(6)
	end

	def edit
		@user = User.find (params[:id])
		if @user != current_user
			redirect_to root_path
		end
	end

	def update
		@user = User.find (params[:id])
		if @user.update (user_params)
			redirect_to users_user_path(@user.id)
		else
			render 'edit'
		end
	end

	def destroy
		@user = current_user
		@user.destroy
		redirect_to root_path
	end



private
	def user_params
		params.require(:user).permit(:name,:user_image,:introduction)
	end


end
