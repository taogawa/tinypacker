# frozen_string_literal: true

require "test_helper"

class ConfigurationTest < Minitest::Test
  def setup
    @configuration = Tinypacker::Configuration.new(
      root_path: Pathname.new(File.expand_path("test_app", __dir__)),
      env: "production"
    )
  end

  def test_manifest_path
    manifest_path = File.expand_path File.join(File.dirname(__FILE__), "test_app/public/packs/manifest.json")
    assert_equal @configuration.manifest_path, manifest_path
  end

  def test_cache_manifest?
    assert_equal @configuration.cache_manifest?, true
  end
end
