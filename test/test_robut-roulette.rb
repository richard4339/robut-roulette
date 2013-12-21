require 'test_helper'
require 'robut'
require 'robut-roulette'
require 'mocha/setup'

class Robut::Plugin::RouletteTest < Test::Unit::TestCase

  def setup
    @connection = Robut::ConnectionMock.new
    @presence = Robut::PresenceMock.new(@connection)
    @plugin = Robut::Plugin::Roulette.new(@presence)
  end

  def test_handle_roulette_shot_1_win
    @plugin.stubs(:shot).returns(1)
    @plugin.stubs(:draw).returns(0)
    @plugin.handle(Time.now, "John", "roulette")
    assert_equal( ["Shot 1 of 6: *click*"], @plugin.reply_to.replies )
  end

  # This one actually depends on the previous one to work
  def test_handle_roulette_shot_2_repeat
    @plugin.stubs(:shot).returns(1)
    @plugin.stubs(:draw).returns(0)
    @plugin.handle(Time.now, "John", "roulette")
    assert_equal( ["John: you can't shoot twice in a row, dolt!"], @plugin.reply_to.replies )
  end

  def test_handle_roulette_shot_2_win
    @plugin.stubs(:shot).returns(2)
    @plugin.stubs(:draw).returns(0)
    @plugin.handle(Time.now, "Jane", "roulette")
    assert_equal( ["Shot 2 of 6: *click*"], @plugin.reply_to.replies )
  end

  def test_handle_roulette_shot_1_lose
    @plugin.stubs(:shot).returns(1)
    @plugin.stubs(:draw).returns(1)
    @plugin.handle(Time.now, "Tim", "roulette")
    assert_equal( ["Shot 1 of 6: (boom)", "*reloads*"], @plugin.reply_to.replies )
  end

end