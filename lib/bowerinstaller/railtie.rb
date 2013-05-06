require 'bowerinstaller'
require 'rails'
module BowerInstaller
  class Railtie < Rails::Railtie
    railtie_name :bowerinstaller

    config.after_initialize do |app|
      ["lib", "vendor"].each do |dir|
        app.config.assets.paths << Rails.root.join(dir, 'assets', 'components')
      end
    end

    rake_tasks do
      load "tasks/bowerinstaller.rake"
    end
  end
end
