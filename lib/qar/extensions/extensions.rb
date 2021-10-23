require "matrix"
# Complex class round extension
class Complex
  def round(digits)
    Complex(real.round(digits), imag.round(digits))
  end
end

class Integer
  def round(num)
    num
  end
end

class Matrix
  class << self
    def kronecker(a, b)
      c = Matrix.zero(a.row_count * b.row_count, a.column_count * b.column_count)
      x = 0
      a.row_count.times do |i|
        y = 0
        a.column_count.times do |j|
          b.row_count.times do |p|
            b.column_count.times do |q|
              c[i + p + x, j + q + y] = b[p, q] * a[i, j]
            end
          end
          y += b.column_count - 1
        end
        x += b.row_count - 1
      end
      c
    end
  end
end
