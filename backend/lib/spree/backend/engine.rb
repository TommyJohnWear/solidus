module Spree
  module Backend
    class Engine < ::Rails::Engine
      config.middleware.use "Spree::Backend::Middleware::SeoAssist"

      initializer "spree.backend.environment", :before => :load_config_initializers do |app|
        Spree::Backend::Config = Spree::BackendConfiguration.new
      end

      # sets the manifests / assets to be precompiled, even when initialize_on_precompile is false
      initializer "spree.assets.precompile", :group => :all do |app|
        app.config.assets.precompile += %w[
          spree/backend/all*
          spree/backend/orders/edit_form.js
          spree/backend/address_states.js
          jqPlot/excanvas.min.js
          spree/backend/images/new.js
          fontawesome-webfont*
          select2_locale*
        ]
      end
    end
  end
end
