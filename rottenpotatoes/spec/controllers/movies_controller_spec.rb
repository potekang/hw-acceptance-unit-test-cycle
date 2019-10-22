require 'rails_helper'

RSpec.describe MoviesController do
    before(:each) do
        @movie_1 = Movie.create(title: "pupreme",rating: "PG", description:"notfun", director: "me",release_date: 20100101)
    end
    
    describe ' find movie with same directors ' do
        before :each do
            @fack_movive =double(Movie, :title => "pupreme", :director => "me", :id => '1')
            @fack_movive2 =double(Movie, :title => "pupremeE", :director => "you", :id => '2')
            @fack_movive3 =double(Movie, :title => "pupremeE", :director => nil, :id => '3')
        end
        
        it 'should do happy path' do
            expect(Movie).to receive(:find).with('1').and_return(@fack_movive)
            fake_results = [double('fack_movive3', :title => 'pupremeEb', :director => 'me')]
            expect(Movie).to receive(:same_director).with('me').and_return(fake_results)
            get :same_director, {:id => '1'}
            expect(response).to render_template('same_director')
        end
        
        it 'should do sad path' do
            expect(Movie).to receive(:find).with('3').and_return(@fack_movive3)
            get :same_director, {:id => '3'}
            response.should redirect_to(movies_path)
            flash[:notice].should_not be_blank
        end
    end
    
    describe "create" do
        it "create movie with given parameters" do
            @fake = {title: "fake_movie", rating: "R", director: "me"}
            post :create, movie: @fake
            expect(flash[:notice]).to eq("fake_movie was successfully created.")
            expect(response).to redirect_to(movies_path)
        end
    end
    
    describe "desroy" do
        it "delete a movie" do
            @id = "-1"
            @null = double('null movie').as_null_object
            expect(Movie).to receive(:find).with(@id).and_return(@null)
        
            delete :destroy, id: @id
            expect(flash[:notice]).to match(/Movie || deleted./)
            expect(response).to redirect_to(movies_path)
        end
    end
    
    describe "show" do
        it "show details about movie" do
            @id = "1"
            @fack_movive =double(Movie, :title => "pupreme", :director => "me", :id => '1')
            expect(Movie).to receive(:find).and_return(@fack_movive)
            get :show, id: @id
            expect(response).to render_template(:show)
        end
    end
    
    describe "edit" do
        it "edit a movie" do
            @id = "1"
            @fack_movive =double(Movie, :title => "pupreme", :director => "me", :id => '1')
            expect(Movie).to receive(:find).and_return(@fack_movive)
        
            get :edit, id: @id
            expect(response).to render_template(:edit)
        end
    end
    
    describe "new" do
        it "render the new template" do
            get :new 
            expect(response).to render_template(:new)
    end
  end
  
    describe "sorting movies" do
        it "RESTful sort with ratings" do 
            get :index, sort: "title"
            expect(response.body).to include "ratings"
        end
        it "RESTful sort with realease_date" do 
            get :index, sort: "release_date"
            expect(response.body).to include "release_date"
        end 
    end
  
    
end