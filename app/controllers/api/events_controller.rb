class Api::EventsController < ApplicationController
  def index
    @events = Events::EventSearchService
              .new(event_params)
              .search
              .includes(:categories, :city)
    response.headers['X-Total-Count'] = @events.count
    render json: @events.page(params[:page]), each_serializer: Api::EventSerializer
  end

  private

  def event_params
    params.permit(
      :name,
      :city,
      :start_time,
      :email,
      categories: []
    )
  end
end
