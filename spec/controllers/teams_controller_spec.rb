require 'spec_helper'

describe TeamsController do
  render_views
  
  describe "GET 'index'" do
    it "shows the page when no teams in db" do      
      get 'index'
      response.should be_success
    end
  end
end
