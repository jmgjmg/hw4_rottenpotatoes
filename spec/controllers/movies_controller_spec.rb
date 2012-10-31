require 'spec_helper'

describe MoviesController do
  describe 'find_director' do
    before :each do
	@fake_results = [mock('Movie1'), mock('Movie2')]
    end
    it 'should call the model method to check for movies of same director' do
	Movie.stub(:find)
	@movie.stub(:director).and_return('almodovar')
	Movie.stub(:find_all_by_director)
	Movie.should_receive(:find_all_by_director).with('almodovar')
        get :find_director, { :id=> '1'}
    end
    it 'should select the find director template for rendering' do
	Movie.stub(:find)
	@movie.stub(:director).and_return('almodovar')
	Movie.stub(:find_all_by_director)
        get :find_director, { :id=> '1'}
 	response.should render_template('find_director')
    end
    it 'should make the movies of same director available to that template' do
	Movie.stub(:find)
	@movie.stub(:director).and_return('almodovar')
	Movie.stub(:find_all_by_director).and_return (@fake_results)
        get :find_director, { :id=> '1'}
	assigns(:movies).should == @fake_results
    end
  end
  describe 'empty_director' do
    it 'should go to main page when director of selected movie is nil' do
	Movie.stub(:find).and_return(mock('Movie',:title =>"dummy", :director =>nil))
        get :find_director, { :id=> '1'} 
        response.should redirect_to movies_path
    end
    it 'should go to main page when director of selected movie is empty' do
	Movie.stub(:find).and_return(mock('Movie',:title =>"dummy", :director =>""))
        get :find_director, { :id=> '1'} 
        response.should redirect_to movies_path
    end
  end
  describe 'create_movie' do
    it 'should call the create method' do
	Movie.stub(:create!).and_return(mock('Movie',:title =>"dummy"))
	Movie.should_receive(:create!)
	post :create
        response.should redirect_to movies_path
    end
  end

end
