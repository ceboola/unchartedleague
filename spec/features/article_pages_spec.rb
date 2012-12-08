require 'spec_helper'

describe "Article pages" do
  subject { page }
  
  describe "signup page" do
    before { visit articles_path }
    
    it { should have_selector('a', text: "Zaloguj")}
  end
end
