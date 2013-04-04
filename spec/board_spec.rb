require_relative 'spec_helper'

describe Letris::Board do
  it "must be 10 wide" do
    Letris::Board.new.width.must_equal 10
  end

  it "must be 20 wide" do
    Letris::Board.new.height.must_equal 20
  end
end
