
extends BetTypeClass
	
class_name AboveDealer3Spot

func payout_odds():
	return 4

func type_str():
	return "Above DLR-3 spots"
	
func is_winner(player_hand, dealer_hand, last_four):
	var highs = 0
	for i in range(player_hand.hand_values.size()):
		if (player_hand.hand_values[i] >= 7):
			highs += 1
	return (highs == 3 and player_hand.hand_totals() > dealer_hand.hand_totals())

func sort_order():
	return 4
	
func mutex_class_number():
	return 3
