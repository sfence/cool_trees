--
-- Oak
--

local modname = "oak"
local modpath = minetest.get_modpath(modname)
local mg_name = minetest.get_mapgen_setting("mg_name")

-- internationalization boilerplate
local S = minetest.get_translator(minetest.get_current_modname())

--Acorn

minetest.register_node("hades_oak:acorn", {
	description = S("Acorn"),
	drawtype = "plantlike",
	tiles = {"oak_acorn.png"},
	inventory_image = "oak_acorn.png",
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
	sounds = hades_sounds.node_sound_leaves_defaults(),

	after_place_node = function(pos, placer, itemstack)
		minetest.set_node(pos, {name = "hades_oak:acorn", param2 = 1})
	end,
})

-- oak

local function grow_new_oak_tree(pos)
	if not default.can_grow(pos) then
		-- try a bit later again
		minetest.get_node_timer(pos):start(math.random(1, 1))
		return
	end
	minetest.remove_node(pos)
	minetest.place_schematic({x = pos.x-5, y = pos.y, z = pos.z-5}, modpath.."/schematics/oak.mts", "0", nil, false)
end

--
-- Decoration
--

if mg_name ~= "v6" and mg_name ~= "singlenode" then

	if minetest.get_modpath("rainf") then
		place_on = "rainf:meadow"
		biomes = "rainf"
		offset = 0.0008
		scale = 0.00004
	else
		place_on = "default:dirt_with_grass"
		biomes = "grassland"
		offset = 0.0008
		scale = 0.00004
	end

	minetest.register_decoration({
		deco_type = "schematic",
		place_on = {place_on},
		sidelen = 16,
		noise_params = {
			offset = offset,
			scale = scale,
			spread = {x = 250, y = 250, z = 250},
			seed = 6431,
			octaves = 3,
			persist = 0.66
		},
		biomes = {biomes},
		y_min = 1,
		y_max = 80,
		schematic = modpath.."/schematics/oak.mts",
		flags = "place_center_x, place_center_z,  force_placement",
		rotation = "random",
		place_offset_y = 0,
	})
end

--
-- Nodes
--

minetest.register_node("hades_oak:sapling", {
	description = S("Oak Sapling"),
	drawtype = "plantlike",
	tiles = {"oak_sapling.png"},
	inventory_image = "oak_sapling.png",
	wield_image = "oak_sapling.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	on_timer = grow_new_oak_tree,
	selection_box = {
		type = "fixed",
		fixed = {-4 / 16, -0.5, -4 / 16, 4 / 16, 7 / 16, 4 / 16}
	},
	groups = {snappy = 2, dig_immediate = 3, flammable = 2,
		attached_node = 1, sapling = 1},
	sounds = hades_sounds.node_sound_leaves_defaults(),

	on_construct = function(pos)
		minetest.get_node_timer(pos):start(math.random(1,1))
	end,

	on_place = function(itemstack, placer, pointed_thing)
		itemstack = default.sapling_on_place(itemstack, placer, pointed_thing,
			"hades_oak:sapling",
			-- minp, maxp to be checked, relative to sapling pos
			-- minp_relative.y = 1 because sapling pos has been checked
			{x = -2, y = 1, z = -2},
			{x = 2, y = 6, z = 2},
			-- maximum interval of interior volume check
			4)

		return itemstack
	end,
})

minetest.register_node("hades_oak:trunk", {
	description = S("Oak Trunk"),
	tiles = {
		"oak_trunk_top.png",
		"oak_trunk_top.png",
		"oak_trunk.png"
	},
	groups = {tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2},
	sounds = hades_sounds.node_sound_wood_defaults(),
	paramtype2 = "facedir",
	on_place = minetest.rotate_node,
})

-- oak wood
minetest.register_node("hades_oak:wood", {
	description = S("Oak Wood"),
	tiles = {"oak_wood.png"},
	is_ground_content = false,
	groups = {wood = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 3},
	sounds = hades_sounds.node_sound_wood_defaults(),
})

-- oak tree leaves
minetest.register_node("hades_oak:leaves", {
	description = S("Oak Leaves"),
	drawtype = "allfaces_optional",
	tiles = {"oak_leaves.png"},
	inventory_image = "oak_leaves.png",
	wield_image = "oak_leaves.png",
	paramtype = "light",
	walkable = true,
	waving = 1,
	groups = {snappy = 3, leafdecay = 3, leaves = 1, flammable = 2},
	drop = {
		max_items = 1,
		items = {
			{items = {"hades_oak:sapling"}, rarity = 20},
			{items = {"hades_oak:leaves"}}
		}
	},
	sounds = hades_sounds.node_sound_leaves_defaults(),
	after_place_node = default.after_place_leaves,
})

--
-- Craftitems
--

--
-- Recipes
--

minetest.register_craft({
	output = "hades_oak:wood 4",
	recipe = {{"hades_oak:trunk"}}
})

minetest.register_craft({
	type = "fuel",
	recipe = "hades_oak:trunk",
	burntime = 30,
})

minetest.register_craft({
	type = "fuel",
	recipe = "hades_oak:wood",
	burntime = 7,
})


minetest.register_lbm({
	name = "hades_oak:convert_oak_saplings_to_node_timer",
	nodenames = {"hades_oak:sapling"},
	action = function(pos)
		minetest.get_node_timer(pos):start(math.random(1, 1))
	end
})

--[[
default.register_leafdecay({
	trunks = {"hades_oak:trunk"},
	leaves = {"hades_oak:leaves"},
	radius = 3,
})
--]]

--Stairs

if minetest.get_modpath("stairs") ~= nil then
	stairs.register_stair_and_slab(
		"oak_trunk",
		"hades_oak:trunk",
		{choppy = 2, oddly_breakable_by_hand = 2, flammable = 2},
		{"oak_wood.png"},
		S("Oak Stair"),
		S("Outer Oak Stair"),
		S("Inner Oak Stair"),
		S("Oak Slab"),
		hades_sounds.node_sound_wood_defaults()
	)
end

if minetest.get_modpath("bonemeal") ~= nil then
	bonemeal:add_sapling({
		{"hades_oak:sapling", grow_new_oak_tree, "soil"},
	})
end

if minetest.get_modpath("doors") ~= nil then
	doors.register("door_oak_wood", {
			tiles = {{ name = "oak_door_wood.png", backface_culling = true }},
			description = S("Oak Wood Door"),
			inventory_image = "oak_item_wood.png",
			groups = {node = 1, choppy = 2, oddly_breakable_by_hand = 2, flammable = 2},
			recipe = {
				{"hades_oak:wood", "hades_oak:wood"},
				{"hades_oak:wood", "hades_oak:wood"},
				{"hades_oak:wood", "hades_oak:wood"},
			}
	})
end
