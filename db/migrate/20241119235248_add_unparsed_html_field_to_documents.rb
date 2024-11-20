class AddUnparsedHtmlFieldToDocuments < ActiveRecord::Migration[8.0]
  def change
    add_column :documents, :unparsed_html, :text
  end
end
