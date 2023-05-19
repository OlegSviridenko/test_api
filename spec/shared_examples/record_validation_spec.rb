# frozen_string_literal: true

shared_examples_for 'not valid without' do |params, param|
  it "not valid without #{params}" do
    expect(described_class.new(params.except(params))).to_not be_valid
  end
end
