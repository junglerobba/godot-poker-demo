extends Position2D
class_name Hand

var limit: int = 5
export var cards: Array = []

signal card_played

func add_to_hand(card: Card) -> void:
	card.connect("card_clicked", self, "card_in_hand_clicked")
	cards.append(card)
	add_child(card)
	update()

func discard_card(card: Card) -> void:
	cards.erase(card)
	remove_child(card)

func card_in_hand_clicked(card: Card) -> void:
	discard_card(card)

func update() -> void:
	var offset = (cards.size() - 1) * 36
	for i in range (0, cards.size()):
		cards[i].position = Vector2(i * 200, 0)
	for card in cards:
		card.position = card.position + Vector2(-offset, 0)