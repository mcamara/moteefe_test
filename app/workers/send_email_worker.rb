class SendEmailWorker
  include Sidekiq::Worker

  def perform(*args)
    # email should be sent here
  end
end
