module Letris
  class Piece
    attr_reader :current_state, :piece_type

    def self.new_random
      Piece.new(PieceType.get_random)
    end

    def initialize(piece_type)
      raise unless piece_type
      @piece_type = piece_type
      @current_state = piece_type.states[0]
    end

    def has_tile?(x,y)
      @current_state.has_tile?(x,y)
    end

    def change_to_next_state!
      @current_state = @current_state.next_state
    end
  end
end
