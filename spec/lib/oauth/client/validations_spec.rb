require 'spec_helper_integration'

describe Doorkeeper::OAuth::Client::Validations do
  let :attributes do
    {
      :redirect_uri => 'https://tst.com/cb',
      :uid => 'some-uid',
      :secret => 'some-secret',
    }
  end

  subject do
    described_class.new(attributes)
  end

  it 'requires redirect_uri to be_present' do
    subject.redirect_uri = nil
    subject.should_not be_valid
  end

  it 'requires uid to be_present' do
    subject.uid = nil
    subject.should_not be_valid
  end

  it 'requires secret to be_present' do
    subject.secret = nil
    subject.should_not be_valid
  end

  it 'requires the redirect_uri to a valid oauth uri' do
    subject.redirect_uri = '/invalid'
    subject.should_not be_valid
  end
end
