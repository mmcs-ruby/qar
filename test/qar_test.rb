# frozen_string_literal: true

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
end
