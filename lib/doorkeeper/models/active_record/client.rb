module Doorkeeper
  module Models
    module ActiveRecord
      module Client
        extend ActiveSupport::Concern

        included do
          validates :name, :secret, :uid, :redirect_uri, :presence => true
          validates :uid, :uniqueness => true
          validates :redirect_uri, :redirect_uri => true

          before_validation :generate_uid, :generate_secret, :on => :create

          attr_accessible :name, :redirect_uri
        end

        module ClassMethods
          def model_name
            ActiveModel::Name.new(self, Doorkeeper, 'Application')
          end

          def authenticate(uid, secret)
            where(:uid => uid, :secret => secret).first
          end

          def by_uid(uid)
            where(:uid => uid).first
          end
        end

        def generate_uid
          self.uid = OAuth::Helpers::UniqueToken.generate
        end
        private :generate_uid

        def generate_secret
          self.secret = OAuth::Helpers::UniqueToken.generate
        end
        private :generate_secret
      end
    end
  end
end
