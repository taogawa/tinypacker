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
end
