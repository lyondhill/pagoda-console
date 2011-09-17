module Pagoda::Command
  class Mysql < Base

    def create
      app
      display
      client.database_create(app, 'mysql')
      display "+> creating a sql database on pagodabox...", false
      loop_transaction
      display "+> created"
      display
    end
    alias :launch :create
    alias :register :create



  end
end