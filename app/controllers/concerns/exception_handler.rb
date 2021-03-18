module ExceptionHandler
  extend ActiveSupport::Concern

  included do
    rescue_from ActionController::ParameterMissing do |e|
      json_response({ message: e.message }, :bad_request)
    end

    rescue_from ActiveRecord::RecordNotFound do |e|
      json_response({ message: e.message }, :not_found)
    end

    rescue_from ActiveRecord::RecordInvalid do |e|
      json_response({ message: e.message }, :unprocessable_entity)
    end

    rescue_from Exception do |e|
      json_response({ message: "Sorry but happen something bad. Please contact our support." }, :internal_server_error)
    end
  end
end