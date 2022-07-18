# frozen_string_literal: true

require_relative "tinypacker/version"
require "json"

module Tinypacker
  def self.instance
    @instance ||= Tinypacker::Instance.new
  end

  class Error < StandardError; end

  class Manifest
    def initialize(path)
      load(path)
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

    def initialize
      @root_path = Rails.root
      @manifest_path = Rails.root.join("public/packs/manifest.json")
      @manifest = Tinypacker::Manifest.new(@manifest_path)
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
end
