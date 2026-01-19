class CreateBooks < ActiveRecord::Migration[8.1]
  def change
    create_table :books do |t|
      t.integer :serial_number, null: false
      t.string :title, null: false
      t.string :author, null: false

      t.boolean :borrowed, null: false, default: false
      t.datetime :borrowed_at
      t.references :reader, foreign_key: true, null: true

      t.timestamps
    end

    add_index :books, :serial_number, unique: true
  end
end
