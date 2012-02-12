# We need the actual library file
require_relative '../lib/dish'
# For Ruby < 1.9.3, use this instead of require relative
# require(File.expand_path('../../lib/dish', __FILE__))

# Dependencies
require 'minitest/autorun'
require 'webmock/minitest'
require 'vcr'
require 'turn'

Turn.config do |c|
  # :outline - Turn's original case/test outline mode [default]
  c.format  = :outline
  # Turn on invoke/execute tracing, enable full backtrace
  c.trace   = true
  # Use humanized test names (works only with :outline format)
  c.natural = true   
end

# VCR config
VCR.config do |c|
  c.cassette_library_dir = 'spec/fixtures/dish_cassettes'
  c.stub_with :webmock
end
