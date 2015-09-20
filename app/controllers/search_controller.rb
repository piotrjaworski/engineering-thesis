class SearchController < ApplicationController

  def index
    query = params[:query]
    unless query.present?
      redirect_to root_path
      return flash[:error] = "Please enter a search phrase."
    end
    @results = PgSearch.multisearch(query)
  end

end
