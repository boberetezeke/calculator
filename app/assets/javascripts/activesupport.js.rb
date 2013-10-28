class Object
  def blank?
    false
  end

  def present?
    !blank?
  end
end

class NilClass
  def blank?
    true
  end
end

class String
  def blank?
    self == ""
  end
end
