require 'spec_helper'

describe Article do
  before(:each) do
    @article = FactoryGirl.build(:article)
  end
  
  it "has title" do    
    @article.title.should eq "Title"
  end
  
  it "has content" do    
    @article.content.should eq "Content"
  end
  
  it "has html_content which is rendered from Markdown markup" do
    @article.content = "This is *bongos*, indeed"
    @article.html_content.should eq "<p>This is <em>bongos</em>, indeed</p>"    
  end
  
  it "has author from User database" do
    @article.author.should be_kind_of User
    @article.author.psn_name.should eq "miciek"
  end
end
