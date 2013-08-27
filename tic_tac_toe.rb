class TicTacToe

  def initialize(player_count)
    @player_count = player_count
    @human_first = player_count == 0 ? nil : get_human_first
    @board = [[' ',' ',' '],[' ',' ',' '],[' ',' ',' ']]
    @x_turn = true
    @turn = 1
  end

  def get_human_first
    input = ""
    until input.downcase == "y" or input.downcase == 'n'
      puts "Would you like to go first? (Y/n)"
      input = gets.chomp
    end

    input == "y"
  end

  def switch_turn
    @x_turn = ! @x_turn
  end

  def play
    until won?(@board)
      run_loop
    end
    puts "Victory!"
    display_board
  end

  def run_loop
    if @player_count == 0
          comp_turn
          display_board
    elsif @player_count == 1 and @human_first
      user_turn
      unless won?(@board)
        comp_turn
        display_board
      end
    elsif @player_count == 1 and not @human_first
      comp_turn
      unless won?(@board)
        display_board
        user_turn
      end
    elsif @player_count == 2
      display_board
      user_turn
    end
  end

  def user_turn
    make_move(get_user_move,@board, @x_turn)
    switch_turn
  end

  def comp_turn
    make_move(get_comp_move,@board, @x_turn)
    switch_turn
  end

  def make_move(move, board, x_turn)
    if x_turn
      board[move[0]][move[1]] = 'X'
    else
      board[move[0]][move[1]] = 'O'
    end
  end

  def won?(board)
    triples = get_triples(board)
    triples.each do |triple|
      if triple == %w(X X X) or triple == %w(O O O)
        return true
      end
    end

    false
  end

  def get_triples(board)
    b = board
    c1 = []
    c2 = []
    c3 = []
    triples = []
    b.each do |row|
      c1 << row[0]
      c2 << row[1]
      c3 << row[2]
    end
    h1 = [b[0][0],b[1][1],b[2][2]]
    h2 = [b[2][0],b[1][1],b[0][2]]

    [c1,c2,c3,b[0],b[1],b[2],h1,h2]
  end

  def display_board
    @board.each do |line|
      puts line.join('')
    end
  end

  def get_user_move
    user_move = [nil,nil]
    until valid_move?(user_move)
      puts @x_turn ? "X's turn" : "O's Turn"
      coord = []
      print 'x location: '
      coord << gets.chomp.to_i
      print 'y location: '
      coord << gets.chomp.to_i
      user_move = coord
    end
    user_move
  end

  def valid_move?(coord)
    if coord == [nil,nil] or not coord[0].between?(0,2) or not coord[1].between?(0,2)
      return false
    end
    @board[coord[0]][coord[1]] == ' '
  end

  def get_comp_move
    valid_moves = get_valid_moves(@board)

    valid_moves.each do |m|
      temp_board = super_dup(@board)
      make_move(m, temp_board, @x_turn)
      return m if won?(temp_board)
    end

    return valid_moves.shuffle[0]
  end

  def get_valid_moves(board)
    valid_moves = []
    3.times do |x|
      3.times do |y|
        if board[x][y] == ' '
          valid_moves << [x,y]
        end
      end
    end

    valid_moves
  end

  def super_dup(array)
    new_array = []
    array.each do |element|
      new_array << element.dup
    end
    new_array
  end

end

if __FILE__ == $0
  TicTacToe.new(1).play
end