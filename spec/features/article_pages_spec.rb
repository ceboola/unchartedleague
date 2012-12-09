require 'spec_helper'

describe "Articles" do
  include Helpers
  before(:each) { FactoryGirl.create(:author) }
  
  describe "index page" do
    it "has header" do
      visit articles_path
      page.should have_selector('h1')
    end
    
    it "has a list of articles" do
      expect do
        FactoryGirl.create(:article)
        FactoryGirl.create(:article, :title => "Title2")
      end.to change(Article, :count).by(2)
      Article.count.should == 2
      visit articles_path      
      page.should have_selector('section[@id="article_list"]//ul')
      for article in Article.all
        page.should have_selector('li//a', :text => article.title)
      end
    end
    
    it "supports paging" do
      pending
    end
  end
  
  describe "new article page" do
    describe "by invalid user" do
      before(:each) do
        @user = FactoryGirl.create(:user)
        login @user
      end
      
      it "doesn't show a form" do
        visit new_article_path
        page.should_not have_selector('form')
        page.should_not have_selector('input', :type => 'submit')
      end
    end
    
    describe "by valid user" do
      before(:each) do
        @user = FactoryGirl.create(:admin)
        login @user
      end

      it "shows a form" do
        visit new_article_path
        page.should have_selector('form')
        page.should have_selector('input', :type => 'submit')
      end
    end
  end
  
  describe "article content page" do
    describe "has title, author and content" do
      subject { page }
      let(:article) { FactoryGirl.create(:article)}
      before { visit article_path(article) }

      it { should have_selector('h1', text: article.title)}
      it { should have_selector('section', text: article.author.psn_name)}
      it { should have_selector('article') }
    end
    
    it "allows to add comments" do
      pending
      # add article
      # visit article page
      # check for form
      # fill in form
      # check that comment was created in db
    end    
    
    it "has a list of comments" do
      pending
      # add article
      # add 2 comments to article
      # visit article page
      # check for those 2 comments
    end
  end
end
