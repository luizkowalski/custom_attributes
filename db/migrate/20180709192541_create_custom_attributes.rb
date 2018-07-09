class CreateCustomAttributes < ActiveRecord::Migration[5.1]
  def change
    create_table :custom_attributes do |t|
      t.references :user, foreign_key: true
      t.references :company, foreign_key: true
      t.string :field_name
      t.string :field_value

      t.timestamps
    end
  end
end
