class TermsMarkingService
  attr_accessor :errors, :translation

  def initialize(translation, glossary_id = nil)
    @translation = translation
    @glossary_id = glossary_id
    @errors = []
  end

  def call
    return false if translation.nil?

    if glossary.present? && glossary_id_is_valid? && necessary_marking?
      process_marking(mark_source_text)
    else
      true
    end
  end

  private

  # Using where().first to avoid record not found error, if translation not found should return not modified source code
  def glossary
    @glossary ||= Glossary.where(
      source_language_code: translation.source_language_code,
      target_language_code: translation.target_language_code
    ).first
  end

  def glossary_id_is_valid?
    return true if @glossary_id.nil? || glossary.id == @glossary_id

    errors << 'Glossary id is not match'
    false
  end

  # Determining if source_text needs to be revised for newly added terms
  def necessary_marking?
    # when glossary terms empty
    translation.terms_marked_at.nil? || translation.terms_marked_at < (glossary.terms_changed_at || glossary.created_at)
  end

  def mark_source_text
    text_for_marking = translation.source_text
    terms_list = glossary.terms.pluck(:source_term)

    # Separate word by spaces to avoid substring detection
    terms_list.each do |term|
      text_for_marking.gsub!(
        /(?<=\s)#{term}(?=[.,\s]|$)/,
        Translation::MARKING_OPEN_TAG + term + Translation::MARKING_CLOSE_TAG
      )
    end
    text_for_marking
  end

  def process_marking(text_for_marking)
    translation.source_text != text_for_marking ? update_and_save_translation(text) : true
  end

  def update_and_save_translation(text)
    translation.source_text = text
    translation.terms_marked_at = Time.now

    if translation.save
      true
    else
      errors << 'Invalid record'
      false
    end
  end
end
