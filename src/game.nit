class Game
	var board: Board
	var max_rounds: Int
	var round: nullable Round
	
	init(max_rounds: Int) do
		self.board = new Board
		self.max_rounds = max_rounds
	end
	
	fun game_start do
		assert missing_player: board.is_ready	
		board.init_board	
		round = new Round.first
	end
	
	fun play_round do
		round.play(self)
		if is_won then return
		
		round = round.next_round
	end
	
	fun game_end do end
	
	fun is_won: Bool do
		if round.id == max_rounds or board.player1.is_dead or board.player2.is_dead then return true
		return false
	end 
	
	fun winner: Player do 
		if board.player1.is_dead then return board.player2.as(not null)
		return board.player1.as(not null)
	end
end

class Board
	var player1: nullable Player writable
	var player2: nullable Player writable
	
	init do end
	fun init_board do end	
	fun is_ready: Bool do return player1 != null and player2 != null
end

abstract class Player
	var name: String protected writable
	var max_health: Int = 50
	var health: Int = max_health
	 
	init(name: String) do
		self.name = name
	end
	
	fun hurt(v: Int) do 
		health = health - v
	end
	
	fun heal(v: Int) do
		if health + v >= max_health then
			health = max_health
		else
			health = health + v
		end
	end
	
	fun is_dead: Bool do return health <= 0	
	redef fun to_s do return name
	
	fun play(opponent: Player, board: Board) do
		if can_play(board) then 
			play_routine(opponent, board)
		end
		after_play(board)
	end
	
	fun play_routine(opponent: Player, board: Board) do end
	fun can_play(board: Board): Bool do return true 
	fun after_play(board: Board) do end
end

class Round
	var id: Int
	
	init(id: Int) do self.id = id 
	
	init first do
		init(1)
	end
	
	fun play(game: Game) do
		round_start
		
		var turn: Turn
		turn = new Turn(game.board.player1.as(not null), game.board.player2.as(not null))
		turn.play(game.board)
		if game.is_won then return
		
		turn = turn.opponent_turn
		turn.play(game.board)
		if game.is_won then return
		
		round_end
	end
	
	protected fun round_start do end
	protected fun round_end do end
	
	fun next_round: Round do return new Round(id + 1)
end

class Turn
	var player: Player
	var opponent: Player
	
	fun play(board: Board) do 
		turn_start
		
		player.play(opponent, board)
		turn_end
	end
	
	protected fun turn_start do end
	protected fun turn_end do end
	
	fun opponent_turn: Turn do return new Turn(opponent, player)
end

