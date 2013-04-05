require_relative '../spec_helper'

describe Letris::Board do
  it "must be 10 wide" do
    Letris::Board.new.width.must_equal 10
  end

  it "must be 20 wide" do
    Letris::Board.new.height.must_equal 20
  end

  describe "When trying to move a piece left and another piece is in the way" do
    before do
      @board = Letris::Board.new
      @board.add_new_piece_by_name(:j)
      20.times { @board.move_piece_down }

      @board.add_new_piece_by_name(:o)
      2.times { @board.move_piece_right }
      18.times { @board.move_piece_down }

      @current_piece_pos = @board.current_piece_pos
    end

    it 'should return false' do
      @board.try_move_piece_left.must_equal false
    end

    it 'should still be in the same position' do
      @board.try_move_piece_left
      @board.current_piece_pos.must_equal @current_piece_pos 
    end
  end

  describe "When trying to move a piece left or right and another piece is NOT in the way" do
    before do
      @board = Letris::Board.new

      @board.add_new_piece_by_name(:o)
      18.times { @board.move_piece_down }

      @current_piece_pos = @board.current_piece_pos
    end

    it 'should return true' do
      @board.try_move_piece_left.must_equal true
    end

    it 'should be moved to the left' do
      @board.try_move_piece_left
      @board.current_piece_pos.must_equal [3,1] 
    end

    it 'should be moved to the right' do
      @board.try_move_piece_right
      @board.current_piece_pos.must_equal [5,1] 
    end

  end


  describe "When there is a filled row" do
    before do
      @board = Letris::Board.new
      @board.add_new_piece_by_name(:o)
      4.times { @board.move_piece_left }
      20.times { @board.move_piece_down }

      @board.add_new_piece_by_name(:o)
      2.times { @board.move_piece_left }
      20.times { @board.move_piece_down }

      @board.add_new_piece_by_name(:o)
      20.times { @board.move_piece_down }

      @board.add_new_piece_by_name(:o)
      2.times { @board.move_piece_right }
      20.times { @board.move_piece_down }

      @board.add_new_piece_by_name(:l)
      4.times { @board.move_piece_right }
      20.times { @board.move_piece_down }
    end

    it "the board should return the number of filled rows" do
      @board.filled_row_count.must_equal 1
    end
  end

  describe "When a piece is added to the board and the top of the piece is above the top" do
    before do
      @board = Letris::Board.new
      @board.add_new_piece_by_name(:s)
      20.times { @board.move_piece_down }
      @board.add_new_piece_by_name(:s)
      18.times { @board.move_piece_down }
      @board.add_new_piece_by_name(:s)
      16.times { @board.move_piece_down }
      @board.add_new_piece_by_name(:s)
      14.times { @board.move_piece_down }
      @board.add_new_piece_by_name(:s)
      12.times { @board.move_piece_down }
      @board.add_new_piece_by_name(:s)
      10.times { @board.move_piece_down }
      @board.add_new_piece_by_name(:s)
      8.times { @board.move_piece_down }
      @board.add_new_piece_by_name(:s)
      6.times { @board.move_piece_down }
      @board.add_new_piece_by_name(:s)
      4.times { @board.move_piece_down }
      @board.add_new_piece_by_name(:s)
      2.times { @board.move_piece_down }
      @board.add_new_piece_by_name(:s)
      1.times { @board.move_piece_down }
    end

    it "board should be full ie. game over" do
      @board.is_game_over?.must_equal true
    end
  end

  describe "On an empty board, when moving a piece to the bottom" do
    before do
      @board = Letris::Board.new
      @piece = Letris::Piece.new(Letris::PieceType.by_name(:s)) 
      @board.current_piece = @piece
    end

    it "must add the piece to the board" do
      20.times { @board.move_piece_down }
      @board.tile_for_xy_empty?(4,0).must_equal false
      @board.tile_for_xy_empty?(5,0).must_equal false
      @board.tile_for_xy_empty?(6,0).must_equal true
      @board.tile_for_xy_empty?(4,1).must_equal true
      @board.tile_for_xy_empty?(5,1).must_equal false
      @board.tile_for_xy_empty?(6,1).must_equal false
    end

    describe "when moving down a piece on top of an existing piece" do
      before do
        @board = Letris::Board.new
        @board.add_new_piece_by_name(:s)
        20.times { @board.move_piece_down }
        @board.add_new_piece_by_name(:s)
        17.times { @board.move_piece_down }
      end

      it "the first piece is still there" do
        @board.tile_for_xy_empty?(4,0).must_equal false
        @board.tile_for_xy_empty?(5,0).must_equal false
      end 

      it "the next piece should be placed on top of the first one" do
        @board.tile_for_xy_empty?(4,2).must_equal false
        @board.tile_for_xy_empty?(5,2).must_equal false
      end 

      it "the board should return the number of filled rows" do
        @board.filled_row_count.must_equal 0
      end

      it "it's not yet game over" do
        @board.is_game_over?.must_equal false
      end
    end

  end

end
