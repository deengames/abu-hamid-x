extends Node

export (Dictionary) var config = {
    "enable_sword": true,
    "flying_attacks": true,
    "enable_gun": true,
    "enable_boost": false,
    "enable_float_down": false
}

export (int) var FINAL_WAVE_NUMBER = 5

# Map of preloaded_enemy_scene => point cost
# Used to determine which sets of enemies spawn in which scenarios
export (Dictionary) var current_spawns = {}
# What waves (eg. 3) and what special things to spawn (eg. giant) on them
export (Dictionary) var special_spawns = {}