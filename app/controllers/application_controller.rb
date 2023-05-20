class ApplicationController < ActionController::Base
  skip_forgery_protection

  rescue_from ActionController::ParameterMissing, ActiveModel::ValidationError do
    render_bad_request
  end

  rescue_from ActiveRecord::RecordNotFound do
    render_not_found
  end

  private

  def render_not_found
    render json: { error: 'Record not Found' }, status: :not_found
  end

  def render_bad_request
    render json: { error: 'Bad Request' }, status: :bad_request
  end

  def serializers_map
    {
      :Term => TermSerializer,
      :Glossary => GlossarySerializer,
      :Translation => TranslationSerializer
    }
  end
end
