class CreateTranslations < ActiveRecord::Migration[7.1]
  def change
    create_table :translations do |t|
      t.string :source_language_code
      t.string :target_language_code
      t.text :source_text

      # Add marker for detection last translation text terms marking
      t.datetime :terms_marked_at, default: -> { 'CURRENT_TIMESTAMP' }, null: false
      t.timestamps
    end
  end
end
