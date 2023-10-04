class_name GameStateData
extends Resource


const HOLE_PENALTY : int = -100000
const HOLE_MINE_PENALTY : int = -50000
const GOLD_VALUE : int = 20000
const DIAMOND_VALUE : int = 80000
const BAT_PENALTY : int = -50000

var level : int = 1
var hole_flags_left : int = 0
var gold_flags_left : int = 0
var diamond_flags_left : int = 0
var money : int = 0
var time : float = 0.0
var paused : bool = true
var game_over : bool = false

