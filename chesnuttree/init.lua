--
-- Chesnuttree
--

local modname = "chesnuttree"
local modpath = minetest.get_modpath(modname)
local mg_name = minetest.get_mapgen_setting("mg_name")

-- internationalization boilerplate
local S = minetest.get_translator(minetest.get_current_modname())

--Chesnut Bur

minetest.register_node("chesnuttree:bur", {
	description = S("Chesnut Bur"),
	drawtype = "plantlike",
	tiles = {"chesnuttree_bur.png"},
	inventory_image = "chesnuttree_bur.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	is_ground_content = false,
	selection_box = {
		type = "fixed",
		fixed = {-3 / 16, -7 / 16, -3 / 16, 3 / 16, 4 / 16, 3 / 16}
	},
	groups = {fleshy = 3, dig_immediate = 3, flammable = 2,
		leafdecay = 3, leafdecay_drop = 1},
	on_use = minetest.item_eat(2),
	sounds = default.node_sound_leaves_defaults(),

	after_place_node = function(pos, placer, itemstack)
		minetest.set_node(pos, {name = "chesnuttree:bur", param2 = 1})
	end,
})

--Chesnut Fruit

minetest.register_craftitem("chesnuttree:fruit", {
	description = S("Chesnut"),
	inventory_image = "chesnuttree_fruit.png",	
	on_use = minetest.item_eat(2),
	groups = {flammable = 2, food = 2},
})

minetest.register_craft({
	output = "chesnuttree:fruit",
	recipe = {
		{'chesnuttree:bur'}
	}
})

-- chesnuttree

local function grow_new_chesnuttree_tree(pos)
	if not default.can_grow(pos) then
		-- try a bit later again
		minetest.get_node_timer(pos):start(math.random(240, 600))
		return
	end

	minetest.place_schematic({x = pos.x-6, y = pos.y, z = pos.z-6}, modpath.."/schematics/chesnuttree.mts", "0", nil, true)
end

--
-- Decoration
--

if mg_name ~= "v6" and mg_name ~= "singlenode" then
	minetest.register_decoration({
		deco_type = "schematic",
		place_on = {"default:dirt_with_grass"},
		sidelen = 16,
		noise_params = {
			offset = 0.00005,
			scale = 0.00004,
			spread = {x = 250, y = 250, z = 250},
			seed = 2,
			octaves = 3,
			persist = 0.66
		},
		biomes = {"grassland"},
		y_min = 1,
		y_max = 80,
		schematic = modpath.."/schematics/chesnuttree.mts",
		flags = "place_center_x, place_center_z,  force_placement",
		rotation = "random",
		place_offset_y = 1,
	})
end

--
-- Nodes
--

minetest.register_node("chesnuttree:sapling", {
	description = S("Chesnut Tree Sapling"),
	drawtype = "plantlike",
	visual_scale = 1.0,
	tiles = {"chesnuttree_sapling.png"},
	inventory_image = "chesnuttree_sapling.png",
	wield_image = "chesnuttree_sapling.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	on_timer = grow_new_chesnuttree_tree,
	selection_box = {
		type = "fixed",
		fixed = {-4 / 16, -0.5, -4 / 16, 4 / 16, 7 / 16, 4 / 16}
	},
	groups = {snappy = 2, dig_immediate = 3, flammable = 2,
		attached_node = 1, sapling = 1},
	sounds = default.node_sound_leaves_defaults(),

	on_construct = function(pos)
		minetest.get_node_timer(pos):start(math.random(2400,4800))
	end,

	on_place = function(itemstack, placer, pointed_thing)
		itemstack = default.sapling_on_place(itemstack, placer, pointed_thing,
			"chesnuttree:sapling",
			-- minp, maxp to be checked, relative to sapling pos
			-- minp_relative.y = 1 because sapling pos has been checked
			{x = -2, y = 1, z = -2},
			{x = 2, y = 6, z = 2},
			-- maximum interval of interior volume check
			4)

		return itemstack
	end,
})

minetest.register_node("chesnuttree:trunk", {
	description = S("Chesnut Tree Trunk"),
	tiles = {
		"chesnuttree_trunk_top.png",
		"chesnuttree_trunk_top.png",
		"chesnuttree_trunk.png"
	},
	groups = {tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2},
	sounds = default.node_sound_wood_defaults(),
	paramtype2 = "facedir",
	on_place = minetest.rotate_node,
})

-- chesnuttree wood
minetest.register_node("chesnuttree:wood", {
	description = S("Chesnut Tree Wood"),
	tiles = {"chesnuttree_wood.png"},
	is_ground_content = false,
	groups = {wood = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 3},
	sounds = default.node_sound_wood_defaults(),
})

-- chesnuttree tree leaves
minetest.register_node("chesnuttree:leaves", {
	description = S("Chesnut Tree Leaves"),
	drawtype = "allfaces_optional",
	visual_scale = 1.2,
	tiles = {"chesnuttree_leaves.png"},
	inventory_image = "chesnuttree_leaves.png",
	wield_image = "chesnuttree_leaves.png",
	paramtype = "light",
	walkable = true,
	waving = 1,
	groups = {snappy = 3, leafdecay = 3, leaves = 1, flammable = 2},
	drop = {
		max_items = 1,
		items = {
			{items = {"chesnuttree:sapling"}, rarity = 20},
			{items = {"chesnuttree:leaves"}}
		}
	},
	sounds = default.node_sound_leaves_defaults(),
	after_place_node = default.after_place_leaves,
})

--
-- Craftitems
--

--
-- Recipes
--

minetest.register_craft({
	output = "chesnuttree:wood 4",
	recipe = {{"chesnuttree:trunk"}}
})

minetest.register_craft({
	type = "fuel",
	recipe = "chesnuttree:trunk",
	burntime = 30,
})

minetest.register_craft({
	type = "fuel",
	recipe = "chesnuttree:wood",
	burntime = 7,
})


minetest.register_lbm({
	name = "chesnuttree:convert_chesnuttree_saplings_to_node_timer",
	nodenames = {"chesnuttree:sapling"},
	action = function(pos)
		minetest.get_node_timer(pos):start(math.random(1200, 2400))
	end
})

default.register_leafdecay({
	trunks = {"chesnuttree:trunk"},
	leaves = {"chesnuttree:leaves"},
	radius = 3,
})

--Stairs

if minetest.get_modpath("stairs") ~= nil then
	stairs.register_stair_and_slab(
		"chesnuttree_trunk",
		"chesnuttree:trunk",
		{choppy = 2, oddly_breakable_by_hand = 2, flammable = 2},
		{"chesnuttree_wood.png"},
		S("Chesnut Tree Stair"),
		S("Chesnut Tree Slab"),
		default.node_sound_wood_defaults()
	)
end
