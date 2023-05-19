class GlossarySerializer < JSONAPI::Serializable::Resource
  type :glossaries
  attributes :source_language_code, :target_language_code
  has_many :terms
end
