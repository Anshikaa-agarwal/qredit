class ProfilesController < ApplicationController
    before_action :authenticate_user!

    def show
        @user = current_user
        @topics = Topic.all
    end

    def edit
    end

    def update
    end
end