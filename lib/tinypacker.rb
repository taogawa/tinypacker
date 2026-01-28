# frozen_string_literal: true

require_relative "tinypacker/version"
require "active_support"
require "rails/engine"
require "json"

module Tinypacker
  def self.instance
    @instance ||= Tinypacker::Instance.new
  end

  class Manifest
    class FileNotFoundError < ::StandardError; end

    def initialize(configuration)
      @configuration = configuration
    end

    def lookup(name)
      data[name.to_s].presence
    end

    private

    def load
      JSON.parse(File.read(@configuration.manifest_path))
    rescue Errno::ENOENT => e
      raise Tinypacker::Manifest::FileNotFoundError, "manifest file not found #{@configuration.manifest_path}. Error: #{e.message}"
    end

    def data
      if @configuration.cache_manifest?
        @data ||= load
      else
        @data = load
      end
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
    class FileNotFoundError < ::StandardError; end
    class SyntaxError < ::StandardError; end

    attr_reader :root_path, :config_path

    def initialize(root_path:, env: Rails.env)
      @root_path = root_path
      @config_path = root_path.join("config/tinypacker.yml")
      @env = env
      @data = load(@config_path)
    end

    def manifest_path
      @root_path.join(@data.fetch(:manifest_path)).to_s
    end

    def cache_manifest?
      !!@data.fetch(:cache_manifest)
    end

    private

    def load(config_path)
      config = begin
        YAML.load_file(config_path.to_s, aliases: true)
      rescue ArgumentError
        YAML.load_file(config_path.to_s)
      end
      config[@env].deep_symbolize_keys
    rescue Errno::ENOENT => e
      raise Tinypacker::Configuration::FileNotFoundError, "Tinypacker configuration file not found #{config_path}. Error: #{e.message}"
    rescue Psych::SyntaxError => e
      raise Tinypacker::Configuration::SyntaxError, "YAML syntax error occurred while parsing #{config_path}. Error: #{e.message}"
    end
  end

  module Helper
    def javascript_pack_tag(*names, **options)
      manifest = Tinypacker.instance.manifest
      sources = names.map do |name|
        manifest.lookup(full_pack_name(name, :javascript))
      end
      javascript_include_tag(*sources, **options)
    end

    def stylesheet_pack_tag(*names, **options)
      manifest = Tinypacker.instance.manifest
      sources = names.map do |name|
        manifest.lookup(full_pack_name(name, :stylesheet))
      end
      stylesheet_link_tag(*sources, **options)
    end

    def asset_pack_path(name, **options)
      manifest = Tinypacker.instance.manifest
      path_to_asset(manifest.lookup(full_pack_name(name)), options)
    end

    def asset_pack_url(name, **options)
      manifest = Tinypacker.instance.manifest
      url_to_asset(manifest.lookup(full_pack_name(name)), options)
    end

    private

    def full_pack_name(name, pack_type = nil)
      return name unless File.extname(name.to_s).empty?
      return name if pack_type.nil?
      "#{name}.#{manifest_type(pack_type)}"
    end

    def manifest_type(pack_type)
      case pack_type
      when :javascript then "js"
      when :stylesheet then "css"
      else pack_type.to_s
      end
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
