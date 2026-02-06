class RemoveDefaultStatusFromAnswers < ActiveRecord::Migration[8.1]
  def change
    change_column_default :answers, :status, from: 0, to: nil
  end
end
