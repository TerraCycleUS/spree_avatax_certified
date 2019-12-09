# frozen_string_literal: true

module Spree
  module AddressDecorator
    module ClassMethods
      def validation_enabled_countries
        Spree::Config.avatax_address_validation_enabled_countries
      end
    end

    def self.prepended(base)
      base.singleton_class.extend ClassMethods
    end

    def validation_enabled?
      Spree::Config.avatax_address_validation && country_validation_enabled?
    end

    def country_validation_enabled?
      Spree::Address.validation_enabled_countries.include?(country.try(:name))
    end
  end
end

Spree::Address.prepend Spree::AddressDecorator
