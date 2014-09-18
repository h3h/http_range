require 'json'

class HTTPRange
module Middleware

  # Rack Middleware for parsing `Range` headers. See [SPEC][1] for
  # more details.
  #
  #  [1]: https://github.com/h3h/http_range/blob/master/SPEC.md
  #
  # Request Header Format:
  #
  #   Range: <attr> <first>..<last>[; order=<asc|desc>][; max=<int>]
  #
  # Examples:
  #
  #   Range: id 29f99177-36e9-466c-baef-f855e1ab731e..6c714be1-d901-4c40-adb3-22c9a8cda950; max=100
  #   Range: created_at 2014-09-18T16:30:38Z..2014-09-18T17:30:33Z; order=desc
  #
  # Output:
  #
  # `env` keys exposed from the parsed content of the requested Range header:
  #
  #   - env['rack.range.attribute']: attribute name
  #   - env['rack.range.first']:           first value in the range
  #   - env['rack.range.last']:            last value in the range
  #   - env['rack.range.first_inclusive']: whether the first value is inclusive
  #   - env['rack.range.last_inclusive']:  whether the last value is inclusive
  #   - env['rack.range.order']:           order param
  #   - env['rack.range.max']:             max param
  #
  # Usage:
  #
  #   use HTTPRange::Middleware::AcceptRanges
  #
  class AcceptRanges
    def initialize(app)
      @app = app
    end

    def call(env)
      range_header = env['HTTP_RANGE']
      if range_header && range_header.length > 0
        http_range = HTTPRange.parse(range_header)

        set_env_fields(
          env:             env,
          attribute:       http_range.attribute,
          first:           http_range.first,
          last:            http_range.last,
          first_inclusive: http_range.first_inclusive,
          last_inclusive:  http_range.last_inclusive,
          order:           http_range.order,
          max:             http_range.max,
        )
      end

      @app.call(env)
    rescue HTTPRange::MalformedRangeHeaderError => ex
      [400, {'Content-Type' => 'application/json'}, [{errors: [ex.message]}.to_json]]
    end

  private

    # Expose fields in the given env hash for the rest of the application.
    #
    # @param env      [Hash]
    # @param **fields [Hash]
    #
    # @return [nil]
    #
    def set_env_fields(env:, **fields)
      fields.each do |field, value|
        env["rack.range.#{field}"] = value
      end
    end
  end

end
end
