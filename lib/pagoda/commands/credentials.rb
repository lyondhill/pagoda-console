module Pagoda::Command
  class Credentials < Base

    def reset
      Pagoda::Auth.delete_credentials
      display "Your Credentials have been reset"
    end

    def update
      display "deleting old credentials.."
      Pagoda::Auth.delete_credentials
      Pagoda::Auth.save_credentials(Pagoda::Auth.ask_for_credentials)
    end

  end
end