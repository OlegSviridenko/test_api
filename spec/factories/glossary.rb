FactoryBot.define do
  factory :glossary, class: Glossary do
    source_language_code { 'en' }
    target_language_code { 'pl' }
  end
end
