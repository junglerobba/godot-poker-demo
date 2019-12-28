extends Position2D
class_name Hand

export var limit: int = 5
export var cards: Array = []

signal cards_discarded

func init() -> void:
	cards = []

func add_to_hand(card: Card) -> void:
	card.connect("card_clicked", self, "card_in_hand_clicked")
	cards.append(card)
	add_child(card)
	update()

func on_draw() -> void:
	var amount: int = 0
	for card in cards:
		if !card.hold:
			amount += 1
			discard_card(card)
	emit_signal("cards_discarded", amount)
	for card in cards:
		card.hold = false
		card.update()

func discard_card(card: Card) -> void:
	var index = cards.find(card)
	card.disconnect("card_clicked", self, "card_in_hand_clicked")
	cards.erase(card)
	remove_child(card)

func card_in_hand_clicked(card: Card) -> void:
	card.toggle_hold()

static func sort_by_rank(a: Card, b: Card) -> bool:
	return a.rank < b.rank

func update() -> void:
	cards.sort_custom(self, "sort_by_rank")
	var offset = (cards.size() - 1)
	for i in range (0, cards.size()):
		cards[i].position = Vector2(i * 200, 0)
	for card in cards:
		card.position = card.position + Vector2(-offset, 0)