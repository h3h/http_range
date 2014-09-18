require 'http_range'
require 'spec_helper'

RSpec.describe HTTPRange do
  describe '.parse' do
    subject { described_class.parse(header) }

    context "for a correctly formatted Range header" do
      let(:header) { 'Range: id 29f99177-36e9-466c-baef-f855e1ab731e..6c714be1-d901-4c40-adb3-22c9a8cda950[; max=100' }

      it "returns an instance of the class" do
        expect(subject).to be_an(HTTPRange)
      end

      it { expect(subject.attribute).to eq('id') }
      it { expect(subject.first).to eq('29f99177-36e9-466c-baef-f855e1ab731e') }
      it { expect(subject.last).to eq('6c714be1-d901-4c40-adb3-22c9a8cda950') }
      it { expect(subject.first_inclusive).to eq(true) }
      it { expect(subject.last_inclusive).to eq(false) }
      it { expect(subject.max).to eq('100') }
      it { expect(subject.order).to be_nil }
    end

    context "for a Range header with a wacky but valid attribute name" do
      let(:header) { "Range: purple.cycle-cleaner_knob ]1e3f..2e5a; order=desc" }

      it { expect(subject.attribute).to eq('purple.cycle-cleaner_knob') }
      it { expect(subject.first).to eq('1e3f') }
      it { expect(subject.last).to eq('2e5a') }
      it { expect(subject.first_inclusive).to eq(false) }
      it { expect(subject.last_inclusive).to eq(true) }
      it { expect(subject.max).to be_nil }
      it { expect(subject.order).to eq('desc') }
    end

    context "for a Range header with an invalid order param" do
      let(:header) { "Range: purple.cycle-cleaner_knob ]1e3f..2e5a; order=true" }

      it { expect { subject }.to raise_error(HTTPRange::MalformedRangeHeaderError) }
    end

    context "for a Range header with an invalid range spec syntax" do
      let(:header) { "Range: id 1e3f...2e5a" }

      it { expect { subject }.to raise_error(HTTPRange::MalformedRangeHeaderError) }
    end

    context "for a Range header with an invalid range attribute name" do
      let(:header) { "Range: !!!amazing!!! 1e3f...2e5a" }

      it { expect { subject }.to raise_error(HTTPRange::MalformedRangeHeaderError) }
    end

    context "for a Range header without an attribute name" do
      let(:header) { "Range: 1..2" }

      it { expect { subject }.to raise_error(HTTPRange::MalformedRangeHeaderError) }
    end

    context "for a Range header without a range" do
      let(:header) { "Range: hi" }

      it { expect { subject }.to raise_error(HTTPRange::MalformedRangeHeaderError) }
    end

    context "for a nil Range header" do
      let(:header) { nil }

      it { expect { subject }.to raise_error(HTTPRange::MalformedRangeHeaderError) }
    end
  end
end
