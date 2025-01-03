class ChangeExpiresInToBigInt < ActiveRecord::Migration[8.0]
  def change
    change_column :oauth_access_tokens, :expires_in, :bigint
  end
end
