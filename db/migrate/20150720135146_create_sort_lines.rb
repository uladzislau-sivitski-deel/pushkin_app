class CreateSortLines < ActiveRecord::Migration
  def change
    create_table :sortlines do |t|
      t.string :title
      t.text :content

      t.timestamps
    end
  end
end
