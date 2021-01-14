--
-- Palm Tree
--

-- internationalization boilerplate
local S = minetest.get_translator(minetest.get_current_modname())

palm = {}

local ai = {name = "air", param1 = 000}
local tr = {name = "hades_palm:trunk", param1 = 255}
local tf = {name = "hades_palm:trunk", param1 = 255, force_place = true}
local lp = {name = "hades_palm:leaves", param1 = 255}
local cn = {name = "hades_palm:coconut", param1 = 255}

palm.palmtree = {

	size = {y = 9, x = 9, z = 9},

	data = {
		ai, ai, ai, ai, ai, ai, ai, ai, ai,
		ai, ai, ai, ai, ai, ai, ai, ai, ai,
		ai, ai, ai, ai, ai, ai, ai, ai, ai,
		ai, ai, ai, ai, ai, ai, ai, ai, ai,
		ai, ai, ai, ai, ai, ai, ai, ai, ai,
		ai, ai, ai, ai, ai, ai, ai, ai, ai,
		ai, ai, ai, ai, ai, ai, ai, ai, ai,
		ai, ai, ai, ai, ai, ai, ai, ai, ai,
		ai, ai, ai, ai, ai, ai, ai, ai, ai,

		ai, ai, ai, ai, ai, ai, ai, ai, ai,
		ai, ai, ai, ai, ai, ai, ai, ai, ai,
		ai, ai, ai, ai, ai, ai, ai, ai, ai,
		ai, ai, ai, ai, ai, ai, ai, ai, ai,
		ai, ai, ai, ai, ai, ai, ai, ai, ai,
		ai, ai, ai, ai, ai, lp, ai, ai, ai,
		ai, ai, ai, ai, ai, lp, ai, ai, ai,
		ai, ai, ai, ai, ai, ai, ai, ai, ai,
		ai, ai, ai, ai, ai, ai, ai, ai, ai,

		ai, ai, ai, ai, ai, ai, ai, ai, ai,
		ai, ai, ai, ai, ai, ai, ai, ai, ai,
		ai, ai, ai, ai, ai, ai, ai, ai, ai,
		ai, ai, ai, ai, ai, ai, ai, ai, ai,
		ai, ai, ai, ai, ai, ai, ai, ai, ai,
		ai, ai, ai, ai, ai, ai, ai, ai, ai,
		ai, ai, ai, ai, ai, lp, ai, ai, ai,
		ai, ai, ai, ai, ai, lp, ai, ai, ai,
		ai, ai, ai, ai, ai, ai, ai, ai, ai,

		ai, ai, ai, ai, ai, ai, ai, ai, ai,
		ai, ai, ai, ai, ai, ai, ai, ai, ai,
		ai, ai, ai, ai, ai, ai, ai, ai, ai,
		ai, ai, ai, ai, ai, ai, ai, ai, ai,
		ai, ai, ai, ai, ai, ai, ai, ai, ai,
		ai, ai, ai, ai, ai, ai, ai, ai, ai,
		ai, ai, ai, ai, ai, cn, ai, ai, ai,
		ai, ai, ai, ai, ai, lp, ai, ai, ai,
		ai, ai, ai, ai, ai, ai, ai, ai, ai,

		ai, ai, ai, ai, tf, ai, ai, ai, ai,
		ai, ai, ai, ai, tf, ai, ai, ai, ai,
		ai, ai, ai, ai, tr, ai, ai, ai, ai,
		ai, ai, ai, ai, tr, tr, ai, ai, ai,
		ai, ai, ai, ai, ai, tr, ai, ai, ai,
		ai, ai, lp, ai, ai, tr, ai, ai, lp,
		ai, ai, lp, lp, cn, tr, cn, lp, lp,
		ai, ai, ai, lp, lp, lp, lp, lp, ai,
		ai, ai, ai, ai, ai, lp, ai, ai, ai,

		ai, ai, ai, ai, ai, ai, ai, ai, ai,
		ai, ai, ai, ai, ai, ai, ai, ai, ai,
		ai, ai, ai, ai, ai, ai, ai, ai, ai,
		ai, ai, ai, ai, ai, ai, ai, ai, ai,
		ai, ai, ai, ai, ai, ai, ai, ai, ai,
		ai, ai, ai, ai, ai, ai, ai, ai, ai,
		ai, ai, ai, ai, ai, cn, ai, ai, ai,
		ai, ai, ai, ai, ai, lp, ai, ai, ai,
		ai, ai, ai, ai, ai, ai, ai, ai, ai,

		ai, ai, ai, ai, ai, ai, ai, ai, ai,
		ai, ai, ai, ai, ai, ai, ai, ai, ai,
		ai, ai, ai, ai, ai, ai, ai, ai, ai,
		ai, ai, ai, ai, ai, ai, ai, ai, ai,
		ai, ai, ai, ai, ai, ai, ai, ai, ai,
		ai, ai, ai, ai, ai, ai, ai, ai, ai,
		ai, ai, ai, ai, ai, lp, ai, ai, ai,
		ai, ai, ai, ai, ai, lp, ai, ai, ai,
		ai, ai, ai, ai, ai, ai, ai, ai, ai,

		ai, ai, ai, ai, ai, ai, ai, ai, ai,
		ai, ai, ai, ai, ai, ai, ai, ai, ai,
		ai, ai, ai, ai, ai, ai, ai, ai, ai,
		ai, ai, ai, ai, ai, ai, ai, ai, ai,
		ai, ai, ai, ai, ai, ai, ai, ai, ai,
		ai, ai, ai, ai, ai, lp, ai, ai, ai,
		ai, ai, ai, ai, ai, lp, ai, ai, ai,
		ai, ai, ai, ai, ai, ai, ai, ai, ai,
		ai, ai, ai, ai, ai, ai, ai, ai, ai,

		ai, ai, ai, ai, ai, ai, ai, ai, ai,
		ai, ai, ai, ai, ai, ai, ai, ai, ai,
		ai, ai, ai, ai, ai, ai, ai, ai, ai,
		ai, ai, ai, ai, ai, ai, ai, ai, ai,
		ai, ai, ai, ai, ai, ai, ai, ai, ai,
		ai, ai, ai, ai, ai, ai, ai, ai, ai,
		ai, ai, ai, ai, ai, ai, ai, ai, ai,
		ai, ai, ai, ai, ai, ai, ai, ai, ai,
		ai, ai, ai, ai, ai, ai, ai, ai, ai,
	}
}

local function can_grow(pos)
	local node_under = minetest.get_node_or_nil({x = pos.x, y = pos.y - 1, z = pos.z})
	if not node_under then
		return false
	end
	local name_under = node_under.name
	local is_soil = minetest.get_item_group(name_under, "sand")
	if is_soil == 0 then
		return false
	end
	local light_level = minetest.get_node_light(pos)
	if not light_level or light_level < 13 then
		return false
	end
	return true
end


local function grow_new_palm_tree(pos)
	if not can_grow(pos) then
		-- try a bit later again
		minetest.get_node_timer(pos):start(math.random(240, 600))
		return
	end
	minetest.remove_node(pos)
	minetest.place_schematic({x = pos.x - 4, y = pos.y, z = pos.z - 4},
		palm.palmtree, "0", nil, false)
end

--
-- Decoration
--

minetest.register_decoration({
	deco_type = "schematic",
	place_on = {"default:sand"},
		sidelen = 16,
		noise_params = {
			offset = 0.001,
			scale = 0.002,
			spread = {x = 250, y = 250, z = 250},
			seed = 2337,
			octaves = 3,
			persist = 0.66
		},
	biomes = {"sandstone_desert_ocean", "desert_ocean"},
	y_min = 1,
	y_max = 2,
	schematic = palm.palmtree,
	flags = "place_center_x, place_center_z",
	rotation = "random",
})

--
-- Nodes
--

minetest.register_node("hades_palm:sapling", {
	description = S("Palm Sapling"),
	drawtype = "plantlike",
	tiles = {"palm_sapling.png"},
	inventory_image = "palm_sapling.png",
	wield_image = "palm_sapling.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	on_timer = grow_new_palm_tree,
	selection_box = {
		type = "fixed",
		fixed = {-4 / 16, -0.5, -4 / 16, 4 / 16, 7 / 16, 4 / 16}
	},
	groups = {snappy = 2, dig_immediate = 3, flammable = 2,
		attached_node = 1, sapling = 1},
	sounds = hades_sounds.node_sound_leaves_defaults(),

	on_construct = function(pos)
		minetest.get_node_timer(pos):start(math.random(2400,4800))
	end,

	on_place = function(itemstack, placer, pointed_thing)
		itemstack = default.sapling_on_place(itemstack, placer, pointed_thing,
			"hades_palm:sapling",
			-- minp, maxp to be checked, relative to sapling pos
			-- minp_relative.y = 1 because sapling pos has been checked
			{x = -2, y = 1, z = -2},
			{x = 2, y = 6, z = 2},
			-- maximum interval of interior volume check
			4)

		return itemstack
	end,
})

-- palm trunk (thanks to VanessaE for palm textures)
minetest.register_node("hades_palm:trunk", {
	description = S("Palm Trunk"),
	tiles = {
		"palm_trunk_top.png",
		"palm_trunk_top.png",
		"palm_trunk.png"
	},
	groups = {tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2},
	sounds = hades_sounds.node_sound_wood_defaults(),
	paramtype2 = "facedir",
	is_ground_content = false,
	on_place = minetest.rotate_node,
})

-- palm wood
minetest.register_node("hades_palm:wood", {
	description = S("Palm Wood"),
	tiles = {"palm_wood.png"},
	is_ground_content = false,
	groups = {wood = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 3},
	sounds = hades_sounds.node_sound_wood_defaults(),
})

-- palm tree leaves
minetest.register_node("hades_palm:leaves", {
	description = S("Palm Leaves"),
	drawtype = "allfaces_optional",
	tiles = {"palm_leaves.png"},
	inventory_image = "palm_leaves.png",
	wield_image = "palm_leaves.png",
	paramtype = "light",
	walkable = true,
	waving = 1,
	groups = {snappy = 3, leafdecay = 3, leaves = 1, flammable = 2},
	drop = {
		max_items = 1,
		items = {
			{items = {"hades_palm:sapling"}, rarity = 10},
			{items = {"hades_palm:leaves"}}
		}
	},
	sounds = hades_sounds.node_sound_leaves_defaults(),
	after_place_node = default.after_place_leaves,
})

-- Coconut (Gives 4 coconut slices, each heal 1/2 heart)
minetest.register_node("hades_palm:coconut", {
	description = S("Coconut"),
	drawtype = "normal",
	walkable = false,
	paramtype = "light",
	sunlight_propagates = true,
	tiles = {"palm_coconut_top.png", "palm_coconut_side.png"},
	--inventory_image = "palm_coconut_side.png",
	--wield_image = "palm_coconut_side.png",
	selection_box = {
		type = "fixed",
		fixed = {-0.31, -0.43, -0.31, 0.31, 0.44, 0.31}
	},
	groups = {
		snappy = 1, oddly_breakable_by_hand = 1, cracky = 1,
		choppy = 1, flammable = 1, leafdecay = 3, leafdecay_drop = 1
	},
	drop = "hades_palm:coconut_slice 4",
	sounds = hades_sounds.node_sound_wood_defaults(),
})

-- Candle from Wax and String/Cotton
minetest.register_node("hades_palm:candle", {
	description = S("Coconut Wax Candle"),
	drawtype = "plantlike",
	inventory_image = "palm_candle_static.png",
	wield_image = "palm_candle_static.png",
	tiles = {
		{
			name = "palm_candle.png",
			animation={
				type="vertical_frames",
				aspect_w = 32,
				aspect_h = 32,
				length = 1.0
			}
		},
	},
	paramtype = "light",
	light_source = 11,
	sunlight_propagates = true,
	walkable = false,
	groups = {dig_immediate = 3, attached_node = 1},
	sounds = hades_sounds.node_sound_defaults(),
	selection_box = {
		type = "fixed",
		fixed = { -0.15, -0.5, -0.15, 0.15, 0, 0.15 }
	},
})

if minetest.get_modpath("doors") ~= nil then
	doors.register("door_palm", {
		tiles = {{ name = "palm_door_wood.png", backface_culling = true }},
		description = S("Palm Door"),
		inventory_image = "palm_door_wood_inv.png",
		groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2},
		recipe = {
			{"hades_palm:wood", "hades_palm:wood"},
			{"hades_palm:leaves", "hades_palm:leaves"},
			{"hades_palm:wood", "hades_palm:wood"},
		}
	})
end

--
-- Craftitems
--

-- Coconut Slice (Heals half heart when eaten)
minetest.register_craftitem("hades_palm:coconut_slice", {
	description = S("Coconut Slice"),
	inventory_image = "palm_coconut_slice.png",
	wield_image = "palm_coconut_slice.png",
	on_use = minetest.item_eat(1),
})

-- Palm Wax
minetest.register_craftitem("hades_palm:wax", {
	description = S("Palm Wax"),
	inventory_image = "palm_wax.png",
	wield_image = "palm_wax.png",
})

--
-- Recipes
--

minetest.register_craft({
	type = "cooking",
	cooktime = 10,
	output = "hades_palm:wax",
	recipe = "hades_palm:leaves"
})


minetest.register_craft({
	output = "hades_palm:wood 4",
	recipe = {{"hades_palm:trunk"}}
})

minetest.register_craft({
	output = "hades_palm:candle 2",
	recipe = {
		{"farming:cotton"},
		{"hades_palm:wax"},
		{"hades_palm:wax"},
	}
})

minetest.register_craft({
	type = "fuel",
	recipe = "hades_palm:sapling",
	burntime = 10,
})

minetest.register_craft({
	type = "fuel",
	recipe = "hades_palm:trunk",
	burntime = 34,
})

minetest.register_craft({
	type = "fuel",
	recipe = "hades_palm:wood",
	burntime = 9,
})

minetest.register_craft({
	type = "fuel",
	recipe = "hades_palm:leaves",
	burntime = 2,
})

minetest.register_lbm({
	name = "hades_palm:convert_palmtree_saplings_to_node_timer",
	nodenames = {"hades_palm:sapling"},
	action = function(pos)
		minetest.get_node_timer(pos):start(math.random(1200, 2400))
	end
})

--[[
default.register_leafdecay({
	trunks = {"hades_palm:trunk"},
	leaves = {"hades_palm:leaves", "hades_palm:coconut"},
	radius = 3,
})
--]]

--Stairs

if minetest.get_modpath("stairs") ~= nil then
	stairs.register_stair_and_slab(
		"palm_trunk",
		"hades_palm:trunk",
		{choppy = 2, oddly_breakable_by_hand = 2, flammable = 2},
		{"palm_wood.png"},
		S("Palm Tree Stair"),
		S("Outer Palm Tree Stair"),
		S("Inner Palm Tree Stair"),
		S("Palm Tree Slab"),
		hades_sounds.node_sound_wood_defaults()
	)
end

if minetest.get_modpath("bonemeal") ~= nil then
	bonemeal:add_sapling({
		{"hades_palm:sapling", grow_new_palm_tree, "soil"},
		{"hades_palm:sapling", grow_new_palm_tree, "sand"},
	})
end
