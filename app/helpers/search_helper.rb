module SearchHelper

  def facet_helper(params, filter)
    params[:filters].include?(filter) ? true : false
  rescue
    true
  end

end
