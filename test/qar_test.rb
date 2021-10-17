# frozen_string_literal: true

require "test_helper"

class QarTest < Minitest::Test
  include QuantumException
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

  def test_qubit_constructor
    q = Qubit.new(1, 0)

    assert_raises NormalizationException do
      q = Qubit.new(1, 1)
    end

    q = Qubit.new(Math.sqrt(2) / 2, Math.sqrt(2) / 2)

    assert_raises NormalizationException do
      q = Qubit.new(-1i / 2, 2i)
    end
  end

  def test_qubit_measure
    srand(1000)

    q = Qubit.new(1, 0)

    assert q.measure.zero?

    q = Qubit.new(Math.sqrt(2) / 2, Math.sqrt(2) / 2)

    assert q.measure.zero?

    q = Qubit.new((1 + 1i) / 2, 1i / Math.sqrt(2))

    assert q.measure == 1
  end

  def test_qubit_to_s
    q = Qubit.new(1, 0)

    assert q.to_s == "1|0>"

    q = Qubit.new(Math.sqrt(2) / 2, Math.sqrt(2) / 2)

    p q.to_s
    assert q.to_s == "0.7071067812|0> + 0.7071067812|1>"

    q = Qubit.new((1 + 1i) / 2, 1i / Math.sqrt(2))

    assert q.to_s == "1/2+1/2i|0> + 0.0+0.7071067812i|1>"
  end
end
