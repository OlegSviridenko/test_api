require 'active_support/concern'

module IsoLanguageCodesValidator
  extend ActiveSupport::Concern
  include ActiveModel::Validations

  CODES_LIST_KEY = 'codes_list'.freeze
  CODES_LIST_PATH = 'storage/language-codes.csv'.freeze

  included do
    validates :source_language_code, presence: true
    validates :target_language_code, presence: true

    validate :codes_in_iso
  end

  private

  def codes_in_iso
    return if codes_valid?

    errors.add :base, 'Invalid codes'
  end

  def codes_valid?
    return false unless (codes_list = fetch_codes_list).present?
    return false unless source_language_code.in?(codes_list)
    return false unless target_language_code.in?(codes_list)

    true
  end

  def fetch_codes_list
    Rails.cache.fetch(CODES_LIST_KEY) do
      list = read_code_list_from_csv
      Rails.cache.write(CODES_LIST_KEY, list) if list.present?

      list
    end&.split(',')
  end

  # We can store it in DB through data-migrations gem with created Settings model or smth like that, but in this case
  # it will be enough
  def read_code_list_from_csv
    CSV.parse(File.read(CODES_LIST_PATH), headers: true).by_col[0].join(',')
  end
end
