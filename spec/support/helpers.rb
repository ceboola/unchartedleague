# coding: utf-8

module Helpers
  def login(user)    
    visit new_user_session_path
    fill_in "E-mail", :with => user.email
    fill_in "Hasło", :with => user.password
    click_button "Zaloguj się"
    
    expect(page).to have_content("Zalogowano jako #{user.psn_name}")
  end
  
  def devise_alert_should_be_shown_on(page)
    page.should have_selector("div[@class='flash alert']")
  end
end
