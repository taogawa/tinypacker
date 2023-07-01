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
end
