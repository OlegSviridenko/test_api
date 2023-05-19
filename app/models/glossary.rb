class Glossary < ApplicationRecord
  include IsoLanguageCodesValidator

  has_many :terms, dependent: :destroy

  validates :source_language_code, uniqueness: { scope: :target_language_code }
end
