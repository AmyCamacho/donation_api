class CreateDonations < ActiveRecord::Migration[7.0]
  def change
    create_table :donations do |t|
      t.decimal :amount
      t.integer :payment_method
      t.string :email
      t.text :user_agent
      t.string :ip_address
      t.belongs_to :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
