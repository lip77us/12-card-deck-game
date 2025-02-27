extends BetTypeClass

class_name AboveDealerClass

func type_str():
	return "Above DLR"

func payout_odds():
	return 1
	
func is_winner(player_hand, dealer_hand, last_four):
	return player_hand.hand_totals() > dealer_hand.hand_totals()
	
func sort_order():
	return 1
	
func mutex_class_number():
	return 1
	
func over_dealer_bet():
	return true
	


	
