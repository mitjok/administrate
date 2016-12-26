require "rails_helper"
require "administrate/namespace"

describe Administrate::Namespace do
  describe "#resources" do
    it "searches the routes for resources in the namespace" do
      begin
        namespace = Administrate::Namespace.new(:admin)
        Rails.application.routes.draw do
          namespace(:admin) { resources :customers }
        end
        namespace_array = [described_class::Resource.new(:customers,
                                                         [:admin, :customers]),]
        expect(namespace.resources).to match_array(namespace_array)
      ensure
        reset_routes
      end
    end

    it "handles namespaced routes" do
      begin
        namespace = Administrate::Namespace.new(:admin)
        Rails.application.routes.draw do
          namespace(:admin) do
            resources :customers
            namespace(:v1) { resources :customers }
          end
        end

        expect(namespace.resources).to match_array(
          [described_class::Resource.new(:customers, [:admin, :customers]),
           described_class::Resource.new(:"v1/customers", [:admin, :v1, :customers]),])
      ensure
        reset_routes
      end
    end
  end
end
