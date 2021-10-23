require "matrix"
# Complex class round extension
class Complex
  def round(digits)
    Complex(real.round(digits), imag.round(digits))
  end
end

# Integer class round extension
class Integer
  def round(num)
    num
  end
end

# Matrix class product and print extensions
class Matrix
  class << self
    # Computes Kronecker product of two given matrices
    def kronecker(a, b)
      c = Matrix.zero(a.row_count * b.row_count, a.column_count * b.column_count)
      m = [a.row_count, b.row_count].max
      n = [a.column_count, b.column_count].max
      (0...a.row_count * b.row_count).each do |i|
        (0...a.column_count * b.column_count).each do |j|
          c[i, j] = a[i / m, j / n] * b[i % m, j % n]
        end
      end
      c
    end
  end

  # Prints a matrix
  def print
    (0...row_count).each do |i|
      (0...column_count).each do |j|
        Kernel.print "#{self[i, j]}\t"
      end
      puts
    end
  end
end
