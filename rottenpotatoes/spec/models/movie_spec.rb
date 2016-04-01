require 'spec_helper'

describe Movie do
    describe "Find With Same Director" do
        it "successfully find" do 
            alien = double(:title => "Alien", :director => "Ridley Scott")
            Movie.same_director_of(alien).each { |movie_entry| expect(movie_entry.director).to eq("Ridley Scott") }
        end
    end
end
