class CreateSearches < ActiveRecord::Migration[5.1]
  def change
    create_table :searches do |t|
      t.string :email
      t.date :date
      t.jsonb :search_params, null: false, default: '{}'

      t.timestamps
    end
  end
end
