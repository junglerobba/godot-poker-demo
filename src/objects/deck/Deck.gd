extends Area2D
class_name Deck

var Card = load("res://src/objects/card/Card.tscn")
var cards = []
var deck = []

signal pressed

func create_deck() -> void:
	for rank in deck:
		for suit in range(0, 4):
			var card = Card.instance()
			card.init(rank, suit, false)
			cards.append(card)
	shuffle()

func draw(amount: int) -> Array:
	if cards.size() < amount:
		amount = cards.size()
	var c: Array = []
	for i in range(0, amount):
		c.append(cards.back())
		cards.pop_back()
	update()
	return c

func shuffle() -> void:
	randomize()
	cards.shuffle()

func _ready() -> void:
	for rank in CardData.Ranks:
		deck.append(CardData.Ranks[rank])
	create_deck()

func _input_event(viewport, event, shape_idx) -> void:
	if event is InputEventMouseButton \
	and event.button_index == BUTTON_LEFT \
	and event.is_pressed():
		self.on_click()

func on_click() -> void:
	emit_signal("pressed")

func update() -> void:
	if cards.size() == 0:
		hide()
	else:
		show()