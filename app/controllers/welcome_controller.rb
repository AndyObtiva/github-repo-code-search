class WelcomeController < ApplicationController
  def index
    @gists = Gist.all
  end

  def search
    @gists = Gist.search do
      fulltext params[:q]
    end.results
    render :index
  end
end
