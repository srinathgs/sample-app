# == Schema Information
#
# Table name: users
#
#  id                 :integer          not null, primary key
#  name               :string(255)
#  email              :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  encrypted_password :string(255)
#  salt               :string(255)
#

require 'spec_helper'

describe User do
	before(:each) do
		@attr = {:name => "Example Name",
		:email => "someone@example.com",
		:password => "foobar",
		:password_confirmation => "foobar"
		}
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

	describe "password validations" do
		it "should require a password" do
			User.new(@attr.merge(:password=>"",:password_confirmation=>"")).should_not be_valid
		end
		it "should require a matching password confirmation" do
			User.new(@attr.merge(:password_confirmation=>"invalid")).should_not be_valid
		end
		it "should reject short passwords" do
			short = "a"*5
			User.new(@attr.merge(:password=>short,:password_confirmation=>short)).should_not be_valid
		end
		it "should reject long passwords" do
			long = "a"*41
			User.new(@attr.merge(:password=>long,:password_confirmation=>long)).should_not be_valid
		end
	end
	
	describe "password encryption" do
		before(:each) do
			@user = User.create!(@attr)
		end
		it "should have an encrypted password attribute" do
			@user.should respond_to(:encrypted_password)
		end
		it "should set the encrypted password" do
			@user.encrypted_password.should_not be_blank
		end
		describe "has_password? method" do
			it "should be true if the passwords match" do
				@user.has_password?(@attr[:password]).should be_true
			end
			it "should be false if the passwords don't match" do
				@user.has_password?("invalid").should be_false
			end
		end
		describe "authentication method" do
			it "should return nil on email/password mismatch" do
				wrong_pass_user = User.authenticate(@attr[:email],"wrongpass")
				wrong_pass_user.should be_nil
			end
			it "should return user on email/password match" do
				matching_pass_user = User.authenticate(@attr[:email],@attr[:password])
				matching_pass_user == @user
			end
			it "should return nil for non-existent email" do
				nonex_pass_user = User.authenticate("bar@foo.com","wrongpass")
				nonex_pass_user.should be_nil
			end


		end
	end

end
