require_relative 'template_api'

####################################
#            Framing               #
####################################
addProduct2 {
    template_id :TwoFourNinetySixStuds
    name '2"x4"x96" Studs'
    misc 'Supply/Install Interior Partition'
    materials_cost 2.43
    labor_cost 10.00
    hd_sku 161640
    detail {
        name LINEAR_FEET_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_times(1.25)
}

addProduct2 {
    template_id :TwoSixNinetySixStuds
    name '2"x6"x96" Studs'
    misc 'Supply/Install Interior Partition'
    materials_cost 4.43
    labor_cost 10.00
    hd_sku 161713
    detail {
        name LINEAR_FEET_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_times(1.25)
}

addProduct2 {
    template_id :SillPlate
    name "Sill Plate Using 2'x8'x16' PT Lumber"
    shortname "Sill Plate"
    materials_cost 12.67
    labor_cost 32.00
    hd_sku 128340
    detail {
        name SELECTED_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn "function(d, ms) {return (ms.house_perimeter + ms.addition_perimeter)/16}"
}

addProduct2 {
    template_id :SillPlateAddition
    name "Sill Plate Using 2'x8'x16' PT Lumber"
    shortname "Sill Plate"
    materials_cost 12.67
    labor_cost 32.00
    hd_sku 128340
    detail {
        name SELECTED_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn "function(d, ms) {return (2*ms.addition_length + ms.addition_width)/16;}"
}

addProduct2 {
    template_id :OwensCorningSillSeal
    name "Owens-Corning Sill Seal"
    shortname "Sill Seal"
    materials_cost 8.57
    labor_cost 5.00
    hd_sku 409989
    detail {
        name SELECTED_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn "function(d, ms) {return (ms.house_perimeter + ms.addition_perimeter)/50}"
}

addProduct2 {
    template_id :OwensCorningSillSealAddition
    name "Owens-Corning Sill Seal"
    shortname "Sill Seal"
    materials_cost 8.57
    labor_cost 5.00
    hd_sku 409989
    detail {
        name SELECTED_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn "function(d, ms) {return (2*ms.addition_length + ms.addition_width)/50;}"
}

addProduct2 {
    template_id :RimJoistsAndFloorJoists
    name "2\"x10\"x16' Rim Joists, 16\" Floor Joists"
    shortname "Rim/Floor Joists"
    materials_cost 18.00
    labor_cost 13.40
    hd_sku 603724
    detail {
        name SELECTED_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn "function(d, ms) {return ms.house_length/1.33 + ms.house_perimeter/16 + ms.addition_length/1.33 + ms.addition_perimeter/16;}"
}

addProduct2 {
    template_id :RimJoistsAndFloorJoistsAddition
    name "2\"x10\"x16' Rim Joists, 16\" Floor Joists"
    shortname "Rim/Floor Joists"
    materials_cost 18.00
    labor_cost 13.40
    hd_sku 603724
    detail {
        name SELECTED_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn "function(d, ms) {return (ms.addition_length/1.33) + ms.addition_perimeter/16;}"
}

addProduct2 {
    template_id :OSBSheet
    name "4'x8'x3/4\" T&G OSB Sheet"
    shortname "OSB Sheet"
    materials_cost 29.08
    labor_cost 17.92
    hd_sku 920924
    detail {
        name SELECTED_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn "function(d, ms) {return ((ms.house_length * ms.house_width)/32 +
        (ms.addition_length * ms.addition_width)/32)}"
}

addProduct2 {
    template_id :OSBSheetAddition
    name "4'x8'x3/4\" T&G OSB Sheet"
    shortname "OSB Sheet"
    materials_cost 29.08
    labor_cost 17.92
    hd_sku 920924
    detail {
        name SELECTED_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn "function(d, ms) {return (ms.addition_length * ms.addition_width)/32;}"
}

addProduct2 {
    template_id :ExteriorWallDoubleTopPlate2By4By96
    name "Exterior Wall Using 2\"x4\"x96\" Studs, Double Top Plate"
    shortname "Exterior Wall, 2\"x4\""
    materials_cost 4.29
    labor_cost 7.20
    hd_sku 161640
    detail {
        name LINEAR_FEET_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_times(1.25)
}

addProduct2 {
    template_id :ExteriorWallDoubleTopPlate2By6By96
    name "Exterior Wall Using 2\"x6\"x96\" Studs, Double Top Plate"
    shortname "Exterior Wall, 2\"x6\""
    materials_cost 6.50
    labor_cost 8.00
    hd_sku 161713
    detail {
        name LINEAR_FEET_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_times(1.25)
}

addProduct2 {
    template_id :OSBSheathing
    name "4'x8'x7/16\" OSB Sheathing"
    shortname "OSB Sheathing"
    materials_cost 12.25
    labor_cost 24.64
    hd_sku 386081
    detail {
        name LINEAR_FEET_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_times(1/4.0)
}

addProduct2 {
    template_id :Sheathing
    name "4'x8'x19/32\" Sheathing"
    shortname "Sheathing"
    materials_cost 18.97
    labor_cost 26.24
    hd_sku 166081
    detail {
        name SELECTED_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn "function(d, ms) {return (1.1/32)*(ms.house_length * ms.house_width);}"
}

addProduct2 {
    template_id :SheathingAddition
    name "4'x8'x19/32\" Sheathing"
    shortname "Sheathing"
    materials_cost 18.97
    labor_cost 26.24
    hd_sku 166081
    detail {
        name SELECTED_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn "function(d, ms) {return (1.1)/32*(ms.addition_length * ms.addition_width);}"
}

addProduct2 {
    template_id :FramingLumberFlatRoof
    name "2\"x8\"x16\' Framing Lumber (For Flat Roof)"
    materials_cost 12.17
    labor_cost 14.68
    hd_sku 201088
    detail {
        name SELECTED_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn "function(d, ms) {return (ms.house_length/2) + (ms.house_perimeter/16);}"
}

addProduct2 {
    template_id :TwoBy8By16FramingLumber
    name "2\"x8\"x16\' Framing Lumber (Flat Roof)"
    shortname "Framing Lumber"
    materials_cost 12.17
    labor_cost 14.68
    hd_sku 201088
    detail {
        name SELECTED_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn "function(d, ms) {return ms.addition_length/2 + ms.addition_perimeter/16;}"
}

addProduct2 {
    template_id :RoofTrusses
    name "Roof Trusses (Labor And Material Calculated By Supplier)"
    shortname "Roof Trusses"
    materials_cost 100.00
    labor_cost 20.00
    hd_sku nil
    detail {
        name QUANTITY_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_identity
}

####################################
#             Drywall              #
####################################
addProduct2 {
    template_id :RepairGypsumBoardHalfFourEight
    name '1/2"x4\'x8\' Gypsum Board'
    misc 'Repair Sheetrock Damage'
    materials_cost 10.48
    labor_cost 339.52
    hd_sku 893749
    detail {
        name QUANTITY_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_identity
}

addProduct2 {
    template_id :GypsumBoardHalfFourEight
    name '1/2"x4\'x8\' Gypsum Board'
    misc 'Supply/Hang/Tape/Finish'
    materials_cost 10.48
    labor_cost 44.52
    hd_sku 893749
    detail {
        name SELECTED_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn wall_area_and_floor_area_times(1/32.0)
}

addProduct2 {
    template_id :MoldToughGypsumBoardHalfFourEight
    name 'Mold Tough 1/2"x4\'x8\' Gypsum Board'
    shortname 'Mold Tough Gypsum Board'
    misc 'Supply/Hang/Tape/Finish'
    materials_cost 13.98
    labor_cost 41.02
    hd_sku 525423
    detail {
        name SELECTED_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn wall_area_and_floor_area_times(1/32.0)
}

addProduct2 {
    template_id :GypsumBoardHalfFourTwelve
    name '1/2"x4\'x12\' Gypsum Board'
    misc 'Supply/Hang/Tape/Finish'
    materials_cost 15.78
    labor_cost 44.52
    hd_sku 897148
    detail {
        name SELECTED_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn wall_area_and_floor_area_times(1/48.0)
}

####################################
#              Trim                #
####################################
addProduct2 {
    template_id :SixPanelPrehungDoor
    name "6-Panel H/C Prehung Interior Door, Defiant Satin Nickel Knob"
    shortname "6-Panel Prehung Interior Door"
    materials_cost 120.00
    labor_cost 75.00
    hd_sku 883624
    detail {
        name QUANTITY_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_identity
}

addProduct2 {
    template_id :TwentyFourInch6PanelBifoldDoor
    name "24\" 6-Panel Bi-Fold Door"
    materials_cost 47.00
    labor_cost 75.00
    hd_sku nil
    detail {
        name QUANTITY_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_identity
}

addProduct2 {
    template_id :SimpleCloset
    name "8' Pine Shelf, White Closet Pole, Pole Sockets"
    shortname "Shelf, Pole, Pole Sockets"
    materials_cost 43.71
    labor_cost 28.00
    hd_sku nil
    detail {
        name QUANTITY_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_identity
}

addProduct2 {
    template_id :WM623PJFBaseboard
    name "WM 623 9/16\"x3-1/4\"x192\" PFJ Baseboard"
    shortname  "WM 623 PFJ Baseboard"
    materials_cost 0.88
    labor_cost 1.50
    detail {
        name SELECTED_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn perimeter_identity
}

addProduct2 {
    template_id :WM163EPJFBaseboard
    name "WM 163E 9/16\"x5-1/4\"x192\" PFJ Baseboard"
    shortname "WM 163E PFJ Baseboard"
    materials_cost 1.16
    labor_cost 1.50
    hd_sku nil
    detail {
        name SELECTED_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn perimeter_identity
}

addProduct2 {
    template_id :WM49PJFCrownMoulding
    name "WM 49 19/32\"x3-5/8\"x192\" PFJ Crown Moulding"
    shortname "WM 49 PFJ Crown Moulding"
    materials_cost 0.99
    labor_cost 1.75
    detail {
        name SELECTED_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn perimeter_identity
}

addProduct2 {
    template_id :FeatherRiverZincDoor
    name "Feather River Lakewood Zinc 3/4 Oval Lite Stained Light Oak Fiberglass Prehung Front Door, 2 Sidelites"
    shortname "Zinc Oval Prehung Door"
    materials_cost 2421.00
    labor_cost 350.00
    hd_sku nil
    detail {
        name QUANTITY_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_identity
}

addProduct2 {
    template_id :FeatherRiverPatinaDoor
    name "Feather River Lakewood Patina 3/4 Oval Lite Stained Medium Oak Fiberglass Prehung Front Door, 1 Sidelite"
    shortname "Patina Oval Prehung Door"
    materials_cost 1433.00
    labor_cost 350.00
    hd_sku nil
    detail {
        name QUANTITY_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_identity
}

addProduct2 {
    template_id :FeatherRiverPatinaDoorNoSidelite
    name "Feather River Lakewood Patina 3/4 Oval Lite Stained Medium Oak Fiberglass Prehung Front Door, No Sidelite"
    shortname "Patina Oval Prehung Door"
    materials_cost 444.00
    labor_cost 350.00
    hd_sku 125397
    detail {
        name QUANTITY_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_identity
}

addProduct2 {
    template_id :SixPanelSteelDoor
    name "3068 6-Panel Primed Steel Prehung Front Door, Brickmold"
    shortname "Steel Prehung Door"
    materials_cost 177.00
    labor_cost 350.00
    hd_sku 827640
    detail {
        name QUANTITY_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_identity
}

addProduct2 {
    template_id :SixOhSixEightSlidingPatioDoor
    name "6068 Composite Right-Hand Sliding Patio Door, Smooth Interior"
    shortname "Sliding Patio Door"
    materials_cost 613.00
    labor_cost 350.00
    hd_sku 954964
    detail {
        name QUANTITY_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_identity
}

addProduct2 {
    template_id :SixOhSixEightFrenchPatioDoor
    name "6068 White Right-Hand Inswing Steel French Patio Door"
    shortname "French Patio Door"
    materials_cost 454.00
    labor_cost 350.00
    hd_sku 218126
    detail {
        name QUANTITY_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_identity
}

addProduct2 {
    template_id :KwiksetNickelExtKnob
    name "Kwikset Satin Nickel Ext Knob, Deadbolt, SmartKey"
    shortname "Nickel Ext Knob"
    materials_cost 53.00
    labor_cost 30.00
    hd_sku 909843
    detail {
        name QUANTITY_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_identity
}

addProduct2 {
    template_id :VinylWindows
    name "Average Size Vinyl Windows"
    shortname "Vinyl Windows"
    materials_cost 250.00
    labor_cost 100.00
    hd_sku nil
    detail {
        name QUANTITY_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_identity
}

addProduct2 {
    template_id :Andersen400SeriesWindows
    name "Andersen 400 Series Windows"
    shortname "Andersen 400 Windows"
    materials_cost 425.00
    labor_cost 50.00
    hd_sku nil
    detail {
        name QUANTITY_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_identity
}

addProduct2 {
    template_id :BayBowWindow
    name "Bay/Bow Window (custom)"
    shortname "Bay/Bow Window"
    materials_cost 3000.00
    labor_cost 400.00
    hd_sku nil
    detail {
        name QUANTITY_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_identity
}

# FIXME: Spreadsheet has weird quantity calculation
addProduct2 {
    template_id :WM376WindowDoorCasing
    name "WM 376 11/16\"x2-1/4\" PFJ Window/Door Casing"
    shortname "Window/Door Casing"
    materials_cost 0.50
    labor_cost 1.50
    hd_sku nil
    detail {
        name QUANTITY_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_identity
}

# FIXME: Spreadsheet has weird quantity calculation
addProduct2 {
    template_id :WM1021WindowStool
    name "WM 1021 11/16\"x5-1/4\" PFJ Window Stool"
    shortname "Window Stool"
    materials_cost 4.72
    labor_cost 2.25
    hd_sku nil
    detail {
        name QUANTITY_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_identity
}

addProduct2 {
    template_id :KitchenCabinets
    name "Kitchen Cabinets (Configured By Supplier)"
    shortname "Kitchen Cabinets"
    materials_cost 3500.00
    labor_cost 300.00
    hd_sku nil
    detail {
        name QUANTITY_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_identity
}

addProduct2 {
    template_id :Level2GraniteCounterTop
    name "Level 2 Granite Counter Top"
    materials_cost 45.00
    labor_cost 0.00
    hd_sku nil
    detail {
        name LINEAR_FEET_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_times(2.125)
}

addProduct2 {
    template_id :Level3GraniteCounterTop
    name "Level 3 Granite Counter Top"
    shortname "Granite Counter Top"
    materials_cost 65.00
    labor_cost 0.00
    hd_sku nil
    detail {
        name LINEAR_FEET_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_times(2.125)
}

addProduct2 {
    template_id :BullnoseEdgeOnGranite
    name "1/2 Bullnose Edge On Granite (Measure Outside Edge Of Granite)"
    shortname "1/2 Bullnose Edge"
    misc 'Self Install'
    materials_cost 14.00
    labor_cost 0.00
    hd_sku nil
    detail {
        name LINEAR_FEET_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_identity
}

addProduct2 {
    template_id :TesseraPianoNassau
    name "12\"x12\" Stone And Glass Mosaic Backsplash Tile"
    shortname "Stone, Glass Mosaic Tile"
    materials_cost 12.98
    labor_cost 4.00
    hd_sku 220098
    detail {
        name LINEAR_FEET_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_times(1.83*1.1)
}

addProduct2 {
    template_id :GlacierBayHamptonOakVanity48By21
    name "Glacier Bay Hampton 48\"x21\" Oak Vanity"
    shortname "Oak Vanity 48\"x21\""
    materials_cost 339.00
    labor_cost 100.00
    hd_sku 285603
    detail {
        name QUANTITY_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_identity
}

addProduct2 {
    template_id :GlacierBayHamptonOakVanity36By21
    name "Glacier Bay Hampton 36\"x21\" Oak Vanity"
    shortname "Oak Vanity 36\"x21\""
    materials_cost 259.00
    labor_cost 100.00
    hd_sku 285570
    detail {
        name QUANTITY_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_identity
}

addProduct2 {
    template_id :GlacierBayNewportOakVanity30By21
    name "Glacier Bay Hampton 30\"x21\" Oak Vanity"
    shortname "Oak Vanity 30\"x21\""
    materials_cost 209.00
    labor_cost 100.00
    hd_sku 285504
    detail {
        name QUANTITY_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_identity
}

addProduct2 {
    template_id :GlacierBayNewportVanityTop49
    name "Glacier Bay Newport 49\" Vanity Top"
    shortname "Vanity Top 49\""
    materials_cost 139.00
    labor_cost 25.00
    hd_sku 143770
    detail {
        name QUANTITY_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_identity
}

addProduct2 {
    template_id :GlacierBayNewportVanityTop37
    name "Glacier Bay Newport 37\" Vanity Top"
    shortname "Vanity Top 37\""
    materials_cost 99.00
    labor_cost 25.00
    hd_sku 143311
    detail {
        name QUANTITY_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_identity
}

addProduct2 {
    template_id :GlacierBayNewportVanityTop31
    name "Glacier Bay Newport 31\" Vanity Top"
    shortname "Vanity Top 31\""
    materials_cost 82.00
    labor_cost 25.00
    hd_sku 143626
    detail {
        name QUANTITY_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_identity
}

addProduct2 {
    template_id :PolishedEdgeMirror
    name "36\"x42\" Polished Edge Mirror"
    shortname "Polished Edge Mirror"
    materials_cost 39.99
    labor_cost 25.00
    hd_sku 1001085227
    detail {
        name QUANTITY_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_identity
}

addProduct2 {
    template_id :BeveledWallMirror
    name "36\"x30\" Beveled Wall Mirror"
    shortname "Beveled Wall Mirror"
    materials_cost 29.99
    labor_cost 25.00
    hd_sku 103649
    detail {
        name QUANTITY_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_identity
}

addProduct2 {
    template_id :BeveledEdgeMirror
    name "48\"x36\" Beveled Edge Mirror"
    shortname "Beveled Edge Mirror"
    materials_cost 45.98
    labor_cost 25.00
    hd_sku 1001085224
    detail {
        name QUANTITY_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_identity
}

addProduct2 {
    template_id :ZenithFramelessMedicineCabinet
    name "Zenith 16\"x24\" Frameless Mirrored Recessed Medicine Cabinet"
    shortname "Medicine Cabinet"
    materials_cost 89.99
    labor_cost 25.00
    hd_sku 197968
    detail {
        name QUANTITY_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_identity
}

addProduct2 {
    template_id :DeltaGreenwichTowelToiletPaperKit
    name "Delta Greenwich Towel Bar/Ring/Toilet Paper Kit"
    shortname "Towel/Toilet Paper Kit"
    materials_cost 49.98
    labor_cost 60.00
    hd_sku nil
    detail {
        name QUANTITY_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_identity
}

####################################
#               Paint              #
####################################
addProduct2 {
    template_id :SherwinWilliamsProMarEggShell
    name "Sherwin Williams ProMar 200 Eggshell, One Color, White Semi-Gloss On Trim"
    shortname "Sherwin Williams Eggshell"
    misc 'Supply/Paint Two Coats'
    materials_cost 25.00
    labor_cost 1.00
    hd_sku nil
    detail {
        name SELECTED_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(200.0*labor_cost)
    quantity_fn wall_area_and_floor_area_times(1.0/200.0)
}

addProduct2 {
    template_id :GrayEpoxyConcretePaintFloor
    name "1 gallon 902 Slate Gray 1-Part Epoxy Concrete/Garage Floor Paint"
    shortname "Epoxy Concrete/Paint"
    misc "Seal"
    materials_cost 0.07
    labor_cost 1.00
    hd_sku 396523
    detail {
        name SELECTED_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn floor_area_times(labor_cost)
    quantity_fn floor_area_times(1.0/400.0)
}

addProduct2 {
    template_id :GrayEpoxyConcretePaintWalls
    name "1 gallon 902 Slate Gray 1-Part Epoxy Concrete/Garage Wall Paint"
    shortname "Epoxy Concrete/Paint"
    misc "Seal"
    materials_cost 0.07
    labor_cost 0.50
    hd_sku 396523
    detail {
        name SELECTED_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn floor_area_times(labor_cost)
    quantity_fn wall_area_times(2)
}

####################################
#             Flooring             #
####################################
addProduct2 {
    template_id :HardwoodFloor
    name "Hardwood Floor (1 Coat Poly/Sealer, 2 Coats Water Poly, Subcontractor Supplies All Materials)"
    shortname "Hardwood Floor"
    misc "Refinish/Sand/Stain"
    materials_cost 0.00
    labor_cost 2.95
    hd_sku nil
    detail {
        name SELECTED_DETAIL
        units nil
    }
    materials_cost_total_fn zero
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn floor_area_identity
}

addProduct2 {
    template_id :BrucePlanoMarshOak
    name "Bruce Plano Marsh Oak 3/4\"x2-1/4\" HW Flooring"
    shortname "Bruce Plano Marsh Oak"
    materials_cost 3.29
    labor_cost 2.50
    hd_sku 296601
    detail {
        name SELECTED_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn floor_area_times(1.1)
}

addProduct2 {
    template_id :DurrockUnderlayment
    name "1/2\" Durrock Underlayment"
    materials_cost 0.00
    labor_cost 2.50
    hd_sku 917647
    detail {
        name SELECTED_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn floor_area_times(1)
}

addProduct2 {
    template_id :SantaBarbaraFloorTile
    name "Santa Barbara Pacific Sand 12\"x12\" Ceramic Floor Tile"
    shortname "Ceramic Floor Tile"
    materials_cost 1.57
    labor_cost 4.00
    hd_sku 616881
    detail {
        name SELECTED_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn floor_area_times(1.1)
}

addProduct2 {
    template_id :IvoryTravertineFloorWallTile
    name "Ivory 12\"x12\" Honed Travertine Floor, Wall Tile"
    shortname "Ivory Travertine Tile"
    materials_cost 2.97
    labor_cost 7.50
    hd_sku 553804
    detail {
        name SELECTED_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn floor_area_times(1.1)
}

addProduct2 {
    template_id :PennsylvaniaLaminateFlooring
    name "Pennsylvania Traditions Laminate Flooring"
    shortname "Laminate Flooring"
    materials_cost 1.29
    labor_cost 2.35
    hd_sku 1000025009
    detail {
        name SELECTED_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn floor_area_times(1.1)
}

addProduct2 {
    template_id :WhiteMarbleVinylSheet
    name "White Marble, 12' Wide Vinyl Sheet"
    shortname "White Marble Sheet"
    materials_cost 1.24
    labor_cost 2.00
    hd_sku 1001107266
    detail {
        name SELECTED_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn floor_area_times(1.1)
}

addProduct2 {
    template_id :CeramicFlooringPattern
    name "Ceramic Flooring, Pattern"
    shortname "Ceramic Flooring"
    materials_cost 4.00
    labor_cost 6.00
    detail {
        name SELECTED_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn floor_area_times(1.1)
}

addProduct2 {
    template_id :MohawkWestinHillCarpet
    name "Mohawk Westin Hill or Power Play carpet, with 1/2' 8 lb pad"
    shortname "Mohawk W/H Carpet"
    materials_cost 10.25
    labor_cost 5.25
    detail {
        name SELECTED_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn "function(d, ms) {
        let w = ms.width; w = (w <= 12 ? 12 : (w <= 15 ? 15 : 27));
        return (ms.length * w * (1/9));
    }"
}

addProduct2 {
    template_id :MohawkWestinHillCarpetSteps
    name "Mohawk Westin Hill or Power Play carpet, with 1/2' 8 lb pad on stairs"
    shortname "M/W/H Carpet Steps"
    materials_cost 13.00
    labor_cost 4.00
    hd_sku nil
    detail {
        name STEPS_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_identity
}

####################################
#            Electric              #
####################################
addProduct2 {
    template_id :HastingsFiveLightChandelier
    name "Hastings 5-Light Brushed Steel Chandelier"
    shortname "Hastings Steel Chandelier"
    materials_cost 139.00
    labor_cost 40.00
    hd_sku 1000014937
    detail {
        name QUANTITY_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_identity
}

addProduct2 {
    template_id :LyndhurstIndoorCeilingFan
    name "Lyndhurst 52\" Brushed Nickel Indoor Ceiling Fan"
    shortname "Lyndhurst Ceiling Fan"
    materials_cost 94.97
    labor_cost 50.00
    hd_sku 850193
    detail {
        name QUANTITY_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_identity
}

addProduct2 {
    template_id :DryerElectricOutlet
    name "Dryer Electric Outlet (30 Amp)"
    shortname "Dryer Outlet"
    materials_cost 100.00
    labor_cost 200.00
    hd_sku nil
    detail {
        name QUANTITY_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_identity
}

addProduct2 {
    template_id :WasherPlumbing
    name "Washer Plumbing"
    shortname "Washer Plumbing"
    materials_cost 100.00
    labor_cost 400.00
    hd_sku nil
    detail {
        name QUANTITY_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_identity
}

addProduct2 {
    template_id :ICAirtightHousing
    name "6\" Aluminum Recessed IC New Construction Airtight Housing, HD SKU 611290; 6\" R30 White Recessed Baffle Trim HD SKU 693032"
    shortname "IC Airtight Housting"
    materials_cost 13.34
    labor_cost 100.00
    hd_sku nil
    detail {
        name QUANTITY_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_identity
}

addProduct2 {
    template_id :HamptonBayNickelVanityLight
    name "Hampton Bay 3-Light Brushed Nickel Vanity Light"
    shortname "Nickel Vanity Light"
    materials_cost 39.98
    labor_cost 35.00
    hd_sku 610563
    detail {
        name QUANTITY_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_identity
}

addProduct2 {
    template_id :SeventyCFMCeilingExhaustFan
    name "70 CFM Ceiling Exhaust Fan with Light, White Grille, Bulb"
    shortname "Exhaust Fan"
    misc "Operating with separate switches"
    materials_cost 58.78
    labor_cost 75.00
    hd_sku 416986
    detail {
        name QUANTITY_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_identity
}

addProduct2 {
    template_id :CommercialElectricLEDFlushmount
    name "Commercial Electric Brushed Nickel LED Flushmount"
    shortname "LED Flushmount"
    materials_cost 24.97
    labor_cost 25.00
    hd_sku 696626
    detail {
        name QUANTITY_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_identity
}

addProduct2 {
    template_id :EntireHouseNew200AmpPanelAndLightingFixtures
    name "Entire House, New 200 Amp Panel, Lighting Fixtures"
    shortname "200 Amp Panel"
    materials_cost 0.00
    labor_cost 8825.00
    hd_sku nil
    detail {
        name QUANTITY_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_identity
}

addProduct2 {
    template_id :ServiceAndPanel
    name "Service And Panel (Total Amps)"
    shortname "Service And Panel"
    materials_cost 0.00
    labor_cost 3000.00
    hd_sku nil
    detail {
        name QUANTITY_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_identity
}

addProduct2 {
    template_id :NewElectricalPanel
    name "New Electrical Panel"
    materials_cost 0.00
    labor_cost 2000.00
    hd_sku nil
    detail {
        name QUANTITY_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_identity
}

addProduct2 {
    template_id :NewElectricCircuitOutlet
    name "New Electric Circuit, Outlet In New Interior Partition"
    shortname "Electric Circuit/Outlet"
    materials_cost 0.00
    labor_cost 100.00
    hd_sku nil
    detail {
        name QUANTITY_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_identity
}

addProduct2 {
    template_id :NewCircuitSwitchForCeilingFanOrLight
    name "New Circuit, Switch; For Ceiling Fan Or Light"
    shortname "Circuit/Switch"
    materials_cost 0.00
    labor_cost 125.00
    hd_sku nil
    detail {
        name QUANTITY_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_identity
}

addProduct2 {
    template_id :NewCircuitGFCIOutlet
    name "New Circuit, GFCI Outlet"
    shortname "Circuit, GFCI Outlet"
    materials_cost 0.00
    labor_cost 125.00
    hd_sku nil
    detail {
        name QUANTITY_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_identity
}

addProduct2 {
    template_id :Leviton15AmpDuplexOutlet
    name "New Leviton 15 Amp Duplex Outlet - White, SKU # 221860 or Leviton 15 Amp Single-Pole Toggle Switch - White, SKU # 614287, w/Mulberry Princess 1-Gang Maxi Wall Plate, SKU # 737949 in existing outlet box"
    shortname "15 Amp Duplex Outlet"
    materials_cost 1.44
    labor_cost 5.00
    hd_sku nil
    detail {
        name QUANTITY_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_identity
}

####################################
#            Plumbing              #
####################################
addProduct2 {
    template_id :KrausDoubleBowlKitchenSink
    name "Kraus Undermount Stainless Steel 32\" Double Bowl Kitchen Sink"
    shortname "Kraus Double Bowl Sink"
    materials_cost 279.95
    labor_cost 50.00
    hd_sku 1001297793
    detail {
        name QUANTITY_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_identity
}

addProduct2 {
    template_id :MoenBanburyKitchenFaucet
    name "Moen Banbury Kitchen Faucet"
    materials_cost 139.00
    labor_cost 200.00
    hd_sku 425242
    detail {
        name QUANTITY_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_identity
}


addProduct2 {
    template_id :WhirlpoolGarbageDisposal
    name "Whirlpool Garbage Disposal, Model GC2000XE"
    shortname "Garbage Disposal"
    materials_cost 87.00
    labor_cost 50.00
    hd_sku nil
    detail {
        name QUANTITY_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_identity
}

addProduct2 {
    template_id :ShelburnePedestalAndSinkBasin
    name "Shelburne Pedestal HD SKU 592680, Shelburne 20\" Pedestal Sink Basin HD SKU 779190"
    shortname "Shelburne Sink"
    materials_cost 88.00
    labor_cost 250.00
    hd_sku nil
    detail {
        name QUANTITY_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_identity
}

addProduct2 {
    template_id :MoenBanburyShowerheadFaucetKit
    name "Moen Banbury Brushed Nickel Showerhead, Faucet Kit"
    shortname "Showerhead, Faucet"
    materials_cost 157.00
    labor_cost 120.00
    hd_sku nil
    detail {
        name QUANTITY_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_identity
}

addProduct2 {
    template_id :MoenBanburyShowerhead
    name "Moen Banbury Brushed Nickel Showerhead"
    shortname "Showerhead, Faucet"
    materials_cost 142.00
    labor_cost 120.00
    hd_sku nil
    detail {
        name QUANTITY_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_identity
}

addProduct2 {
    template_id :NewPlumbingEntireHouse
    name "New Plumbing For Entire House (1,500 sq. ft 3/2 House)"
    shortname "New Plumbing"
    materials_cost 0.00
    labor_cost 8500.00
    hd_sku nil
    detail {
        name QUANTITY_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_identity
}

addProduct2 {
    template_id :NewPVCTrapSupplyLinesClosetFlangeValves
    name "New PVC Trap, Supply Lines, Closet Flange, Valves"
    shortname "PVC Trap, etc."
    materials_cost 0.00
    labor_cost 350.00
    hd_sku nil
    detail {
        name QUANTITY_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_identity
}

addProduct2 {
    template_id :GlacierBayToiletElongatedSeat
    name "Glacier Bay Toilet, Elongated, Seat"
    shortname "Toilet, Seat"
    materials_cost 104.00
    labor_cost 200.00
    hd_sku nil
    detail {
        name QUANTITY_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_identity
}

addProduct2 {
    template_id :TanklessWaterHeater
    name "Tankless Water Heater"
    materials_cost 1180.00
    labor_cost 400.00
    hd_sku nil
    detail {
        name QUANTITY_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_identity
}

addProduct2 {
    template_id :RheemNaturalGasWaterHeater
    name "Rheem 50 Gal Natural Gas Water Heater"
    materials_cost 609.00
    labor_cost 550.00
    hd_sku 1000035246
    detail {
        name QUANTITY_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_identity
}

addProduct2 {
    template_id :RheemElectricWaterHeater
    name "Rheem 50 Gal Electric Water Heater"
    materials_cost 399.00
    labor_cost 300.00
    hd_sku 1001301858
    detail {
        name QUANTITY_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_identity
}

addProduct2 {
    template_id :AutomaticSprinklers
    name "Automatic Sprinklers"
    materials_cost 0.00
    labor_cost 6000.00
    hd_sku nil
    detail {
        name QUANTITY_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_identity
}

addProduct2 {
    template_id :Twenty15ICCBuildingCodeSepticSystem
    name "2015 ICC Building Code Septic System"
    shortname "Septic System"
    materials_cost 0.00
    labor_cost 20000.00
    hd_sku nil
    detail {
        name QUANTITY_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_identity
}

addProduct2 {
    template_id :SepticSystem1500GallonTank
    name "Septic System, 1500 Gallon Tank"
    shortname "Septic System, 1500 Gallons"
    materials_cost 0.00
    labor_cost 5500.00
    hd_sku nil
    detail {
        name QUANTITY_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_identity
}

addProduct2 {
    template_id :SepticSystemTrencesLeachField
    name "Septic System Trenches (Leach Field Only)"
    shortname "Septic System Trenches"
    materials_cost 0.00
    labor_cost 3000.00
    hd_sku nil
    detail {
        name QUANTITY_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_identity
}

addProduct2 {
    template_id :WellWellPumpAndHeadPipe
    name "Well, 3/4 HP Well Pump, Well Head/Pipe"
    shortname "Well, Pump, Head/Pipe"
    materials_cost 0.00
    labor_cost 5000.00
    hd_sku nil
    detail {
        name QUANTITY_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_identity
}

addProduct2 {
    template_id :MoenBanburyLavatoryFaucet
    name "Moen Banbury Brushed Nickel 4\" Lavatory Faucet, Stopper, Drain"
    shortname "Lavatory Faucet"
    materials_cost 95.00
    labor_cost 175.00
    hd_sku nil
    detail {
        name QUANTITY_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_identity
}

####################################
#           Appliances             #
####################################
addProduct2 {
    template_id :WhirlpoolElectricRange
    name "Whirlpool Electric Range, Model WFE530C0ES"
    shortname "Electric Range"
    materials_cost 591.00
    labor_cost 50.00
    hd_sku nil
    detail {
        name QUANTITY_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_identity
}

addProduct2 {
    template_id :WhirlpoolRefrigerator
    name "Whirlpool Refrigerator, Model WRF736SDAM"
    shortname "Refrigerator"
    materials_cost 1563.00
    labor_cost 50.00
    hd_sku nil
    detail {
        name QUANTITY_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_identity
}

addProduct2 {
    template_id :WhirlpoolDishwasher
    name "Whirlpool Dishwasher, Model WDT920SADM"
    shortname "Whirlpool Dishwasher"
    materials_cost 603.00
    labor_cost 75.00
    hd_sku nil
    detail {
        name QUANTITY_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_identity
}

addProduct2 {
    template_id :WhirlpoolMicrowave
    name "Whirlpool Microwave, Model WMH53520CS"
    shortname "Whirlpool Microwave"
    materials_cost 299.00
    labor_cost 75.00
    hd_sku nil
    detail {
        name QUANTITY_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_identity
}

addProduct2 {
    template_id :RangeHoodWithFIT
    name "30\" Range Hood with the FIT System, Model UXT2030ADW"
    shortname "Range Hood"
    materials_cost 74.00
    labor_cost 75.00
    hd_sku nil
    detail {
        name QUANTITY_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_identity
}

addProduct2 {
    template_id :MaytagElectricRange
    name "Maytag Electric Range, Model MER8600DS"
    shortname "Maytag Electric Range"
    materials_cost 624.00
    labor_cost 50.00
    hd_sku nil
    detail {
        name QUANTITY_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_identity
}

addProduct2 {
    template_id :MaytagWideBottomMountRefrigerator
    name "Maytag 33\" Wide Bottom Mount Refrigerator 22 cu. ft., Model MBF2258DEM"
    shortname "Maytag Refrigerator"
    materials_cost 1111.00
    labor_cost 50.00
    hd_sku nil
    detail {
        name QUANTITY_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_identity
}

addProduct2 {
    template_id :MaytagDishwasher
    name "Maytag Dishwasher, Model MDB7949DM"
    shortname "Maytag Dishwasher"
    materials_cost 485.00
    labor_cost 75.00
    hd_sku nil
    detail {
        name QUANTITY_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_identity
}

addProduct2 {
    template_id :MaytagMicrowave
    name "Maytag Microwave, Model AMV1150VAS"
    shortname "Maytag Microwave"
    materials_cost 187.00
    labor_cost 75.00
    hd_sku nil
    detail {
        name QUANTITY_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_identity
}

addProduct2 {
    template_id :ApplicanceDelivery
    name "Appliance Delivery"
    shortname "Appliance Delivery"
    materials_cost 0.00
    labor_cost 75.00
    hd_sku nil
    detail {
        name QUANTITY_DETAIL
        units nil
    }
    materials_cost_total_fn zero
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_identity
}

####################################
#               Plan               #
####################################
addProduct2 {
    template_id :ArchitecturalDrawings
    name "Architectural Drawings"
    misc "Purchase"
    materials_cost 0.00
    labor_cost 850.00
    hd_sku nil
    detail {
        name QUANTITY_DETAIL
        units nil
    }
    materials_cost_total_fn zero
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_identity
}

addProduct2 {
    template_id :SiteGradingPlan
    name "Site Grading Plan"
    misc "Produce"
    materials_cost 0.00
    labor_cost 8000.00
    hd_sku nil
    detail {
        name QUANTITY_DETAIL
        units nil
    }
    materials_cost_total_fn zero
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_identity
}

addProduct2 {
    template_id :PercolationTest
    name "Percolation Test"
    misc "Conduct"
    materials_cost 0.00
    labor_cost 900.00
    hd_sku nil
    detail {
        name QUANTITY_DETAIL
        units nil
    }
    materials_cost_total_fn zero
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_identity
}

addProduct2 {
    template_id :WellSepticSystemVerification
    name "Well, Septic System Verification"
    shortname "Well/Septic Verification"
    misc "Conduct"
    materials_cost 0.00
    labor_cost 950.00
    hd_sku nil
    detail {
        name QUANTITY_DETAIL
        units nil
    }
    materials_cost_total_fn zero
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_identity
}

addProduct2 {
    template_id :PortableToilet
    name "Portable Toilet"
    misc "Rent"
    materials_cost 0.00
    labor_cost 127.50
    hd_sku nil
    detail {
        name QUANTITY_DETAIL
        units nil
    }
    materials_cost_total_fn zero
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_identity
}

addProduct2 {
    template_id :BuildingPermit
    name "Building Permit"
    misc "Obtain"
    taxable false
    materials_cost 250.00
    labor_cost 100.00
    hd_sku nil
    detail {
        name QUANTITY_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_identity
}

addProduct2 {
    template_id :TermiteTreatment
    name "Termite Treatment"
    misc "Apply"
    materials_cost 0.00
    labor_cost 400.00
    hd_sku nil
    detail {
        name QUANTITY_DETAIL
        units nil
    }
    materials_cost_total_fn zero
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_identity
}

addProduct2 {
    template_id :StructuralEngineerFoundation
    name "Structural Engineer Recommendations To Repair Foundation"
    misc "Hire"
    materials_cost 0.00
    labor_cost 750.00
    hd_sku nil
    detail {
        name QUANTITY_DETAIL
        units nil
    }
    materials_cost_total_fn zero
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_identity
}

####################################
#               Demo               #
####################################
addProduct2 {
    template_id :FifteenYardTruckDumpster
    name "Fifteen Yard Truck, Dumpster"
    shortname "Truck, Dumpster"
    misc "Haul Junk Left By Seller"
    materials_cost 0.00
    labor_cost 650.00
    hd_sku nil
    detail {
        name QUANTITY_DETAIL
        units nil
    }
    materials_cost_total_fn zero
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_identity
}

addProduct2 {
    template_id :ThreeManCrew
    name "Three Man Crew, 40 hours"
    misc "Demolition"
    materials_cost 0.00
    labor_cost 1920.00
    hd_sku nil
    detail {
        name QUANTITY_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_identity
}

addProduct2 {
    template_id :ThirtyYardDumpster
    name "Thirty Yard Dumpster"
    misc "Rent"
    taxable false
    materials_cost 450.00
    labor_cost 0.00
    hd_sku nil
    detail {
        name QUANTITY_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn zero
    quantity_fn detail_identity
}

addProduct2 {
    template_id :RemoveMold
    name "Remove Mold"
    misc "Treat"
    materials_cost 0.00
    labor_cost 1000.00
    hd_sku nil
    detail {
        name QUANTITY_DETAIL
        units nil
    }
    materials_cost_total_fn zero
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_identity
}

addProduct2 {
    template_id :RemoveAsbestosSidingOrShingles
    name "Remove Asbestos Siding Or Shingles"
    misc "Remove"
    materials_cost 0.00
    labor_cost 1500.00
    hd_sku nil
    detail {
        name QUANTITY_DETAIL
        units nil
    }
    materials_cost_total_fn zero
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_identity
}

####################################
#            Foundation            #
####################################
addProduct2 {
    template_id :ExcavateFormReinforceFinishNewFootings
    name "Excavate, Form, Reinforce And Finish New Footings, 24\" Wide And 30\" Below Grade"
    shortname "Excavate to Finish Footings"
    misc "Excavate"
    materials_cost 25.50
    labor_cost 28.68
    hd_sku nil
    detail {
        name SELECTED_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn "function(d, ms) {return ms.addition_perimeter;}"
}

addProduct2 {
    template_id :ExcavateFormReinforceFinishNewFootingsAddition
    name "Excavate, Form, Reinforce And Finish New Footings, 24\" Wide And 30\" Below Grade"
    shortname "Excavate Addition"
    misc "Excavate"
    materials_cost 25.50
    labor_cost 28.68
    hd_sku nil
    detail {
        name SELECTED_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn "function(d, ms) {return 2*ms.addition_length + ms.addition_width;}"
}

addProduct2 {
    template_id :FoundationWallsPoured
    name "Foundation walls (Poured, Block)"
    shortname "Pour Foundation"
    misc "Construct"
    materials_cost 0.00
    labor_cost 5.00
    hd_sku nil
    detail {
        name SELECTED_DETAIL
        units nil
    }
    materials_cost_total_fn zero
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn "function(d, ms) {return ms.house_length + ms.house_width + ms.addition_length + ms.addition_width;}"
}

addProduct2 {
    template_id :FoundationWallsPouredAddition
    name "Foundation Walls Addition (Poured, Block)"
    shortname "Pour Foundation Addition"
    misc "Construct"
    materials_cost 0.00
    labor_cost 5.00
    hd_sku nil
    detail {
        name SELECTED_DETAIL
        units nil
    }
    materials_cost_total_fn zero
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn "function(d, ms) {return 2*ms.addition_length + ms.addition_width;}"
}

####################################
#             Roofing              #
####################################
addProduct2 {
    template_id :NewRoof
    name "New Roof, Layover Shingle Installation; Includes Tamko Heritage Architectural Shingles, 15 lb Roofer's Felt, C 3-1/2 Aluminum White Drip Edge, up to 3 1.5\" to 3\" aluminum pipe collars"
    shortname "New Roof"
    materials_cost 121.40
    labor_cost 120.00
    hd_sku nil
    detail {
        name SELECTED_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn "function(d, ms) {
        const p = 2*ms.house_gable_height/ms.house_gable_width;
        const x = (p <= 6 ? 1.08 : (p <= 9 ? 1.25 : 1.42));
        return ((ms.house_length * ms.house_width) + (ms.addition_length * ms.addition_width) + (ms.garage_length * ms.garage_width))*(x/100)};"
}

addProduct2 {
    template_id :NewRoofAddition
    name "New Roof, Layover Shingle Installation; Includes Tamko Heritage Architectural Shingles, 15 lb Roofer's Felt, C 3-1/2 Aluminum White Drip Edge, up to 3 1.5\" to 3\" aluminum pipe collars"
    shortname "New Roof"
    materials_cost 121.40
    labor_cost 120.00
    hd_sku nil
    detail {
        name SELECTED_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn "function(d, ms) {
        const p = 2*ms.gable_height/ms.gable_width;
        const x = (p <= 6 ? 1.08 : (p <= 9 ? 1.25 : 1.42));
        return ((ms.addition_length * ms.addition_width) + (ms.garage_length * ms.garage_width))*(x/100)};"
}

addProduct2 {
    template_id :TamkoElite25Shingles
    name "Tamko Elite25 3-Tab Shingles (Top Ridge Vent)"
    shortname "Tamko Shingles"
    materials_cost 29.81
    labor_cost 0.00
    hd_sku nil
    detail {
        name SELECTED_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn zero
    quantity_fn "function(d, ms) {return (ms.house_length * ms.house_width) * (0.15/100);}"
}

addProduct2 {
    template_id :AluminumStandardEdge
    name "C3 - 1/2 Aluminum Standard White Drip Edge"
    shortname "Aluminum Standard Edge"
    materials_cost 3.60
    labor_cost 0.00
    hd_sku nil
    detail {
        name QUANTITY_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn zero
    quantity_fn "function(d, ms) {return (ms.house_length*1.42)/10;}"
}

addProduct2 {
    template_id :Cobra3ExhaustVent
    name "Cobra 3 13-3/4\"x48\" Roof Ridge Exhaust Vent"
    shortname "Roof Ridge Exhaust Vent"
    materials_cost 10.00
    labor_cost 0.00
    hd_sku nil
    detail {
        name SELECTED_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn zero
    quantity_fn "function(d, ms) {return (ms.house_length + ms.addition_length)/4;}"
}

addProduct2 {
    template_id :WeatherWatchIceWaterBarrier
    name "WeatherWatch Ice/Water Barrier (3' x 50', For Valleys)"
    shortname "Ice Water Barrier"
    materials_cost 63.00
    labor_cost 0.00
    hd_sku nil
    detail {
        name QUANTITY_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn zero
    quantity_fn detail_identity
}

addProduct2 {
    template_id :BlackStepFlashing
    name "Aluminum Black Step Flashing, 100 pcs/pack"
    shortname "Black Step Flashing"
    materials_cost 28.42
    labor_cost 0.00
    hd_sku nil
    detail {
        name QUANTITY_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn zero
    quantity_fn detail_identity
}

addProduct2 {
    template_id :ChimneyFlashing
    name "Flashing Around 2' x 2' Chimney"
    shortname "Chimney Flashing"
    materials_cost 0.00
    labor_cost 200.00
    hd_sku nil
    detail {
        name QUANTITY_DETAIL
        units nil
    }
    materials_cost_total_fn zero
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_identity
}

addProduct2 {
    template_id :RoofSheathing
    name "Roof Sheathing - 4'x8' Sheet Or Less"
    shortname "Roof Sheathing"
    materials_cost 18.97
    labor_cost 50.00
    hd_sku nil
    detail {
        name QUANTITY_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_identity
}

addProduct2 {
    template_id :FasciaRake
    name "Fascia/Rake - 1x6 FJP"
    shortname "Fascia/Rake"
    materials_cost 1.18
    labor_cost 3.85
    hd_sku nil
    detail {
        name QUANTITY_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_identity
}

####################################
#             Gutters              #
####################################
addProduct2 {
    template_id :WhiteGutters
    name "White 5\" Gutters, Hidden Hangers"
    shortname "White Gutters"
    materials_cost 0.00
    labor_cost 3.25
    hd_sku nil
    detail {
        name SELECTED_DETAIL
        units nil
    }
    materials_cost_total_fn zero
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn "function(d, ms) {return ms.house_length * 2}"
}

addProduct2 {
    template_id :WhiteGuttersAddition
    name "White 5\" Gutters, Hidden Hangers"
    shortname "White Gutters"
    materials_cost 0.00
    labor_cost 3.25
    hd_sku nil
    detail {
        name SELECTED_DETAIL
        units nil
    }
    materials_cost_total_fn zero
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn "function(d, ms) {return ms.addition_length * 2}"
}

addProduct2 {
    template_id :WhiteDownspouts
    name "White 2\"x3\" Downspouts"
    shortname "White Downspouts"
    materials_cost 0.00
    labor_cost 3.25
    hd_sku nil
    detail {
        name SELECTED_DETAIL
        units nil
    }
    materials_cost_total_fn zero
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn "function(d, ms) {return ms.house_height + 2}"
}

addProduct2 {
    template_id :WhiteDownspoutsAddition
    name "White 2\"x3\" Downspouts"
    shortname "White Downspouts"
    materials_cost 0.00
    labor_cost 3.25
    hd_sku nil
    detail {
        name SELECTED_DETAIL
        units nil
    }
    materials_cost_total_fn zero
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn "function(d, ms) {return ms.addition_height + 2}"
}

addProduct2 {
    template_id :LeafRelief
    name "5\" Leaf Relief"
    shortname "Leaf Relief"
    materials_cost 0.00
    labor_cost 4.25
    hd_sku nil
    detail {
        name SELECTED_DETAIL
        units nil
    }
    materials_cost_total_fn zero
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn "function(d, ms) {return ms.house_length * 2}"
}

addProduct2 {
    template_id :LeafReliefAddition
    name "5\" Leaf Relief"
    shortname "Leaf Relief"
    materials_cost 0.00
    labor_cost 4.25
    hd_sku nil
    detail {
        name SELECTED_DETAIL
        units nil
    }
    materials_cost_total_fn zero
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn "function(d, ms) {return ms.addition_length * 2}"
}

####################################
#             Siding               #
####################################
addProduct2 {
    template_id :CertainteedDoubleDuthSiding
    name "Certainteed Mainstreet 5\" Double Dutch Siding"
    shortname "Double Dutch Siding"
    materials_cost 83.00
    labor_cost 150.00
    hd_sku nil
    detail {
        name SELECTED_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn "function(d, ms) {return ((ms.house_length * ms.house_height)*2 +
        (ms.house_width * ms.house_height)*2 +
        (ms.house_gable_width * ms.house_gable_height)/2)/100 +
        ((ms.addition_length * ms.addition_height)*2 +
        (ms.addition_width * ms.addition_height)*2 +
        (ms.addition_gable_width * ms.addition_gable_height)/2)/100 +
        ((ms.garage_length * ms.garage_height)*2 +
        (ms.garage_width * ms.garage_height)*2 +
        (ms.garage_gable_width * ms.garage_gable_height)/2)/100;}"
}

addProduct2 {
    template_id :CertainteedInsideCorner
    name "Certainteed Mainstreet Inside Corner (Matching)"
    shortname "Inside Corner"
    materials_cost 10.59
    labor_cost 0.00
    hd_sku nil
    detail {
        name QUANTITY_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn zero
    quantity_fn detail_identity
}

addProduct2 {
    template_id :CertainteedOutsideCorner
    name "Certainteed Mainstreet Outside Corner (Matching)"
    shortname "Outside Corner"
    materials_cost 20.74
    labor_cost 0.00
    hd_sku nil
    detail {
        name QUANTITY_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn zero
    quantity_fn detail_identity
}

addProduct2 {
    template_id :CertainteedJChannel
    name "Certainteed Mainstreet J-Channel (Matching)"
    shortname "J-Channel"
    materials_cost 4.29
    labor_cost 0.00
    hd_sku nil
    detail {
        name QUANTITY_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn zero
    quantity_fn detail_identity
}

addProduct2 {
    template_id :CertainteedUSill
    name "Certainteed Mainstreet U-Sill (Matching)"
    shortname "U-Sill"
    materials_cost 4.75
    labor_cost 0.00
    hd_sku nil
    detail {
        name QUANTITY_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn zero
    quantity_fn detail_identity
}

addProduct2 {
    template_id :VinylSidingStarterStrip
    name "Vinyl Siding Starter Strip 12'"
    shortname "Vinyl Siding Strip"
    materials_cost 2.71
    labor_cost 0.00
    hd_sku nil
    detail {
        name SELECTED_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn zero
    quantity_fn "function(d, ms) {return (ms.house_length + ms.house_width +
        ms.addition_length + ms.addition_width)*(2/12);}"
}

addProduct2 {
    template_id :CompleteVinylSidingInstallation
    name "Complete Vinyl Siding Installation (Certainteed Mainstreet 5\" Double Dutch Siding, Inside/Outside Corners, J-Channel, U-Sill, Soffit)"
    shortname "Complete Vinyl Siding"
    materials_cost 83.00
    labor_cost 150.00
    hd_sku nil
    detail {
        name SELECTED_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn "function(d, ms) {return ((2*ms.addition_length*ms.addition_height) + (ms.addition_width*ms.addition_height) + (ms.gable_width * ms.gable_height/2))/100}"
}

addProduct2 {
    template_id :WhiteJChannel
    name "5/8\" White J-Channel, 12' piece"
    shortname "White J-Channel"
    materials_cost 6.78
    labor_cost 0.00
    hd_sku nil
    detail {
        name QUANTITY_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn zero
    quantity_fn detail_identity
}

addProduct2 {
    template_id :WhiteVinylSoffit
    name "White Vented Vinyl Soffit, 12'x4\" panel"
    shortname "White Vinyl Soffit"
    materials_cost 15.70
    labor_cost 2.50
    hd_sku nil
    detail {
        name SELECTED_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn "function(d, ms) {return ms.house_length/4;}"
}

addProduct2 {
    template_id :StoneFacade
    name "Stone Facade"
    materials_cost 6.00
    labor_cost 25.00
    hd_sku nil
    detail {
        name SELECTED_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn "function(d, ms) {return ms.house_length*ms.house_height;}"
}

addProduct2 {
    template_id :StoneFacadeAddition
    name "Stone Facade"
    materials_cost 6.00
    labor_cost 25.00
    hd_sku nil
    detail {
        name SELECTED_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn "function(d, ms) {return ms.addition_length*ms.addition_height;}"
}

addProduct2 {
    template_id :BrickExterior
    name "Brick Exterior"
    materials_cost 6.00
    labor_cost 25.00
    hd_sku nil
    detail {
        name SELECTED_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn "function(d, ms) {return ((ms.house_length * ms.house_height)*2 +
        (ms.house_width * ms.house_height)*2 +
        (ms.house_gable_width * ms.house_gable_height)/2)/100;}"
}

addProduct2 {
    template_id :BrickExteriorAddition
    name "Brick Exterior"
    materials_cost 6.00
    labor_cost 25.00
    hd_sku nil
    detail {
        name SELECTED_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn "function(d, ms) {return ((2*ms.addition_length*ms.addition_height) + (ms.addition_width*ms.addition_height) + (ms.gable_width * ms.gable_height/2))/100}"
}

addProduct2 {
    template_id :TrimCoilStock
    name "White Aluminum Trim Coil Stock"
    materials_cost 1.50
    labor_cost 2.00
    hd_sku nil
    detail {
        name QUANTITY_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_identity
}

addProduct2 {
    template_id :PVCBrickmold
    name "White PVC Brickmold"
    materials_cost 1.50
    labor_cost 2.50
    hd_sku nil
    detail {
        name QUANTITY_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_identity
}

addProduct2 {
    template_id :PowerwashExterior
    name "Powerwash House Exterior"
    materials_cost 0.00
    labor_cost 0.25
    hd_sku nil
    detail {
        name SELECTED_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn "function(d, ms) {return ((ms.house_length * ms.house_height)*2 +
        (ms.house_width * ms.house_height)*2 +
        (ms.house_gable_width * ms.house_gable_height)/2)/100 +
        ((ms.addition_length * ms.addition_height)*2 +
        (ms.addition_width * ms.addition_height)*2 +
        (ms.addition_gable_width * ms.addition_gable_height)/2)/100 +
        ((ms.garage_length * ms.garage_height)*2 +
        (ms.garage_width * ms.garage_height)*2 +
        (ms.garage_gable_width * ms.garage_gable_height)/2)/100;}"
}

addProduct2 {
    template_id :RepairPargingMortar
    name "Repair Parging/Mortar"
    materials_cost 0.00
    labor_cost 10.00
    hd_sku nil
    detail {
        name QUANTITY_DETAIL
        units nil
    }
    materials_cost_total_fn zero
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_identity
}

addProduct2 {
    template_id :PrepPaintExterior
    name "Prep/Paint Exterior Walls/Siding (Whole Property, Trim)"
    materials_cost 0.15
    labor_cost 1.50
    hd_sku nil
    detail {
        name SELECTED_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn "function(d, ms) {return ((ms.house_length * ms.house_height)*2 +
        (ms.house_width * ms.house_height)*2 +
        (ms.house_gable_width * ms.house_gable_height)/2);}"
}

addProduct2 {
    template_id :PrepPaintExteriorAddition
    name "Prep/Paint Exterior Walls/Siding (Whole Property, Trim)"
    materials_cost 0.15
    labor_cost 1.50
    hd_sku nil
    detail {
        name SELECTED_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn "function(d, ms) {return (2*ms.addition_length*ms.addition_height) + (ms.addition_width*ms.addition_height) + (ms.gable_width * ms.gable_height/2)}"
}

addProduct2 {
    template_id :PrepPaintExteriorTrim
    name "Prep/Paint Exterior Trim"
    materials_cost 0.15
    labor_cost 1.50
    hd_sku nil
    detail {
        name QUANTITY_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_identity
}

####################################
#             Garage               #
####################################
addProduct2 {
    template_id :GarageDoorEightBySeven
    name "Garage Door 8'x7' Door, Track, Springs"
    shortname "8'x7' Garage Door"
    materials_cost 0.00
    labor_cost 600.00
    hd_sku nil
    detail {
        name QUANTITY_DETAIL
        units nil
    }
    materials_cost_total_fn zero
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_identity
}

addProduct2 {
    template_id :GarageDoorNineBySeven
    name "Garage Door 9'x7' Door, Track, Springs"
    shortname "9'x7' Garage Door"
    materials_cost 0.00
    labor_cost 800.00
    hd_sku nil
    detail {
        name QUANTITY_DETAIL
        units nil
    }
    materials_cost_total_fn zero
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_identity
}

addProduct2 {
    template_id :GarageDoorSixteenBySeven
    name "Garage Door 16'x7' Door, Track, Springs"
    shortname "16'x7' Garage Door"
    materials_cost 0.00
    labor_cost 1500.00
    hd_sku nil
    detail {
        name QUANTITY_DETAIL
        units nil
    }
    materials_cost_total_fn zero
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_identity
}

addProduct2 {
    template_id :GarageDoorOpener
    name "Garage Door Opener"
    materials_cost 0.00
    labor_cost 225.00
    hd_sku nil
    detail {
        name QUANTITY_DETAIL
        units nil
    }
    materials_cost_total_fn zero
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_identity
}

####################################
#             Chimney              #
####################################
addProduct2 {
    template_id :BrickFireplace
    name "Brick Fireplace, Firebox And Chimney"
    shortname "Brick Fireplace"
    materials_cost 0.00
    labor_cost 8000.00
    hd_sku nil
    detail {
        name QUANTITY_DETAIL
        units nil
    }
    materials_cost_total_fn zero
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_identity
}

####################################
#            Driveway              #
####################################
addProduct2 {
    template_id :RemoveExistingDriveway
    name "Remove Existing Concrete/Asphalt Driveway"
    shortname "Remove Driveway"
    misc "Demo"
    materials_cost 0.00
    labor_cost 6.00
    hd_sku nil
    detail {
        name SQUARE_FEET_DETAIL
        units nil
    }
    materials_cost_total_fn zero
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_identity
}

addProduct2 {
    template_id :ConcreteDriveway
    name "Concrete Driveway, Excavation, Gravel"
    shortname "Concrete Driveway"
    materials_cost 0.00
    labor_cost 8.00
    hd_sku nil
    detail {
        name SQUARE_FEET_DETAIL
        units nil
    }
    materials_cost_total_fn zero
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_identity
}

addProduct2 {
    template_id :AsphaltDriveway
    name "Asphalt Driveway, Excavation, Gravel"
    materials_cost 0.00
    labor_cost 5.00
    hd_sku nil
    detail {
        name SQUARE_FEET_DETAIL
        units nil
    }
    materials_cost_total_fn zero
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_identity
}

####################################
#           Landscaping            #
####################################
addProduct2 {
    template_id :PlantsBushesLargeLot
    name "Large (> 1/2 acre) Lot. Includes $500 Assorted Plants/Bushes"
    shortname "Plants/Bushes Large"
    misc "Landscape"
    materials_cost 500.00
    labor_cost 4500.00
    hd_sku nil
    detail {
        name QUANTITY_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_identity
}

addProduct2 {
    template_id :PlantsBushesMediumLot
    name "Medium (< 1/2 acre) lot. Includes $300 assorted plants/bushes"
    shortname "Plants/Bushes Medium"
    misc "Landscape"
    materials_cost 300.00
    labor_cost 2700.00
    hd_sku nil
    detail {
        name QUANTITY_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_identity
}

addProduct2 {
    template_id :PlantsBushesSmallLot
    name "Small lot. Includes $200 assorted palants/bushes"
    shortname "Plants/Bushes Small"
    misc "Landscape"
    materials_cost 200.00
    labor_cost 1800.00
    hd_sku nil
    detail {
        name QUANTITY_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_identity
}

addProduct2 {
    template_id :MinorYardWork
    name "Minor Yard Work (Mowing, Trimming)"
    shortname "Minor Yard Work"
    misc "Landscape"
    materials_cost 0.00
    labor_cost 500.00
    hd_sku nil
    detail {
        name QUANTITY_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_identity
}

addProduct2 {
    template_id :RemoveExistingTreesShrubs
    name "Remove Existing Trees/Shrubs"
    misc "Remove"
    materials_cost 0.00
    labor_cost 1000.00
    hd_sku nil
    detail {
        name QUANTITY_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_identity
}

addProduct2 {
    template_id :PlantNewTree
    name "Plant New Tree"
    misc "Plant"
    materials_cost 100.00
    labor_cost 20.00
    hd_sku nil
    detail {
        name QUANTITY_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_identity
}

####################################
#              Deck                #
####################################
addProduct2 {
    template_id :DeckPressureTreated
    name "All materials and fasteners, to build deck to meet 2015 building code. Including 24\" diameter, 12' thick concrete footings; PT 6x6 posts, double 2x10 PT beam, 2x8 PT joists, 5/4\" PT decking, 4x4 PT rail posts,  2x2 PT ballusters"
    shortname "Pressure-Treated Deck"
    materials_cost 7.00
    labor_cost 8.00
    hd_sku nil
    detail {
        name SELECTED_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn "function(d, ms) {return (ms.deck_length * ms.deck_width);}"
}

addProduct2 {
    template_id :DeckComposite
    name "All materials and fasteners, to build deck to meet 2015 building code. Including 24\" diameter, 12' thick concrete footings; PT 6x6 posts, double 2x10 PT beam, 2x8 PT joists, 5/4\" COMPOSITE decking, 4x4 PT rail posts,  2x2 ballusters"
    shortname "Composite Deck"
    materials_cost 10.25
    labor_cost 9.00
    hd_sku nil
    detail {
        name SELECTED_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn "function(d, ms) {return (ms.deck_length * ms.deck_width);}"
}

addProduct2 {
    template_id :DeckNoInfrastructurePressureTreated
    name "5/4\"x6\" Pressure-Treated Decking (No Infrastructure)"
    shortname 'Deck, No Infrastructure'
    materials_cost 1.25
    labor_cost 5.00
    hd_sku nil
    detail {
        name SELECTED_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn "function(d, ms) {return (ms.deck_length * ms.deck_width);}"
}

addProduct2 {
    template_id :DeckStairsPressureTreated
    name "Deck Stairs, Pressure-Treated"
    shortname "Deck Stairs PT"
    materials_cost 20.00
    labor_cost 25.00
    hd_sku nil
    detail {
        name STEPS_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_identity
}

addProduct2 {
    template_id :DeckStairsComposite
    name "Deck Stairs, Composite"
    shortname "Deck Stairs Composite"
    materials_cost 23.25
    labor_cost 30.00
    hd_sku nil
    detail {
        name STEPS_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_identity
}

####################################
#             Fence                #
####################################
addProduct2 {
    template_id :FencePanelPressureTreated
    name "6'x8' Pressure-Treated Pine Shadowbox Fence Panel"
    materials_cost 52.97
    labor_cost 15.00
    hd_sku 647550
    detail {
        name LINEAR_FEET_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_identity
}

addProduct2 {
    template_id :GatePanelPressureTreated
    name "Pressure-Treated Shadowbox Gate Panel"
    materials_cost 25.00
    labor_cost 50.00
    hd_sku nil
    detail {
        name QUANTITY_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_identity
}

addProduct2 {
    template_id :ChainLinkFence
    name "50' Chain Link Fence, No Gate"
    materials_cost 1.75
    labor_cost 2.50
    hd_sku nil
    detail {
        name LINEAR_FEET_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_identity
}

####################################
#           Ceramic                #
####################################
addProduct2 {
    template_id :BootzIndustriesSoakingTub
    name "Bootz Industries Aloha 5' Right Hand Drain Soaking Tub in White"
    shortname "Soaking Tub"
    materials_cost 134.00
    labor_cost 250.00
    hd_sku nil
    detail {
        name QUANTITY_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_identity
}

addProduct2 {
    template_id :MoenCurvedShowerRod
    name "Moen 60\" Curved Shower Rod with Pivoting Flanges in Brushed Nickel"
    shortname "Curved Shower Rod"
    materials_cost 29.29
    labor_cost 100.00
    hd_sku nil
    detail {
        name QUANTITY_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_identity
}

addProduct2 {
    template_id :KohlerSlidingBathtubDoorAndHandle
    name "Kohler Levity 59-5/8\" x 62\" Semi-Frameless Sliding Bathtub Door and Handle in Nickel"
    shortname "Bathtub Door/Handle"
    materials_cost 349.00
    labor_cost 350.00
    hd_sku nil
    detail {
        name QUANTITY_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_identity
}

addProduct2 {
    template_id :DurocHalfThreeFiveCementBoard
    name "Duroc 1/2\"x3'x5' Cement Board"
    shortname "Duroc Cement Board"
    materials_cost 0.70
    labor_cost 1.80
    hd_sku 917647
    detail {
        name SELECTED_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn "function(d, ms) {return ms.shower_wall_area}"
}

addProduct2 {
    template_id :SantaBarbaraCeramicMosaicTile
    name "Santa Barbara Pacific Sand Blend Glazed Ceramic Mosaic Tile"
    shortname "Ceramic Mosaic Tile"
    materials_cost 2.00
    labor_cost 4.00
    hd_sku 769427
    detail {
        name SELECTED_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn "function(d, ms) {return ms.shower_wall_area}"
}

addProduct2 {
    template_id :MarbleAccentWallTile
    name "2-3/8\"x12\" Marble Accent Wall Tile"
    shortname "Marble Wall Tile"
    materials_cost 4.68
    labor_cost 4.00
    hd_sku 771392
    detail {
        name SELECTED_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn "function(d, ms) {return ms.shower_wall_area}"
}

addProduct2 {
    template_id :SantaBarbaraCeramicBullnose
    name "Santa Barbara Pacific Sand 3\"x12\" Ceramic Bullnose"
    shortname "Ceramic Bullnose"
    materials_cost 2.70
    labor_cost 2.50
    hd_sku 768618
    detail {
        name SELECTED_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn "function(d, ms) {return ms.shower_wall_area}"
}

addProduct2 {
    template_id :ShowerWallTile
    name "Shower Wall Tile, Pattern"
    shortname "Shower Wall Tile"
    materials_cost 4.00
    labor_cost 6.00
    hd_sku nil
    detail {
        name SELECTED_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn "function(d, ms) {return ms.shower_wall_area*1.01}"
}

addProduct2 {
    template_id :WallMountSoapDish
    name "White Wall Mount Ceramic Soap Dish"
    shortname "Soap Dish"
    materials_cost 9.48
    labor_cost 12.50
    hd_sku 405625
    detail {
        name QUANTITY_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_identity
}

addProduct2 {
    template_id :KohlerWellworthRoundToilet
    name "Kohler Wellworth Classic Complete Solution 2-piece 1.28 GPF Single Flush Round Toilet in White"
    shortname "Round Toilet"
    materials_cost 128.00
    labor_cost 250.00
    hd_sku nil
    detail {
        name QUANTITY_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_identity
}

addProduct2 {
    template_id :CustomMudPan
    name "Custom Mud Pan (Liner, Tile (16 sq. ft) Installation, Grout, Drain Trim Placement)"
    shortname "Custom Mud Pan"
    materials_cost 0.00
    labor_cost 915.36
    hd_sku nil
    detail {
        name QUANTITY_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_identity
}

addProduct2 {
    template_id :RondecBullnoseTileEdgingTrim
    name "Rondec Satin Nickel Anodized Aluminum 3/8\"x8\' 2-1/2\" Metal Bullnose Tile Edging Trim"
    shortname "Tile Edging Trim"
    materials_cost 4.00
    labor_cost 4.00
    hd_sku nil
    detail {
        name LINEAR_FEET_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_times(2*2.38)
}

addProduct2 {
    template_id :FourteenBy14RecessedShowerShelf
    name "14\"x14\" Recessed Shower Shelf"
    shortname "Recessed Shower Shelf"
    materials_cost 14.00
    labor_cost 25.00
    hd_sku nil
    detail {
        name QUANTITY_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_identity
}

# FIXME: Implement `Ceramic tile on 14"x14" recessed shower shelf`

addProduct2 {
    template_id :SixBy14RecessedShowerShelf
    name "6\"x14\" Recessed Shower Shelf"
    shortname "Recessed Shower Shelf"
    materials_cost 14.00
    labor_cost 25.00
    hd_sku nil
    detail {
        name QUANTITY_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_identity
}

# FIXME: Implement `Ceramic tile on 6"x14"" recessed shower shelf`

addProduct2 {
    template_id :SealShowerWalls
    name "Seal Shower Walls"
    materials_cost 0.00
    labor_cost 450.00
    hd_sku nil
    detail {
        name QUANTITY_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_identity
}

addProduct2 {
    template_id :CustomGlassShowerEnclosure
    name "Custom Glass Shower Enclosure, Brushed Nickel HW"
    shortname "Glass Shower Enclosure"
    materials_cost 0.00
    labor_cost 2500.00
    hd_sku nil
    detail {
        name QUANTITY_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_identity
}

####################################
#              HVAC                #
####################################

addProduct2 {
    template_id :GenericGasHeatingACAndDuctwork
    name "Generic Gas Fired Forced Hot Air Heating, AC, Ductwork"
    shortname "Gas Heating, AC, Ductwork"
    materials_cost 0.00
    labor_cost 9500.00
    hd_sku nil
    detail {
        name QUANTITY_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_identity
}

addProduct2 {
    template_id :GenericGasHeatingAndDuctwork
    name "Generic Gas Fired Forced Hot Air Heating, Ductwork (No AC)"
    shortname "Gas Heating, Ductwork"
    materials_cost 0.00
    labor_cost 6500.00
    hd_sku nil
    detail {
        name QUANTITY_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_identity
}

addProduct2 {
    template_id :GenericGasHeating
    name "Gas Fired Forced Hot Air Heating (No Ductwork, No AC)"
    shortname "Gas Heating"
    materials_cost 0.00
    labor_cost 5000.00
    hd_sku nil
    detail {
        name QUANTITY_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_identity
}

addProduct2 {
    template_id :ElectricHeatingACAndDuctwork
    name "Electric Forced Hot Air Heating, AC, Ductwork"
    shortname "Electric Heating, AC, Ductwork"
    materials_cost 0.00
    labor_cost 8200.00
    hd_sku nil
    detail {
        name QUANTITY_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_identity
}

addProduct2 {
    template_id :ElectricHeatingAndDuctwork
    name "Electric Forced Hot Air Heating, Ductwork (No AC)"
    shortname "Electric Heating, Ductwork"
    materials_cost 0.00
    labor_cost 6500.00
    hd_sku nil
    detail {
        name QUANTITY_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_identity
}

addProduct2 {
    template_id :ElectricHeating
    name "Electric Forced Hot Air Heating (No Ductwork, No AC)"
    shortname "Electric Heating"
    materials_cost 0.00
    labor_cost 5500.00
    hd_sku nil
    detail {
        name QUANTITY_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_identity
}

addProduct2 {
    template_id :ACDuctwork
    name "AC, Ductwork"
    materials_cost 0.00
    labor_cost 8500.00
    hd_sku nil
    detail {
        name QUANTITY_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_identity
}

addProduct2 {
    template_id :ForcedAirDuctwork
    name "Replace Forced Air Ductwork"
    materials_cost 0.00
    labor_cost 2300.00
    hd_sku nil
    detail {
        name QUANTITY_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_identity
}

addProduct2 {
    template_id :ReplaceBoilerHotWaterBaseboards
    name "Replace Boiler, Hot Water Baseboards"
    materials_cost 0.00
    labor_cost 9900.00
    hd_sku nil
    detail {
        name QUANTITY_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_identity
}

addProduct2 {
    template_id :ServiceHeatingCooling
    name "Service Heating, Cooling"
    materials_cost 0.00
    labor_cost 800.00
    hd_sku nil
    detail {
        name QUANTITY_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_identity
}

####################################
#             Insulation           #
####################################
addProduct2 {
    template_id :R13KraftFacedInsulationBatts15by93
    name "R-13 Kraft Faced Insulation Batts 15\"x93\""
    materials_cost 0.48
    labor_cost 2.50
    hd_sku nil
    detail {
        name QUANTITY_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_identity
}

addProduct2 {
    template_id :R19KraftFacedInsulationBatts15by93
    name "R-19 Kraft Faced Insulation Batts 15\"x93\""
    materials_cost 0.57
    labor_cost 2.50
    hd_sku nil
    detail {
        name QUANTITY_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_identity
}

addProduct2 {
    template_id :R21KraftFacedInsulationBatts15by93
    name "R-21 Kraft Faced Insulation Batts 15\"x93\""
    materials_cost 0.57
    labor_cost 2.50
    hd_sku nil
    detail {
        name QUANTITY_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_identity
}

addProduct2 {
    template_id :R30KraftFacedInsulationBatts15by93
    name "R-30 Kraft Faced Insulation Batts 15\"x93\""
    materials_cost 0.57
    labor_cost 2.50
    hd_sku nil
    detail {
        name QUANTITY_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_identity
}

addProduct2 {
    template_id :R38KraftFacedInsulationBatts15by93
    name "R-38 Kraft Faced Insulation Batts 15\"x93\""
    materials_cost 0.57
    labor_cost 2.50
    hd_sku nil
    detail {
        name QUANTITY_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_identity
}

addProduct2 {
    template_id :AtticR49KraftFacedInsulationBatts15by93
    name "Attic R-49 Kraft Faced Insulation Batts 24\"x48\""
    materials_cost 8.94
    labor_cost 2.50
    hd_sku nil
    detail {
        name QUANTITY_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_identity
}

addProduct2 {
    template_id :R49BlownInAtticInsulation
    name "R-49 BLOWN-IN Attic Insulation"
    materials_cost 1.00
    labor_cost 0.00
    hd_sku nil
    detail {
        name QUANTITY_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_identity
}

addProduct2 {
    template_id :AirSealRoom
    name "Air Seal Room"
    materials_cost 0.15
    labor_cost 0.00
    hd_sku nil
    detail {
        name QUANTITY_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_identity
}

####################################
#              Special             #
####################################

addProduct2 {
    template_id :BasementWaterproofing
    name "Basement Waterproofing (Concrete Cuts, Drain Tile, Gravel, Sump Pit/Pump/Pipe, New Concrete)"
    shortname "Basement Waterproofing"
    materials_cost 0.00
    labor_cost 150.00
    hd_sku nil
    detail {
        name SELECTED_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn perimeter_identity
}

addProduct2 {
    template_id :Thirty6PineBoxStairs
    name "36\" pine box stairs - CUSTOM MEASURE"
    shortname "Pine Box Stairs"
    materials_cost 1200.00
    labor_cost 500.00
    hd_sku nil
    detail {
        name QUANTITY_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_identity
}

addProduct2 {
    template_id :UnfinishedHemlockWallHandRail
    name "Unfinished Hemlock Wall Hand Rail"
    shortname "Wall Hand Rail"
    materials_cost 3.61
    labor_cost 10.00
    hd_sku 622896
    detail {
        name LINEAR_FEET_DETAIL
        units nil
    }
    materials_cost_total_fn quantity_times(materials_cost)
    labor_cost_total_fn quantity_times(labor_cost)
    quantity_fn detail_identity
}
