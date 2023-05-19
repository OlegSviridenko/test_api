require 'rails_helper'

# Really have no time to cover all cases and split to unit

describe TranslationsController, type: :request do
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

  let(:term) { create(:term, source_term: 'term', glossary: glossary1) }
  let(:source_text) { "Source text with #{term.source_term}" }
  let(:marked_term) { Translation::MARKING_OPEN_TAG + term.source_term + Translation::MARKING_CLOSE_TAG }
  let(:marked_text) { "Source text with #{marked_term}" }

  describe '#show' do
    let(:translation) do
      create(
        :translation,
        source_language_code: list_of_permitted_codes.first,
        target_language_code: list_of_permitted_codes.last,
        source_text: source_text
      )
    end
    it 'returns error resonse if wrong id' do
      get translation_path(id: 'Wrong id')

      expect(response.status).to eq 404
    end

    it 'returns correct glossary' do
      get translation_path(id: translation.id)

      expect(json_response).to include(
        'data' => a_hash_including(
          'id' => translation.id.to_s,
          'type' => 'translations',
          'attributes' => a_hash_including(
            'source_language_code' => translation.source_language_code,
            'target_language_code' => translation.target_language_code,
            'source_text' => marked_text
          )
        )
      )
    end
  end

  describe '#create' do
    let(:params) do
      {
        source_language_code: list_of_permitted_codes.first,
        target_language_code: list_of_permitted_codes.last,
        source_text: source_text
      }
    end

    it 'returns erorr for request without source_language_code' do
      post translations_path params: params.except(:source_language_code)

      expect(response.status).to eq 400
    end

    it 'returns erorr for request without target_language_code' do
      post translations_path params: params.except(:target_language_code)

      expect(response.status).to eq 400
    end

    it 'returns erorr for request without source_text' do
      post translations_path params: params.except(:source_text)

      expect(response.status).to eq 400
    end

    it 'returns erorr when glossary and target_language_code with source_language_code not match' do
      post translations_path params: params.merge(glossary_id: glossary2.id)

      expect(response.status).to eq 400
    end

    context 'with valid params' do
      it 'when sending valid glossary id' do
        post translations_path params: params.merge(glossary_id: glossary1.id)

        expect(response.status).to eq 400
      end

      it 'returns created translation' do
        post translations_path params: params

        expect(response.status).to eq 200

        expect(json_response).to include(
          'data' => a_hash_including(
            'type' => 'translations',
            'attributes' => a_hash_including(
              'source_language_code' => params[:source_language_code],
              'target_language_code' => params[:target_language_code],
              'source_text' => marked_text
            )
          )
        )
      end
    end
  end
end
