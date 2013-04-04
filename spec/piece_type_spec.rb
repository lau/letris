require_relative 'spec_helper'

describe Letris::PieceType do
  it "must find all pieces" do
    Letris::PieceType.all.size.must_equal 7
  end

  it "should be able to find piece by letter" do
    Letris::PieceType.by_name(:l).must_be_instance_of Letris::PieceType
  end

  it "must have states" do
    Letris::PieceType.by_name(:l).states[0].must_be_instance_of Letris::PieceType::State
  end

  it "must have correct amount of states" do
    Letris::PieceType.by_name(:l).states.size.must_equal 4
  end

  it "must have state with width" do
    Letris::PieceType.by_name(:l).states[0].width.must_equal 2
  end

  it "must have state with height" do
    Letris::PieceType.by_name(:l).states[0].height.must_equal 3
  end

  it "must respond if there are tiles or not for a specific set of coordinates" do
    state = Letris::PieceType.by_name(:l).states[0]
    state.has_tile?(0,0).must_equal true
    state.has_tile?(1,0).must_equal true
    state.has_tile?(0,1).must_equal true
    state.has_tile?(1,1).must_equal false
    state.has_tile?(0,2).must_equal true
    state.has_tile?(1,2).must_equal false
  end

end
