class RenameReportedByInAbuse < ActiveRecord::Migration[8.1]
  def change
    rename_column :abuses, :reported_by_id, :reporter_id
  end
end
