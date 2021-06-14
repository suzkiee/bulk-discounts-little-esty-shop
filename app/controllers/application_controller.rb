class ApplicationController < ActionController::Base
  add_flash_types :notice, :error
  
  private
    def error_message(errors)
      errors.full_messages.join(',')
    end
end
