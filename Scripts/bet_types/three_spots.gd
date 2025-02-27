extends BetTypeClass

class_name ThreeSpot

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func type_str():
	return "Exactly 3 spots"
	
func payout_odds():
	return 1.2
	
func is_winner(player_hand, dealer_hand, last_four):
	var lows = 0
	for i in range(player_hand.hand_values.size()):
		if (player_hand.hand_values[i] <= 6):
			lows += 1
	return lows == 3 
	
func sort_order():
	return 6
	
