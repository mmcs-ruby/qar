# frozen_string_literal: true

require "test_helper"

class QarTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Qar::VERSION
  end

  def test_it_does_something_useful
    assert !:i_am_a_teapot.nil?
  end
end
