class CreateMembers < ActiveRecord::Migration[5.1]
  def change
    create_table :members do |t|
      t.string :name
      t.belongs_to :event, foreign_key: true

      t.timestamps
    end
  end
end
