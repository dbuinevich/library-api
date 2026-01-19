class CreateBorrowHistories < ActiveRecord::Migration[8.1]
  def change
    create_table :borrow_histories do |t|
      t.references :book, null: false, foreign_key: true
      t.references :reader, null: false, foreign_key: true

      t.datetime :borrowed_at, null: false
      t.datetime :returned_at

      t.timestamps
    end

    add_index :borrow_histories, :borrowed_at
    add_index :borrow_histories, :returned_at
  end
end
