class CreateTimelines < ActiveRecord::Migration
  def change
    create_table :timelines do |t|
      t.string :hashtag

      t.timestamps
    end
  end
end
