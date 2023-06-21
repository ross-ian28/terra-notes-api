class CreateNotes < ActiveRecord::Migration[7.0]
  def change
    create_table :notes do |t|
      t.references :user, foreign_key: true
      t.text :contents

      t.timestamps
    end
  end
end
