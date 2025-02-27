extends BetTypeClass

func type_str():
	return "Match DLR"
	
func payout_odds():
	return 14
	
func is_winner(player_hand, dealer_hand, last_four):
	return player_hand.hand_totals() == dealer_hand.hand_totals()
	
func sort_order():
	return 3
