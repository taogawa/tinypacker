# frozen_string_literal: true

require_relative "tinypacker/version"
require "json"

module Tinypacker
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
end
