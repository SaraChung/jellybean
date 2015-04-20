class CreateReplies < ActiveRecord::Migration
  def change
    create_table :replies do |t|
      t.string   "content"
	    t.integer  "comment_id"
	    t.string   "name"

      t.timestamps null: false
    end
  end
end
