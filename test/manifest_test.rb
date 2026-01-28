# frozen_string_literal: true

require "test_helper"

class ManifestTest < Minitest::Test
  def setup
    configuration = Tinypacker::Configuration.new(
      root_path: Pathname.new(File.expand_path("test_app", __dir__)),
      env: "production"
    )
    @manifest = Tinypacker::Manifest.new(configuration)
  end

  def test_lookup
    assert_equal "/packs/js/application-12345.js", @manifest.lookup("application.js")
  end

  def test_lookup_key_not_found
    assert_raises Tinypacker::Manifest::MissingEntryError do
      @manifest.lookup("foo")
    end
  end

  def test_manifest_file_not_found
    configuration = Tinypacker::Configuration.new(
      root_path: Pathname.new(File.expand_path("test_app", __dir__)),
      env: "error"
    )
    manifest = Tinypacker::Manifest.new(configuration)
    assert_raises Tinypacker::Manifest::FileNotFoundError do
      manifest.lookup("foo")
    end
  end

  def test_invalid_manifest_file
    configuration = Tinypacker::Configuration.new(
      root_path: Pathname.new(File.expand_path("test_app", __dir__)),
      env: "invalid_manifest"
    )
    manifest = Tinypacker::Manifest.new(configuration)
    assert_raises Tinypacker::Manifest::InvalidManifestError do
      manifest.lookup("application.js")
    end
  end
end
