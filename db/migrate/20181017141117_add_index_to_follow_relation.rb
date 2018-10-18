class AddIndexToFollowRelation < ActiveRecord::Migration[5.0]
  def change
    add_index :follow_relations , [:user_id, :follow_id], unique: true
  end
end
