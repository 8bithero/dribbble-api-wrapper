require_relative '../../spec_helper'
# For Ruby < 1.9.3, use this instead of require_relative
# require (File.expand_path('./../../../spec_helper', __FILE__))

describe Dish::Player do
  
  describe "default attributes" do
    it "must include httparty methods" do
      Dish::Player.must_include HTTParty
    end

    it "must have the base url set to the Dribble API endpoint" do
      Dish::Player.base_uri.must_equal 'http://api.dribbble.com'
    end
  end


  describe "default instance attributes" do

    let(:player) { Dish::Player.new('simplebits') }

    it "must have an id attribute" do
      player.must_respond_to :username
    end

    it "must have the right id" do
      player.username.must_equal 'simplebits'
    end
  end


  describe "GET profile" do

    let(:player) { Dish::Player.new('simplebits') }

    before do
      VCR.insert_cassette 'base', :record => :new_episodes
    end

    after do
      VCR.eject_cassette
    end

    it "must have a profile method" do
      player.must_respond_to :profile
    end

    it "must parse the api response from JSON to Hash" do
      player.profile.must_be_instance_of Hash
    end

    it "must perform the request and get the data" do
      player.profile["username"].must_equal "simplebits"
    end


    describe "dynamic attributes" do

      before do
        player.profile
      end

      it "must return the attribute value if present in profile" do
        player.id.must_equal 1
        player.shots_count.must_equal 184
      end

      it "must raise method missing if attribute is not present" do
        lambda { player.foo_attribute }.must_raise NoMethodError
      end
    end

    describe "caching" do
      # We use Webmock to disable the network connection after
      # fetching the profile
      before do
        player.profile
        stub_request(:any, /api.dribbble.com/).to_timeout
      end

      it "must cache the profile" do
        player.profile.must_be_instance_of Hash
      end

      it "must refresh the profile if forced" do
        lambda { player.profile(true) }.must_raise Timeout::Error
      end
    end
  end
end