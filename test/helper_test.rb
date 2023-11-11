# frozen_string_literal: true

require "test_helper"

class HelperTest < ActionView::TestCase
  tests Tinypacker::Helper

  attr_reader :request

  def setup
    @request = Class.new do
      def base_url
        "https://example.com"
      end
    end.new
  end

  def test_javascript_pack_tag
    assert_equal '<script src="/packs/js/application-12345.js"></script>', javascript_pack_tag("application.js")
  end

  def test_javascript_pack_tag_without_extname
    assert_equal '<script src="/packs/js/application-12345.js"></script>', javascript_pack_tag("application")
  end

  def test_stylesheet_pack_tag
    assert_match /<link\s+rel="stylesheet"(?=.*href="\/packs\/css\/application-\d+\.css")(?=.*media="screen")[^>]*\s+\/>/, stylesheet_pack_tag("application.css")
  end

  def test_stylesheet_pack_tag_without_extname
    assert_match /<link\s+rel="stylesheet"(?=.*href="\/packs\/css\/application-\d+\.css")(?=.*media="screen")[^>]*\s+\/>/, stylesheet_pack_tag("application")
  end

  def test_asset_pack_path
    assert_equal "/packs/css/application-12345.css", asset_pack_path("application.css")
  end

  def test_asset_pack_url
    assert_equal "https://example.com/packs/css/application-12345.css", asset_pack_url("application.css")
  end
end
