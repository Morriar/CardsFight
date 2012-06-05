import ai
import console

srand

var game = new Game(10)
game.board.player1 = new ConsolePlayer.console
game.board.player2 = new AIPlayer.ai

game.game_start

while not game.is_won do
	game.play_round
end
game.game_end