# config file of Pagy for pagination
Rails.application.config.assets.paths << Pagy.root.join("javascripts")
Pagy::VARS[:items] = 20
require "pagy/extras/i18n"
require "pagy/extras/navs"
require "pagy/extras/bootstrap"
