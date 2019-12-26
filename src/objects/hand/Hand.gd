extends Position2D
class_name Hand

var limit: int = 5
export var cards: Array = []

signal card_played

func add_to_hand(card: Card, index: int) -> void:
	card.connect("card_clicked", self, "card_in_hand_clicked")
	if (index == -1):
		cards.append(card)
	else:
		cards.insert(index, card)
	add_child(card)
	update()

func discard_card(card: Card) -> void:
	var index = cards.find(card)
	card.disconnect("card_clicked", self, "card_in_hand_clicked")
	cards.erase(card)
	remove_child(card)
	emit_signal("card_played", index, card)

func card_in_hand_clicked(card: Card) -> void:
	discard_card(card)

func update() -> void:
	var offset = (cards.size() - 1) * 36
	for i in range (0, cards.size()):
		cards[i].position = Vector2(i * 200, 0)
	for card in cards:
		card.position = card.position + Vector2(-offset, 0)