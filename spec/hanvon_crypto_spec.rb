require 'spec_helper'

describe Hanvon::Crypto do

  it "should not accept empty password" do
    lambda {
      Hanvon::Crypto.new('')
    }.should raise_exception(Hanvon::Crypto::InvalidPasswordException)
  end

  it "should not accept password with more than 8 digits" do
    lambda {
      Hanvon::Crypto.new('123123123')
    }.should raise_exception(Hanvon::Crypto::InvalidPasswordException)
  end

  it "should not accept non-numeric password" do
    lambda {
      Hanvon::Crypto.new('abc')
    }.should raise_exception(Hanvon::Crypto::InvalidPasswordException)
  end

  context "with password 12345678" do
    before :all do
      @crypto = Hanvon::Crypto.new('12345678')
    end

    describe "#encrypt" do
      it "returns encrypted message" do
        @crypto.encrypt("GetDeviceInfo()").should == ['7656417c58303e1b547a5b5e526e7e'].pack("H*")
      end
    end

    describe "#decrypt" do
      it "returns original message" do
        @crypto.decrypt(['7656417c58303e1b547a5b5e526e7e'].pack("H*")).should == "GetDeviceInfo()"
      end
    end
  end

  context "with password 00000000" do
    before :all do
      @crypto = Hanvon::Crypto.new('00000000')
    end

    describe "#encrypt" do
      it "returns encrypted message" do
        @crypto.encrypt("GetDeviceInfo()").should == ['775446705d36391355785c52576879'].pack("H*")
      end
    end

    describe "#decrypt" do
      it "returns original message" do
        @crypto.decrypt(['775446705d36391355785c52576879'].pack("H*")).should == "GetDeviceInfo()"
      end
    end
  end

  context "with password 1234" do
    before :all do
      @crypto = Hanvon::Crypto.new('1234')
    end

    describe "#encrypt" do
      it "returns encrypted message" do
        @crypto.encrypt("GetDeviceInfo()").should == ['7656417c6d664923547a5b5e673809'].pack("H*")
      end
    end

    describe "#decrypt" do
      it "returns original message" do
        @crypto.decrypt(['7656417c6d664923547a5b5e673809'].pack("H*")).should == "GetDeviceInfo()"
      end
    end
  end

end
