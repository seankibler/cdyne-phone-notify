require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe PhoneNotify do
  it "should create a module wrapper for PhoneNotify" do
    PhoneNotify.should be_a Module
  end
  
  it "should create connection error classes" do
    PhoneNotify::CantConnect.should be_a Class
    PhoneNotify::Unavailable.should be_a Class
  end

  it "should create an api error class" do
    PhoneNotify::ApiError.should be_a Class
  end
end

