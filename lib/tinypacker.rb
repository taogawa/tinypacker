# frozen_string_literal: true

require_relative "tinypacker/version"
require "rails/engine"
require "json"

module Tinypacker
  def self.instance
    @instance ||= Tinypacker::Instance.new
  end

  class Error < StandardError; end

  class Manifest
    def initialize(configuration)
      load(configuration.manifest_path)
    end

    def lookup(name)
      @data[name.to_s]
    end

    private

    def load(path)
      @data = JSON.parse(File.read(path))
    end
  end

  class Instance
    attr_reader :root_path, :manifest_path, :manifest

    def initialize(root_path: Rails.root, env: Rails.env)
      @root_path = root_path
      configuration = Tinypacker::Configuration.new(root_path: root_path, env: env)
      @manifest_path = configuration.manifest_path
      @manifest = Tinypacker::Manifest.new(configuration)
    end
  end

  class Configuration
    attr_reader :root_path, :config_path

    def initialize(root_path:, env: Rails.env)
      @root_path = root_path
      @config_path = root_path.join("config/tinypacker.yml")
      @env = env
      load(@config_path)
    end

    def manifest_path
      @root_path.join(@data.fetch(:manifest_path)).to_s
    end

    private

    def load(config_path)
      config = begin
        YAML.load_file(config_path.to_s, aliases: true)
      rescue ArgumentError
        YAML.load_file(config_path.to_s)
      end
      @data = config[@env].deep_symbolize_keys
    rescue Errno::ENOENT => e
      raise Tinypacker::Error, "Tinypacker configuration file not found #{config_path}. Error: #{e.message}"
    rescue Psych::SyntaxError => e
      raise Tinypacker::Error, "YAML syntax error occurred while parsing #{config_path}. Error: #{e.message}"
    end
  end

  module Helper
    def javascript_pack_tag(*names, **options)
      manifest = Tinypacker.instance.manifest
      sources = names.map do |name|
        manifest.lookup(name)
      end
      javascript_include_tag(*sources, **options)
    end
  end

  class Engine < ::Rails::Engine
    initializer "tinypacker.helper" do
      ActiveSupport.on_load :action_controller do
        ActionController::Base.helper Tinypacker::Helper
      end

      ActiveSupport.on_load :action_view do
        include Tinypacker::Helper
      end
    end
  end
end
