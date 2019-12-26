extends Node2D

onready var deck = $Deck
onready var hand = $Hand

const REDRAW_LIMIT: = 2
var redraws: = 0

func _ready() -> void:
	deck.connect("pressed", self, "on_deck_pressed")
	hand.connect("card_played", self, "on_card_played")

func on_deck_pressed() -> void:
	if hand.cards.size() != 0:
		return
	redraws = 0
	var cards: Array = deck.draw(5)
	for card in cards:
		hand.add_to_hand(card, -1)

func on_card_played(index: int, card_played: Card) -> void:
	if redraws >= REDRAW_LIMIT:
		hand.add_to_hand(card_played, index)
	if hand.cards.size() < 5:
		redraws += 1
		var cards: Array = deck.draw(1)
		for card in cards:
			hand.add_to_hand(card, index)