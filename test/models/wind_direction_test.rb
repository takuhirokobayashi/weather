require "test_helper"

class WindDirectionTest < ActiveSupport::TestCase
  test 'compass_directionが空だとエラー' do
    wd = WindDirection.new
    assert_not wd.valid?, 'WindDirectionはcompass_directionを指定せずvalid?された'
    assert_not_nil wd.errors[:compass_direction]
  end

  test 'compass_directionが重複しているとエラー' do
    wd = WindDirection.new( compass_direction: '北東北' )
    wd.save
    wd_next = WindDirection.new( compass_direction: '北東北' )
    assert_not wd_next.valid?, 'WindDirectionはcompass_directionが重複しているデータを指定されvalid?された'
    assert_not_nil wd_next.errors[:prid]
  end

  test '正常値を設定してvalid?に成功した' do
    wd = WindDirection.new( compass_direction: '北東北' )
    assert wd.valid?
  end
end
