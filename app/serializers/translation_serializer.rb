class TranslationSerializer < JSONAPI::Serializable::Resource
  type :translations
  attributes :source_text, :target_language_code, :source_language_code
end
