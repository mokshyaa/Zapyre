# frozen_string_literal: true

class AddOauthFieldsToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :provider, :string
    add_column :users, :uid, :string
  end
end
