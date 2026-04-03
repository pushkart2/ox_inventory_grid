return {
    ----------------------------------------------------------------
    -- REMOMVED BUT LEFT IN FOR CONFIG STRUCTURE REFRERENCE
    ----------------------------------------------------------------


    -- ['testburger'] = {
    --     label = 'Test Burger',
    --     weight = 220,
    --     degrade = 60,
    --     client = {
    --         image = 'burger_chicken.png',
    --         status = { hunger = 200000 },
    --         anim = 'eating',
    --         prop = 'burger',
    --         usetime = 2500,
    --         export = 'ox_inventory_examples.testburger'
    --     },
    --     server = {
    --         export = 'ox_inventory_examples.testburger',
    --         test = 'what an amazingly delicious burger, amirite?'
    --     },
    --     buttons = {
    --         {
    --             label = 'Lick it',
    --             action = function(slot)
    --                 print('You licked the burger')
    --             end
    --         },
    --         {
    --             label = 'Squeeze it',
    --             action = function(slot)
    --                 print('You squeezed the burger :(')
    --             end
    --         },
    --         {
    --             label = 'What do you call a vegan burger?',
    --             group = 'Hamburger Puns',
    --             action = function(slot)
    --                 print('A misteak.')
    --             end
    --         },
    --         {
    --             label = 'What do frogs like to eat with their hamburgers?',
    --             group = 'Hamburger Puns',
    --             action = function(slot)
    --                 print('French flies.')
    --             end
    --         },
    --         {
    --             label = 'Why were the burger and fries running?',
    --             group = 'Hamburger Puns',
    --             action = function(slot)
    --                 print('Because they\'re fast food.')
    --             end
    --         }
    --     },
    --     consume = 0.3
    -- },

    -- ['burger'] = {
    --     label = 'Burger',
    --     weight = 220,
    --     client = {
    --         status = { hunger = 200000 },
    --         anim = 'eating',
    --         prop = 'burger',
    --         usetime = 2500,
    --         notification = 'You ate a delicious burger'
    --     },
    -- },

    -- ['sprunk'] = {
    --     label = 'Sprunk',
    --     weight = 350,
    --     client = {
    --         status = { thirst = 200000 },
    --         anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
    --         prop = { model = `prop_ld_can_01`, pos = vec3(0.01, 0.01, 0.06), rot = vec3(5.0, 5.0, -180.5) },
    --         usetime = 2500,
    --         notification = 'You quenched your thirst with a sprunk'
    --     }
    -- },

    -- ['phone'] = {
    --     label = 'Phone',
    --     weight = 190,
    --     stack = false,
    --     consume = 0,
    --     client = {
    --         add = function(total)
    --             if total > 0 then
    --                 pcall(function() return exports.npwd:setPhoneDisabled(false) end)
    --             end
    --         end,

    --         remove = function(total)
    --             if total < 1 then
    --                 pcall(function() return exports.npwd:setPhoneDisabled(true) end)
    --             end
    --         end
    --     }
    -- },

    ----------------------------------------------------------------
    -- COSMETIC / MISC FUN
    ----------------------------------------------------------------
    ['garbage'] = {
        label = 'Garbage',
    },

    ['paperbag'] = {
        label = 'Paper Bag',
        weight = 10,
        stack = false,
        close = false,
        consume = 0
    },

    ['panties'] = {
        label = 'Knickers',
        weight = 10,
        consume = 0,
        client = {
            status = { thirst = -100000, stress = -25000 },
            anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
            prop = { model = `prop_cs_panties_02`, pos = vec3(0.03, 0.0, 0.02), rot = vec3(0.0, -13.5, -1.5) },
            usetime = 2500,
        }
    },

    ['stickynote'] = {
        label = 'Sticky Note',
        weight = 1,
    },

    ----------------------------------------------------------------
    -- FOOD & DRINK
    ----------------------------------------------------------------
    -- ['mustard'] = {
    --     label = 'Mustard',
    --     weight = 250,
    --     client = {
    --         status = { hunger = 25000, thirst = 25000 },
    --         anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
    --         prop = { model = `prop_food_mustard`, pos = vec3(0.01, 0.0, -0.07), rot = vec3(1.0, 1.0, -1.5) },
    --         usetime = 2500,
    --         notification = 'You... drank mustard'
    --     }
    -- },

    ['flour'] = {
        label = 'Flour',
        weight = 500,
        stack = true,
        close = true,
        description = 'Basic baking ingredient, used for bread and other foods.'
    },

    ['dough'] = {
        label = 'Dough',
        weight = 500,
        stack = true,
        close = true,
        degrade = 7 * 24 * 60,
		decay = true,
        description = 'Used for baking bread and other foods.'
    },


    ['mre']                 = {
        label = 'MRE Pack',
        weight = 500,
        stack = true,
        close = true,
        degrade = 14 * 24 * 60,
		decay = true,
        description = 'Meal Ready-to-Eat. Shelf-stable ration for long-term survival.'
    },

    ['canned_food']         = {
        label = 'Canned Food',
        weight = 220,
        stack = true,
        close = true,
        degrade = 14 * 24 * 60,
		decay = true,
        description = 'Non-perishable canned food. Safe to eat cold or heated.'
    },

    ['pottedmeat']          = {
        label = 'Potted Meat',
        weight = 180,
        stack = true,
        close = true,
        degrade = 14 * 24 * 60,
		decay = true,
        description = 'Processed canned meat. Not pretty, but it keeps you alive.'
    },

    ['sardines']            = {
        label = 'Canned Sardines',
        weight = 60,
        stack = true,
        close = true,
        degrade = 14 * 24 * 60,
		decay = true,
        description = 'Salty canned fish, high in protein.'
    },

    ['bread']               = {
        label = 'Bread',
        weight = 180,
        stack = true,
        close = true,
        degrade = 14 * 24 * 60,
		decay = true,
        description = 'Simple loaf of bread. Good base for a meal.'
    },

    -- ['wine']                = {
    --     label = 'Wine',
    --     weight = 250,
    -- },

    -- ['grape']               = {
    --     label = 'Grape',
    --     weight = 5,
    -- },

    -- ['grapejuice']          = {
    --     label = 'Grape Juice',
    --     weight = 100,
    -- },

    -- ['coffee']              = {
    --     label = 'Coffee',
    --     weight = 100,
    -- },

    -- ['vodka']               = {
    --     label = 'Vodka',
    --     weight = 250,
    -- },

    -- ['whiskey']             = {
    --     label = 'Whiskey',
    --     weight = 250,
    -- },

    ['beer']                = {
        label = 'beer',
        weight = 175,
    },

    -- ['sandwich']            = {
    --     label = 'Sandwich',
    --     weight = 55,
    -- },

    ----------------------------------------------------------------
    -- ARMOR, CLOTHING, ACCESSORIES
    ----------------------------------------------------------------
    -- ['armour']              = {  DO NOT USE IN OUTBREAK
    --     label = 'Bulletproof Vest',
    --     weight = 620,
    --     stack = false,
    --     client = {
    --         anim = { dict = 'clothingshirt', clip = 'try_shirt_positive_d' },
    --         usetime = 3500
    --     }
    -- },

    -- ['clothing']            = {
    --     label = 'Clothing',
    --     consume = 0,
    -- },

    ['harness']             = {
        label = 'Harness',
        weight = 300,
    },

    ----------------------------------------------------------------
    -- CURRENCY & DOCUMENTS
    ----------------------------------------------------------------
    ['gold_coin']           = {
        label = 'Gold Coin',
    },

    ['diamond_ring']        = {
        label = 'Diamond',
        weight = 30,
    },

    ['rolex']               = {
        label = 'Golden Watch',
        weight = 30,
    },

    ['goldbar']             = {
        label = 'Gold Bar',
        weight = 2000,
    },

    ['goldchain']           = {
        label = 'Golden Chain',
        weight = 90,
    },

    ['id_card']             = {
        label = 'Identification Card',
    },

    ['driver_license']      = {
        label = 'Drivers License',
    },

    ['weaponlicense']       = {
        label = 'Weapon License',
    },

    ['lawyerpass']          = {
        label = 'Lawyer Pass',
    },

    ['prop_money_bag_01']   = {
        label = 'Bag',
        weight = 100,
    },

    ----------------------------------------------------------------
    -- RADIOS & ELECTRONICS
    ----------------------------------------------------------------
    ['radio']               = {
        label = 'Radio',
        weight = 600,
        allowArmed = true,
        consume = 0,
        client = {
            event = 'mm_radio:client:use'
        }
    },

    ['jammer']              = {
        label = 'Radio Jammer',
        weight = 10000,
        allowArmed = true,
        client = {
            event = 'mm_radio:client:usejammer'
        }
    },

    ['radiocell']           = {
        label = 'AAA Cells',
        weight = 25,
        stack = true,
        allowArmed = true,
        client = {
            event = 'mm_radio:client:recharge'
        }
    },

    ['electronickit']       = {
        label = 'Electronic Kit',
        weight = 250,
    },

    ['cryptostick']         = {
        label = 'Crypto Stick',
        weight = 50,
    },

    ['trojan_usb']          = {
        label = 'Trojan USB',
        weight = 50,
    },

    ['small_tv']            = {
        label = 'Small TV',
        weight = 100,
    },

    ['keypad']              = {
        label = 'KeyPad',
        weight = 50,
        stack = false,
        consume = 0,
    },

    ['redkey']              = {
        label = 'Red Key',
        weight = 50,
        stack = false,
        consume = 0,
    },

    ["crafting_blueprints"] = {
        label = "Crafting Blueprint",
        weight = 0,
        stack = false,
        consume = 0,
        client = {
            image = 'blueprint.png',
        },
    },

    ----------------------------------------------------------------
    -- TOOLS, KITS & UTILITY ITEMS
    ----------------------------------------------------------------
    ['parachute']           = {
        label = 'Parachute',
        weight = 2000,
        stack = false,
        client = {
            anim = { dict = 'clothingshirt', clip = 'try_shirt_positive_d' },
            usetime = 1500
        }
    },

    ['lockpick']            = {
        label = 'Lockpick',
        weight = 12,
        stack = true,
        close = true,
        description = 'Useful for opening locked things... quietly.'
    },

    ['advancedlockpick']    = {
        label = 'Advanced Lockpick',
        weight = 30,
    },

    ['screwdriverset']      = {
        label = 'Screwdriver Set',
        weight = 454,
    },

    ['cleaningkit']         = {
        label = 'Cleaning Kit',
        weight = 70,
    },

    ['repairkit']           = {
        label = 'Repair Kit',
        weight = 670,
    },

    ['advancedrepairkit']   = {
        label = 'Advanced Repair Kit',
        weight = 1250,
    },

    ['drill']               = {
        label = 'Drill',
        weight = 660,
    },

    ['thermite']            = {
        label = 'Thermite',
        weight = 125,
    },

    ['toaster']             = {
        label = 'Toaster',
        weight = 340,
    },

    ['walking_stick']       = {
        label = 'Walking Stick',
        weight = 70,
    },

    ['lighter']             = {
        label = 'Lighter',
        weight = 35,
    },

    ['binoculars']          = {
        label = 'Binoculars',
        weight = 125,
    },

    ['empty_evidence_bag']  = {
        label = 'Empty Evidence Bag',
        weight = 250,
    },

    ['filled_evidence_bag'] = {
        label = 'Filled Evidence Bag',
        weight = 500,
    },

    ['handcuffs']           = {
        label = 'Handcuffs',
        weight = 25,
    },

    ['airdropcaller1']      = {
        label = 'Airdrop Caller 1',
        weight = 1,
        stack = false,
        close = true,
        description = 'A device used to call in airdrops.'
    },

    ['airdropcaller2']      = {
        label = 'Airdrop Caller 2',
        weight = 1,
        stack = false,
        close = true,
        description = 'A device used to call in airdrops.'
    },

    ----------------------------------------------------------------
    -- MEDICAL / STIMS / CHEMS
    ----------------------------------------------------------------
    ['chillpill']           = {
        label = 'Chill Pill',
        weight = 38,
        stack = true,
        close = true,
        description = 'A pill to make you, um, chill.'
    },

    ['rad_cure']            = {
        label = 'Rad Cure',
        weight = 40,
        stack = true,
        close = true,
        description = 'A pill that neutralizes radiation in your body.'
    },
    ['blood']               = {
        label = 'Blood Bag',
        weight = 225,
        stack = true,
        close = true,
        description = 'A stored unit of blood for medical use.'
    },

    ['needles']             = {
        label = 'Needles',
        weight = 30,
        stack = true,
        close = true,
        description = 'Sterile needles used for injections or medical procedures.'
    },

    ['antiseptic']          = {
        label = 'Antiseptic',
        weight = 120,
        stack = true,
        close = true,
        description = 'Disinfectant used to clean wounds and prevent infection.'
    },

    ['firstaid']            = {
        label = 'First Aid Kit',
        weight = 670,
        stack = true,
        close = true,
        description = 'A compact kit containing basic medical supplies.'
    },

    ['health_shot']         = {
        label = 'Health Shot',
        weight = 40,
        stack = true,
        close = true,
        degrade = 14 * 24 * 60,
		decay = true,
        description = 'A fast-acting medical injection to stabilize minor injuries.'
    },

    ['adrenaline_shot']     = {
        label = 'Adrenaline Shot',
        weight = 40,
        stack = true,
        close = true,
        degrade = 14 * 24 * 60,
		decay = true,
        description = 'Temporary boost to reflexes and energy. Use with caution.'
    },

    ['antibiotic_shot']     = {
        label = 'Antibiotic Shot',
        weight = 40,
        stack = true,
        close = true,
        degrade = 14 * 24 * 60,
		decay = true,
        description = 'Injection used to combat infections.'
    },

    ['hydration_shot']      = {
        label = 'Hydration Shot',
        weight = 40,
        stack = true,
        close = true,
        degrade = 14 * 24 * 60,
		decay = true,
        description = 'Electrolyte-packed injection to restore hydration quickly.'
    },

    ['stamina_shot']        = {
        label = 'Stamina Shot',
        weight = 40,
        stack = true,
        close = true,
        degrade = 14 * 24 * 60,
		decay = true,
        description = 'Boosts stamina for extended physical activity.'
    },

    ['anti-fatigue_shot']   = {
        label = 'Anti-Fatigue Shot',
        weight = 40,
        stack = true,
        close = true,
        degrade = 14 * 24 * 60,
		decay = true,
        description = 'Designed to reduce exhaustion and keep you going longer.'
    },

    ['saline']              = {
        label = 'Saline Bag',
        weight = 225,
        stack = true,
        close = true,
        description = 'IV saline solution, used to rehydrate and stabilize patients.'
    },

    ['ifaks']               = {
        label = 'Individual First Aid Kit',
        weight = 630,
    },

    ['painkillers']         = {
        label = 'Painkillers',
        weight = 12,
    },

    ['bandage']             = {
        label = 'Bandage',
        weight = 40
    },

    ----------------------------------------------------------------
    -- FIREWORKS
    ----------------------------------------------------------------
    ['firework1']           = {
        label = '2Brothers',
        weight = 1000,
    },

    ['firework2']           = {
        label = 'Poppelers',
        weight = 1000,
    },

    ['firework3']           = {
        label = 'WipeOut',
        weight = 1000,
    },

    ['firework4']           = {
        label = 'Weeping Willow',
        weight = 1000,
    },

    ----------------------------------------------------------------
    -- RESOURCES / ORES / CRAFTING MATERIALS
    ----------------------------------------------------------------
    ['wood']                = {
        label = 'Wood',
        weight = 125,
    },

    ['stone']               = {
        label = 'Stone',
        weight = 175,
    },

    ['steel']               = {
        label = 'Steel',
        weight = 320,
    },

    ['rubber']              = {
        label = 'Rubber',
        weight = 60,
    },

    ['metalscrap']          = {
        label = 'Metal Scrap',
        weight = 60,
    },

    ['iron']                = {
        label = 'Iron',
        weight = 275,
    },

    ['iron_ore']            = {
        label = 'Iron Ore',
        weight = 425,
        stack = true,
        close = true,
        description = 'Raw iron ore, used for metal production.'
    },

    ['copper']              = {
        label = 'Copper',
        weight = 475,
    },

    ['copper_ore']          = {
        label = 'Copper Ore',
        weight = 475,
        stack = true,
        close = true,
        description = 'Raw copper ore, ready to be processed.'
    },

    ['aluminium']           = {
        label = 'Aluminium',
        weight = 250,
    },

    ['aluminium_ore']        = {
        label = 'Aluminum Ore',
        weight = 250,
        stack = true,
        close = true,
        description = 'Raw Aluminium ore, lightweight but sturdy when processed.'
    },

    ['plastic']             = {
        label = 'Plastic',
        weight = 125,
    },

    ['glass']               = {
        label = 'Glass',
        weight = 175,
    },

    ['cable']               = {
        label = 'Cable',
        weight = 100,
    },

    ['cables']              = {
        label = 'Cables',
        weight = 75,
        stack = true,
        close = true,
        description = 'Various electrical cables.'
    },

    ['cement']              = {
        label = 'Cement',
        weight = 1250,
        stack = true,
        close = true,
        description = 'A bag of cement mix for construction.'
    },

    ['string']              = {
        label = 'String',
        weight = 15,
        stack = true,
        close = true,
        description = 'Thin string, handy for small crafting jobs.'
    },

    ['cloth']               = {
        label = 'Cloth',
        weight = 85,
        stack = true,
        close = true,
        description = 'Well, it is what it says.'
    },

    ['rope']                = {
        label = 'Rope',
        weight = 80,
        stack = true,
        close = true,
        description = 'Sturdy rope for climbing, tying, or securing supplies.'
    },

    ['duct_tape']           = {
        label = 'Duct Tape',
        weight = 40,
        stack = true,
        close = true,
        description = 'Fixes almost anything. Almost.'
    },

    ['acid']                = {
        label = 'Acid',
        weight = 125,
        stack = true,
        close = true,
        description = 'Corrosive chemical. Handle with extreme care.'
    },

    ['nails']               = {
        label = 'Nails',
        weight = 15,
        stack = true,
        close = true,
        description = 'Small metal nails used for building and repairs.'
    },



    ----------------------------------------------------------------
    -- DRUGS & NARCOTICS
    ----------------------------------------------------------------
    ['crack_baggy']           = {
        label = 'Crack Baggy',
        weight = 100,
    },

    ['cokebaggy']             = {
        label = 'Bag of Coke',
        weight = 100,
    },

    ['coke_brick']            = {
        label = 'Coke Brick',
        weight = 2000,
    },

    ['coke_small_brick']      = {
        label = 'Coke Package',
        weight = 1000,
    },

    ['xtcbaggy']              = {
        label = 'Bag of Ecstasy',
        weight = 100,
    },

    ['meth']                  = {
        label = 'Methamphetamine',
        weight = 10,
    },

    ['oxy']                   = {
        label = 'Oxycodone',
        weight = 10,
    },

    ['weed_ak47']             = {
        label = 'AK47 2g',
        weight = 2,
    },

    ['weed_ak47_seed']        = {
        label = 'AK47 Seed',
        weight = 1,
    },

    ['weed_skunk']            = {
        label = 'Skunk 2g',
        weight = 2,
    },

    ['weed_skunk_seed']       = {
        label = 'Skunk Seed',
        weight = 1,
    },

    ['weed_amnesia']          = {
        label = 'Amnesia 2g',
        weight = 2,
    },

    ['weed_amnesia_seed']     = {
        label = 'Amnesia Seed',
        weight = 1,
    },

    ['weed_og-kush']          = {
        label = 'OGKush 2g',
        weight = 2,
    },

    ['weed_og-kush_seed']     = {
        label = 'OGKush Seed',
        weight = 1,
    },

    ['weed_white-widow']      = {
        label = 'OGKush 2g',
        weight = 2,
    },

    ['weed_white-widow_seed'] = {
        label = 'White Widow Seed',
        weight = 1,
    },

    ['weed_purple-haze']      = {
        label = 'Purple Haze 2g',
        weight = 2,
    },

    ['weed_purple-haze_seed'] = {
        label = 'Purple Haze Seed',
        weight = 1,
    },

    ['weed_brick']            = {
        label = 'Weed Brick',
        weight = 1000,
    },

    ['weed_nutrition']        = {
        label = 'Plant Fertilizer',
        weight = 1275,
    },

    ['joint']                 = {
        label = 'Joint',
        weight = 20,
    },

    ['rolling_paper']         = {
        label = 'Rolling Paper',
        weight = 1,
    },

    ['empty_weed_bag']        = {
        label = 'Empty Weed Bag',
        weight = 1,
    },

    ----------------------------------------------------------------
    -- HYDRATION SYSTEM & WATER
    ----------------------------------------------------------------
    ['empty_bottle']          = {
        label = 'Empty Water Bottle',
        description = 'An empty water bottle, can be filled with water',
        weight = 10,
        server = {
            export = 'tarp_hydration.fillBottle'
        },
        consume = 0,
    },

    ['survival_water']        = {
        label = 'Survival Water',
        weight = 30,
        stack = true,
        close = true,
        degrade = 14 * 24 * 60,
		decay = true,
        description = 'Sealed emergency water rations for long-term storage.',
    },

    ['clean_water']           = {
        label = 'Clean Water',
        description = 'A bottle of clean water, safe to drink',
        weight = 250,
        stack = false,
        weight = 25,
        consume = 0,
        client = {
            image = 'water_bottle.png',
        },
        server = {
            export = 'tarp_hydration.drinkWaterBottle'
        },
    },

    ['dirty_water']           = {
        label = 'Dirty Water',
        weight = 270,
        stack = false,
        consume = 0,
        weight = 27,
        description = 'A bottle of dirty water, not safe to drink',
        client = {
            image = 'dirty_water.png',
        },
        stack = false,
        consume = 0,
        server = {
            export = 'tarp_hydration.drinkWaterBottle'
        },
    },

    ['water_filter']          = {
        label = 'Water Filter',
        weight = 70,
        description = 'A filter that can be used to purify dirty water',
        stack = false,
        consume = 0,
        server = {
            export = 'tarp_hydration.useWaterFilter'
        },
    },

    ----------------------------------------------------------------
    -- PARTS & FUEL
    ----------------------------------------------------------------
    ['bicycle']               = {
        label = 'Bicycle',
        weight = 780,
        description = 'Two wheels is better than none',
        stack = false,
        consume = 0,
        degrade = 24 * 60,
        decay = true,
        server = {
            export = 'snipe-bicycles.useBicycle'
        },
    },

    ['bicycle_tire']          = {
        label = 'Bicycle Tire',
        weight = 120,
        stack = true,
        close = true,
        description = 'A tire suitable for bicycles.'
    },

    ['bike_tire']             = {
        label = 'Motorcycle Tire',
        weight = 440,
        stack = true,
        close = true,
        description = 'A tire suitable for motorcycles.'
    },

    ['car_tire']              = {
        label = 'Car Tire',
        weight = 960,
        stack = true,
        close = true,
        description = 'A tire suitable for cars.'
    },

    ['truck_tire']            = {
        label = 'Truck Tire',
        weight = 1250,
        stack = true,
        close = true,
        description = 'A tire suitable for trucks.'
    },

    ['vehicleparts']          = {
        label = 'Vehicle Parts',
        weight = 75,
        stack = true,
        close = true,
        description = 'General vehicle components.'
    },

    ['engineoil']             = {
        label = 'Engine Oil',
        weight = 120,
        stack = true,
        close = true,
        description = 'Used for engine lubrication.'
    },

    ['hand_pump']             = {
        label = 'Hand Pump',
        weight = 300,
        stack = true,
        close = true,
        description = 'A manual pump used to siphon fuel from vehicles or containers.'
    },

    ['siphon']                = {
        label = 'Siphon Hose',
        weight = 150,
        stack = true,
        close = true,
        description = 'A simple siphon tube for extracting fuel manually.'
    },

    ["gasoline"]              = {
        label = "Gasoline Can",
        weight = 55,
        stack = true,
        close = true,
        description = 'One Gallon of Gasoline.'
    },

    ["diesel"]                = {
        label = "Diesel Can",
        weight = 55,
        stack = true,
        close = true,
        description = 'One Gallon of Diesel.'
    },

    ["kerosine"]              = {
        label = "Kerosine Can",
        weight = 45,
        stack = true,
        close = true,
        description = 'One Gallon of Kerosine.'
    },

    ["empty_fuel"]            = {
        label = "Empty Jug",
        weight = 40,
        stack = true,
        close = true,
        description = 'One Gallon Container.'
    },

    ["water"]            = {
        label = "Water Jug",
        weight = 40,
        stack = true,
        close = true,
        description = 'Non-potable misc use fluid.'
    },

    ['jerry_can']             = {
        label = 'Jerrycan',
        weight = 1250,
    },

    ['nitrous']               = {
        label = 'Nitrous',
        weight = 2345,
    },

    ['24v_battery']           = {
        label = '24v Battery',
        weight = 6250,
        stack = true,
        close = true,
        description = 'Large 24V power source.'
    },

    ['12v_battery']           = {
        label = '12v Battery',
        weight = 4625,
        stack = true,
        close = true,
        description = 'Standard 12V automotive battery.'
    },

    ['6v_battery']            = {
        label = '6v Battery',
        weight = 3575,
        stack = true,
        close = true,
        description = 'Small 6V battery unit.',
        client = {
            export = 'tarp_nvg.useBattery' }
    },

    ['fixkit']                = {
        label = 'Repair Kit',
        weight = 350,
        stack = true,
        close = true,
        description = 'A kit used to repair items.'
    },

    ['toolbox']               = {
        label = 'ToolBox',
        weight = 630,
        stack = true,
        close = true,
        description = 'A toolbox containing various tools.'
    },

    ['gunpowder']             = {
        label = 'Gunpowder',
        weight = 5,
        stack = true,
        close = true,
        description = "A fine explosive powder used for crafting ammunition and explosive components.",
    },

    ['bullet_casing']         = {
        label = 'Bullet Casing',
        weight = 1,
        stack = true,
        close = true,
        description = "An empty brass shell used in crafting live ammunition.",
    },

    ['pipe']                  = {
        label = 'Pipe',
        weight = 30,
        stack = true,
        close = true,
        description = "A metal pipe that can be used for crafting or mechanical fabrication.",
    },


    ----------------------------------------------------------------
    -- FISHING & FISH
    ----------------------------------------------------------------
    ['basic_rod']            = {
        label = 'Basic Fishing Rod',
        weight = 45,
        stack = false,
        close = true,
        consume = 0,
        description = 'A simple rod used for catching fish.',
        client = {
            export = 'tarp_fishing.useRodItem'
        }
    },

    ['bait']                 = {
        label = 'Fishing Bait',
        weight = 10,
        stack = true,
        close = true,
        description = 'Worms and grubs for fishing.',
    },

    ['shovel']               = {
        label = 'Shovel',
        weight = 600,
        stack = false,
        close = true,
        consume = 0,
        description = 'A sturdy shovel used for digging bait from the soil.',
        client = {
            export = 'tarp_fishing.useShovelItem'
        }
    },

    ['mullet']               = {
        label = 'Mullet',
        weight = 250,
        stack = true,
        close = true,
        degrade = 7 * 24 * 60,
		decay = true,
        description = 'A small shallow-water fish.',
    },

    ['bass']                 = {
        label = 'Bass',
        weight = 450,
        stack = true,
        close = true,
        degrade = 7 * 24 * 60,
		decay = true,
        description = 'A popular freshwater fish with firm meat.',
    },

    ['eel']                  = {
        label = 'Eel',
        weight = 250,
        stack = true,
        close = true,
        degrade = 7 * 24 * 60,
		decay = true,
        description = 'A slippery eel with plenty of meat.',
    },

    ['salmon']               = {
        label = 'Salmon',
        weight = 600,
        stack = true,
        close = true,
        degrade = 7 * 24 * 60,
		decay = true,
        description = 'A prized fish known for its rich flavor.',
    },

    ['catfish']              = {
        label = 'Catfish',
        weight = 300,
        stack = true,
        close = true,
        degrade = 7 * 24 * 60,
		decay = true,
        description = 'A large bottom-feeder with thick meat.',
    },

    ['shark']                = {
        label = 'Shark',
        weight = 4250,
        stack = true,
        close = true,
        degrade = 7 * 24 * 60,
		decay = true,
        description = 'A massive and dangerous catch.',
    },

    ['killerwhale'] = {
        label = 'Killer Whale',
        weight = 8500,
        stack = true,
        close = true,
        degrade = 7 * 24 * 60,
        decay = true,
        description = 'An enormous apex predator from the deep.',
    },

    ['stingray'] = {
        label = 'Stingray',
        weight = 1800,
        stack = true,
        close = true,
        degrade = 7 * 24 * 60,
        decay = true,
        description = 'A flat-bodied ray with a dangerous tail barb.',
    },

    ['sharktiger'] = {
        label = 'Tiger Shark',
        weight = 5200,
        stack = true,
        close = true,
        degrade = 7 * 24 * 60,
        decay = true,
        description = 'A powerful shark known for its aggression.',
    },

    ['sharkhammer'] = {
        label = 'Hammerhead Shark',
        weight = 4800,
        stack = true,
        close = true,
        degrade = 7 * 24 * 60,
        decay = true,
        description = 'A distinctive shark with a wide hammer-shaped head.',
    },
    ----------------------------------------------------------------
    -- MEAT ITEMS
    ----------------------------------------------------------------
    ['raw_meat_small'] = {
        label = "Small Raw Meat",
        weight = 25,
        stack = true,
        close = true,
        degrade = 7 * 24 * 60,
        decay = true,
        description = "Small cut of raw game meat.",
        client = { image = "raw_meat_small.png" }
    },

    ['raw_meat_medium'] = {
        label = "Raw Meat",
        weight = 45,
        stack = true,
        close = true,
        degrade = 7 * 24 * 60,
        decay = true,
        description = "Fresh raw meat from a medium-sized animal.",
        client = { image = "raw_meat_medium.png" }
    },

    ['raw_meat_large'] = {
        label = "Large Raw Meat",
        weight = 70,
        stack = true,
        close = true,
        degrade = 7 * 24 * 60,
        decay = true,
        description = "Large slab of raw meat from big game.",
        client = { image = "raw_meat_large.png" }
    },
    ----------------------------------------------------------------
    -- FISH & SEA ITEMS
    ----------------------------------------------------------------
    ['raw_fish'] = {
        label = "Raw Fish",
        weight = 40,
        stack = true,
        close = true,
        degrade = 7 * 24 * 60,
        decay = true,
        description = "Freshly killed fish.",
        client = { image = "raw_fish.png" }
    },

    ['shark_fin'] = {
        label = "Shark Fin",
        weight = 60,
        stack = true,
        close = true,
        description = "Valuable but controversial shark fin.",
        client = { image = "shark_fin.png" }
    },

    ['blubber'] = {
        label = "Blubber",
        weight = 80,
        stack = true,
        close = true,
        description = "Thick fatty tissue from a sea mammal.",
        client = { image = "blubber.png" }
    },
    ----------------------------------------------------------------
    -- HIDES
    ----------------------------------------------------------------
    ['small_hide'] = {
        label = "Small Hide",
        weight = 30,
        stack = true,
        close = true,
        description = "Small animal hide suitable for light crafting.",
        client = { image = "small_hide.png" }
    },

    ['pelt'] = {
        label = "Animal Pelt",
        weight = 90,
        stack = true,
        close = true,
        description = "Thick animal pelt from a large predator.",
        client = { image = "pelt.png" }
    },

    ['rare_pelt'] = {
        label = "Rare Pelt",
        weight = 100,
        stack = true,
        close = true,
        description = "High-quality rare pelt worth a lot.",
        client = { image = "rare_pelt.png" }
    },
    ----------------------------------------------------------------
    -- ANIMAL MATERIALS
    ----------------------------------------------------------------
    ['animal_fat'] = {
        label = "Animal Fat",
        weight = 30,
        stack = true,
        close = true,
        description = "Rendered animal fat used for crafting or cooking.",
        client = { image = "animal_fat.png" }
    },

    ['bone_fragments'] = {
        label = "Bone Fragments",
        weight = 20,
        stack = true,
        close = true,
        description = "Fragments of bone from harvested animals.",
        client = { image = "bone_fragments.png" }
    },

    ['feather'] = {
        label = "Feather",
        weight = 5,
        stack = true,
        close = true,
        description = "Light feather from a bird.",
        client = { image = "feather.png" }
    },
    ----------------------------------------------------------------
    -- COOKED MEAT ITEMS
    ----------------------------------------------------------------
    ['cooked_meat_small'] = {
        label = "Cooked Small Meat",
        weight = 20,
        stack = true,
        close = true,
        degrade = 7 * 24 * 60,
        decay = true,
        description = "Cooked small game meat. Restores a small amount of hunger.",
        client = {image = "cooked_meat_small.png"}
    },

    ['cooked_meat_medium'] = {
        label = "Cooked Meat",
        weight = 35,
        stack = true,
        close = true,
        degrade = 7 * 24 * 60,
        decay = true,
        description = "Cooked meat from a medium animal.",
        client = {image = "cooked_meat_medium.png"}
    },

    ['cooked_meat_large'] = {
        label = "Cooked Large Meat",
        weight = 55,
        stack = true,
        close = true,
        degrade = 7 * 24 * 60,
        decay = true,
        description = "Large cooked slab of meat. Very filling.",
        client = {image = "cooked_meat_large.png"}
    },

    ['cooked_predator_meat'] = {
        label = "Cooked Predator Meat",
        weight = 45,
        stack = true,
        close = true,
        degrade = 7 * 24 * 60,
        decay = true,
        description = "Cooked meat from a predator. Restores hunger and boosts stamina.",
        client = {image = "cooked_predator_meat.png"}
    },

    ['cooked_bacon'] = {
        label = "Cooked Bacon",
        weight = 35,
        stack = true,
        close = true,
        degrade = 7 * 24 * 60,
        decay = true,
        description = "Cooked bacon, but how?",
        client = {image = "cooked_bacon.png"}
    },

    ['bone_broth'] = {
            label = "Bone Broth",
            weight = 20,
            stack = true,
            close = true,
            degrade = 7 * 24 * 60,
            decay = true,
            description = "Some warm bone broth for comfort.",
            client = {image = "bone_broth.png"}
    },
    ['shark_fin_stew'] = {
            label = "Shark Fin Stew",
            weight = 20,
            stack = true,
            close = true,
            degrade = 7 * 24 * 60,
            decay = true,
            description = "A stew of superior powers",
            client = {image = "shark_fin_stew.png"}
    },



    -- -- ### Dusa Hunting ###

    -- ['hunting_license']      = {
    --     label = 'Hunting License',
    --     weight = 100,
    --     stack = false,
    --     close = true,
    --     client = {
    --         image = 'hunting_license.png',
    --     }
    -- },

    -- -- ['campfire']             = {
    -- --     label = "Campfire",
    -- --     weight = 300,
    -- --     stack = true,
    -- --     close = true,
    -- --     consume = 0,
    -- --     description = "A cooking station to prepare food and drinks",
    -- --     server = {
    -- --         export = "snipe-crafting.placeCraftingTable"
    -- --     }
    -- -- },

    ['primitive_grill']      = {
        label = "Primitive Grill",
        weight = 750,
        stack = true,
        close = true,
        consume = 0,
        description = "A cooking station to prepare food and drinks",
        server = {
            export = "snipe-crafting.placeCraftingTable"
        }
    },

    ['advanced_grill']       = {
        label = "Advanced Grill",
        weight = 1200,
        stack = true,
        close = true,
        consume = 0,
        description = "A cooking station to prepare food and drinks",
        server = {
            export = "snipe-crafting.placeCraftingTable"
        }
    },

    ['hunting_bait']         = {
        label = "Hunting Bait",
        weight = 60,
        stack = true,
        close = true,
        description = "This must be the most effective bait ever!",
    },

    -- -- ### Dusa Hunting Animal Parts ###
                -- BEEF CUTS
                ['deer_beef']            = {
                    label = 'Deer Beef', 
                    weight = 125, 
                    stack = true, 
                    close = true, 
                    degrade = 7 * 24 * 60,
                    decay = true,
                    description = 'Lean venison with a mild, earthy flavor.', 
                    client = { image = 'deer_beef.png' } 
                },

                ['rabbit_beef']          = { 
                    label = 'Rabbit Beef', 
                    weight = 60, 
                    stack = true, 
                    close = true, 
                    degrade = 7 * 24 * 60,
                    decay = true,
                    description = 'Light, tender meat with a subtle taste.', 
                    client = { image = 'rabbit_beef.png' } 
                },

                ['bear_beef']            = { 
                    label = 'Bear Beef', 
                    weight = 175, 
                    stack = true, 
                    close = true, 
                    degrade = 7 * 24 * 60,
                    decay = true,
                    description = 'Dense, rich meat packed with fat and protein.', 
                    client = { image = 'bear_beef.png' } 
                },

                ['redpanda_beef']        = { 
                    label = 'Red Panda Beef', 
                    weight = 125, 
                    stack = true, 
                    close = true, 
                    degrade = 7 * 24 * 60,
                    decay = true,
                    description = 'Exotic meat with a soft texture and mild sweetness.', 
                    client = { image = 'redpanda_beef.png' } 
                },

                ['boar_beef']            = { 
                    label = 'Boar Beef', 
                    weight = 125, 
                    stack = true, 
                    close = true, 
                    degrade = 7 * 24 * 60,
                    decay = true,
                    description = 'Dark, flavorful meat with a slightly gamey bite.', 
                    client = { image = 'boar_beef.png' } 
                },

                ['coyote_beef']          = { 
                    label = 'Coyote Beef', 
                    weight = 75, 
                    stack = true, 
                    close = true, 
                    degrade = 7 * 24 * 60,
                    decay = true,
                    description = 'Tough meat with a sharp, wild flavor.', 
                    client = { image = 'coyote_beef.png' } 
                },

                ['mtlion_beef']          = { 
                    label = 'Mountain Lion Beef', 
                    weight = 125, 
                    stack = true, 
                    close = true, 
                    degrade = 7 * 24 * 60,
                    decay = true,
                    description = 'Lean, firm meat similar to very mild pork.', 
                    client = { image = 'mtlion_beef.png' } 
                },

                ['lion_beef']            = { 
                    label = 'Lion Beef', 
                    weight = 160, 
                    stack = true, 
                    close = true, 
                    degrade = 7 * 24 * 60,
                    decay = true,
                    description = 'Rare, powerful meat with a strong, savory taste.', 
                    client = { image = 'lion_beef.png' } 
                },

                ['oryx_beef']            = { 
                    label = 'Oryx Beef', 
                    weight = 125, 
                    stack = true, 
                    close = true, 
                    degrade = 7 * 24 * 60,
                    decay = true,
                    description = 'Clean, beef-like meat with a hint of sweetness.', 
                    client = { image = 'oryx_beef.png' } 
                },

                ['antelope_beef']        = { 
                    label = 'Antelope Beef', 
                    weight = 175, 
                    stack = true, 
                    close = true, 
                    degrade = 7 * 24 * 60,
                    decay = true,
                    description = 'Lean and tender meat with a clean, grassy flavor.', 
                    client = { image = 'antelope_beef.png' } 
                },

                -- RIB CUTS
                ['deer_rib']             = { 
                    label = 'Deer Rib', 
                    weight = 225, 
                    stack = true, 
                    close = true, 
                    degrade = 7 * 24 * 60,
                    decay = true,
                    description = 'Meaty venison ribs with a rich aroma.', 
                    client = { image = 'deer_rib.png' } 
                },

                ['bear_rib']             = { 
                    label = 'Bear Rib', 
                    weight = 325, 
                    stack = true, 
                    close = true, 
                    degrade = 7 * 24 * 60,
                    decay = true,
                    description = 'Thick, fatty ribs that cook down into hearty meals.', 
                    client = { image = 'bear_rib.png' } 
                },

                ['boar_rib']             = { 
                    label = 'Boar Rib', 
                    weight = 225, 
                    stack = true, 
                    close = true, 
                    degrade = 7 * 24 * 60,
                    decay = true,
                    description = 'Robust ribs with deep, smoky flavor potential.', 
                    client = { image = 'boar_rib.png' } 
                },

                ['coyote_rib']           = { 
                    label = 'Coyote Rib', 
                    weight = 80, 
                    stack = true, 
                    close = true, 
                    degrade = 7 * 24 * 60,
                    decay = true,
                    description = 'Bony ribs yielding small but usable meat.', 
                    client = { image = 'coyote_rib.png' } 
                },

                ['mtlion_rib']           = { 
                    label = 'Mountain Lion Rib', 
                    weight = 275, 
                    stack = true, 
                    close = true, 
                    degrade = 7 * 24 * 60,
                    decay = true,
                    description = 'Lean ribs with firm meat along the bone.', 
                    client = { image = 'mtlion_rib.png' } 
                },

                ['lion_rib']             = { 
                    label = 'Lion Rib', 
                    weight = 250, 
                    stack = true, 
                    close = true, 
                    degrade = 7 * 24 * 60,
                    decay = true,
                    description = 'Heavy ribs from a powerful predator.', 
                    client = { image = 'lion_rib.png' } 
                },

                ['oryx_rib']             = { 
                    label = 'Oryx Rib', 
                    weight = 225, 
                    stack = true, 
                    close = true, 
                    degrade = 7 * 24 * 60,
                    decay = true,
                    description = 'Well-formed ribs with dense, high-quality meat.', 
                    client = { image = 'oryx_rib.png' } 
                },

                ['antelope_rib']         = { 
                    label = 'Antelope Rib', 
                    weight = 225, 
                    stack = true, 
                    close = true, 
                    degrade = 7 * 24 * 60,
                    decay = true,
                    description = 'Light ribs with tender, lean meat.', 
                    client = { image = 'antelope_rib.png' } 
                },

                -- LEG CUTS
                ['deer_leg']             = { 
                    label = 'Deer Leg', 
                    weight = 325, 
                    stack = true, 
                    close = true, 
                    degrade = 7 * 24 * 60,
                    decay = true,
                    description = 'Large venison cut ideal for roasting.', 
                    client = { image = 'deer_leg.png' } 
                },

                ['rabbit_leg']           = { 
                    label = 'Rabbit Leg', 
                    weight = 25, 
                    stack = true, 
                    close = true, 
                    degrade = 7 * 24 * 60,
                    decay = true,
                    description = 'Small, tender leg prized for quick cooking.', 
                    client = { image = 'rabbit_leg.png' } 
                },

                ['bear_leg']             = { 
                    label = 'Bear Leg', 
                    weight = 600, 
                    stack = true, 
                    close = true, 
                    degrade = 7 * 24 * 60,
                    decay = true,
                    description = 'Massive leg cut, rich in fat and calories.', 
                    client = { image = 'bear_leg.png' } 
                },

                ['redpanda_leg']         = { 
                    label = 'Red Panda Leg', 
                    weight = 175, 
                    stack = true, 
                    close = true, 
                    degrade = 7 * 24 * 60,
                    decay = true,
                    description = 'Uncommon leg cut with delicate meat.', 
                    client = { image = 'redpanda_leg.png' } 
                },

                ['boar_leg']             = { 
                    label = 'Boar Leg', 
                    weight = 325, 
                    stack = true, 
                    close = true, 
                    degrade = 7 * 24 * 60,
                    decay = true,
                    description = 'Muscular leg with strong flavor and toughness.', 
                    client = { image = 'boar_leg.png' } 
                },

                ['coyote_leg']           = { 
                    label = 'Coyote Leg', 
                    weight = 160, 
                    stack = true, 
                    close = true, 
                    degrade = 7 * 24 * 60,
                    decay = true,
                    description = 'Sinewy leg with limited edible meat.', 
                    client = { image = 'coyote_leg.png' } 
                },

                ['mtlion_leg']           = { 
                    label = 'Mountain Lion Leg', 
                    weight = 375, 
                    stack = true, 
                    close = true, 
                    degrade = 7 * 24 * 60,
                    decay = true,
                    description = 'Lean, powerful leg suited for slow cooking.', 
                    client = { image = 'mtlion_leg.png' } 
                },

                ['lion_leg']             = { 
                    label = 'Lion Leg', 
                    weight = 400, 
                    stack = true, 
                    close = true, 
                    degrade = 7 * 24 * 60,
                    decay = true,
                    description = 'Heavy leg cut from an apex predator.', 
                    client = { image = 'lion_leg.png' } 
                },

                ['oryx_leg']             = { 
                    label = 'Oryx Leg', 
                    weight = 300, 
                    stack = true, 
                    close = true, 
                    degrade = 7 * 24 * 60,
                    decay = true,
                    description = 'Thick, meaty leg with high yield.', 
                    client = { image = 'oryx_leg.png' } 
                },

                ['antelope_leg']         = { 
                    label = 'Antelope Leg', 
                    weight = 325, 
                    stack = true, 
                    close = true, 
                    degrade = 7 * 24 * 60,
                    decay = true,
                    description = 'Long, lean leg with firm texture.', 
                    client = { image = 'antelope_leg.png' } 
                },

                -- BODY PARTS
                ['rabbit_body']          = { 
                    label = 'Rabbit Body', 
                    weight = 300, 
                    stack = true, 
                    close = true, 
                    degrade = 7 * 24 * 60,
                    decay = true,
                    description = 'Whole rabbit carcass ready for processing.', 
                    client = { image = 'rabbit_body.png' } 
                },

                ['redpanda_body']        = { 
                    label = 'Red Panda Body', 
                    weight = 1200, 
                    stack = true, 
                    close = true, 
                    degrade = 7 * 24 * 60,
                    decay = true,
                    description = 'Entire red panda body, rarely obtained.', 
                    client = { image = 'redpanda_body.png' } 
                },

                ['lion_body']            = { 
                    label = 'Lion Body', 
                    weight = 9000, 
                    stack = true, 
                    close = true, 
                    degrade = 7 * 24 * 60,
                    decay = true,
                    description = 'Full lion carcass, imposing and valuable.', 
                    client = { image = 'lion_body.png' } 
                },

                ['rawwildmeat']            = { 
                    label = 'Meat of da wild', 
                    weight = 200, 
                    stack = true, 
                    close = true, 
                    degrade = 7 * 24 * 60,
                    decay = true,
                    description = 'Could be roadkill, could be wagyu.', 
                    client = { image = 'rawwildmeat.png' } 
                },

                -- Cooked Items
                ['deer_beef_cooked']     = {
                    label = 'Cooked Deer Beef', 
                    weight = 125, 
                    stack = true, 
                    close = true, 
                    degrade = 10 * 24 * 60,
                    decay = true,
                    description = 'Lean venison with a mild, earthy flavor.', 
                    client = { image = 'deer_beef_cooked.png' }
                },

                ['deer_rib_cooked']      = {
                    label = 'Cooked Deer Rib', 
                    weight = 200, 
                    stack = true, 
                    close = true, 
                    degrade = 10 * 24 * 60,
                    decay = true,
                    description = 'Meaty venison ribs with a rich aroma.', 
                    client = { image = 'deer_rib_cooked.png' }
                },

                ['deer_leg_cooked']      = {
                    label = 'Cooked Deer Leg', 
                    weight = 325, 
                    stack = true, 
                    close = true, 
                    degrade = 10 * 24 * 60,
                    decay = true,
                    description = 'Large venison cut ideal for roasting.', 
                    client = { image = 'deer_leg_cooked.png' }
                },

                ['rabbit_body_cooked']   = {
                    label = 'Cooked Rabbit Body', 
                    weight = 300, 
                    stack = true, 
                    close = true, 
                    degrade = 10 * 24 * 60,
                    decay = true,
                    description = 'Whole rabbit carcass ready for processing.', 
                    client = { image = 'rabbit_body_cooked.png' }
                },

                ['rabbit_leg_cooked']    = {
                    label = 'Cooked Rabbit Leg', 
                    weight = 25, 
                    stack = true, 
                    close = true, 
                    degrade = 10 * 24 * 60,
                    decay = true,
                    description = 'Small, tender leg prized for quick cooking.', 
                    client = { image = 'rabbit_leg_cooked.png' }
                },

                ['rabbit_beef_cooked']   = {
                    label = 'Cooked Rabbit Beef', 
                    weight = 60, 
                    stack = true, 
                    close = true, 
                    degrade = 10 * 24 * 60,
                    decay = true,
                    description = 'Light, tender meat with a subtle taste.', 
                    client = { image = 'rabbit_beef_cooked.png' }
                },

                ['bear_beef_cooked']     = {
                    label = 'Cooked Bear Beef', 
                    weight = 120, 
                    stack = true, 
                    close = true, 
                    degrade = 10 * 24 * 60,
                    decay = true,
                    description = 'Dense, rich meat packed with fat and protein.', 
                    client = { image = 'bear_beef_cooked.png' }
                },

                ['bear_rib_cooked']      = {
                    label = 'Cooked Bear Rib', 
                    weight = 325, 
                    stack = true, 
                    close = true, 
                    degrade = 10 * 24 * 60,
                    decay = true,
                    description = 'Thick, fatty ribs that cook down into hearty meals.', 
                    client = { image = 'bear_rib_cooked.png' }
                },

                ['bear_leg_cooked']      = {
                    label = 'Cooked Bear Leg', 
                    weight = 600, 
                    stack = true, 
                    close = true, 
                    degrade = 10 * 24 * 60,
                    decay = true,
                    description = 'Massive leg cut, rich in fat and calories.', 
                    client = { image = 'bear_leg_cooked.png' }
                },

                ['redpanda_body_cooked'] = {
                    label = 'Cooked Red Panda Body', 
                    weight = 750, 
                    stack = true, 
                    close = true, 
                    degrade = 10 * 24 * 60,
                    decay = true,
                    description = 'Entire red panda body, rarely obtained.', 
                    client = { image = 'redpanda_body_cooked.png' }
                },

                ['redpanda_leg_cooked']  = {
                    label = 'Cooked Red Panda Leg', 
                    weight = 325, 
                    stack = true, 
                    close = true, 
                    degrade = 10 * 24 * 60,
                    decay = true,
                    description = 'Uncommon leg cut with delicate meat.', 
                    client = { image = 'redpanda_leg_cooked.png' }
                },
                ['redpanda_beef_cooked'] = {
                    label = 'Cooked Red Panda Beef', 
                    weight = 225, 
                    stack = true, 
                    close = true, 
                    degrade = 10 * 24 * 60,
                    decay = true,
                    description = 'Exotic meat with a soft texture and mild sweetness.', 
                    client = { image = 'redpanda_beef_cooked.png' }
                },

                ['boar_leg_cooked']      = {
                    label = 'Cooked Boar Leg', 
                    weight = 625, 
                    stack = true, 
                    close = true, 
                    degrade = 10 * 24 * 60,
                    decay = true,
                    description = 'Muscular leg with strong flavor and toughness.', 
                    client = { image = 'boar_leg_cooked.png' }
                },

                ['boar_beef_cooked']     = {
                    label = 'Cooked Boar Beef', 
                    weight = 250, 
                    stack = true, 
                    close = true, 
                    degrade = 10 * 24 * 60,
                    decay = true,
                    description = 'Dark, flavorful meat with a slightly gamey bite.', 
                    client = { image = 'boar_beef_cooked.png' }
                },

                ['boar_rib_cooked']      = {
                    label = 'Cooked Boar Rib', 
                    weight = 425, 
                    stack = true, 
                    close = true, 
                    degrade = 10 * 24 * 60,
                    decay = true,
                    description = 'Robust ribs with deep, smoky flavor potential.', 
                    client = { image = 'boar_rib_cooked.png' }
                },

                ['coyote_beef_cooked']   = {
                    label = 'Cooked Coyote Beef', 
                    weight = 75, 
                    stack = true, 
                    close = true, 
                    degrade = 10 * 24 * 60,
                    decay = true,
                    description = 'Tough meat with a sharp, wild flavor.', 
                    client = { image = 'coyote_beef_cooked.png' }
                },

                ['coyote_rib_cooked']    = {
                    label = 'Cooked Coyote Rib', 
                    weight = 125, 
                    stack = true, 
                    close = true, 
                    degrade = 10 * 24 * 60,
                    decay = true,
                    description = 'Bony ribs yielding small but usable meat.', 
                    client = { image = 'coyote_rib_cooked.png' }
                },

                ['coyote_leg_cooked']    = {
                    label = 'Cooked Coyote Leg', 
                    weight = 320, 
                    stack = true, 
                    close = true, 
                    degrade = 10 * 24 * 60,
                    decay = true,
                    description = 'Sinewy leg with limited edible meat.', 
                    client = { image = 'coyote_leg_cooked.png' }
                },

                ['mtlion_beef_cooked']   = {
                    label = 'Cooked Mountain Lion Beef', 
                    weight = 250, 
                    stack = true, 
                    close = true, 
                    degrade = 10 * 24 * 60,
                    decay = true,
                    description = 'Lean, firm meat similar to very mild pork.', 
                    client = { image = 'mtlion_beef_cooked.png' }
                },

                ['mtlion_rib_cooked']    = {
                    label = 'Cooked Mountain Lion Rib', 
                    weight = 550, 
                    stack = true, 
                    close = true, 
                    degrade = 10 * 24 * 60,
                    decay = true,
                    description = 'Lean ribs with firm meat along the bone.', 
                    client = { image = 'mtlion_rib_cooked.png' }
                },

                ['mtlion_leg_cooked']    = {
                    label = 'Cooked Mountain Lion Leg', 
                    weight = 750, 
                    stack = true, 
                    close = true, 
                    degrade = 10 * 24 * 60,
                    decay = true,
                    description = 'Lean, powerful leg suited for slow cooking.', 
                    client = { image = 'mtlion_leg_cooked.png' }
                },

                ['lion_beef_cooked']     = {
                    label = 'Cooked Lion Beef', 
                    weight = 275, 
                    stack = true, 
                    close = true, 
                    degrade = 10 * 24 * 60,
                    decay = true,
                    description = 'Rare, powerful meat with a strong, savory taste.', 
                    client = { image = 'lion_beef_cooked.png' }
                },

                ['lion_rib_cooked']      = {
                    label = 'Cooked Lion Rib', 
                    weight = 500, 
                    stack = true, 
                    close = true, 
                    degrade = 10 * 24 * 60,
                    decay = true,
                    description = 'Heavy ribs from a powerful predator.', 
                    client = { image = 'lion_rib_cooked.png' }
                },

                ['lion_leg_cooked']      = {
                    label = 'Cooked Lion Leg', 
                    weight = 800, 
                    stack = true, 
                    close = true, 
                    degrade = 10 * 24 * 60,
                    decay = true,
                    description = 'Heavy leg cut from an apex predator.', 
                    client = { image = 'lion_leg_cooked.png' }
                },

                ['lion_body_cooked']     = {
                    label = 'Cooked Lion Body', 
                    weight = 12000, 
                    stack = true, 
                    close = true, 
                    degrade = 10 * 24 * 60,
                    decay = true,
                    description = 'Full lion carcass, imposing and valuable.', 
                    client = { image = 'lion_body_cooked.png' }
                },

                ['oryx_beef_cooked']     = {
                    label = 'Cooked Oryx Beef', 
                    weight = 225, 
                    stack = true, 
                    close = true, 
                    degrade = 10 * 24 * 60,
                    decay = true,
                    description = 'Clean, beef-like meat with a hint of sweetness.', 
                    client = { image = 'oryx_beef_cooked.png' }
                },

                ['oryx_rib_cooked']      = {
                    label = 'Cooked Oryx Rib', 
                    weight = 425, 
                    stack = true, 
                    close = true, 
                    degrade = 10 * 24 * 60,
                    decay = true,
                    description = 'Well-formed ribs with dense, high-quality meat.', 
                    client = { image = 'oryx_rib_cooked.png' }
                },

                ['oryx_leg_cooked']      = {
                    label = 'Cooked Oryx Leg', 
                    weight = 600, 
                    stack = true, 
                    close = true, 
                    degrade = 10 * 24 * 60,
                    decay = true,
                    description = 'Thick, meaty leg with high yield.', 
                    client = { image = 'oryx_leg_cooked.png' }
                },

                ['antelope_beef_cooked'] = {
                    label = 'Cooked Antelope Beef', 
                    weight = 225, 
                    stack = true, 
                    close = true, 
                    degrade = 10 * 24 * 60,
                    decay = true,
                    description = 'Lean and tender meat with a clean, grassy flavor.', 
                    client = { image = 'antelope_beef_cooked.png' }
                },

                ['antelope_rib_cooked']  = {
                    label = 'Cooked Antelope Rib', 
                    weight = 425, 
                    stack = true, 
                    close = true, 
                    degrade = 10 * 24 * 60,
                    decay = true,
                    description = 'Light ribs with tender, lean meat.', 
                    client = { image = 'antelope_rib_cooked.png' }
                },

                ['antelope_leg_cooked']  = {
                    label = 'Cooked Antelope Leg',
                    weight = 625, 
                    stack = true, 
                    close = true, 
                    degrade = 10 * 24 * 60,
                    decay = true,
                    description = 'Long, lean leg with firm texture.', 
                    client = { image = 'antelope_leg_cooked.png' }
                },

    ['fish_cooked']          = {
        label = 'Cooked Fish', 
        weight = 30, 
        stack = true, 
        close = true, 
        degrade = 10 * 24 * 60,
		decay = true,
        description = 'Delishfish', 
        client = { image = 'cooked_fish.png' }
    },

    ['mysterymeat']          = {
        label = 'Cooked Creature', 
        weight = 125, 
        stack = true, 
        close = true, 
        degrade = 10 * 24 * 60,
		decay = true,
        description = 'Mystery Meat', 
        client = { image = 'mysterymeat.png' }
    },

    ['hide']                 = {
        label = "Hide",
        weight = 500,
        stack = true,
        close = true,
        description = "",
        client = {
            image = "hide.png",
        }
    },


    ['binocular']                          = {
        label = 'Binocular',
        weight = 20,
        stack = true,
        close = true,
        description = "",
    },

    ['hunting_trap']                       = {
        label = 'Hunting Trap',
        weight = 300,
        stack = true,
        close = true,
        description = "",
    },

    ['hunting_laptop']                     = {
        label = 'Hunting Laptop',
        weight = 250,
        stack = true,
        close = true,
        description = "",
    },
    ----------------------------------------------------------------
    -- BACKPACKS & PERSONAL STORAGE
    ----------------------------------------------------------------
    ['backpack_small']                     = {
        label = "Small Backpack",
        weight = 100,
        stack = false,
        close = false,
        consume = 0,
        description = 'A compact backpack for light storage needs.',
        server = {
            export = 'snipe-backpacks.useBackpackItem'
        },
        buttons = {
            {
                label = 'Create Alias',
                action = function(slot)
                    exports["snipe-backpacks"]:GiveAlias(slot)
                end
            },
            {
                label = 'Remove Locks',
                action = function(slot)
                    exports["snipe-backpacks"]:RemoveLocks(slot)
                end
            },
        },
    },

    ['backpack_medium']                    = {
        label = 'Medium Backpack',
        weight = 200,
        stack = false,
        close = false,
        consume = 0,
        description = 'A medium-sized backpack with extra storage space.',
        server = {
            export = 'snipe-backpacks.useBackpackItem'
        },
        buttons = {
            {
                label = 'Create Alias',
                action = function(slot)
                    exports["snipe-backpacks"]:GiveAlias(slot)
                end
            },
            {
                label = 'Remove Locks',
                action = function(slot)
                    exports["snipe-backpacks"]:RemoveLocks(slot)
                end
            },
        },

    },

    ['backpack_large']                     = {
        label = 'Large Backpack',
        weight = 300,
        stack = false,
        close = false,
        consume = 0,
        description = 'A large backpack designed for long expeditions.',
        server = {
            export = 'snipe-backpacks.useBackpackItem'
        },
        buttons = {
            {
                label = 'Create Alias',
                action = function(slot)
                    exports["snipe-backpacks"]:GiveAlias(slot)
                end
            },
            {
                label = 'Remove Locks',
                action = function(slot)
                    exports["snipe-backpacks"]:RemoveLocks(slot)
                end
            },
        },
    },

    ['small_blueprint_binder'] = {
        label = "Small Blueprint Binder",
        weight = 100,
        stack = false,
        close = true,
        consume = 0,
        description = 'A compact binder for storing blueprints.',
        client = {
            image = 'blueprint_binder.png'
        },
        server = {
            export = 'snipe-backpacks.useBlueprintBinder'
        },
        buttons = {
            {
                label = 'Create Alias',
                action = function(slot)
                    exports["snipe-backpacks"]:GiveAlias(slot)
                end
            },
        },
    },

    ['blueprint_binder'] = {
        label = "Binder",
        weight = 200,
        stack = false,
        close = true,
        consume = 0,
        description = 'A large binder for storing blueprints.',
        server = {
            export = 'snipe-backpacks.useBlueprintBinder'
        },
        buttons = {
            {
                label = 'Create Alias',
                action = function(slot)
                    exports["snipe-backpacks"]:GiveAlias(slot)
                end
            },a
        },
    },

    ['small_container']                    = {
        label = 'Small Container',
        weight = 1,
        stack = false,
        consume = 0,
        server = {
            export = 'snipe-containers.placeContainer'
        },
    },

    ['medium_container']                   = {
        label = 'Medium Container',
        weight = 1,
        stack = false,
        consume = 0,
        server = {
            export = 'snipe-containers.placeContainer'
        },
    },

    ['large_container']                    = {
        label = 'Large Container',
        weight = 1,
        stack = false,
        consume = 0,
        server = {
            export = 'snipe-containers.placeContainer'
        },
    },

    ----------------------------------------------------------------
    -- SECURITY & HEIST TOOLS
    ----------------------------------------------------------------
    ['gatecrack']                          = {
        label = 'Gatecrack',
        weight = 1000,
    },

    ['security_card_01']                   = {
        label = 'Security Card A',
        weight = 100,
    },

    ['security_card_02']                   = {
        label = 'Security Card B',
        weight = 100,
    },

    ----------------------------------------------------------------
    -- DIVING & CORAL
    ----------------------------------------------------------------
    ['diving_gear']                        = {
        label = 'Diving Gear',
        weight = 2400,
    },

    ['diving_fill']                        = {
        label = 'Diving Tube',
        weight = 900,
    },

    ['antipatharia_coral']                 = {
        label = 'Antipatharia',
        weight = 200,
    },

    ['dendrogyra_coral']                   = {
        label = 'Dendrogyra',
        weight = 200,
    },

    ----------------------------------------------------------------
    -- BUILDING SYSTEM (HRS BASE BUILDING)
    ----------------------------------------------------------------
    -- WOOD BUILDING
    ['model_door_wood']                    = { 
        label = 'Wood Door', 
        weight = 0 
    },

    ['model_window_wood']                  = { 
        label = 'Wood Window', 
        weight = 0 
    },

    ['model_windowway_wood']               = { 
        label = 'Wood Window Frame', 
        weight = 0 
    },

    ['model_wall_wood']                    = { 
        label = 'Wood Wall', 
        weight = 0 
    },

    ['model_doorway_wood']                 = { 
        label = 'Wood Door Frame', 
        weight = 0
    },

    ['model_gateway_wood']                 = { 
        label = 'Wood Gate Frame', 
        weight = 0 
    },

    ['model_base_wood']                    = { 
        label = 'Wood Foundation', 
        weight = 0 
    },

    ['model_ceiling_wood']                 = { 
        label = 'Wood Ceiling', 
        weight = 0 
    },

    ['model_ceilingstairs_wood']           = { 
        label = 'Wood Ceiling Stairs', 
        weight = 0 
    },

    ['model_pillar_wood']                  = { 
        label = 'Wood Pillar', 
        weight = 0 
    },

    ['model_gate_wood']                    = { 
        label = 'Wood Gate', 
        weight = 0 
    },

    ['model_bigwall_wood']                 = { 
        label = 'Big Wall Wood', 
        weight = 0 
    },

    ['model_biggateway_wood']              = { 
        label = 'Big Gate Frame Wood', 
        weight = 0 
    },

    ['model_biggate_wood']                 = { 
        label = 'Big Gate Wood', 
        weight = 0 
    },

    ['model_base_wood_triangle']           = { 
        label = 'Wood Triangle Foundation', 
        weight = 0 
    },
    ['model_ceiling_wood_triangle']        = { 
        label = 'Wood Triangle Foundation', 
        weight = 0 
    },

    ['model_wall_wood_roof']               = { 
        label = 'Wood Roof', 
        weight = 0 
    },

    ['model_wall_wood_roof_triangle']      = { 
        label = 'Wood Triangle Roof', 
        weight = 0 
    },

    ['model_wall_wood_small']              = { 
        label = 'Wood Small Wall', 
        weight = 0 
    },

    ['model_wall_wood_triangle']           = { 
        label = 'Wood Triangle Wall', 
        weight = 0 
    },

    ['model_ceilingladder_wood_triangle']  = { 
        label = 'Wood Triangle Ceiling Ladder', 
        weight = 0 
    },

    ['model_stairs_wood']                  = { 
        label = 'Wood stairs', 
        weight = 0 
    },

    -- STONE BUILDING
    ['model_door_stone']                   = { 
        label = 'Stone Door', 
        weight = 0 
    },

    ['model_window_stone']                 = { 
        label = 'Stone Window', 
        weight = 0 
    },

    ['model_windowway_stone']              = { 
        label = 'Stone Window Frame', 
        weight = 0 
    },

    ['model_wall_stone']                   = { 
        label = 'Stone Wall', 
        weight = 0
    },

    ['model_doorway_stone']                = { 
        label = 'Stone Door Frame', 
        weight = 0
    },

    ['model_gateway_stone']                = { 
        label = 'Stone Gate Frame', 
        weight = 0 
    },

    ['model_base_stone']                   = { 
        label = 'Stone Foundation', 
        weight = 0 
    },

    ['model_ceiling_stone']                = { 
        label = 'Stone Ceiling', 
        weight = 0 
    },

    ['model_ceilingstairs_stone']          = { 
        label = 'Stone Stairs', 
        weight = 0 
    },

    ['model_pillar_stone']                 = { 
        label = 'Stone Pillar', 
        weight = 0 
    },

    ['model_gate_stone']                   = { 
        label = 'Stone Gate', 
        weight = 0 
    },

    ['model_base_stone_triangle']          = { 
        label = 'Stone Triangle Foundation', 
        weight = 0 
    },

    ['model_ceiling_stone_triangle']       = { 
        label = 'Stone Triangle Ceiling', 
        weight = 0 
    },

    ['model_wall_stone_roof']              = { 
        label = 'Stone Roof', 
        weight = 0 
    },

    ['model_wall_stone_roof_triangle']     = { 
        label = 'Stone Triangle Roof', 
        weight = 0 
    },

    ['model_wall_stone_small']             = { 
        label = 'Stone Small Wall', 
        weight = 0 
    },

    ['model_wall_stone_triangle']          = { 
        label = 'Stone Triangle Wall', 
        weight = 0 
    },

    ['model_ceilingladder_stone_triangle'] = { 
        label = 'Stone Triangle Ceiling Ladder', 
        weight = 0
    },

    ['model_stairs_stone']                 = { 
        label = 'Stone stairs', 
        weight = 0 
    },

    -- METAL BUILDING
    ['model_door_metal']                   = { 
        label = 'Metal Door', 
        weight = 0 
    },

    ['model_window_metal']                 = { 
        label = 'Metal Window', 
        weight = 0 
    },

    ['model_windowway_metal']              = { 
        label = 'Metal Window', 
        weight = 0 
    },

    ['model_wall_metal']                   = { 
        label = 'Metal Wall', 
        weight = 0 
    },

    ['model_doorway_metal']                = { 
        label = 'Metal Door Frame', 
        weight = 0 
    },

    ['model_gateway_metal']                = { 
        label = 'Metal Gate Frame', 
        weight = 0 
    },

    ['model_base_metal']                   = { 
        label = 'Metal Foundation', 
        weight = 0 
    },

    ['model_ceiling_metal']                = { 
        label = 'Metal Ceiling', 
        weight = 0 
    },

    ['model_ceilingstairs_metal']          = { 
        label = 'Metal Ceiling Stairs', 
        weight = 0 
    },

    ['model_pillar_metal']                 = { 
        label = 'Metal Pillar', 
        weight = 0 
    },

    ['model_gate_metal']                   = { 
        label = 'Metal Gate', 
        weight = 0 
    },

    ['model_base_metal_triangle']          = { 
        label = 'Metal Triangle Foundation', 
        weight = 0 
    },

    ['model_wall_metal_roof']              = { 
        label = 'Metal Roof', 
        weight = 0 
    },

    ['model_wall_metal_roof_triangle']     = { 
        label = 'Metal Triangle Roof', 
        weight = 0 
    },

    ['model_wall_metal_small']             = { 
        label = 'Metal Small Wall', 
        weight = 0 
    },

    ['model_wall_metal_triangle']          = { 
        label = 'Metal Triangle Wall', 
        weight = 0

    },

    ['model_ceiling_metal_triangle']       = { 
        label = 'Metal Triangle Ceiling', 
        weight = 0 
    },

    ['model_ceilingladder_metal_triangle'] = { 
        label = 'Metal Triangle Ceiling Ladder', 
        weight = 0 
    },

    ['model_stairs_metal']                 = { 
        label = 'Metal stairs', 
        weight = 0 
    },

    -- FURNITURE
    ['bkr_prop_biker_campbed_01']          = { 
        label = 'Wood Bed', 
        weight = 0 
    },
    ['v_tre_sofa_mess_b_s']                = { 
        label = 'Wood Sofa', 
        weight = 0 
    },

    ['prop_box_wood01a']                   = { 
        label = 'Wood Storage', 
        weight = 0 
    },

    ['gr_prop_gr_gunlocker_01a']           = { 
        label = 'Metal Storage', 
        weight = 0 
    }, 
    ['p_v_43_safe_s']                      = { 
        label = 'Metal Storage Lv2', 
        weight = 0 
    },


    -- CRAFTING TABLES
    ['prop_tool_bench02_ld']               = { 
        label = 'Wood Storage Table', 
        weight = 0 
    },

    ['bkr_prop_meth_table01a']             = { 
        label = 'Medical Storage Table', 
        weight = 0 
    },

    ['gr_prop_gr_bench_02a']               = { 
        label = 'Weapon Storage Table', 
        weight = 0 
    },

    ['prop_planer_01']                     = { 
        label = 'Recycle Machine', 
        weight = 0 
    },
    ['prop_trailr_fridge']               = { 
        label = 'Fridge', 
        weight = 0 
    },

    -- LIGHTS
    ['model_worklight_2']                  = { 
        label = 'WorkLight Small', 
        weight = 0 
    },

    ['model_oldlight_ext']                 = { 
        label = 'Old Exterior Light', 
        weight = 0 
    },
    ['model_worklight_1']                  = { 
        label = 'WorkLight Big', 
        weight = 0
     },

    ['model_biglight_1']                   = { 
        label = 'Big Light', 
        weight = 0 
    },

    ['model_walllight_1']                  = { 
        label = 'Wall Light', 
        weight = 0 
    },

    ['model_ceilinglight_1']               = { 
        label = 'Ceiling Light', 
        weight = 0 
    },

    -- GENERATORS & POWER
    ['model_generator_small']              = { 
        label = 'Small Generator', 
        weight = 0 
    },

    ['model_generator_big']                = { 
        label = 'Big Generator', 
        weight = 0 
    },

    ['model_generator_medium']             = { 
        label = 'Medium Size Generator', 
        weight = 0 
    },
    ['prop_solarpanel_02']                 = { 
        label = 'Big Solar Panel', 
        weight = 0 
    },

    ['prop_solarpanel_03']                 = { 
        label = 'Solar Panel', 
        weight = 0 
    },

    ['prop_rural_windmill']                = { 
        label = 'Wind Turbine', 
        weight = 0 
    },

    -- EXTRA ENERGY PROPS
    ['model_powerdist1_wall']              = { 
        label = 'Power Distributor', 
        weight = 0 
    },

    ['model_powercomb1_wall']              = { 
        label = 'Power Combiner', 
        weight = 0 
    },

    ['model_powerdist1_switch_wall']       = { 
        label = 'Power Distributor [ON/OFF]', 
        weight = 0 
    },
    ['prop_telegraph_06a']                 = { 
        label = 'Power Line', 
        weight = 0 
    },

    -- BATTERIES
    ['model_battery_pack_6']               = { 
        label = 'Battery Pack', weight = 0 },

    -- UPKEEP
    ['model_upkeep_1']                     = { 
        label = 'Upkeep Lvl 1', 
        weight = 00
    },

    ['model_upkeep_2']                     = { 
        label = 'Upkeep Lvl 2', 
        weight = 0 
    },

    ['model_upkeep_3']                     = { 
        label = 'Ukeeep Lvl 3', 
        weight = 0 
    },

    -- TOTEM
    ['model_totem']                        = { 
        label = 'Totem', 
        weight = 0 },

    -- MENUOPEN
    ['base_blueprint']                     = { 
        label = "Base Blueprint", 
        weight = 450 
    },

    ['utility_blueprint']                  = { 
        label = "Utility Blueprint", 
        weight = 450 
    },

    --FIREPLACE ITEMS
    ['portable_fireplace']                 = { 
        label = 'Portable Fireplace', 
        weight = 660 
    },

    ['portable_furnace']                   = { 
        label = 'Portable Furnace', 
        weight = 780 },

    --GARAGE ITEM
    ['prop_container_03b']                 = { 
        label = 'Large Container', 
        weight = 0 },

    --DEFENSE ITEMS
    ['model_electricfence']                = {
        label = 'Electric Fence',
        weight = 0,
        description = 'Used for base building',
        stack = true,
        close = true,
    },
    ['model_spikeswall_wood']              = {
        label = 'Spikes Wall',
        weight = 0,
        description = 'Used for base building',
        stack = true,
        close = true,
    },
    ['model_mg']                           = {
        label = 'Turret',
        weight = 0,
        description = 'Used for base building',
        stack = true,
        close = true,
    },
    ['model_rpg']                          = {
        label = 'RPG Turret',
        weight = 0,
        description = 'Used for base building',
        stack = true,
        close = true,
    },
    ['model_grenadelauncher']              = {
        label = 'Grenade Turret',
        weight = 0,
        description = 'Used for base building',
        stack = true,
        close = true,
    },
    ['model_fire_turret']                  = {
        label = 'Fire Turret',
        weight = 0,
        description = 'Used for base building',
        stack = true,
        close = true,
    },
    ['model_mg_stand']                     = {
        label = 'Turret Stand',
        weight = 0,
        description = 'Used for base building',
        stack = true,
        close = true,
    },

    -- CRAFTING TABLE ITEMS (PLACERS)
    ["crafting_table_meth"]                = {
        label = "Crafting Table (Meth)",
        weight = 0,
        stack = true,
        close = true,
        consume = 0,
        description = "A stash box to store your stuff in",
        server = {
            export = "snipe-crafting.placeCraftingTable"
        }
    },

    ["crafting_table_saw"]                 = {
        label = "Crafting Table (Saw)",
        weight = 0,
        stack = true,
        close = true,
        consume = 0,
        description = "A stash box to store your stuff in",
        server = {
            export = "snipe-crafting.placeCraftingTable"
        }
    },

    ["crafting_table_tool"]                = {
        label = "Crafting Table (Tool)",
        weight = 0,
        stack = true,
        close = true,
        consume = 0,
        description = "A stash box to store your stuff in",
        server = {
            export = "snipe-crafting.placeCraftingTable"
        }
    },

    ["crafting_table_weapon"]              = {
        label = "Crafting Table (Weapon)",
        weight = 0,
        stack = true,
        close = true,
        consume = 0,
        description = "A stash box to store your stuff in",
        server = {
            export = "snipe-crafting.placeCraftingTable"
        }
    },

    ["crafting_table_bigtool"]             = {
        label = "Crafting Table (Big Tool)",
        weight = 0,
        stack = true,
        close = true,
        consume = 0,
        description = "A stash box to store your stuff in",
        server = {
            export = "snipe-crafting.placeCraftingTable"
        }
    },

    ["crafting_table_cooking"] = {
        label = "Cooking Station",
        weight = 0,
        stack = true,
        close = true,
        consume = 0,
        description = "A cooking station to prepare food and drinks",
        server = {
            export = "snipe-crafting.placeCraftingTable"
        }
    },

    ["radiation_mask"] = {
        label = "Radiation Mask",
        weight = 800,
        stack = false,
        close = true,
        consume = 0,
        server = {
            export = 'snipe-icebox.useChain',
        }
    },

    ['environmental_scanner'] = {
        label = 'Environmental Scanner',
        weight = 800,
        stack = false,
        close = true,
        description = 'Scans the environment for hazardous radiation.',
        client = {
            export = 'tarp_radiation.useEnvironmentalScanner'
        }
    },


    -- Clothing as Items
    ["clothing_mask_basic"] = {
        label = "Basic Mask",
        weight = 5,
        stack = false,
        consume = 0,
        server = {
            export = 'ox_inventory.wearClothing',
        }
    },
    ["clothing_scarf_basic"] = {
        label = "Basic Scarf",
        weight = 15,
        stack = false,
        consume = 0,
        server = {
            export = 'ox_inventory.wearClothing',
        }
    },
    ["clothing_jacket_basic"] = {
        label = "Basic Jacket",
        weight = 90,
        stack = false,
        consume = 0,
        server = {
            export = 'ox_inventory.wearClothing',
        }
    },
    ["clothing_shirt_basic"] = {
        label = "Basic Shirt",
        weight = 18,
        stack = false,
        consume = 0,
        server = {
            export = 'ox_inventory.wearClothing',
        }
    },
    ["clothing_body_armor_basic"] = {
        label = "Basic Body Armor",
        weight = 220,
        stack = false,
        consume = 0,
        server = {
            export = 'ox_inventory.wearClothing',
        }
    },
    ["clothing_bag_basic"] = {
        label = "Basic Bag",
        weight = 70,
        stack = false,
        consume = 0,
        server = {
            export = 'ox_inventory.wearClothing',
        }
    },
    ["clothing_gloves_basic"] = {
        label = "Basic Gloves",
        weight = 12,
        stack = false,
        consume = 0,
        server = {
            export = 'ox_inventory.wearClothing',
        }
    },
    ["clothing_pants_basic"] = {
        label = "Basic Pants",
        weight = 78,
        stack = false,
        consume = 0,
        server = {
            export = 'ox_inventory.wearClothing',
        }
    },
    ["clothing_shoes_basic"] = {
        label = "Basic Shoes",
        weight = 80,
        stack = false,
        consume = 0,
        server = {
            export = 'ox_inventory.wearClothing',
        }
    },
    ["clothing_hat_basic"] = {
        label = "Basic Hat",
        weight = 9,
        stack = false,
        consume = 0,
        server = {
            export = 'ox_inventory.wearClothing',
        }
    },
    ["clothing_glasses_basic"] = {
        label = "Basic Glasses",
        weight = 3,
        stack = false,
        consume = 0,
        server = {
            export = 'ox_inventory.wearClothing',
        }
    },
    ["clothing_earwear_basic"] = {
        label = "Basic Earwar",
        weight = 2,
        stack = false,
        consume = 0,
        server = {
            export = 'ox_inventory.wearClothing',
        }
    },
    ["clothing_watch_basic"] = {
        label = "Basic Watch",
        weight = 5,
        stack = false,
        consume = 0,
        server = {
            export = 'ox_inventory.wearClothing',
        }
    },
    ["clothing_bracelet_basic"] = {
        label = "Basic Bracelet",
        weight = 5,
        stack = false,
        consume = 0,
        server = {
            export = 'ox_inventory.wearClothing',
        }
    },
    ["clothing_tag"] = {
        label = "Clothing Tag",
        description = "Allows you to rename clothing items",
        weight = 1,
        stack = false
    },
    ["surgery_kit"] = {
        label = "Surgery Kit",
        description = "Allows you to change your appearance",
        weight = 500,
        stack = false,
        server = {
            export = 'ox_inventory.useSurgeryKit',
        }
    },
    ["tattoo_kit"] = {
        label = "Tattoo Kit",
        description = "Allows you to change your tattoo",
        weight = 1,
        stack = false,
        server = {
            export = 'ox_inventory.useTattooKit',
        }
    },

    ['tarp_goggles'] = {
        label = 'Night Vision Goggles',
        weight = 200,
        stack = false,
        close = true,
        description = 'Allows you to see in the dark...Oooooo',
        client = {
            export = 'tarp_nvg.useNVG'
        }
    },
    ['platecarrier_t1'] = {
        label = 'Plate Carrier (Tier 1)',
        weight = 3000,
        stack = false,
        close = false,
        consume = 0,
        server = {
            export = 'tarp_platecarrier.openCarrier'
        }
    },

    ['platecarrier_t2'] = {
        label = 'Plate Carrier (Tier 2)',
        weight = 3500,
        stack = false,
        close = false,
        consume = 0,
        server = {
            export = 'tarp_platecarrier.openCarrier'
        }
    },

    ['platecarrier_t3'] = {
        label = 'Plate Carrier (Tier 3)',
        weight = 4000,
        stack = false,
        close = false,
        consume = 0,
        server = {
            export = 'tarp_platecarrier.openCarrier'
        }
    },

    ['armor_plate'] = {
        label = 'Armor Plate',
        weight = 650,
        stack = false,
        decay = true,
    },

    ['armor_plate_busted'] = {
        label = 'Busted Armor Plate',
        weight = 350,
        stack = true,
    },

    ['carrot'] = {
        label = 'Carrot',
        weight = 35,
        stack = true
    },

    ['hay'] = {
        label = 'Hay',
        weight = 350,
        stack = true
    },

    ['apple'] = {
        label = 'Apple',
        weight = 35,
        stack = true
    },


    ['hobo_stew']     = {
        label = 'Hobo Stew', 
        weight = 125, 
        stack = true, 
        close = true, 
        degrade = 10 * 24 * 60,
		decay = true,
        description = 'A questionable stew made from whatever ingredients were on hand.', 
        client = { image = 'hobo_stew.png' }
    },

}
