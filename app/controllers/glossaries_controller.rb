# frozen_string_literal: true

class GlossariesController < ApplicationController
  before_action :check_glossary_params, only: [:create]
  before_action :check_term_params, only: [:create_term]

  def index
    render jsonapi: Glossary.all, include: [:terms], class: serializers_map, status: :ok
  end

  def show
    glossaries = Glossary.find(params.require(:id))
    if glossaries.present?
      render jsonapi: glossaries, include: [:terms], class: serializers_map, status: :ok
    else
      render nothing: true, status: :not_found
    end
  end

  def create
    glossary = Glossary.new(params.permit(:source_language_code, :target_language_code))
    if glossary.save
      render jsonapi: glossary, class: serializers_map, status: :ok
    else
      render_bad_request
    end
  end

  def create_term
    glossary = Glossary.find(params.require(:id))
    term = Term.new(params.permit(:source_term, :target_term).to_h.merge(glossary:))
    if term.save
      glossary.update(terms_changed_at: Time.now)
      render jsonapi: term, class: serializers_map, status: :ok
    else
      render_bad_request
    end
  end

  private

  def check_glossary_params
    params.require(%i[source_language_code target_language_code])
  end

  def check_term_params
    params.require(%i[id source_term target_term])
  end
end
