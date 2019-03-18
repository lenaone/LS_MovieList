class MoviesController < ApplicationController
  def index
  end

  def search
    @url= "https://api.themoviedb.org/3/search/movie?api_key=74e7e1d6b0003e43c02532361ec804ed&query=#{params[:movie_title]}"
    @data = HTTParty.get(@url)
    render :search_display
  end

  def upcoming
    date = Time.now
    current_day = date.strftime("%Y-%m-%e")
    url = "https://api.themoviedb.org/3/discover/movie?api_key=74e7e1d6b0003e43c02532361ec804ed&language=en-EN&region=AU&release_date.gte=#{current_day}&release_date.lte=2019-12-31"
    @data = HTTParty.get(url)
    
  end

  def popular
    url = "https://api.themoviedb.org/3/discover/movie?api_key=74e7e1d6b0003e43c02532361ec804ed&language=en-EN&region=AU&sort_by=popularity.desc&include_adult=false&include_video=false&page=1"
    @data = HTTParty.get(url)
  end

  def save_movie(id, date)
    movie = Movie.new
    url="https://api.themoviedb.org/3/movie/#{id}?api_key=74e7e1d6b0003e43c02532361ec804ed"
    data = HTTParty.get(url)
    movie.id = id
    movie.poster = data["poster_path"]
    movie.title = data["title"]
    movie.plot = data["overview"]
    movie.rating = data["vote_average"]
    movie.released = date || data["release_date"]
    movie.save!
    movie
  end

  def show
    if Movie.find_by(id: params[:id]) == nil
      @movie = save_movie(params[:id],params[:date])
    else
      @movie = Movie.find(params[:id])
    end
  end


end
