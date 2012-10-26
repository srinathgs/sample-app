# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe User do
	before(:each) do
		@attr = {:name => "Example Name",:email => "someone@example.com"}
	end
	it "should create a new instance given valid attributes" do
		User.create!(@attr)
	end
	it "should require a name" do
		no_name_user = User.new(@attr.merge(:name=>""))
		no_name_user.should_not be_valid
	end

	it "should require an email" do
		no_email_user = User.new(@attr.merge(:email=>""))
		no_email_user.should_not be_valid
	end
	it "should not allow names that are too long" do
		long_name = User.new(@attr.merge(:name=>"a"*51))
		long_name.should_not be_valid
	end

	it "should accept valid email" do
		addresses = %w[user@foo.com User@foo.org.com xyz@king.com]
		addresses.each do |address|
			valid_email_user = User.new(@attr.merge(:email=>address))
			valid_email_user.should be_valid
		end
	end

	it "should not accept invalid email id" do
		invaddresses = %w[user@foo,com user_at_.org usdfdsjf@ddd]
		invaddresses.each do |invadd|
			inv_email_email = User.new(@attr.merge(:email=>invadd))
			inv_email_email.should_not be_valid
		end
	end

	it "should not accept duplicate entries" do
		User.create!(@attr)
		duplicate_email = User.create(@attr)
		duplicate_email.should_not be_valid
	end
	it "should not accept capitalized same email" do
		User.create!(@attr)
		caps_email = User.create(@attr.merge(:email=>@attr[:email].upcase))
		caps_email.should_not be_valid
	end
end
