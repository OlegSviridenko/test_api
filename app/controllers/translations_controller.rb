# frozen_string_literal: true

class TranslationsController < ApplicationController
  before_action :check_translation_params, only: [:create]

  def show
    translation = Translation.find(params.require(:id))
    mark_terms_and_render_response(translation)
  end

  def create
    translation = Translation.new(params.permit(:source_language_code, :target_language_code, :source_text))
    mark_terms_and_render_response(translation)
  end

  private

  def mark_terms_and_render_response(translation)
    service = TermsMarkingService.new(translation, glossary_id)

    if service.call && service.errors.empty?
      render jsonapi: service.translation, class: serializers_map, status: :ok
    else
      render_bad_request
    end
  end

  def check_translation_params
    params.require(%i[source_language_code target_language_code source_text])
  end

  def glossary_id
    glossary_id = params.permit(:glossary_id)
    glossary_id.present? ? glossary_id : nil
  end
end
