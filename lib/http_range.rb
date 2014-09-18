require 'http_range/version'

class HTTPRange

  class MalformedRangeHeaderError < StandardError; end

  attr_reader :attribute
  attr_reader :first
  attr_reader :last
  attr_reader :first_inclusive
  attr_reader :last_inclusive
  attr_reader :order
  attr_reader :max

  def initialize(fields)
    fields.each { |field, value| instance_variable_set(:"@#{field}", value) }
  end

  def self.parse(header_string)
    new(Parser.new(header_string).extract_parts_hash)
  end
end

require 'http_range/parser'
require 'http_range/middleware/accept_ranges'
