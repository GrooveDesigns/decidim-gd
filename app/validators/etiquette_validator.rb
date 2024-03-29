# frozen_string_literal: true

# This validator takes care of ensuring the validated content is
# respectful, doesn't use caps, and overall is meaningful.
class EtiquetteValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.blank?

    # 文字列内に大文字が含まれる割合は気にしなくてよいので外す
    # validate_caps(record, attribute, text_value)
    validate_marks(record, attribute, value)
    validate_caps_first(record, attribute, value)
  end

  private

  def validate_caps(record, attribute, value)
    return if value.scan(/[A-Z]/).length < value.length / 4

    record.errors.add(attribute, options[:message] || :too_much_caps)
  end

  def validate_marks(record, attribute, value)
    return if value.scan(/[!?¡¿]{2,}/).empty?

    record.errors.add(attribute, options[:message] || :too_many_marks)
  end

  def validate_caps_first(record, attribute, value)
    return if value.scan(/\A[a-z]{1}/).empty?

    record.errors.add(attribute, options[:message] || :must_start_with_caps)
  end
end