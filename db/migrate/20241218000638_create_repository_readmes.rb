class CreateRepositoryReadmes < ActiveRecord::Migration[8.0]
  def change
    create_table :repository_readmes do |t|
      t.text :content
      t.datetime :fetched_at

      t.timestamps
    end
  end
end
