module Pagoda::Command
  class Logs < Base

    def view
      # snorkel tunnel thing.. prolly
    # -n, --num NUM        # the number of lines to display
    # -p, --ps PS          # only display logs from the given process
    # -s, --source SOURCE  # only display logs from the given source
    # -t, --tail           # continually stream logs

      display "not yet implemented"
    end
    alias :index :view

    def syslog
      # another snorkel thing... prolly
    # logs:drains add URL     # add a syslog drain
    # logs:drains remove URL  # remove a syslog drain
    # logs:drains clear       # remove all syslog drains

      display "not yet implemented"
    end
    alias :drain :syslog

  end
end