extends Node2D

@onready var main = $".."
@onready var bankroll_display = $"../Table Layout/Bankroll/BankrollAmt"

const START_BANKROLL = 100

# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	update_bankroll_display()
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func update_bankroll(amount):
	var amt = round(amount*100) / 100  # round to the nearest penny
	UserProfile.change_bankroll_by( amt)
	update_bankroll_display()

func update_bankroll_display():
	bankroll_display.set_text(str(UserProfile.get_bankroll()))
	
func set_bankroll_to(amt):
	UserProfile.set_bankroll(amt)
	
func get_bankroll():
	return UserProfile.get_bankroll()
	
func save():
	var save_data = [["bankroll", str(get_bankroll())]] # i intend to add in high water mark
	return save_data
		
func is_new_high_score():
	if UserProfile.get_high_score() < UserProfile.get_bankroll():
		UserProfile.set_new_high_score()
		return true
	else:
		return false
