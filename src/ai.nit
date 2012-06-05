import cards

class AIPlayer super Player
	init ai do init("AI") 
	
	redef fun play_routine(opponent, board) do
		var card = hand.rand
		card.action(self, opponent)
		board.deck.used.add(card)
	end
end