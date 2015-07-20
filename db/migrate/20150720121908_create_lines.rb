class CreateLines < ActiveRecord::Migration
   def change
      create_table :lines do |t|
      t.string :title
      t.text :content

      t.timestamps
    end
  end
end
