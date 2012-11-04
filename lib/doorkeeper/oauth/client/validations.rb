module Doorkeeper
  module OAuth
    class Client
      class Validations
        include ActiveModel::Validations

        validates :redirect_uri, :uid, :secret, :presence => true
        validates :redirect_uri, :redirect_uri => true

        attr_accessor :redirect_uri, :uid, :secret

        def initialize(attrs)
          attrs.each do |name, value|
            send("#{name}=", value)
          end
        end
      end
    end
  end
end
