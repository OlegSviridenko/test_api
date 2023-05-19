require 'rails_helper'

describe GlossariesController, type: :request do
  let(:list_of_permitted_codes) { %w[en by pl] }
  before { allow(CSV).to receive_message_chain(:parse, :by_col, :[]).and_return(list_of_permitted_codes) }

  let(:glossary1) do
    create(
      :glossary,
      source_language_code: list_of_permitted_codes.first,
      target_language_code: list_of_permitted_codes.last
    )
  end

  let(:glossary2) do
    create(
      :glossary,
      source_language_code: list_of_permitted_codes.last,
      target_language_code: list_of_permitted_codes.first
    )
  end

  let!(:term1) { create(:term, glossary: glossary1) }
  let!(:term2) { create(:term, glossary: glossary1) }
  let!(:term3) { create(:term, glossary: glossary2) }

  describe '#index' do
    it 'should return list of glossaries' do
      get glossaries_path

      expect(json_response[:data].size).to eq 2
      expect(json_response[:data].map { |glossary| glossary[:id] }).to include(glossary1.id.to_s, glossary2.id.to_s)
    end

    it 'should returns list of terms for glossaries' do
      get glossaries_path

      expect(json_response[:included].size).to eq 3
      expect(json_response[:included].map { |record| record[:type] }.all? { |type| type == 'terms' }).to be true
      expect(json_response[:included].map { |record| record[:id] }).to include(term1.id.to_s, term2.id.to_s,
                                                                               term3.id.to_s)
    end
  end

  describe '#show' do
    let!(:term1) { create(:term, glossary: glossary1) }
    let!(:term2) { create(:term, glossary: glossary1) }

    it 'returns error resonse if wrong id' do
      get glossary_path(id: 'Wrong id')

      expect(response.status).to eq 404
    end

    it 'returns correct glossary' do
      get glossary_path(id: glossary1.id)

      expect(json_response).to include(
        'data' => a_hash_including(
          'id' => glossary1.id.to_s,
          'type' => 'glossaries',
          'attributes' => a_hash_including(
            'source_language_code' => glossary1.source_language_code,
            'target_language_code' => glossary1.target_language_code
          )
        )
      )
    end

    it 'returns correct terms' do
      get glossary_path(id: glossary1.id)

      expect(json_response[:included].map { |record| record[:id] }).to include(term1.id.to_s, term2.id.to_s)
      expect(json_response[:included].map { |record| record[:id] }).not_to include(term3.id.to_s)
    end
  end

  describe '#create' do
    let(:params) do
      { source_language_code: list_of_permitted_codes.last, target_language_code: list_of_permitted_codes.first }
    end

    it 'returns bad erorr for request without required params' do
      post glossaries_path

      expect(response.status).to eq 400
    end

    it 'returns erorr for request without source_language_code' do
      post glossaries_path params: params.except(:source_language_code)

      expect(response.status).to eq 400
    end

    it 'returns erorr for request without target_language_code' do
      post glossaries_path params: params.except(:target_language_code)

      expect(response.status).to eq 400
    end

    it 'returns erorr when same glossary already exists' do
      post glossaries_path params: params

      expect(response.status).to eq 400
    end

    it 'returns erorr when invalid source code' do
      post glossaries_path params: params.merge(source_language_code: 'Invalid')

      expect(response.status).to eq 400
    end

    context 'when params valid' do
      before { glossary2.destroy }

      it 'returns created glossary with correct params' do
        post glossaries_path params: params

        expect(response.status).to eq 200
        expect(json_response[:data][:id]).not_to eq glossary2.id.to_s
        expect(json_response).to include(
          'data' => a_hash_including(
            'type' => 'glossaries',
            'attributes' => a_hash_including(
              'source_language_code' => params[:source_language_code],
              'target_language_code' => params[:target_language_code]
            )
          )
        )
      end
    end
  end

  describe '#create_term' do
    let(:params) { { source_term: Faker::Alphanumeric.alpha, target_term: Faker::Alphanumeric.alpha } }

    it 'returns error when glossary id is invalid' do
      post term_glossary_path(id: 'Invalid'), params: params

      expect(response.status).to eq 404
    end

    it 'returns erorr for request without source_term' do
      post term_glossary_path(id: glossary1.id), params: params.except(:source_term)

      expect(response.status).to eq 400
    end

    it 'returns erorr for request without target_term' do
      post term_glossary_path(id: glossary1.id), params: params.except(:target_term)

      expect(response.status).to eq 400
    end

    it 'returns created term with valid params' do
      post term_glossary_path(id: glossary1.id), params: params

      expect(response.status).to eq 200

      term = Term.find(json_response.dig(:data, :id))

      expect(json_response).to include(
        'data' => a_hash_including(
          'type' => 'terms',
          'attributes' => a_hash_including(
            'source_term' => params[:source_term],
            'target_term' => params[:target_term]
          )
        )
      )

      expect(term.glossary_id).to eq glossary1.id
    end
  end
end
