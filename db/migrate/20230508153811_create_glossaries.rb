class CreateGlossaries < ActiveRecord::Migration[7.1]
  def change
    create_table :glossaries do |t|
      t.string :source_language_code
      t.string :target_language_code

      # Add datetime of last added term to glossary, for check is translation source text
      # should be updated with new added terms
      t.datetime :terms_changed_at

      t.index %i[source_language_code target_language_code], unique: true
      t.timestamps
    end
  end
end
