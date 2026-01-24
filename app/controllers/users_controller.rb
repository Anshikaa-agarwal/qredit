class UsersController < ApplicationController
    def index
        @users = User.all
    end

    def new
        @user = User.new
    end

    def create
    end

    def edit
    end

    def update
    end

    def show
    end

    def destroy
    end
end