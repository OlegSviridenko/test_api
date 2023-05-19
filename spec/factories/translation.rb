FactoryBot.define do
  factory :translation, class: Translation do
    source_language_code { 'en' }
    target_language_code { 'pl' }
  end
end
