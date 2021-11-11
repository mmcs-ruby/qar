# frozen_string_literal: true

require 'simplecov'
SimpleCov.start

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require_relative "qar"
require 'simplecov'

require "minitest/autorun"
module Minitest
  module Assertions
    def assert_nothing_raised(*)
      yield
    end
  end
end
