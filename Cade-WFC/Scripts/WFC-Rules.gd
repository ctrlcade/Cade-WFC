extends Node
class_name WFCRules

var ruleset : Dictionary = {
	
	"Grass_0": {
		"mesh_label": "Grass",
		"mesh_rotation": 0,
		"constrain_to": "",
		"constrain_from": "",
		"mesh_weight": 1,
		"mesh_neighbours": [
			["Grass_0", "Grass_1", "Grass_2", "Grass_3", "Slope_0", "InCorner_0", "InCorner_3"],
			["Grass_0", "Grass_1", "Grass_2", "Grass_3", "Slope_1", "InCorner_0", "InCorner_1"],
			["Grass_0", "Grass_1", "Grass_2", "Grass_3", "Slope_2", "InCorner_1", "InCorner_2"],
			["Grass_0", "Grass_1", "Grass_2", "Grass_3", "Slope_3", "InCorner_2", "InCorner_3"],
			["Blank"],
			["Blank"]
		]
	},
	
	"Grass_1": {
		"mesh_label": "Tree",
		"mesh_rotation": 0,
		"constrain_to": "",
		"constrain_from": "",
		"mesh_weight": 1,
		"mesh_neighbours": [
			["Grass_0", "Slope_0", "InCorner_0", "InCorner_3"],
			["Grass_0", "Slope_1", "InCorner_0", "InCorner_1"],
			["Grass_0", "Slope_2", "InCorner_1", "InCorner_2"],
			["Grass_0", "Slope_3", "InCorner_2", "InCorner_3"],
			["Blank"],
			["Blank"]
		]
	},
	
	"Grass_2": {
		"mesh_label": "Flowers",
		"mesh_rotation": 0,
		"constrain_to": "",
		"constrain_from": "",
		"mesh_weight": 1,
		"mesh_neighbours": [
			["Grass_0", "Grass_1", "Grass_3", "Slope_0", "InCorner_0", "InCorner_3"],
			["Grass_0", "Grass_1", "Grass_3", "Slope_1", "InCorner_0", "InCorner_1"],
			["Grass_0", "Grass_1", "Grass_3", "Slope_2", "InCorner_1", "InCorner_2"],
			["Grass_0", "Grass_1", "Grass_3", "Slope_3", "InCorner_2", "InCorner_3"],
			["Blank"],
			["Blank"]
		]
	},
	
	"Grass_3": {
		"mesh_label": "Flowers",
		"mesh_rotation": 1,
		"constrain_to": "",
		"constrain_from": "",
		"mesh_weight": 1,
		"mesh_neighbours": [
			["Grass_0", "Grass_1", "Grass_2", "Slope_0", "InCorner_0", "InCorner_3"],
			["Grass_0", "Grass_1", "Grass_2", "Slope_1", "InCorner_0", "InCorner_1"],
			["Grass_0", "Grass_1", "Grass_2", "Slope_2", "InCorner_1", "InCorner_2"],
			["Grass_0", "Grass_1", "Grass_2", "Slope_3", "InCorner_2", "InCorner_3"],
			["Blank"],
			["Blank"]
		]
	},
	
	"Slope_0": {
		"mesh_label": "Slope",
		"mesh_rotation": 0,
		"constrain_to": "bot",
		"constrain_from": "",
		"mesh_weight": 1,
		"mesh_neighbours": [
			["Blank"],
			["Slope_0", "Corner_0", "InCorner_3"],
			["Grass_0", "Grass_1", "Grass_2", "Grass_3", "Slope_2", "InCorner_1", "InCorner_2"],
			["Slope_0", "Corner_3", "InCorner_0"],
			["Blank"],
			["Blank"]
		]
	},
	
	"Slope_1": {
		"mesh_label": "Slope",
		"mesh_rotation": 1,
		"constrain_to": "bot",
		"constrain_from": "",
		"mesh_weight": 1,
		"mesh_neighbours": [
			["Slope_1", "Corner_0", "InCorner_1"],
			["Blank"],
			["Slope_1", "Corner_1", "InCorner_0"],
			["Grass_0", "Grass_1", "Grass_2", "Grass_3", "Slope_3", "InCorner_2", "InCorner_3"],
			["Blank"],
			["Blank"]
		]
	},
	
	"Slope_2": {
		"mesh_label": "Slope",
		"mesh_rotation": 2,
		"constrain_to": "bot",
		"constrain_from": "",
		"mesh_weight": 1,
		"mesh_neighbours": [
			["Grass_0", "Grass_1", "Grass_2", "Grass_3", "Slope_0", "InCorner_0", "InCorner_3"],
			["Slope_2", "Corner_1", "InCorner_2"],
			["Blank"],
			["Slope_2", "Corner_2", "InCorner_1"],
			["Blank"],
			["Blank"]
		]
	},
	
	"Slope_3": {
		"mesh_label": "Slope",
		"mesh_rotation": 3,
		"constrain_to": "bot",
		"constrain_from": "",
		"mesh_weight": 1,
		"mesh_neighbours": [
			["Slope_3", "Corner_3", "InCorner_2"],
			["Grass_0", "Grass_1", "Grass_2", "Grass_3", "Slope_1", "InCorner_0", "InCorner_1"],
			["Slope_3", "Corner_2", "InCorner_3"],
			["Blank"],
			["Blank"],
			["Blank"]
		]
	},
	
	"Corner_0": {
		"mesh_label": "Corner",
		"mesh_rotation": 0,
		"constrain_to": "bot",
		"constrain_from": "",
		"mesh_weight": 1,
		"mesh_neighbours": [
			["Blank"],
			["Blank"],
			["Slope_1", "Corner_1", "InCorner_0"],
			["Slope_0", "Corner_3", "InCorner_0"],
			["Blank"],
			["Blank"]
		]
	},
	
	"Corner_1": {
		"mesh_label": "Corner",
		"mesh_rotation": 1,
		"constrain_to": "bot",
		"constrain_from": "",
		"mesh_weight": 1,
		"mesh_neighbours": [
			["Slope_1", "Corner_0", "InCorner_1"],
			["Blank"],
			["Blank"],
			["Slope_2", "Corner_2", "InCorner_1"],
			["Blank"],
			["Blank"]
		]
	},
	
	"Corner_2": {
		"mesh_label": "Corner",
		"mesh_rotation": 2,
		"constrain_to": "bot",
		"constrain_from": "",
		"mesh_weight": 1,
		"mesh_neighbours": [
			["Slope_3", "Corner_3", "InCorner_2"],
			["Slope_2", "Corner_1", "InCorner_2"],
			["Blank"],
			["Blank"],
			["Blank"],
			["Blank"]
		]
	},
	
	"Corner_3": {
		"mesh_label": "Corner",
		"mesh_rotation": 3,
		"constrain_to": "bot",
		"constrain_from": "",
		"mesh_weight": 1,
		"mesh_neighbours": [
			["Blank"],
			["Slope_0", "Corner_0", "InCorner_3"],
			["Slope_3", "Corner_2", "InCorner_3"],
			["Blank"],
			["Blank"],
			["Blank"]
		]
	},
	
	"InCorner_0": {
		"mesh_label": "InCorner",
		"mesh_rotation": 0,
		"constrain_to": "bot",
		"constrain_from": "",
		"mesh_weight": 1,
		"mesh_neighbours": [
			["Slope_1","Corner_0", "InCorner_1"],
			["Slope_0", "Corner_0", "InCorner_3"],
			["Grass_0", "Grass_1", "Grass_2", "Grass_3", "Slope_2", "InCorner_1", "InCorner_2"],
			["Grass_0", "Grass_1", "Grass_2", "Grass_3", "Slope_3", "InCorner_2", "InCorner_3"],
			["Blank"],
			["Blank"]
		]
	},
	
	"InCorner_1": {
		"mesh_label": "InCorner",
		"mesh_rotation": 1,
		"constrain_to": "bot",
		"constrain_from": "",
		"mesh_weight": 1,
		"mesh_neighbours": [
			["Grass_0", "Grass_1", "Grass_2", "Grass_3", "Slope_0", "InCorner_0", "InCorner_3"],
			["Slope_2", "Corner_1", "InCorner_2"],
			["Slope_1", "Corner_1", "InCorner_0"],
			["Grass_0", "Grass_1", "Grass_2", "Grass_3", "Slope_3", "InCorner_2", "InCorner_3"],
			["Blank"],
			["Blank"]
		]
	},
	
	"InCorner_2": {
		"mesh_label": "InCorner",
		"mesh_rotation": 2,
		"constrain_to": "bot",
		"constrain_from": "",
		"mesh_weight": 1,
		"mesh_neighbours": [
			["Grass_0", "Grass_1", "Grass_2", "Grass_3", "Slope_0", "InCorner_0", "InCorner_3"],
			["Grass_0", "Grass_1", "Grass_2", "Grass_3", "Slope_1", "InCorner_0", "InCorner_1"],
			["Slope_3", "Corner_2", "InCorner_3"],
			["Slope_2", "Corner_2", "InCorner_1"],
			["Blank"],
			["Blank"]
		]
	},
	
	"InCorner_3": {
		"mesh_label": "InCorner",
		"mesh_rotation": 3,
		"constrain_to": "bot",
		"constrain_from": "",
		"mesh_weight": 1,
		"mesh_neighbours": [
			["Slope_3", "Corner_3", "InCorner_2"],
			["Grass_0", "Grass_1", "Grass_2", "Grass_3", "Slope_1", "InCorner_0", "InCorner_1"],
			["Grass_0", "Slope_2", "InCorner_1", "InCorner_2"],
			["Slope_0", "Grass_1", "Grass_2", "Grass_3", "Corner_3", "InCorner_0"],
			["Blank"],
			["Blank"]
		]
	},
	
	"Blank": {
		"mesh_label": "Blank",
		"mesh_rotation": 0,
		"constrain_to": "-1",
		"constrain_from": "-1",
		"mesh_weight": 1,
		"mesh_neighbours": [
			["Slope_2", "Corner_1", "Corner_2", "Blank"],
			["Slope_3", "Corner_2", "Corner_3", "Blank"],
			["Slope_0", "Corner_0", "Corner_3", "Blank"],
			["Slope_1", "Corner_0", "Corner_1", "Blank"],
			["Grass_0", "Grass_1", "Grass_2", "Grass_3", "Slope_0", "Slope_1", "Slope_2", "Slope_3", "Corner_0", "Corner_1", 
			"Corner_2", "Corner_3", "InCorner_0", "InCorner_1","InCorner_2", "InCorner_3", "Blank"],
			["Grass_0", "Grass_1", "Grass_2", "Grass_3", "Slope_0", "Slope_1", "Slope_2", "Slope_3", "Corner_0", "Corner_1",
			"Corner_2", "Corner_3", "InCorner_0", "InCorner_1", "InCorner_2", "InCorner_3", "Blank"]
		]
	}
}
