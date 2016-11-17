require 'spec_helper'

describe ForbidBrowser::Config do
  subject { ForbidBrowser::Config.new }

  it '#forbid' do
    subject.forbid 'Firefox'
    expect(subject.forbids.map(&:name)).to eq(['firefox'])
  end

  it '#exclude' do
    subject.exclude %r{^/assets}
    expect(subject.exclusions).to eq [/^\/assets/]
  end

  it '#redirect' do
    subject.redirect '/forbid_request'
    expect(subject.redirect_to).to eq '/forbid_request'
  end

  context '#excluded?' do
    it 'arg is string' do
      subject.exclude '/users/sign_in'
      expect(subject.excluded?('/users/sign_in')).to eq true
    end

    it 'arg is reg' do
      subject.exclude %r{^/assets}
      expect(subject.excluded?('/assets/xx.js')).to eq true
    end
  end
end
