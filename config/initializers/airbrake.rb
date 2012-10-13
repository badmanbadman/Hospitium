if Rails.env == "production"
  Airbrake.configure do |config|
    config.api_key = ENV['AIRBRAKE_API_KEY']
    config.ignore_only  = []
    # config.ignore << "ActionController::RoutingError"
  end
end
