require 'spec_helper'

describe Article do
  before(:each) do
    @author = FactoryGirl.create(:author)
    @article = FactoryGirl.build(:article)
  end
  
  it "has title" do    
    @article.title.should eq "Title"
  end
  
  it "has content" do    
    @article.content.should eq "Content"
  end
  
  it "can be published" do    
    @article.published.should eq TRUE
  end
  
  it "has html_content which is rendered from Markdown markup" do
    @article.content = "This is *bongos*, indeed"
    @article.html_content.should eq "<p>This is <em>bongos</em>, indeed</p>"    
  end
  
  it "has author from User database" do
    @article.author.should be_kind_of User
    @article.author.psn_name.should eq @author.psn_name
  end
  
  it "has content_preview which is a preview of content" do
    @article.content_preview[0].should == @article.content[0]
  end
  
  it "has image_url attribute" do
    @article.should respond_to :image_url
  end  
  
  it "has views attribute" do
    @article.should respond_to :views
  end  
end
