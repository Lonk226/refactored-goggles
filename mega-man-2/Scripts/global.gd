extends Node

var on_ladder = false
var underwater = false
var mega_man_health = 28
var facing_right = true
var player_invincible = false
var current_weapon: weapons = weapons.buster

signal damage_player()

enum weapons{buster, air, crash, metal, bubble, quick, wood, flash, heat, item_one, item_two, item,_three}
