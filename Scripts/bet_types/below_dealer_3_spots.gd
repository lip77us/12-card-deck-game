extends BetTypeClass

class_name BelowDealer3Spot

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func type_str():
	return "Below DLR-3 spots"
	
func payout_odds():
	return 4
	
func is_winner(player_hand, dealer_hand, last_four):
	var lows = 0
	for i in range(player_hand.hand_values.size()):
		if (player_hand.hand_values[i] <= 6):
			lows += 1
	return (lows == 3 and player_hand.hand_totals() < dealer_hand.hand_totals())
	
func sort_order():
	return 5

func mutex_class_number():
	return 3
