require_relative '../spec_helper'

describe Letris::Board do
  it "must be 10 wide" do
    Letris::Board.new.width.must_equal 10
  end

  it "must be 20 wide" do
    Letris::Board.new.height.must_equal 20
  end

  describe "On an empty board, when moving a piece to the bottom" do
    before do
      @board = Letris::Board.new
      @piece = Letris::Piece.new(Letris::PieceType.by_name(:s)) 
      @board.current_piece = @piece
      @board.init_piece_pos
    end

    it "must add the piece to the board" do
      19.times { @board.move_piece_down }
      puts @board.cur_piece_pos_y
      @board.tile_for_xy_empty?(4,0).must_equal false
    end
  end

end
