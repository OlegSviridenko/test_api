class Term < ApplicationRecord
  validates :source_term, presence: true
  validates :target_term, presence: true

  belongs_to :glossary
  validates_presence_of :glossary
end
