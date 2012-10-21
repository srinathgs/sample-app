require 'spec_helper'

describe "LayoutLinks" do
	it "should have Home page at '/'" do
		get '/'
		response.should have_selector("title",:content=>"SampleApp | Home")
	end
	it "should have Contact page at '/contact'" do
		get '/contact'
		response.should have_selector("title",:content=>"SampleApp | Contact")
	end
	it "should have About page at '/about'" do
		get '/about'
		response.should have_selector("title",:content=>"SampleApp | About")
	end
	it "should have Help page at '/help'" do
		get '/help'
		response.should have_selector("title",:content=>"SampleApp | Help")
	end
	it "should have SignUp at /signup" do
		get '/signup'
		response.should have_selector("title", :content=>"SampleApp | SignUp")
	end

end
