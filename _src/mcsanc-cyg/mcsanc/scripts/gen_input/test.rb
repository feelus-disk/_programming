#!/usr/bin/ruby
require "./mcsanc"
require "test/unit"

class TestMCSANCinput < Test::Unit::TestCase

  def test_init_input
    c=MCSANCinput.new 
    assert_equal String, c.output.class
  end

  def test_bin_by_bin
    c=MCSANCinput.new
      c.vbh_bins[1]=[0,1,2,3,4,5,6]
    assert_equal [0,1], c.bin_by_bin(1)[0].vbh_bins[1]
  end

  def test_save
    c=MCSANCinput.new
    assert_equal "/home/kolesnik/work/mcsanc/share/input.cfg", File::expand_path(c.save)
  end

#  def test_import_config
#    c=MCSANCinput.new
#    c.import_config("../../share/bin_1000.0_1500.0/input.cfg")
#    assert_equal 1000.0, c.vbh_bins[1][0]
#  end
end

class TestMCSANCewparam < Test::Unit::TestCase
  def test_init_ewparam
    ew=MCSANCewparam.new 
    puts ew.output
    assert_equal String, ew.output.class
  end
end
