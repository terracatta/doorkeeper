require 'doorkeeper/models/active_record/client'

module Doorkeeper
  module Models
    module ActiveRecord
      def doorkeeper_client!(options = {})
        include Client
      end
    end
  end
end

