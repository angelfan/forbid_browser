require 'spec_helper'

describe ForbidBrowser::Router do
  let(:app) { double }
  before { allow(app).to receive(:call).and_return([200, 'head', 'body']) }

  it 'OK' do
    allow(app).to receive(:call).and_return([200, 'head', 'body'])
    forbid_browser = ForbidBrowser::Router.new(app) do |config|
      config.forbid 'Firefox'
      config.exclude '/users/sign_in'
      config.redirect '/forbid_request'
    end
    env = {
      'HTTP_USER_AGENT' => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.11; rv:47.0) Gecko/20100101 Firefox/47.0',
      'REQUEST_PATH' => '/users/sign_in'
    }
    expect(forbid_browser.call(env)).to eq [200, 'head', 'body']
  end

  it '302' do
    forbid_browser = ForbidBrowser::Router.new(app) do |config|
      config.forbid 'Firefox'
      config.redirect '/forbid_request'
    end
    env = { 'HTTP_USER_AGENT' => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.11; rv:47.0) Gecko/20100101 Firefox/47.0' }

    expect(forbid_browser.call(env)).to eq [302, { 'Location' => '/forbid_request' }, []]
  end

  it '400' do
    forbid_browser = ForbidBrowser::Router.new(app) do |config|
      config.forbid 'Firefox'
      config.exclude '/users/sign_in'
    end
    env = { 'HTTP_USER_AGENT' => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.11; rv:47.0) Gecko/20100101 Firefox/47.0' }
    expect(forbid_browser.call(env)).to eq [400, { 'Content-Type' => 'text/plain' }, []]
  end
end
