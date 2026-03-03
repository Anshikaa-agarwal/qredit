class Admin::DashboardController < Admin::BaseController
  def index
    @questions_by_topic = Question.joins(:topics).group("topics.name").count
    @questions_by_week_day = Question.group_by_day_of_week(:created_at, format: "%a").count
    @user_by_date = User.group("DATE(created_at)").count
    @popular_plans = CreditPurchase.group(:amount, :unit).count
  end
end
