class CreateDocuments < ActiveRecord::Migration[8.0]
  def change
    create_table :documents do |t|
      t.string :title
      t.string :url, null: false, index: { unique: true }
      t.text :description
      t.string :contributor
      t.string :contributor_type

      t.timestamps
    end
  end
end
