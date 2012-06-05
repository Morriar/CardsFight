import game

abstract class Card
	var name: String
	fun action(from: Player, target: Player) is abstract
	redef fun to_s do return name
end

class Lightning
	super Card

	var damage: Int
	
	init(damage: Int) do 
		super("Lightning({damage})")
		self.damage = damage
	end
		
	redef fun action(from, target) do
		target.hurt(damage)
	end
end

class Heal
	super Card
	
	var value: Int
	
	init(value: Int) do 
		super("Heal({value})")
		self.value = value
	end
	
	redef fun action(from, target) do
		from.heal(value)
	end
end

class Drain
	super Card
	
	var value: Int
	
	init(value: Int) do 
		super("Drain({value})")
		self.value = value
	end
	
	redef fun action(from, target) do
		target.hurt(value)
		from.heal(value)
	end
end

class Stun
	super Card
	
	private init do 
		super("Stun")
	end
	
	redef fun action(from, target) do
		target.is_stunned = true
	end
end

class Deck[E: Card]
	super List[E]
	
	var max: Int
	
	init(max: Int) do self.max = max
	
	redef fun rand: E do 
		assert deck_is_empty: not is_empty
		return super.as(not null)
	end
	
	fun draw: E do
		assert deck_is_empty: not is_empty
		return pop
	end	
end

class TableDeck[E: Card]
	super Deck[E]
	
	var used: List[Card]
	
	init do
		super(50)
		used = new List[Card]
	end
	
	init random do
		init
		while length < max do
			
			if length % 2 == 0 then
				self.add(new Stun)
				continue
			end
			
			if length % 5 == 0 then
				var value = [3, 6, 9].rand.as(not null)
				self.add(new Drain(value))
				continue
			end
			
			var value = [5, 10, 20].rand.as(not null)
			if length % 3 == 0 then
				self.add(new Heal(value))
			else
				self.add(new Lightning(value))
			end
		end
		
		print self
	end
	
	fun add_used(e: E) do used.push(e)
	
	redef fun draw: E do
		if is_empty then 
			self.add_all(used)
			used.clear
		end
		return pop
	end	
end

class HandDeck[E: Card]
	super Deck[E]
	
	init do
		super(5)
	end
	
	fun pick(index: Int): E do 
		assert index_out_of_hand: index >= 0 and index < length
		var card = self[index] 
		remove(card)
		return card
	end
	
	redef fun rand do
		var card = super
		remove(card)
		return card
	end
end

redef class Board
	var deck: TableDeck[Card]
	
	redef init do deck = new TableDeck[Card].random
	
	redef fun init_board do
		super
		player1.fill_hand(deck)
		player2.fill_hand(deck)
	end
end

redef class Player
	var hand: HandDeck[Card]
	var is_stunned: Bool = false
	
	redef init(n) do
		super(n)
		hand = new HandDeck[Card]
	end
	
	redef fun can_play(board) do
		if is_stunned then
			is_stunned = false
			return false
		end
		return true 
	end
	
	redef fun after_play(board) do
		if hand.length < hand.max then draw(board)
	end
	
	fun draw(board: Board) do
		hand.add(board.deck.draw)
	end 
	
	fun fill_hand(deck: TableDeck[Card]) do
		while hand.length < hand.max do
			hand.add(deck.draw)
		end
	end
end