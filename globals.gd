extends Node

var score: int = 0
var score_high: int = 0

enum collision {
	DO_NOT_USE = 0,
	GROUND = 1,
	WALL = 2,
	ENEMY = 3,
	PLATFORM = 4,
	PLAYER = 5,
	PLAYER_WRAP = 6,
	KILLER_GAP = 7,
}
