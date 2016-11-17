require 'spec_helper'

describe ForbidBrowser::Browser do
  subject { ForbidBrowser::Browser.new('firefox') }

  it 'forbid' do
    user_agent = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.11; rv:47.0) Gecko/20100101 Firefox/47.0'
    expect(subject.forbid?(user_agent).nil?).to eq false
  end

  it 'not forbid' do
    user_agent = '"Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/46.0.2490.76 Mobile Safari/537.36"'
    expect(subject.forbid?(user_agent).nil?).to eq true
  end
end
