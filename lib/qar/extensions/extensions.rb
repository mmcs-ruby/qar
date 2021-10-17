# frozen_string_literal: true

# Extensions of existing Ruby classes

# Complex class round extension
class Complex
  def round(digits)
    Complex(real.round(digits), imag.round(digits))
  end
end
