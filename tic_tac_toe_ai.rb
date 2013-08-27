require './tic_tac_toe.rb'
require './tree_node.rb'
require 'debugger'; debugger

class TicTacToeAI < TicTacToe

  def initialize(player_count)
    super
    @move_tree = nil
  end

  def run_loop
    if @player_count == 0
      comp_turn
      unless won?(@board)
        display_board
        comp_turn
      end
      initialize_move_tree(@board) if @turn == 1
      @turn += 1
    elsif @player_count == 1 and @human_first
      user_turn
      unless won?(@board)
        comp_turn
        display_board
      end
      initialize_move_tree(@board) if @turn == 1
      @turn += 1
    elsif @player_count == 1 and not @human_first
      comp_turn
      unless won?(@board)
        display_board
        user_turn
      end
      initialize_move_tree(@board) if @turn == 1
    elsif @player_count == 2
      display_board
      user_turn
      unless won?(@board)
        user_turn
        display_board
      end
      @turn += 1
    end
  end

  def get_comp_move
    if @turn == 1
      @board[1][1] == " " ? [1,1] : [0,0]
    else

      possible_moves = @move_tree.children

      possible_moves.each do |move|
        if is_winning_node?(move,@x_turn)
          return move
        elsif not is_losing_node?(move,x_turn)
          optimal_moves << move
        end
      end

      optimal_moves.sample
    end
  end

  def initialize_move_tree(board)

    parent = TreeNode.new({:board => board, :x_turn => @x_turn})
    possible_nodes = []

    get_valid_moves(board).each do |move|
      new_board = super_dup(board)
      hypo_move(move, new_board, parent.value[:x_turn])
      child_hash = {:board => new_board, :x_turn => !parent.value[:x_turn]}
      child = TreeNode.new(child_hash, parent)
      possible_nodes << child
    end

    until possible_nodes == []
      new_nodes = []
      possible_nodes.each do |from_node|
        get_valid_moves(from_node.value[:board]).each do |move|
          new_board = super_dup(from_node.value[:board])
          hypo_move(move, new_board, from_node.value[:x_turn])
          child = TreeNode.new({:board => new_board, :x_turn => !from_node.value[:x_turn]}, from_node)
          new_nodes << child
        end
      end

      possible_nodes = new_nodes.dup
      possible_nodes.delete_if{ |node| won?(node.value[:board])}
    end

    parent
  end

  def x_won?(board)
    triples = get_triples(board)
    triples.each do |triple|
      if triple == %w(X X X)
        return true
      end
    end

    false
  end

  def o_won?(board)
    triples = get_triples(board)
    triples.each do |triple|
      if triple == %w(O O O)
        return true
      end
    end

    false
  end

  def make_move(move, board, x_turn)
    super
    update_tree
  end

  def hypo_move(move, board, x_turn)
    if x_turn
      board[move[0]][move[1]] = 'X'
    else
      board[move[0]][move[1]] = 'O'
    end
  end

  def update_tree
    @move_tree.children.each do |child|
      if child.value[:board] == board
        @move_tree = child
        break
      end
    end
  end

  def self.is_winning_node?(node,x_turn)
  end

  def self.is_losing_node?(node,x_turn)
  end

end

if __FILE__ == $0
  TicTacToeAI.new(0).play
end