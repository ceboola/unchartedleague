# coding: utf-8

require 'spec_helper'

describe "Competitions" do
  include Helpers
     
  describe "show page" do
    describe "without logged in user" do
      describe "has title, description and regulations" do
        before(:each) do
          @competition = FactoryGirl.create(:competition)
          visit competition_path(@competition)
        end
        subject { page }

        it { should have_selector('h1', text: @competition.name)}
        it { should have_content(@competition.description)}      
        it { should have_content(@competition.regulations)}     
      end

      it "doesn't allow to sign up a team" do
        @competition = FactoryGirl.create(:competition)
        visit competition_path(@competition)
        page.should_not have_selector("input[@type='submit']")     
      end
      
      it "has a list of already signed up teams" do
        @competition = FactoryGirl.create(:competition)
        @teams = []
        5.times do
          team = FactoryGirl.create(:random_team)
          CompetitionEntry.create(:competition => @competition, :team => team)
          @teams.insert team
        end
        
        visit competition_path(@competition)
        for team in @teams do
          page.should have_content(team.name)
        end
      end
    end
    
    describe "with logged in user" do
      before(:each) do
        @user = FactoryGirl.create(:user)
        login(@user)          
      end
      
      it "doesn't allow to sign up if user doesn't have a team" do
        @competition = FactoryGirl.create(:competition)
        visit competition_path(@competition)     
        page.should_not have_selector("input[@type='submit']")    
      end
      
      it "allows to sign up if user has a team" do
        @team = FactoryGirl.create(:team)
        @tp = FactoryGirl.create(:captain_team_participation)
        @competition = FactoryGirl.create(:competition)
        visit competition_path(@competition)     
        page.should have_selector("input[@type='submit']")    
      end
      
      it "refuses to sign up a team with too few users" do
        @team = FactoryGirl.create(:team)
        @tp = FactoryGirl.create(:captain_team_participation)
        @competition = FactoryGirl.create(:competition)
        visit competition_path(@competition)     
        expect do
          click_button "Zapisz do rozgrywek drużynę #{@team.name}" # TODO          
        end.not_to change(CompetitionEntry, :count)
      end
      
      it "signs up a team with proper user quantity and doesn't allow to do it again" do
        @team = FactoryGirl.create(:team)
        @tp = FactoryGirl.create(:captain_team_participation)
        @competition = FactoryGirl.create(:competition)
        
        (@competition.min_players - 1).times do
          FactoryGirl.create(:team_participation)
        end       
        
        visit competition_path(@competition)     
        expect do
          click_button "Zapisz do rozgrywek drużynę #{@team.name}" # TODO          
        end.to change(CompetitionEntry, :count).by(1)
        
        page.should_not have_selector("input[@type='submit']")  
      end
    end
  end
end
