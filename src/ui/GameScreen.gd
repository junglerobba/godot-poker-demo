extends Node2D

onready var deck = $Deck
onready var hand = $Hand

func _ready() -> void:
	deck.connect("pressed", self, "on_deck_pressed")

func on_deck_pressed() -> void:
	if hand.cards.size() != 0:
		return
	var cards: Array = deck.draw(5)
	for card in cards:
		hand.add_to_hand(card)