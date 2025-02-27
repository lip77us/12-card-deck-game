extends Node2D

class_name BetTypeClass

var override_payout_odds = -1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	#load_preflop_bet_types()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func get_payout_odds():
	if override_payout_odds <= 0:
		return payout_odds()
	else:
		return override_payout_odds
	
func payout_odds():
	return -1
	
func payout_multiplier():
	return 1 + get_payout_odds()
	
func completed_after_turn():
	return false
	
func name_with_odds():
	return type_str() + "(" + str(get_payout_odds())+ ")"
	
func type_str():
	return "Abstract Bet_Type"
	
func as_string():
	return type_str()
	
func is_preflop():
	return true
	
func is_flop():
	return false
	
func is_turn():
	return false
	
func instantiation_copies(): # howe many do I make at setup
	return 1
	
func is_magic_total_bet():
	return false
	
func is_flop_dont_bet():
	return false
	
func is_flop_get_card():
	return false
	
func check_for_loss_after_turn():
	return false
	#
func odds_need_context():
	return false
	
func has_mutex_siblings():
	return mutex_class_number() > 0
	
func mutex_class_number():
	return 0
	
func is_turn_five_spots():
	return false
	
func is_turn_hand_total():
	return false
	
func is_turn_flip_over_under():
	return false
	
func under_dealer_bet():
	return false
	
func over_dealer_bet():
	return false
