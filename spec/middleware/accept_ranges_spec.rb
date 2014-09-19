require 'http_range/middleware/accept_ranges'
require 'spec_helper'

RSpec.describe HTTPRange::Middleware::AcceptRanges do
  let(:app)        { ->(env) { [200, env, 'body'] } }
  let(:middleware) { HTTPRange::Middleware::AcceptRanges.new(app) }

  context "without a Range header" do
    let(:headers) { {} }

    before { @response = call_with_headers(middleware, headers) }

    it { expect(@response.status).to eq 200 }
    it { expect(@response['rack.range.attribute']).to be_nil }
    it { expect(@response['rack.range.first']).to be_nil }
    it { expect(@response['rack.range.last']).to be_nil }
    it { expect(@response['rack.range.first_inclusive']).to be_nil }
    it { expect(@response['rack.range.last_inclusive']).to be_nil }
    it { expect(@response['rack.range.order']).to be_nil }
    it { expect(@response['rack.range.max']).to be_nil }
  end

  context "with a valid Range header" do
    let(:headers) { {'HTTP_RANGE' => 'Range: id a..z[; max=100'} }

    before { @response = call_with_headers(middleware, headers) }

    it { expect(@response.status).to eq 200 }
    it { expect(@response['rack.range.attribute']).to eq('id') }
    it { expect(@response['rack.range.first']).to eq('a') }
    it { expect(@response['rack.range.last']).to eq('z') }
    it { expect(@response['rack.range.first_inclusive']).to eq(true) }
    it { expect(@response['rack.range.last_inclusive']).to eq(false) }
    it { expect(@response['rack.range.order']).to be_nil }
    it { expect(@response['rack.range.max']).to eq('100') }
  end

  def call_with_headers(middleware, headers)
    Rack::MockRequest.new(middleware).get('/', headers)
  end
end
