module Pagoda::Command
  class Auth < Base

    def set
      if cred = Pagoda::Auth.read_credentials
        error ["Credentials have already been set for #{cred[0]}",
                "If you would like to set new credentials use pagoda auth:reset"]
      else
        user, password = Pagoda::Auth.credentials
        display "Ceredentials have been set for #{user}"
      end
    end
    alias :login :set

    def reset
      Pagoda::Auth.delete_credentials
      display "Your Credentials have been reset"
    end
    alias :logout :reset

    def update
      display "deleting old credentials.."
      Pagoda::Auth.delete_credentials
      user, password = Pagoda::Auth.credentials
      display "Ceredentials have been set for #{user}"
    end

  end
end