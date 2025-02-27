extends Node2D

var hand_number
var text_edit
var bet_gui_coordinator
var result_csv_strings = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text_edit = $"../../MenuPrimary/TextEdit"
	bet_gui_coordinator = $"../BetGUICoord"
	#var line = BetResult.csv_header()
	var line = "Hand Num, Original Bet Amount, Bet Type, Bet Result"
	text_edit.insert_line_at(0,line)
	result_csv_strings.append(line)

	
func set_deal_number(deal_number):
	hand_number = deal_number
	bet_gui_coordinator.deal_complete(deal_number)


func add_result(result):
	var line = result.csv_string(hand_number)
	text_edit.insert_line_at(hand_number,line)
	result_csv_strings.append (line)
	
func result_csv_lines():
	return result_csv_strings
