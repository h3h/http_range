class HTTPRange
  class Parser
    # Accepts the HTTP Range header string to parse.
    #
    def initialize(header_string)
      raise MalformedRangeHeaderError, "Missing Range header value." if blank?(header_string)

      @header_string = header_string.dup
    end

    # Runs the parser on its given `header_string` and returns a hash of the
    # extracted parts.
    #
    # @return [Hash]
    #
    def extract_parts_hash
      parts_hash = {}

      @header_string.sub!(/\ARange:\s*/, '')

      range_spec_string, params_strings = split_header_string(@header_string)

      parts_hash.merge! extract_range_spec_hash(range_spec_string)
      parts_hash.merge! extract_params_hash(params_strings)

      return parts_hash
    end

  private

    def blank?(value)
      value.nil? || value == '' || value == false
    end

    # Takes raw params strings and returns a hash of key/value pairs.
    #
    # @param params_strings [Array<String>]
    #
    # @return [Hash<String,String>]
    #
    def extract_params_hash(params_strings)
      hash = Hash[params_strings.map { |p| p.split('=').map { |v| v.strip } }]
      hash.detect do |k, v|
        raise MalformedRangeHeaderError, "Params key malformed."      if blank?(k)
        raise MalformedRangeHeaderError, "Params value missing: #{k}" if blank?(v)
        raise MalformedRangeHeaderError, "Invalid order value: #{v}"  if k == 'order' && !%w[asc desc].include?(v)
      end
      hash
    end

    RANGE_SPEC_REGEX = /\A
      (?<attribute>[a-zA-Z][\w\.-]*)
      \s+
      (?<first_exclusive>\])?
      (?<first>[^\.]*?)
      \.\.
      (?<last>[^\.]*?)
      (?<last_exclusive>\[)?
    \z/x

    # Takes a raw range spec string (<attr> <first>..<last>) and returns a hash
    # of key/value pairs for the extracted parts.
    #
    # @param range_spec_string [String]
    #
    # @return [Hash<String,String>]
    #
    def extract_range_spec_hash(range_spec_string)
      hash   = {}
      values = range_spec_string.match(RANGE_SPEC_REGEX)
      if values
        hash.merge!({
          'attribute'       => values['attribute'],
          'first'           => values['first'],
          'last'            => values['last'],
          'first_inclusive' => values['first_exclusive'].nil?,
          'last_inclusive'  => values['last_exclusive'].nil?,
        })
      else
        raise MalformedRangeHeaderError, "Invalid range spec."
      end
      hash
    end

    # Takes the value portion of a Range header string and splits it into the
    # range spec and any params delimited by ;. Also strips whitespace.
    #
    # @param header_string [String]
    #
    # @return [Array<String,Array<String>>]
    #
    def split_header_string(header_string)
      range_spec, *params = header_string.split(';')
      [range_spec.strip, params.map { |s| s.strip }]
    end
  end
end
