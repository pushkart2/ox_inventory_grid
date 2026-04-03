local clothingConfig = {}

clothingConfig.clothing_items = {
    ["clothing_mask_basic"] = {
        component = "masks",
        type = "component",
        allowed_slot = 1,
        component_id = 1,
        defaults = {
            ["female"] = {
                drawable = 0,
                texture = 0
            },
            ["male"] = {
                drawable = 0,
                texture = 0
            },
        },
    },
    ["clothing_scarf_basic"] = {
        component = "scarfAndChains",
        type = "component",
        allowed_slot = 2,
        component_id = 7,
        defaults = {
            ["female"] = {
                drawable = 0,
                texture = 0
            },
            ["male"] = {
                drawable = -1,
                texture = 0
            }
        }
    },
    ["clothing_jacket_basic"] = {
        component = "jackets",
        type = "component",
        allowed_slot = 3,
        component_id = 11,
        defaults = {
            ["female"] = {
                drawable = 5,
                texture = 2
            },
            ["male"] = {
                drawable = 15,
                texture = 0
            }
        },
    },
    ["clothing_shirt_basic"] = {
        component = "shirts",
        type = "component",
        allowed_slot = 4,
        component_id = 8,
        defaults = {
            ["female"] = {
                drawable = 14,
                texture = 0
            },
            ["male"] = {
                drawable = 15,
                texture = 0
            }
        }
    },
    ["clothing_body_armor_basic"] = {
        component = "bodyArmor",
        type = "component",
        allowed_slot = 5,
        component_id = 9,
        defaults = {
            ["female"] = {
                drawable = 0,
                texture = 0
            },
            ["male"] = {
                drawable = 0,
                texture = 0
            }
        }
    },
    ["clothing_bag_basic"] = {
        component = "bags",
        type = "component",
        allowed_slot = 6,
        component_id = 5,
        defaults = {
            ["female"] = {
                drawable = 0,
                texture = 0
            },
            ["male"] = {
                drawable = 0,
                texture = 0
            }
        }
    },
    ["clothing_gloves_basic"] = {
        component = "upperBody",
        type = "component",
        allowed_slot = 7,
        component_id = 3,
        defaults = {
            ["female"] = {
                drawable = 4,
                texture = 0
            },
            ["male"] = {
                drawable = 15,
                texture = 0
            }
        }
    },
    ["clothing_pants_basic"] = {
        component = "lowerBody",
        type = "component",
        allowed_slot = 8,
        component_id = 4,
        defaults = {
            ["female"] = {
                drawable = 107,
                texture = 1
            },
            ["male"] = {
                drawable = 61,
                texture = 2
            }
        }
    },
    ["clothing_shoes_basic"] = {
        component = "shoes",
        type = "component",
        allowed_slot = 9,
        component_id = 6,
        defaults = {
            ["female"] = {
                drawable = 35,
                texture = 0
            },
            ["male"] = {
                drawable = 34,
                texture = 0
            }
        }
    },
    ["clothing_hat_basic"] = {
        component = "hats",
        type = "prop",
        allowed_slot = 10,
        prop_id = 0,
        defaults = {
            ["female"] = {
                drawable = -1,
                texture = -1
            },
            ["male"] = {
                drawable = -1,
                texture = -1
            }
        }
    },
    ["clothing_glasses_basic"] = {
        component = "glasses",
        type = "prop",
        allowed_slot = 11,
        prop_id = 1,
        defaults = {
            ["female"] = {
                drawable = -1,
                texture = -1
            },
            ["male"] = {
                drawable = -1,
                texture = -1
            }
        }
    },
    ["clothing_earwear_basic"] = {
        component = "ear",
        type = "prop",
        allowed_slot = 12,
        prop_id = 2,
        defaults = {
            ["female"] = {
                drawable = -1,
                texture = -1
            },
            ["male"] = {
                drawable = -1,
                texture = -1
            }
        }
    },
    ["clothing_watch_basic"] = {
        component = "watches",
        type = "prop",
        allowed_slot = 13,
        prop_id = 6,
        defaults = {
            ["female"] = {
                drawable = -1,
                texture = -1
            },
            ["male"] = {
                drawable = -1,
                texture = -1
            }
        }
    },
    ["clothing_bracelet_basic"] = {
        component = "bracelets",
        type = "prop",
        allowed_slot = 14,
        prop_id = 7,
        defaults = {
            ["female"] = {
                drawable = -1,
                texture = -1
            },
            ["male"] = {
                drawable = -1,
                texture = -1
            }
        }
    }
}

clothingConfig.surgery_kit = {
    enabled = {
        headBlend = true,
        faceFeatures = true,
        headOverlays = true,
        enableExit = true
    }
}

clothingConfig.tattoo_kit = {
    enabled = {
        tattoos = true,
        enableExit = true
    }
}

return clothingConfig
