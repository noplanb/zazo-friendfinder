class Classifier
  def initialize(parts)
    @string = parts.map(&:to_s).map(&:camelize).join '::'
  end

  def klass
    @string.constantize
  end
end
