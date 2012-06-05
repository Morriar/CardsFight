import game
import cards

redef class Game
	redef fun game_start do
		super
		print "Game start: {board.player1.as(not null)} vs {board.player2.as(not null)}"
	end
	
	redef fun game_end do
		super
		print "Game end: {winner} wins !"
	end
end 

redef class Player
	redef fun hurt(v) do
		super(v)
		print "{self} looses {v}hp"
		if is_dead then print "{self} is dead..."
	end 
	
	redef fun heal(v) do
		super(v)
		print "{self} gains {v}hp"
	end
end

class ConsolePlayer
	super Player

	init console do
		print "Player name:"
		init(stdin.read_line)
	end
	
	redef fun play_routine(opponent, board) do
		print "Select card to play:"
		hand.display
	
		var index = stdin.read_line.to_i
		while index < 1 or index > hand.length do
			print "Incorrect card..."
			index = stdin.read_line.to_i
		end
	
		var card = hand.pick(index - 1)
		card.action(self, opponent)
		board.deck.used.add(card)
	end
	
	redef fun can_play(board) do
		var can = super(board)
		if not can then print "{self} can't play, he's stunned!"
		return can 
	end
end

redef class Round
	redef fun round_start do
		print "--- Round {id} ---"
		super
	end
end

redef class Turn
	redef fun turn_start do
		print "=> {player}'s turn"
	end
end

redef class Deck[E]
	fun display do
		var index = 1
		for card in self do
			print "[{index}] {card}"
			index += 1
		end
	end
end

redef class Lightning
	redef fun action(from, target) do
		print "{from} uses {self} against {target}"
		super 
	end
end

redef class Heal
	redef fun action(from, target) do
		print "{from} heals himself"
		super 
	end
end

redef class Drain
	redef fun action(from, target) do
		print "{from} uses {self} against {target}"
		super 
	end
end

redef class Stun
	redef fun action(from, target) do
		print "{from} uses {self} against {target}"
		super 
	end
end