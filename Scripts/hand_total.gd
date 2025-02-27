extends BetTypeClass

class_name HandTotal

var hand_total = 99

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func type_str():
	return "Player = " + str(hand_total)

func payout_odds():
	return 4.5
	
func is_winner(player_hand, dealer_hand, last_four):
	return player_hand.hand_totals() == hand_total
	
func sort_order():
	return hand_total
	
func is_preflop():
	return false
	
func is_turn():
	return true
	
func is_turn_hand_total():
	return true
	
func instantiation_copies(): # howe many do I make at setup
	return 6
	
