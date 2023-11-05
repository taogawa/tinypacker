# frozen_string_literal: true

require "test_helper"

class HelperTest < ActionView::TestCase
  tests Tinypacker::Helper

  def test_javascript_pack_tag
    assert_equal '<script src="/packs/js/application-12345.js"></script>', javascript_pack_tag("application.js")
  end

  def test_javascript_pack_tag_without_extname
    assert_equal '<script src="/packs/js/application-12345.js"></script>', javascript_pack_tag("application")
  end

  def test_stylesheet_pack_tag
    assert_equal '<link rel="stylesheet" href="/packs/css/application-12345.css" media="screen" />', stylesheet_pack_tag("application.css")
  end

  def test_stylesheet_pack_tag_without_extname
    assert_equal '<link rel="stylesheet" href="/packs/css/application-12345.css" media="screen" />', stylesheet_pack_tag("application")
  end

  def test_asset_pack_path
    assert_equal "/packs/css/application-12345.css", asset_pack_path("application.css")
  end

  def test_asset_pack_url
    assert_equal "http://test.host/packs/css/application-12345.css", asset_pack_url("application.css")
  end
end
