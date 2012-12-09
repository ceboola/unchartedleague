require 'spec_helper'

describe ArticlesController do
  describe 'GET index' do
    it "assigns @articles" do
      article = FactoryGirl.create(:article)
      get :index
      assigns(:articles).should eq([article])
    end
  end
end
