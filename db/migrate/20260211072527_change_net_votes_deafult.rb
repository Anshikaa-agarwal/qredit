class ChangeNetVotesDeafult < ActiveRecord::Migration[8.1]
  def change
    change_column_default :answers, :net_votes, from: nil, to: 0
  end
end
