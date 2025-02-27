extends Node2D

class_name BetResult

var original_bet
var dollar_results #includes both bet and amount won in results

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

static func csv_header():
	return "Hand Num, Orignal Bet Amount, Bet Type, Bet Result"
	
#Getters and Setters
func set_dollars_won (amt):
	dollar_results = amt
	
func set_dollars_lost (amt):
	dollar_results = -amt
	
func set_original_bet(bet):
	original_bet = bet
	
func get_original_bet():
	return original_bet
	
func get_won_or_lost():
	return dollar_results
	
func as_string():
	var win_lost_string
	if(dollar_results > 0):
		win_lost_string = "Won "
	elif (dollar_results < 0):
		win_lost_string = "Lost "
	else:
		win_lost_string = "Tied "
	return win_lost_string + original_bet.as_string()
	
func csv_string(hand_number):
	var line = str(hand_number) + ", "
	line = line + str(original_bet.amount)+", "
	line = line + original_bet.type.as_string() + ", "
	line = line + str(dollar_results)
	return line
	
func get_amount_paid(): #return the amount dealer pays player for the bet.  Note, assumes
						# that player has already paid for the bet at the time the bet was
						# made
	if (dollar_results > 0):
		return dollar_results
	else:
		return 0 
		
func db_format(): # return a dictionary with all the right stuff for the database
	var record = {}
	record["Name"]=UserProfile.get_user_name()
	record["Bet Type"] = original_bet.get_type().as_string()
	record["Bet Amount"] = original_bet.get_amount()
	record["Results"] = dollar_results
	return record
	
		
		
