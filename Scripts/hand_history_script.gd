extends Node2D

var player_hands = [] # an array of arrays with the 6 card values
var dealer_hands = [] # an array of arrays with the 6 card values

var text_edit = TextEdit.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func add_hand_values(player_array, dealer_array):
	var player_hand=[]
	var dealer_hand=[]
	for i in range(6):
		player_hand.append(player_array[i])
		dealer_hand.append(dealer_array[i])
	player_hand.reverse()
	dealer_hand.reverse()
	player_hands.append(player_hand)
	dealer_hands.append(dealer_hand)
	
func write_hand_histories_csv():
	text_edit.clear()
	text_edit.insert_line_at(0, "Hand no., Player Hand,,,,,,Dealer Hand")
	var line = ""
	for i in range(player_hands.size()):
		line = str(i+1)
		for j in range(6):
			line = line + ","+str(player_hands[i][j])
		for j in range(6):
			line = line + ","+str(dealer_hands[i][j])
		text_edit.insert_line_at(i+1,line)

func hand_history_strings():
	var strings = []
	strings.append("Hand no., Player Hand,PH2,PH3,PH4,PH5,PH6,Dealer Hand,DH2,DH3,DH4,DH5,DH6")
	var line = ""
	for i in range(player_hands.size()):
		line = str(i+1)
		for j in range(6):
			line = line + ","+str(player_hands[i][j])
		for j in range(6):
			line = line + ","+str(dealer_hands[i][j])
		strings.append(line)
	return strings
	
	

		
