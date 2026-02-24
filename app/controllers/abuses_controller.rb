class AbusesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_reportable

  def create
    @abuse_report = Abuse.new(abuse_reason_params, reporter: current_user, reportable: @reportable)

    if @abuse_report.save
      redirect_back fallback_location: root_path, notice: "Reported successfully."
    else
      redirect_back fallback_location: root_path, alert: @abuse_report.errors.full_messages.to_sentence
    end
  end

  private def set_reportable
    @reportable = if params[:comment_id]
      Comment.find(params[:comment_id])
    elsif params[:answer_id]
      Answer.find(params[:answer_id])
    elsif params[:question_url]
      Question.find_by!(url: params[:question_url])
    else
      raise "No reportable found"
    end
  end

  private def abuse_reason_params
    params.require(:abuse).permit(:reason)
  end
end
