class ChangeReasonToIntegerInAbuses < ActiveRecord::Migration[8.1]
  def change
    change_column :abuses, :reason, :integer, using: 'reason::integer'
  end
end
