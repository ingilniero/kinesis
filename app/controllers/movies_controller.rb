class MoviesController < ApplicationController
  respond_to :json

  def show
    @movie = Movie.new(params[:id])
    respond_with @movie.get_json
  end
end
