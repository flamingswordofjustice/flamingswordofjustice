module Linkable
  class << self
    def linkables
      @linkables ||= []
    end
  end

  module Subject
    def self.included(base)
      Linkable.linkables << base
      base.send :extend, Linkable::Subject::ClassMethods
    end

    def linkable_title
      self.class.name + ": " + self.title
    end

    module ClassMethods
      def linkable_to(association)
        has_many association, as: :linkable
      end
    end
  end

  module Link
    include Rails.application.routes.url_helpers
    include ActionDispatch::Routing::PolymorphicRoutes

    def self.included(base)
      base.send :belongs_to, :linkable, polymorphic: true
    end

    def default_url_options; {}; end

    def linkable_path
      if linkable.present?
        polymorphic_path self.linkable
      end
    end

    def linkables
      Linkable.linkables.sum(&:all).sort do |a, b|
        if a.class == b.class
          b.created_at <=> a.created_at
        else
          a.class.name <=> b.class.name
        end
      end
    end
  end
end
