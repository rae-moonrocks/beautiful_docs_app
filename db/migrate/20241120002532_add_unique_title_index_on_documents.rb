class AddUniqueTitleIndexOnDocuments < ActiveRecord::Migration[8.0]
  def change
    add_index :documents, :title, unique: true
  end
end
