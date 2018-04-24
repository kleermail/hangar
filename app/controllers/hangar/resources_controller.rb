module Hangar
  class ResourcesController < ActionController::Base
    skip_before_action :verify_authenticity_token, raise: false

    def create
      created = FactoryBot.create resource, *traits, resource_attributes
      render json: created.as_json(include: includes)
    end

    def new
      attributes = FactoryBot.attributes_for resource, *traits, resource_attributes
      render json: attributes
    end

    private

    def resource
      request.path.split('/')[1].singularize.to_sym
    end

    def resource_attributes
      params.fetch(resource, {}).permit!
    end

    def traits
      params.fetch(:traits, []).map &:to_sym
    end

    def includes
      params.fetch(:include, [])
    end
  end
end
