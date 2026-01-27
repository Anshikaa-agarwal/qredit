class ProfilesController < ApplicationController
    before_action :authenticate_user!

    def show
        @user = current_user
        @remaining_topics = Topic.all - @user.topics
    end

    def edit
    end

    def update
        p params
    end
end
