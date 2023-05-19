class Translation < ApplicationRecord
  include IsoLanguageCodesValidator

  MARKING_OPEN_TAG = '<HIGHLIGHT>'.freeze
  MARKING_CLOSE_TAG = '</HIGHLIGHT>'.freeze

  validates :source_text, presence: true
end
