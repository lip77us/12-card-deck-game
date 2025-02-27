extends BetTypeClass

class_name DontGetSpecificCard

var card_name
var card_value

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func type_str():
	return "Don't Get: " + card_name

func payout_odds():
	return 0.1
	
func is_winner(player_hand, dealer_hand, last_four):
	return player_hand.latest_card_value() != card_value
	
func sort_order():
	return 50+card_value
	
func is_preflop():
	return false
	
func is_flop():
	return true
	
func is_flop_dont_bet():
	return true
	
func instantiation_copies(): # howe many do I make at setup
	return 6
	
func completed_after_turn():
	return true
