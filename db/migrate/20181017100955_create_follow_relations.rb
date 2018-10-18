class CreateFollowRelations < ActiveRecord::Migration[5.0]
  def change
    create_table :follow_relations do |t|
      t.references :user, foreign_key: true
      t.references :follow, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
