class Events::EventSearchService
  def initialize(*args)
    @params = args[0] || {}
    @scope = Event
  end

  def search
    search_by_values(:name, operator: 'LIKE', surround: '%')
    search_by_city
    search_by_start_time
    search_by_categories
    store_search
    @scope.order(start_time: :asc)
  end

  private

  def search_by_values(value, operator: '=', surround: '')
    return if @params[value].blank?
    @scope = @scope.where("events.#{value} #{operator} ?", "#{surround}#{@params[value]}#{surround}")
  end

  def search_by_city
    return if @params[:city].blank?
    @scope = @scope.joins(:city).where('cities.name = ?', @params[:city])
  end

  def search_by_start_time
    return if @params[:start_time].blank?
    @scope = @scope.where('events.start_time > ?', @params[:start_time])
  end

  def search_by_categories
    categories = @params[:categories].to_a.map(&:to_i).reject(&:zero?)
    return if categories.blank?
    @scope = @scope.joins(:categories).where('categories.id in (?)', categories)
  end

  def store_search
    return if @params[:email].blank? || @params[:start_time].blank?
    Search.find_or_create_by(email: @params.delete(:email), date: @params.delete(:start_time), search_params: @params)
  end
end
