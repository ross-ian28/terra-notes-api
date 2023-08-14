class CreateNotes < ActiveRecord::Migration[7.0]
  def change
    create_table :notes do |t|
      t.references :user, foreign_key: true, null: false
      t.text :contents, defaul: "", null: false

      t.timestamps
    end
  end
end
