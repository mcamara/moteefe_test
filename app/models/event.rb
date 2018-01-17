class Event < ApplicationRecord
  validates :name, presence: true

  validates :city, presence: true
  belongs_to :city

  validates :start_time, presence: true
  validates :end_time, presence: true
  validate :start_time_is_in_future, on: :create
  validate :end_time_after_start_time

  has_many :categories_events, dependent: :destroy
  has_many :categories, through: :categories_events

  after_create :notify_users

  self.per_page = 24

  private

  def start_time_is_in_future
    return if start_time > Time.zone.now
    errors.add(:start_time, :start_time_should_be_future)
  end

  def end_time_after_start_time
    return if end_time > start_time
    errors.add(:end_time, :end_time_should_be_after_start_time)
  end

  def notify_users
    Search.where(date: start_time).each do |search|
      # This search would be completely changed if the search has more than 3 fields
      next if !search.search_params['name'].blank? && !name.include?(search.search_params['name'])
      next if !search.search_params['category'].nil? && (categories.map(&:id) & search.search_params['category'].to_a).empty?
      next if !search.search_params['city'].blank? && search.search_params['city'].to_s != city.name
      SendEmailWorker.perform_async(email: search.email, message: 'New event that matches your search')
    end
  end
end
