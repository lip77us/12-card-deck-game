extends Node2D

class_name BetType

const UNDER_DEALER_STRING = "< Dealer"
const OVER_DEALER_STRING = "> Dealer"
const EQ_DEALER_STRING = "= Dealer"
const STRINGS = [UNDER_DEALER_STRING, OVER_DEALER_STRING, EQ_DEALER_STRING]

static var bet_types = {}

var bet_type_string
var bet_type_payout

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func as_string():
	return bet_type_string
	
func get_strings ():
	return STRINGS
	
#func load_bet_types ():
	#for i in range(STRINGS.size()):
		#bt = self.new()
		#bt.bet_type_string = STRINGS[i]
		#match STRINGS[i]:
			#UNDER_DEALER_STRING:
				#bt.bet_type_payout = 1
			#OVER_DEALER_STRING:
				#bt.bet_type_payout = 1
			#EQ_DEALER_STRING:
				#bt.bet_type_payout = 7	
			##bet_types[bet_type_string]=bt

func type_for_string(type_string):
	return bet_types[type_string]
