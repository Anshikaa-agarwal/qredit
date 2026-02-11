class AddNetVotesToAnswer < ActiveRecord::Migration[8.1]
  def change
    add_column :answers, :net_votes, :integer
  end
end
