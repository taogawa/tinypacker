# frozen_string_literal: true

require "action_controller/railtie"
require "action_view/railtie"
require "tinypacker"

module TestApp
  class Application < ::Rails::Application
    config.secret_key_base = "abcdef"
    config.eager_load = true
    config.active_support.test_order = :sorted
  end
end
