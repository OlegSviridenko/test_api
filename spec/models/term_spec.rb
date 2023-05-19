require 'rails_helper'

RSpec.describe Term, type: :model do
  let(:glossary) { build(:glossary, id: 1) }
  let(:params) { { source_term: Faker::Alphanumeric.alpha, target_term: Faker::Alphanumeric.alpha, glossary: } }

  it 'is valid with valid attributes' do
    expect(described_class.new(params)).to be_valid
  end

  it 'is not valid without a target_term' do
    expect(described_class.new(params.except(:target_term))).not_to be_valid
  end

  it 'is not valid without a source_term' do
    expect(described_class.new(params.except(:source_term))).not_to be_valid
  end

  it 'is not valid without a glossary' do
    expect(described_class.new(params.except(:glossary))).not_to be_valid
  end
end
