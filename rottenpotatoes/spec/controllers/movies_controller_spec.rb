require 'spec_helper'

describe MoviesController do
    before :each do
        @some_movie = double "movie1", :id => "123", :title => "Some Movie", :director => "Someone"
        @void_director = double "movie2", :id => "456", :title => "Void Director", :director => ""
        @another_movie = double "movie3", :id => "789", :title => "Another Movie", :director => "Someone"
        allow(Movie).to receive(:find).with(@some_movie.id).and_return(@some_movie)
        allow(Movie).to receive(:find).with(@void_director.id).and_return(@void_director)
    end
    describe "click on Find With Same Director" do 
        before :each do
            @movies_collection = [@some_movie, @another_movie]
        end
        it "have a RESTful route" do
            expect(:get => (same_director_path @some_movie)).to route_to(
                :controller => "movies",
                :action => "same_director",
                :id => "#{@some_movie}"
            )
        end
        
        describe "after routing" do 
            before :each do
                allow(Movie).to receive(:same_director_of).with(@some_movie).and_return(@movies_collection)
                get :same_director, :id => @some_movie.id
            end
            it "would grab the id and get the movie" do
                expect(controller.params[:id]).to eq(@some_movie.id)
                expect(controller.instance_variable_get("@movie")).to eq(@some_movie)
            end
            describe "movie have a valid director" do
                it "show movies with same director" do
                    expect(controller.instance_variable_get("@movies")).to eq(@movies_collection)
                end
            end
            describe "movie does not hava a director" do
                it "back to home page" do
                    get :same_director, :id => @void_director.id
                    expect(response).to redirect_to movies_path
                end
            end
        end
    end
    
    describe "delete a movie" do
        it "route successfully" do
            expect(:delete => (movie_path @some_movie)).to route_to(
                    :controller => "movies",
                    :action => "destroy",
                    :id => "#{@some_movie}"
                )
        end
        it "delete successfully" do
            allow(@some_movie).to receive(:destroy).and_return(true)
            delete :destroy, :id => @some_movie.id
        end
    end
    
    describe "add a movie" do
        it "route successfully" do
            expect(:post => movies_path).to route_to(
                    :controller => "movies",
                    :action => "create"
                )
        end
        
        it "create successfully" do
            post :create, :params => {:movie => @some_movie}
            allow(Movie).to receive(:create).with(@some_movie).and_return(true)
            expect(flash[:notice]).to be_present
            expect(response).to redirect_to movies_path
        end
    end
    
    describe "update movie" do
        it "update successfully" do
            allow(@some_movie).to receive("update_attributes!").with("#{@another_movie}").and_return(true)
            put :update, :id => @some_movie.id, :movie => @another_movie
            expect(flash[:notice]).to be_present
            expect(response).to redirect_to movie_path @some_movie
        end
    end 
    
    describe "sort movies" do
        it "successful" do
            get :index, :sort => "title", :ratings => "G" 
            expect(session[:sort]).to eq("title")
        end
    end
end
