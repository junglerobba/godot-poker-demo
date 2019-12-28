extends Node2D

enum HandRanks {
	ROYAL_FLUSH,
	STRAIGHT_FLUSH,
	FOUR_OF_A_KIND,
	FULL_HOUSE,
	FLUSH,
	STRAIGHT,
	THREE_OF_A_KIND,
	TWO_PAIR,
	PAIR,
	HIGH_CARD
}

onready var deck = $Deck
onready var hand = $Hand
onready var turn_button = $TurnButton
onready var draw_button = $DrawButton
onready var win_label = $WinLabel

var redraws: int

func _ready() -> void:
	turn_button.text = tr("end_turn")
	draw_button.text = tr("draw")
	turn_button.hide()
	draw_button.hide()
	deck.connect("pressed", self, "on_deck_pressed")
	hand.connect("card_played", self, "on_card_played")
	init()

func init() -> void:
	win_label.text = ""
	deck.create_deck()
	hand.init()

func on_deck_pressed() -> void:
	if win_label.text.length() > 0:
		init()
	if hand.cards.size() != 0:
		return
	turn_button.show()
	draw_button.show()
	redraws = 0
	var cards: Array = deck.draw(5)
	for card in cards:
		hand.add_to_hand(card, -1)

func on_card_played(index: int, card_played: Card) -> void:
	if hand.cards.size() < 5:
		redraws += 1
		var cards: Array = deck.draw(1)
		for card in cards:
			hand.add_to_hand(card, index)
	if redraws >= 1:
		end_turn()


func evaluate_hand(cards: Array) -> int:
	var res: int = histogram(cards)
	if res != -1:
		return res
	if is_royal_flush(cards):
		return HandRanks.ROYAL_FLUSH
	if is_straight(cards) && is_flush(cards):
		return HandRanks.STRAIGHT_FLUSH
	if is_flush(cards):
		return HandRanks.FLUSH
	if is_straight(cards):
		return HandRanks.STRAIGHT
	return HandRanks.HIGH_CARD

func is_flush(cards: Array) -> bool:
	var suit = cards[0].suit
	var res: = true
	for card in cards:
		if card.suit != suit:
			res = false
	return res

func is_straight(cards: Array) -> bool:
	cards.sort_custom(Hand, "sort_by_rank")
	return cards[cards.size() - 1].rank - cards[0].rank == 4

func is_royal_flush(cards: Array) -> bool:
	cards.sort_custom(Hand, "sort_by_rank")
	return is_flush(cards) && is_straight(cards) && cards[cards.size() - 1].rank == CardData.Ranks.ACE

func histogram(cards: Array) -> int:
	var ranks: = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
	var histogram: = []
	for card in cards:
		ranks[card.rank] += 1
	for i in range (0, ranks.size()):
		if ranks[i] != 0:
			histogram.push_back(ranks[i])
	histogram.sort()
	histogram.invert()
	if histogram == [4, 1]:
		return HandRanks.FOUR_OF_A_KIND
	if histogram == [3, 2]:
		return HandRanks.FULL_HOUSE
	if histogram == [3, 1, 1]:
		return HandRanks.THREE_OF_A_KIND
	if histogram == [2, 2, 1]:
		return HandRanks.TWO_PAIR
	if histogram.size() == 4:
		return HandRanks.PAIR
	return -1

func _on_TurnButton_button_up() -> void:
	end_turn()

func end_turn() -> void:
	print("end turn")
	var result = evaluate_hand(hand.cards)
	turn_button.hide()
	draw_button.hide()
	win_label.text = tr(HandRanks.keys()[result].to_lower())

func _on_DrawButton_button_up() -> void:
	hand.on_draw()