FactoryBot.define do
  factory :term, class: Term do
    source_term { Faker::Alphanumeric.alpha(number: 10) }
    target_term { Faker::Alphanumeric.alpha(number: 10) }
  end
end
