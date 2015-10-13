class SearchController < ApplicationController

  def index
    query = params[:query]
    unless query.present?
      redirect_to root_path
      return flash[:error] = "Please enter a search phrase."
    end
    @results = PgSearch.multisearch(query)
    if @results.present?
      @type_filter = @results.pluck(:searchable_type).uniq
      params[:filters] ||= params[:filtering].nil? ? @type_filter : []
      @results = @results.where(searchable_type: params[:filters])
      @count = @results.length
      @results = @results.paginate(page: params[:page], per_page: 20) if @results.present?
    end
  end

end
