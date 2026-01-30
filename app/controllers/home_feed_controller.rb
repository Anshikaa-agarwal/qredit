class HomeFeedController < ApplicationController
    before_action :set_current_user

    def index
        @questions = Question.all
    end

    private def set_current_user
        @user = current_user
    end
end
