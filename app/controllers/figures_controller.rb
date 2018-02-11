class FiguresController < ApplicationController

  get '/figures' do
    @figures = Figure.all
    erb :'/figures/index'
  end

  get '/figures/new' do
    @titles = Title.all
    @landmarks = Landmark.all
    erb :'/figures/new'
  end

  get '/figures/:id' do
    @figure = Figure.find(params[:id])
    @titles = @figure.titles
    @landmarks = @figure.landmarks
    erb :'/figures/show'
  end

  get '/figures/:id/edit' do
    @figure = Figure.find(params[:id])
    @titles = Title.all
    @landmarks = Landmark.all
    erb :'/figures/edit'
  end

  post '/figures' do
    @figure = Figure.create(name: params[:figure][:name])

    if !!params[:landmark][:name]
      @landmark = Landmark.create(name: params[:landmark][:name], year_completed: params[:landmark][:year_completed])
      @landmark.save
      @figure.landmarks << @landmark
    end

    if !!params[:title][:name]
      @title = Title.create(name: params[:title][:name])
      @title.save
      @figure.titles << @title
    end

    if !!params[:figure][:title_ids]
      params[:figure][:title_ids].each do |title_id|
        @figure.titles << Title.find(title_id)
      end
    end

    if !!params[:figure][:landmark_ids]
      params[:figure][:landmark_ids].each do |landmark_id|
        @figure.landmarks << Landmark.find(landmark_id)
      end
    end

    @figure.save
    redirect ("/figures/#{@figure.id}")
  end

  patch '/figures/:id' do
    @figure = Figure.find(params[:id])

    @figure.name = params[:figure][:name]

    @figure.titles.clear
    if !!params[:figure][:title_ids]
      params[:figure][:title_ids].each do |title_id|
        @figure.titles << Title.find(title_id)
      end
    end

    @figure.landmarks.clear
    if !!params[:figure][:landmark_ids]
      params[:figure][:landmark_ids].each do |landmark_id|
        @figure.landmarks << Landmark.find(landmark_id)
      end
    end

    if !!params[:landmark][:name]
      @landmark = Landmark.find_or_create_by(name: params[:landmark][:name])
      @landmark.update(year_completed: params[:landmark][:year_completed])
      @landmark.save
      @figure.landmarks << @landmark
    end

    if !!params[:title][:name]
      @title = Title.find_or_create_by(name: params[:title][:name])
      @title.save
      @figure.titles << @title
    end

    @figure.save
    redirect ("/figures/#{@figure.id}")
  end

end
