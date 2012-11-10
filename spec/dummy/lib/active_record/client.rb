class Client < ActiveRecord::Base
  self.table_name = :oauth_applications

  doorkeeper_client!
end
