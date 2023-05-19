require 'rails_helper'

RSpec.describe Glossary, type: :model do
  let(:list_of_permitted_codes) { %w[en by pl] }
  let(:params) do
    { source_language_code: list_of_permitted_codes.first, target_language_code: list_of_permitted_codes.last }
  end

  before { allow(CSV).to receive_message_chain(:parse, :by_col, :[]).and_return(list_of_permitted_codes) }

  it 'is valid with valid attributes' do
    expect(described_class.new(params)).to be_valid
  end

  it 'is not valid without a source_language_code' do
    expect(described_class.new(params.except(:source_language_code))).not_to be_valid
  end

  it 'is not valid without a target_language_code' do
    expect(described_class.new(params.except(:target_language_code))).not_to be_valid
  end

  it 'is not valid with invalid source_language_code' do
    expect(described_class.new(params.merge(source_language_code: 'Invalid'))).not_to be_valid
  end

  it 'is not valid with invalid target_language_code' do
    expect(described_class.new(params.merge(target_language_code: 'Invalid'))).not_to be_valid
  end

  it 'is not valid when source and target language codes pair are already exists' do
    create(:glossary, params)
    expect(described_class.new(params)).to_not be_valid
  end
end
