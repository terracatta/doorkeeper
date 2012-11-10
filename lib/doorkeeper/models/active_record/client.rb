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

          has_many :authorized_tokens, :class_name => "Doorkeeper::AccessToken", :conditions => { :revoked_at => nil }, :foreign_key => 'application_id'
          has_many :authorized_applications, :through => :authorized_tokens, :source => :application
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

          def column_names_with_table
            self.column_names.map { |c| "oauth_applications.#{c}" }
          end

          # TODO: Authorized tokens should not be mixed in into client's class
          def authorized_for(resource_owner)
            joins(:authorized_applications).
              where(:oauth_access_tokens => { :resource_owner_id => resource_owner.id, :revoked_at => nil }).
              group(column_names_with_table.join(','))
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

      module Association
        extend ActiveSupport::Concern

        included do
          belongs_to :application, :class_name => Doorkeeper.client, :foreign_key => 'application_id'
        end
      end
    end
  end
end
