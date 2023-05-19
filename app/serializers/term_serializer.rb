class TermSerializer < JSONAPI::Serializable::Resource
  type :terms
  attributes :source_term, :target_term
end
