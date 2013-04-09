module Letris
  class PieceType
    attr_reader :name, :states
    PIECE_SHAPES = {
     :o => [
             ["XX",
              "XX"]
           ],

     :i => [
             ["X",
              "X",
              "X",
              "X"],

             ["XXXX"]
             ],

     :t => [
             ["XXX",
              " X "],

             [" X",
              "XX",
              " X"
             ],

             [" X ",
              "XXX"],

             ["X ",
              "XX",
              "X "]
           ],

     :l => [
             ["X ",
              "X ",
              "XX"],

             ["XXX",
              "X  "],

             ["XX",
              " X",
              " X"],

             ["  X",
              "XXX"]
           ],

     :j => [
             [" X",
              " X",
              "XX"],

             ["X  ",
              "XXX"],

             ["XX",
              "X ",
              "X "],

             ["XXX",
              "  X"]
           ],

     :s => [
             [" XX",
              "XX "],

             ["X ",
              "XX",
              " X"]
           ],

     :z => [
             ["XX ",
              " XX"],

             [" X",
              "XX",
              "X "]
           ] 
    }
    def self.all
      @@pieces ||= {}.tap { |hash| PIECE_SHAPES.each { |k,v| hash[k] = PieceType.new(k,v) } }
    end
    
    def self.by_name(name)
      all[name] 
    end  

    def self.get_random
      all.values[rand(PIECE_SHAPES.size)]
    end

    def initialize(name, states)
      @name = name 
      @states = states.map {|state| State.new(self, state) }
    end

    def to_s
      name.to_s 
    end

    class State
      attr_reader :piece_type, :shape

      def initialize(piece_type, shape)
        @piece_type, @shape = piece_type, shape
      end

      def next_state
        index = @piece_type.states.find_index(self)
        nekst = @piece_type.states[index+1]
        nekst || @piece_type.states[0]
      end

      def has_tile?(x,y)
        # only accept positive coordinates
        return false unless x >=0 && y >= 0
        row = @shape.reverse[y]
        return false unless row
        return true if row[x,1] == "X"
        false
      end

      def width
        @shape[0].length
      end

      def height
        @shape.size
      end
    end
  end
end
