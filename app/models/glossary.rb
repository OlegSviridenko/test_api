class Glossary < ApplicationRecord
  validates :source_code_language, presence: true, uniqueness: true
  validates :source_code_language, presence: true, uniqueness: true

  has_many :term
end
