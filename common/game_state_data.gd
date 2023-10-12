class_name GameStateData
extends Resource


const HOLE_PENALTY : int = -100000
const HOLE_MINE_PENALTY : int = -25000
const GOLD_VALUE : int = 15000
const DIAMOND_VALUE : int = 65000
const BAT_PENALTY : int = -25000

var level : int = 1
var hole_flags_left : int = 0
var gold_flags_left : int = 0
var diamond_flags_left : int = 0
var money : int = 0
var time : float = 0.0
var paused : bool = true
var game_over : bool = false

