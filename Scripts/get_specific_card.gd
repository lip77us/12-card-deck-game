extends BetTypeClass

class_name GetSpecificCard

var card_name
var card_value

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func type_str():
	return "Get: " + card_name

func payout_odds():
	return 4.5
	
func is_winner(player_hand, dealer_hand, last_four):
	#print("in is_winner cv: "+str(card_value)+" lcv:" +str(player_hand.last_card_value()))
	return player_hand.latest_card_value() == card_value
	
func instantiation_copies(): # howe many do I make at setup
	return 6
	
func completed_after_turn():
	return true
	
func sort_order():
	return card_value
	
func is_preflop():
	return false
	
func is_flop_get_card():
	return true
	
func is_flop():
	return true
