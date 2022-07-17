# frozen_string_literal: true

require "test_helper"

class ManifestTest < Minitest::Test
  def setup
    @manifest = Tinypacker::Manifest.new("test/manifest.json")
  end

  def test_lookup
    assert_equal "/packs/js/application-12345.js", @manifest.lookup("application.js")
  end
end
