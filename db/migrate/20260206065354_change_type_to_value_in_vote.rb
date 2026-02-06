class ChangeTypeToValueInVote < ActiveRecord::Migration[8.1]
  def change
    rename_column :votes, :type, :value
  end
end
