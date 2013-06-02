# coding: UTF-8
PIECE_COLORS = { :i => 36, :j => 34, :l => 93, :o => 33, :s => 32, :t => 35, :z => 31 }
module Letris
  class AsciiRenderer
    def colorized(piece_name)
      piece_name == ' ' ? text = ' ' : text  = "X"
      "\e[1;#{PIECE_COLORS[piece_name.downcase.to_sym]};40m"+text+"\e[0m"
    end

    def render_board(board, lines_cleared)
      buf = ''
      buf = buf + "Keys: H: move left. L: move right. R: rotate piece. Q: quit\n"
      buf = buf + "F: drop piece\n"
      buf = buf + "Lines cleared: #{lines_cleared}\n"
      y_pos = board.height - 1
      board.height.times do |y|
        buf = buf + ''
        buf = buf + "║"
        board.width.times
        board.width.times do |x|
          buf = buf + "#{colorized board.tile_for_xy(x,y_pos)}"
        end
        buf = buf + "║"
        buf = buf + "\n"
        y_pos = y_pos - 1
      end
      buf = buf + "╚══════════╝"
      buf
    end
  end
end
