# coding: utf-8

require 'spec_helper'

describe "Articles" do
  include Helpers
  before(:each) { FactoryGirl.create(:author) }
  
  describe "index page" do
    before(:each) do
      expect do
        FactoryGirl.create(:article)
        FactoryGirl.create(:article, :title => "Title2")
      end.to change(Article, :count).by(2)      
    end
    
    subject { page }
    
    it "has header" do
      visit articles_path
      should have_selector('h1')
    end
    
    it "has a list of articles with proper ids" do
      visit articles_path
      should have_selector('section[@id="article_list"]//ul')      
      for article in Article.all
        should have_selector("li[@id='article#{article.id}']//a", :text => article.title)
      end
    end
    
    it "supports paging" do
      pending
    end
    
    it "shows only published articles" do
      expect do
        FactoryGirl.create(:article, :title => "Title3", :published => FALSE)
      end.to change(Article, :count).by(1)
      
      Article.count.should == 3      
      visit articles_path
      
      should have_selector('section[@id="article_list"]//ul')
      for article in Article.all
        if article.published
          should have_selector('li//a', :text => article.title)
        else
          should_not have_selector('li//a', :text => article.title)
        end
      end
    end
    
    it "shows all (including unpublished) articles to admin" do
      expect do
        FactoryGirl.create(:article, :title => "Title3", :published => FALSE)
      end.to change(Article, :count).by(1)
      
      Article.count.should == 3
      login FactoryGirl.create(:admin)
      visit articles_path
      
      should have_selector('section[@id="article_list"]//ul')
      for article in Article.all
        if article.published
          should have_selector('li//a', :text => article.title)
        else
          should have_selector('li//a', :text => article.title)
          should have_selector("li[@id='article#{article.id}']//span", :text => "Nieopublikowany")
        end
      end
    end
    
    it "allows admin users to edit articles" do
      login FactoryGirl.create(:admin)
      visit articles_path      
      for article in Article.all
        should have_selector("li[@id='article#{article.id}']//a", :text => "Edytuj artykuł")        
      end
    end
    
    it "doesn't allow standard users to edit articles" do
      login FactoryGirl.create(:user)
      visit articles_path      
      for article in Article.all
        should have_selector("li[@id='article#{article.id}']//a", :text => article.title) 
        should_not have_selector("li[@id='article#{article.id}']//a", :text => "Edytuj")        
      end
    end
  end
  
  describe "new page" do
    describe "requested by invalid user" do
      before(:each) do
        @user = FactoryGirl.create(:user)
        login @user
      end
      
      it "doesn't show a form" do
        visit new_article_path
        page.should_not have_selector('form')
        page.should_not have_selector('input[@type="submit"]')
        devise_alert_should_be_shown_on(page)
      end
    end
    
    describe "requested by valid user" do
      before(:each) do
        @user = FactoryGirl.create(:admin)
        login @user
        visit new_article_path
      end
      
      subject { page }

      it "shows a form" do        
        should have_selector('form')
        should have_selector('input[@type="submit"]')
      end
      
      it "allows to create valid article" do
        fill_in "Tytuł", :with => "Title_ahaha"
        fill_in "Zawartość", :with => "simple content"
        expect do
          click_button "Create Article" # TODO
        end.to change(Article, :count).by(1)
      end
    end
  end
  
  describe "edit page" do
    describe "requested by invalid user" do
      before(:each) do
        @article = FactoryGirl.create(:article)
        @user = FactoryGirl.create(:user)        
        login @user        
      end
      
      it "doesn't show a form" do
        visit edit_article_path(@article)
        page.should_not have_selector('form')
        page.should_not have_selector('input[@type="submit"]')
        devise_alert_should_be_shown_on(page)
      end
    end
    
    describe "requested by valid user" do
      before(:each) do
        @article = FactoryGirl.create(:article)
        @user = FactoryGirl.create(:admin)
        login @user
        visit edit_article_path(@article)
      end
      
      subject { page }

      it "shows a form" do        
        should have_selector('form')
        should have_selector('input[@type="submit"]')
      end
      
      it "allows to edit the article" do
        title = "Title_ahaha_LOLO"
        fill_in "Tytuł", :with => title
        fill_in "Zawartość", :with => "simple content"
        expect do
          click_button "Update Article" # TODO          
        end.not_to change(Article, :count)
        visit edit_article_path(@article)
        should have_selector("input[@id='article_title'][@value='#{title}']")
      end
    end
  end
  
  describe "content page" do
    let(:article) { FactoryGirl.create(:article) }
    
    describe "has title, author and content" do
      subject { page }      
      before { visit article_path(article) }

      it { should have_selector('h1', text: article.title)}
      it { should have_selector('section', text: article.author.psn_name)}      
      it { should have_selector('article') }
    end
    
    it "has edit link for admins" do
      login FactoryGirl.create(:admin)
      visit article_path(article)
      page.should have_selector('a', :text => "Edytuj")
    end
    
    it "doesn't have edit link for normal users" do
      login FactoryGirl.create(:user)
      visit article_path(article)
      page.should_not have_selector('a', :text => "Edytuj")
    end
    
    it "doesn't allow to add comments for not logged in user" do
      visit article_path(article)
      page.should_not have_selector('textarea[@id="comment_area"]')
      page.should_not have_selector('input[@type="submit"][@value="Dodaj komentarz"]')      
    end
    
    it "allows to add comments for logged in user" do
      login FactoryGirl.create(:user)
      visit article_path(article)      
      page.should have_selector('textarea[@id="comment_area"]')
      page.should have_selector('input[@type="submit"][@value="Dodaj komentarz"]')
      fill_in "Dodaj komentarz", :with => "simple comment"
      expect do
        click_button "Dodaj komentarz"
      end.to change(Comment, :count).by(1)
    end
    
    it "has a list of comments" do
      user = FactoryGirl.create(:user)
      comment = FactoryGirl.create(:comment_for_article, :owner_id => user.id, :commentable_id => article.id)
      login user
      visit article_path(article)
      page.should have_content(comment.body)
    end
    
    it "has a views counter" do
      visit article_path(article)
      page.should have_content("#{article.views + 1} razy")
    end
  end
end
