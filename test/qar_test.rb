# frozen_string_literal: true
require_relative '../lib/qar/extensions/extensions'
require "test_helper"

class QarTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Qar::VERSION
  end

  def test_it_does_something_useful
    # test that we are not a teapot... just 4 fun
    assert self != :i_am_a_teapot

    # test that no errors occur when importing the module
    assert_nothing_raised do
      require "qar"
    end
  end

  def test_ruby_kronecker_product
    a = Matrix[[1, 2],
               [3, 4]]
    b = Matrix[[0, 5],
               [6, 7]]

    assert_equal Matrix.kronecker(a, b),
                 Matrix[[0, 5, 0, 10],
                        [6, 7, 12, 14],
                        [0, 15, 0, 20],
                        [18, 21, 24, 28]]

    a = Matrix[
      [1, -4, 7],
      [-2, 3, 3]
    ]

    b = Matrix[
      [8, -9, -6, 5],
      [1, -3, -4, 7],
      [2, 8, -8, -3]
    ]

    assert_equal Matrix.kronecker(a, b),
                 Matrix[[8, -9, -6, 5, -32, 36, 24, -20, 56, -63, -42, 35],
                        [1, -3, -4, 7, -4, 12, 16, -28, 7, -21, -28, 49],
                        [2, 8, -8, -3, -8, -32, 32, 12, 14, 56, -56, -21],
                        [-16, 18, 12, -10, 24, -27, -18, 15, 24, -27, -18, 15],
                        [-2, 6, 8, -14, 3, -9, -12, 21, 3, -9, -12, 21],
                        [-4, -16, 16, 6, 6, 24, -24, -9, 6, 24, -24, -9]]
  end
end
