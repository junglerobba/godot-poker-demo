extends Area2D
class_name Card

export(CardData.Ranks) var ranks
export(CardData.Suits) var suits

export var hidden: bool
export var rank: int
export var suit: int

signal card_clicked

func set_hidden(hidden: bool) -> void:
	self.hidden = hidden

func set_rank(rank: int) -> void:
	self.rank = rank

func set_suit(suit: int) -> void:
	self.suit = suit

func init(rank: int, suit: int, hidden: bool) -> void:
	self.rank = rank
	self.suit = suit
	self.hidden = hidden
	update()

func update() -> void:
	var backTexture = $Back
	var valueLabel = $ValueLabel
	var baseTexture = $Base
	var suitClubs = $Suit_Clubs
	var suitSpades = $Suit_Spades
	var suitHearts = $Suit_Hearts
	var suitDiamonds = $Suit_Diamonds
	suitClubs.hide()
	suitSpades.hide()
	suitHearts.hide()
	suitDiamonds.hide()
	
	if hidden:
			backTexture.show()
			valueLabel.hide()
			baseTexture.hide()
	else:
		backTexture.hide()
		baseTexture.show()
	
		match suit:
			0:
				suitClubs.show()
			1:
				suitDiamonds.show()
			2:
				suitHearts.show()
			3:
				suitSpades.show()
		
		var valueLabelText
		match rank:
			0, 1, 2, 3, 4, 5, 6, 7, 8:
				valueLabelText = String(rank + 2)
			9:
				valueLabelText = "J"
			10:
				valueLabelText = "Q"
			11:
				valueLabelText = "K"
			12:
				valueLabelText = "A"
		valueLabel.text = valueLabelText
		valueLabel.show()

func _input_event(viewport, event, shape_idx) -> void:
	if event is InputEventMouseButton \
	and event.button_index == BUTTON_LEFT \
	and event.is_pressed():
		self.on_click()

func on_click() -> void:
	emit_signal("card_clicked", self)