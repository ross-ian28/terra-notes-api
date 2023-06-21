class CreateDocs < ActiveRecord::Migration[7.0]
  def change
    create_table :docs do |t|
      t.references :user, foreign_key: true
      t.string :password_digest

      t.timestamps
    end
  end
end
