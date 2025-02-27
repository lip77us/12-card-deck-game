extends Node2D

class_name Bet

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

var type
var amount
var payout_override=0

func payout_multiplier():
	return type.payout_multiplier()
	
func get_payout_odds():
	return type.get_payout_odds()

func as_string(): # Returns a string representation of the bet
	return ""+str(amount)+" "+ type.as_string() + ", Pays " + str(amount*payout_multiplier())

func win_amount(): #return a doller value if we win or a 0 if we lose or null if too early
	pass
	
func set_bet_type(bet_type):
	type = bet_type
	
func get_type(): #getter
	return (type)
	
func get_amount():
	return amount
	
func is_preflop():
	return type.is_preflop()
	
func is_flop():
	return type.is_flop()
		
func is_turn():
	return type.is_turn()
