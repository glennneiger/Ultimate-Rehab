require_relative 'template_api'

# Many products require perimeter, wall_area and floor_area in order to
# calculate prices.

addRoom2 {
    template_id :BuildAddition
    name "Build Addition"

    section {
        name 'plan'
        product :ArchitecturalDrawings
        product :SiteGradingPlan
        product :PercolationTest
        product :WellSepticSystemVerification
        product :BuildingPermit
        product :TermiteTreatment
    }

    section {
        name 'foundation'
        product :ExcavateFormReinforceFinishNewFootingsAddition
        product :FoundationWallsPouredAddition
    }

    section {
        name 'framing'
        product :SillPlateAddition
        product :OwensCorningSillSealAddition
        product :RimJoistsAndFloorJoistsAddition
        product :OSBSheetAddition
        product :ExteriorWallDoubleTopPlate2By4By96
        product :ExteriorWallDoubleTopPlate2By6By96
        product :OSBSheathing
        product :TwoBy8By16FramingLumber
        product :RoofTrusses
        product :SheathingAddition
    }

    section {
        name 'roofing'
        product :NewRoofAddition
    }

    section {
        name 'gutters'
        product :WhiteGuttersAddition
        product :WhiteDownspoutsAddition
        product :LeafReliefAddition
    }

    section {
        name 'siding'
        product :CompleteVinylSidingInstallation
        product :StoneFacadeAddition
        product :BrickExteriorAddition
        product :TrimCoilStock
        product :PVCBrickmold
        product :PrepPaintExteriorTrim
        product :PrepPaintExteriorAddition
    }

    section {
        name 'garage'
        product :GarageDoorEightBySeven
        product :GarageDoorNineBySeven
        product :GarageDoorSixteenBySeven
        product :GarageDoorOpener
    }

    section {
        name 'chimney'
        product :BrickFireplace
    }

    section {
        name 'driveway'
        product :ConcreteDriveway
        product :AsphaltDriveway
    }

    measurement 'addition_length'
    measurement 'addition_width'
    measurement 'addition_perimeter'
    measurement 'addition_height'
    measurement 'gable_width'
    measurement 'gable_height'
    measurement 'garage_length'
    measurement 'garage_width'
    measurement 'garage_gable_height'
measurement 'notes'

}

addRoom2 {
    template_id :Exterior
    name "Exterior"
    section {
        name 'foundation'
        product :ExcavateFormReinforceFinishNewFootings
        product :FoundationWallsPoured
    }

    section {
        name 'framing'
        product :SillPlate
        product :OwensCorningSillSeal
        product :RimJoistsAndFloorJoists
        product :OSBSheet
        product :ExteriorWallDoubleTopPlate2By4By96
        product :ExteriorWallDoubleTopPlate2By6By96
        product :OSBSheathing
        product :Sheathing
        product :FramingLumberFlatRoof
        product :RoofTrusses
    }

    section {
        name 'roofing'
        product :NewRoof
        product :TamkoElite25Shingles
        product :AluminumStandardEdge
        product :Cobra3ExhaustVent
        product :WeatherWatchIceWaterBarrier
        product :BlackStepFlashing
        product :ChimneyFlashing
        product :RoofSheathing
        product :FasciaRake
    }

    section {
        name 'gutters'
        product :WhiteGutters
        product :WhiteDownspouts
        product :LeafRelief
    }

    section {
        name 'siding'
        product :CertainteedDoubleDuthSiding
        product :CertainteedInsideCorner
        product :CertainteedOutsideCorner
        product :CertainteedJChannel
        product :CertainteedUSill
        product :VinylSidingStarterStrip
        product :WhiteJChannel
        product :WhiteVinylSoffit
        product :StoneFacade
        product :BrickExterior
        product :TrimCoilStock
        product :PVCBrickmold
        product :PowerwashExterior
        product :RepairPargingMortar
        product :PrepPaintExterior
        product :PrepPaintExteriorTrim
    }

    section {
        name 'garage'
        product :GarageDoorEightBySeven
        product :GarageDoorNineBySeven
        product :GarageDoorSixteenBySeven
        product :GarageDoorOpener
    }

    section {
        name 'chimney'
        product :BrickFireplace
    }

    section {
        name 'driveway'
        product :RemoveExistingDriveway
        product :ConcreteDriveway
        product :AsphaltDriveway
    }

    section {
        name 'landscaping'
        product :PlantsBushesLargeLot
        product :PlantsBushesMediumLot
        product :PlantsBushesSmallLot
        product :MinorYardWork
        product :RemoveExistingTreesShrubs
        product :PlantNewTree
    }

    section {
        name 'deck'
        product :DeckPressureTreated
        product :DeckComposite
        product :DeckNoInfrastructurePressureTreated
        product :DeckStairsPressureTreated
        product :DeckStairsComposite
    }

    section {
        name 'fence'
        product :FencePanelPressureTreated
        product :GatePanelPressureTreated
        product :ChainLinkFence
    }
 
    measurement 'house_length'
    measurement 'house_width'
    measurement 'house_perimeter'
    measurement 'house_height'
    measurement 'house_gable_height'
    measurement 'house_gable_width'

    measurement 'addition_length'
    measurement 'addition_width'
    measurement 'addition_perimeter'
    measurement 'addition_height'
    measurement 'addition_gable_height'
    measurement 'addition_gable_width'

    measurement 'garage_length'
    measurement 'garage_width'
    measurement 'garage_height'
    measurement 'garage_gable_height'
    measurement 'garage_gable_width'

    measurement 'deck_length'
    measurement 'deck_width'
}

addRoom2 {
    template_id :FoyerHall
    name "Foyer-Hall"

    section {
        name 'framing'
        product :TwoFourNinetySixStuds
        product :TwoSixNinetySixStuds
    }

    section {
        name 'drywall'
        product :RepairGypsumBoardHalfFourEight
        product :GypsumBoardHalfFourEight
        product :GypsumBoardHalfFourTwelve
    }

    section {
        name 'trim'
        product :SixPanelPrehungDoor
        product :SimpleCloset
        product :WM623PJFBaseboard
        product :WM163EPJFBaseboard
        product :WM49PJFCrownMoulding
        product :FeatherRiverZincDoor
        product :FeatherRiverPatinaDoor
        product :FeatherRiverPatinaDoorNoSidelite
        product :SixPanelSteelDoor
        product :KwiksetNickelExtKnob
        product :VinylWindows
        product :Andersen400SeriesWindows
        product :WM376WindowDoorCasing
        product :WM1021WindowStool
    }

    section {
        name 'paint'
        product :SherwinWilliamsProMarEggShell
    }

    section {
        name 'flooring'
        product :HardwoodFloor
        product :BrucePlanoMarshOak
        product :DurrockUnderlayment
        product :SantaBarbaraFloorTile
        product :PennsylvaniaLaminateFlooring
        product :MohawkWestinHillCarpet
        product :CommercialElectricLEDFlushmount
    }

    measurement 'length'
    measurement 'width'
    measurement 'height'
    measurement 'closet_depth'
    measurement 'closet_width'
    measurement 'hall_length'
    measurement 'hall_width'

    calculated_measurement {
        name 'perimeter'
        show_user false
        value_fn 'function(ms) {return 2*(ms.length + ms.width + ms.closet_depth + ms.closet_width + ms.hall_length + ms.hall_width)}'
    }
    calculated_measurement {
        name 'wall_area' 
        show_user true
        value_fn 'function(ms) {return 2*ms.length*ms.height + 2*ms.width*ms.height + 2*ms.closet_depth*ms.height + 3*ms.closet_width*ms.height + 2*ms.hall_length*ms.height}'
    }
    calculated_measurement {
        name 'floor_area'
        show_user true
        value_fn 'function(ms) {return ms.length*ms.width + ms.closet_depth*ms.closet_width + ms.hall_length*ms.hall_width}'
    }
}

addRoom2 {
    template_id :LivingRoom
    name "Living Room"

    section {
        name 'framing'
        product :TwoFourNinetySixStuds
        product :TwoSixNinetySixStuds
    }

    section {
        name 'drywall'
        product :RepairGypsumBoardHalfFourEight
        product :GypsumBoardHalfFourEight
        product :GypsumBoardHalfFourTwelve
    }

    section {
        name 'trim'
        product :SixPanelPrehungDoor
        product :TwentyFourInch6PanelBifoldDoor
        product :SimpleCloset
        product :WM623PJFBaseboard
        product :WM163EPJFBaseboard
        product :WM49PJFCrownMoulding
        product :FeatherRiverZincDoor
        product :FeatherRiverPatinaDoor
        product :FeatherRiverPatinaDoorNoSidelite
        product :SixPanelSteelDoor
        product :KwiksetNickelExtKnob
        product :VinylWindows
        product :Andersen400SeriesWindows
        product :BayBowWindow
        product :WM376WindowDoorCasing
        product :WM1021WindowStool
    }

    section {
        name 'paint'
        product :SherwinWilliamsProMarEggShell
    }

    section {
        name 'flooring'
        product :HardwoodFloor
        product :BrucePlanoMarshOak
        product :DurrockUnderlayment
        product :SantaBarbaraFloorTile
        product :PennsylvaniaLaminateFlooring
        product :MohawkWestinHillCarpet
        product :MohawkWestinHillCarpetSteps
    }

    measurement 'length'
    measurement 'width'
    measurement 'height'

    calculated_measurement {
        name 'perimeter'
        show_user false
        value_fn 'function(ms) {return 2*(ms.length + ms.width)}'
    }
    calculated_measurement {
        name 'wall_area'
        show_user true
        value_fn 'function(ms) {return 2*ms.height*(ms.length + ms.width)}'
    }
    calculated_measurement {
        name 'floor_area'
        show_user true
        value_fn 'function(ms) {return ms.length * ms.width}'
    }
}

addRoom2 {
    template_id :DiningRoom
    name "Dining Room"

    section {
        name 'framing'
        product :TwoFourNinetySixStuds
        product :TwoSixNinetySixStuds
    }

    section {
        name 'drywall'
        product :RepairGypsumBoardHalfFourEight
        product :GypsumBoardHalfFourEight
        product :GypsumBoardHalfFourTwelve
    }

    section {
        name 'trim'
        product :WM623PJFBaseboard
        product :WM163EPJFBaseboard
        product :WM49PJFCrownMoulding
        product :SixOhSixEightSlidingPatioDoor
        product :SixOhSixEightFrenchPatioDoor
        product :KwiksetNickelExtKnob
        product :VinylWindows
        product :Andersen400SeriesWindows
        product :BayBowWindow
        product :WM376WindowDoorCasing
        product :WM1021WindowStool
    }

    section {
        name 'paint'
        product :SherwinWilliamsProMarEggShell
    }

    section {
        name 'flooring'
        product :HardwoodFloor
        product :BrucePlanoMarshOak
        product :DurrockUnderlayment
        product :SantaBarbaraFloorTile
        product :PennsylvaniaLaminateFlooring
        product :MohawkWestinHillCarpet
    }

    section {
        name 'electric'
        product :HastingsFiveLightChandelier
        product :LyndhurstIndoorCeilingFan
    }

    measurement 'length'
    measurement 'width'
    measurement 'height'

    calculated_measurement {
        name 'perimeter'
        show_user false
        value_fn 'function(ms) {return 2*(ms.length + ms.width)}'
    }
    calculated_measurement {
        name 'wall_area'
        show_user true
        value_fn 'function(ms) {return 2*ms.height*(ms.length + ms.width)}'
    }
    calculated_measurement {
        name 'floor_area'
        show_user true
        value_fn 'function(ms) {return ms.length * ms.width}'
    }
}

addRoom2 {
    template_id :Den
    name "Den"

    section {
        name 'framing'
        product :TwoFourNinetySixStuds
        product :TwoSixNinetySixStuds
    }

    section {
        name 'drywall'
        product :RepairGypsumBoardHalfFourEight
        product :GypsumBoardHalfFourEight
        product :GypsumBoardHalfFourTwelve
    }

    section {
        name 'trim'
        product :SixPanelPrehungDoor
        product :SimpleCloset
        product :WM623PJFBaseboard
        product :WM163EPJFBaseboard
        product :WM49PJFCrownMoulding
        product :VinylWindows
        product :Andersen400SeriesWindows
        product :WM376WindowDoorCasing
        product :WM1021WindowStool
    }

    section {
        name 'paint'
        product :SherwinWilliamsProMarEggShell
    }

    section {
        name 'flooring'
        product :HardwoodFloor
        product :BrucePlanoMarshOak
        product :DurrockUnderlayment
        product :SantaBarbaraFloorTile
        product :PennsylvaniaLaminateFlooring
        product :MohawkWestinHillCarpet
    }

    measurement 'length'
    measurement 'width'
    measurement 'height'

    calculated_measurement {
        name 'perimeter'
        show_user false
        value_fn 'function(ms) {return 2*(ms.length + ms.width)}'
    }
    calculated_measurement {
        name 'wall_area'
        show_user true
        value_fn 'function(ms) {return 2*ms.height*(ms.length + ms.width)}'
    }
    calculated_measurement {
        name 'floor_area'
        show_user true
        value_fn 'function(ms) {return ms.length * ms.width}'
    }
}

addRoom2 {
    template_id :Kitchen
    name "Kitchen"

    section {
        name 'framing'
        product :TwoFourNinetySixStuds
        product :TwoSixNinetySixStuds
    }

    section {
        name 'drywall'
        product :RepairGypsumBoardHalfFourEight
        product :GypsumBoardHalfFourEight
        product :GypsumBoardHalfFourTwelve
    }

    section {
        name 'trim'
        product :WM623PJFBaseboard
        product :WM163EPJFBaseboard
        product :WM49PJFCrownMoulding
        product :SixOhSixEightSlidingPatioDoor
        product :SixOhSixEightFrenchPatioDoor
        product :KwiksetNickelExtKnob
        product :VinylWindows
        product :Andersen400SeriesWindows
        product :BayBowWindow
        product :WM376WindowDoorCasing
        product :WM1021WindowStool
        product :KitchenCabinets
        product :Level2GraniteCounterTop
        product :Level3GraniteCounterTop
        product :BullnoseEdgeOnGranite
        product :TesseraPianoNassau
    }

    section {
        name 'paint'
        product :SherwinWilliamsProMarEggShell
    }

    section {
        name 'flooring'
        product :HardwoodFloor
        product :BrucePlanoMarshOak
        product :DurrockUnderlayment
        product :SantaBarbaraFloorTile
        product :IvoryTravertineFloorWallTile
        product :PennsylvaniaLaminateFlooring
    }

    section {
        name 'plumbing'
        product :KrausDoubleBowlKitchenSink
        product :MoenBanburyKitchenFaucet
    }

    section {
        name 'appliances'
        product :WhirlpoolElectricRange
        product :WhirlpoolRefrigerator
        product :WhirlpoolDishwasher
        product :WhirlpoolMicrowave
        product :RangeHoodWithFIT
        product :MaytagElectricRange
        product :MaytagWideBottomMountRefrigerator
        product :MaytagDishwasher
        product :MaytagMicrowave
        product :ApplicanceDelivery
        product :WhirlpoolGarbageDisposal
    }

    section {
        name 'electric'
        product :ICAirtightHousing
    }

    measurement 'length'
    measurement 'width'
    measurement 'height'
    measurement 'eat_in_length'
    measurement 'eat_in_width'
    measurement 'pantry_depth'
    measurement 'pantry_width'

    calculated_measurement {
        name 'perimeter'
        show_user false
        value_fn 'function(ms) {return 2*(ms.length + ms.width);}'
    }
    calculated_measurement {
        name 'wall_area'
        show_user true
        value_fn 'function(ms) {return 2*ms.height*(ms.length + ms.width + ms.eat_in_length + ms.eat_in_width + ms.pantry_depth + ms.pantry_width);}'
    }
    calculated_measurement {
        name 'floor_area'
        show_user true
        value_fn 'function(ms) {return (ms.length * ms.width) + (ms.eat_in_length * ms.eat_in_width) + (ms.pantry_depth * ms.pantry_width);}'
    }
}

addRoom2 {
    template_id :Bathroom
    name "Bathroom"

    section {
        name 'framing'
        product :TwoFourNinetySixStuds
        product :TwoSixNinetySixStuds
    }

    section {
        name 'drywall'
        product :RepairGypsumBoardHalfFourEight
        product :GypsumBoardHalfFourEight
        product :MoldToughGypsumBoardHalfFourEight
    }

    section {
        name 'trim'
        product :SixPanelPrehungDoor
        product :SimpleCloset
        product :WM623PJFBaseboard
        product :WM163EPJFBaseboard
        product :WM49PJFCrownMoulding
        product :VinylWindows
        product :Andersen400SeriesWindows
        product :WM376WindowDoorCasing
        product :WM1021WindowStool
        product :GlacierBayHamptonOakVanity48By21
        product :GlacierBayHamptonOakVanity36By21
        product :GlacierBayNewportOakVanity30By21
        product :GlacierBayNewportVanityTop49
        product :GlacierBayNewportVanityTop37
        product :GlacierBayNewportVanityTop31
        product :BeveledEdgeMirror
        product :PolishedEdgeMirror
        product :BeveledWallMirror
        product :ZenithFramelessMedicineCabinet
        product :DeltaGreenwichTowelToiletPaperKit
        product :MoenCurvedShowerRod
        product :KohlerSlidingBathtubDoorAndHandle
    }

    section {
        name 'paint'
        product :SherwinWilliamsProMarEggShell
    }

    section {
        name 'flooring'
        product :HardwoodFloor
        product :BrucePlanoMarshOak
        product :PennsylvaniaLaminateFlooring
        product :DurrockUnderlayment
        product :SantaBarbaraFloorTile
        product :WhiteMarbleVinylSheet
        product :CeramicFlooringPattern
    }

    section {
        name 'plumbing'
        product :ShelburnePedestalAndSinkBasin
        product :MoenBanburyLavatoryFaucet
        product :MoenBanburyShowerheadFaucetKit
        product :MoenBanburyShowerhead
        product :BootzIndustriesSoakingTub
        product :KohlerWellworthRoundToilet
    }

    section {
        name 'electric'
        product :HamptonBayNickelVanityLight
        product :SeventyCFMCeilingExhaustFan
    }

    section {
        name 'ceramic'
        product :CustomMudPan
        product :DurocHalfThreeFiveCementBoard
        product :ShowerWallTile
        product :RondecBullnoseTileEdgingTrim
        # FIXME: There is a second product associated with the recessed shelves.
        product :FourteenBy14RecessedShowerShelf
        product :SixBy14RecessedShowerShelf
        product :SealShowerWalls
        product :CustomGlassShowerEnclosure
        product :SantaBarbaraCeramicMosaicTile
        product :MarbleAccentWallTile
        product :SantaBarbaraCeramicBullnose
        product :WallMountSoapDish
    }

    measurement 'length'
    measurement 'width'
    measurement 'height'

    measurement 'shower_width'
    measurement 'shower_depth'
    measurement 'shower_height'

    calculated_measurement {
        name 'perimeter'
        show_user false
        value_fn 'function(ms) {return 2*(ms.length + ms.width)}'
    }
    calculated_measurement {
        name 'wall_area'
        show_user true
        value_fn 'function(ms) {return 2*ms.height*(ms.length + ms.width)}'
    }
    calculated_measurement {
        name 'floor_area'
        show_user true
        value_fn 'function(ms) {return ms.length * ms.width}'
    }
    calculated_measurement {
        name 'shower_wall_area'
        show_user false
        value_fn "function(ms) {return ms.shower_height * (2 * ms.shower_depth + ms.shower_width);}"
    }

    # FIXME: `shower_floor_area/shower_perimeter`?
}

addRoom2 {
    template_id :Bedroom
    name "Bedroom"

    section {
        name 'framing'
        product :TwoFourNinetySixStuds
        product :TwoSixNinetySixStuds
    }

    section {
        name 'drywall'
        product :RepairGypsumBoardHalfFourEight
        product :GypsumBoardHalfFourEight
        product :GypsumBoardHalfFourTwelve
    }

    section {
        name 'trim'
        product :SixPanelPrehungDoor
        product :SimpleCloset
        product :WM623PJFBaseboard
        product :WM163EPJFBaseboard
        product :WM49PJFCrownMoulding
        product :VinylWindows
        product :Andersen400SeriesWindows
        product :WM376WindowDoorCasing
        product :WM1021WindowStool
    }

    section {
        name 'paint'
        product :SherwinWilliamsProMarEggShell
    }

    section {
        name 'flooring'
        product :HardwoodFloor
        product :BrucePlanoMarshOak
        product :DurrockUnderlayment
        product :SantaBarbaraFloorTile
        product :PennsylvaniaLaminateFlooring
        product :MohawkWestinHillCarpet
    }

    measurement 'length'
    measurement 'width'
    measurement 'height'
    measurement 'sitting_area_length'
    measurement 'sitting_area_width'
    measurement 'closet_one_depth'
    measurement 'closet_one_width'
    measurement 'closet_two_depth'
    measurement 'closet_two_width'

    calculated_measurement {
        name 'perimeter'
        show_user false
        value_fn 'function(ms) {return 2*(ms.length + ms.width + ms.sitting_area_length + ms.sitting_area_width + ms.closet_one_depth + ms.closet_one_width + ms.closet_two_depth + ms.closet_two_width)}'
    }
    calculated_measurement {
        name 'wall_area'
        show_user true
        value_fn 'function(ms) {return 2*ms.height*(ms.length + ms.width + ms.sitting_area_length + ms.sitting_area_width + ms.closet_one_depth + ms.closet_one_width + ms.closet_two_depth + ms.closet_two_width)}'
    }
    calculated_measurement {
        name 'floor_area'
        show_user true
        value_fn 'function(ms) {return ms.length*ms.width + ms.sitting_area_length*ms.sitting_area_width + ms.closet_one_depth*ms.closet_one_width + ms.closet_two_depth*ms.closet_two_width}'
    }
}

addRoom2 {
    template_id :SecondFloorHall
    name "Second Floor Hall"

    section {
        name 'framing'
        product :TwoFourNinetySixStuds
        product :TwoSixNinetySixStuds
    }

    section {
        name 'drywall'
        product :RepairGypsumBoardHalfFourEight
        product :GypsumBoardHalfFourEight
        product :GypsumBoardHalfFourTwelve
    }

    section {
        name 'trim'
        product :SixPanelPrehungDoor
        product :SimpleCloset
        product :WM623PJFBaseboard
        product :WM163EPJFBaseboard
        product :WM49PJFCrownMoulding
    }

    section {
        name 'paint'
        product :SherwinWilliamsProMarEggShell
    }

    section {
        name 'flooring'
        product :HardwoodFloor
        product :BrucePlanoMarshOak
        product :DurrockUnderlayment
        product :SantaBarbaraFloorTile
        product :PennsylvaniaLaminateFlooring
        product :MohawkWestinHillCarpet
        product :MohawkWestinHillCarpetSteps
    }

    # FIXME: `landing_length/landing_width`
    measurement 'length'
    measurement 'width'
    measurement 'height'
    measurement 'closet_depth'
    measurement 'closet_width'
    measurement 'hall_length'
    measurement 'hall_width'

    calculated_measurement {
        name 'perimeter'
        show_user false
        value_fn 'function(ms) {return 2*(ms.length + ms.width + ms.closet_depth + ms.closet_width + ms.hall_length + ms.hall_width)}'
    }
    calculated_measurement {
        name 'wall_area'
        show_user true
        value_fn 'function(ms) {return 2*ms.height*(ms.length + ms.width + ms.closet_depth + ms.closet_width + ms.hall_length + ms.hall_width)}'
    }
    calculated_measurement {
        name 'floor_area'
        show_user true
        value_fn 'function(ms) {return ms.length*ms.width + ms.closet_depth*ms.closet_width + ms.hall_length*ms.hall_width}'
    }
}

addRoom2 {
    template_id :Basement
    name "Basement"

    section {
        name 'framing'
        product :TwoFourNinetySixStuds
        product :TwoSixNinetySixStuds
    }

    section {
        name 'drywall'
        product :RepairGypsumBoardHalfFourEight
        product :GypsumBoardHalfFourEight
        product :GypsumBoardHalfFourTwelve
    }

    section {
        name 'trim'
        product :SixPanelPrehungDoor
        product :SimpleCloset
        product :WM623PJFBaseboard
        product :WM163EPJFBaseboard
        product :WM49PJFCrownMoulding
        product :VinylWindows
        product :Andersen400SeriesWindows
        product :WM376WindowDoorCasing
        product :WM1021WindowStool
    }

    section {
        name 'paint'
        product :SherwinWilliamsProMarEggShell
        product :GrayEpoxyConcretePaintFloor
        product :GrayEpoxyConcretePaintWalls
    }

    section {
        name 'special'
        product :BasementWaterproofing
        product :Thirty6PineBoxStairs
        product :UnfinishedHemlockWallHandRail
    }

    section {
        name 'flooring'
        product :SantaBarbaraFloorTile
        product :PennsylvaniaLaminateFlooring
        product :MohawkWestinHillCarpet
    }

    measurement 'great_room_length'
    measurement 'great_room_width'
    measurement 'area_two_length'
    measurement 'area_two_width'
    measurement 'area_three_length'
    measurement 'area_three_width'
    measurement 'laundry_room_length'
    measurement 'laundry_room_width'
    measurement 'height'

    calculated_measurement {
        name 'perimeter'
        show_user false
        value_fn 'function(ms) {return 2*(ms.great_room_length + ms.great_room_width + ms.area_two_length + ms.area_two_width + ms.area_three_length + ms.area_three_width + ms.laundry_room_length + ms.laundry_room_width)}'
    }
    calculated_measurement {
        name 'wall_area'
        show_user true
        value_fn 'function(ms) {return 2*ms.height*(ms.great_room_length + ms.great_room_width + ms.area_two_length + ms.area_two_width + ms.area_three_length + ms.area_three_width + ms.laundry_room_length + ms.laundry_room_width)}'
    }
    calculated_measurement {
        name 'floor_area'
        show_user true
        value_fn 'function(ms) {return ms.great_room_length*ms.great_room_width + ms.area_two_length*ms.area_two_width + ms.area_three_length*ms.area_three_width + ms.laundry_room_length*ms.laundry_room_width}'
    }
}

addRoom2 {
    template_id :LaundryRoom
    name "Laundry Room"

    section {
        name 'framing'
        product :TwoFourNinetySixStuds
    }

    section {
        name 'drywall'
        product :RepairGypsumBoardHalfFourEight
        product :GypsumBoardHalfFourEight
    }

    section {
        name 'trim'
        product :SixPanelPrehungDoor
        product :SimpleCloset
        product :WM623PJFBaseboard
    }

    section {
        name 'paint'
        product :SherwinWilliamsProMarEggShell
        product :GrayEpoxyConcretePaintFloor
        product :GrayEpoxyConcretePaintWalls
    }

    section {
        name 'flooring'
        product :SantaBarbaraFloorTile
    }

    section {
        name 'electric'
        product :DryerElectricOutlet
        product :WasherPlumbing
    }

    measurement 'length'
    measurement 'width'
    measurement 'height'

    calculated_measurement {
        name 'perimeter'
        show_user false
        value_fn 'function(ms) {return 2*(ms.length + ms.width)}'
    }
    calculated_measurement {
        name 'wall_area'
        show_user true
        value_fn 'function(ms) {return 2*ms.height*(ms.length + ms.width)}'
    }
    calculated_measurement {
        name 'floor_area'
        show_user true
        value_fn 'function(ms) {return ms.length * ms.width}'
    }
}

addRoom2 {
    template_id :Mechanicals
    name "Mechanicals"

    section {
        name 'HVAC'
        product :GenericGasHeatingACAndDuctwork
        product :GenericGasHeatingAndDuctwork
        product :GenericGasHeating
        product :ElectricHeatingACAndDuctwork
        product :ElectricHeatingAndDuctwork
        product :ElectricHeating
        product :ACDuctwork
        product :ForcedAirDuctwork
        product :ReplaceBoilerHotWaterBaseboards
        product :ServiceHeatingCooling
    }

    section {
        name 'plumbing'
        product :NewPlumbingEntireHouse
        product :NewPVCTrapSupplyLinesClosetFlangeValves
        product :ShelburnePedestalAndSinkBasin
        product :GlacierBayToiletElongatedSeat
        product :TanklessWaterHeater
        product :RheemNaturalGasWaterHeater
        product :RheemElectricWaterHeater
        product :AutomaticSprinklers
        product :Twenty15ICCBuildingCodeSepticSystem
        product :SepticSystem1500GallonTank
        product :SepticSystemTrencesLeachField
        product :WellWellPumpAndHeadPipe
    }

    section {
        name 'electric'
        product :EntireHouseNew200AmpPanelAndLightingFixtures
        product :ServiceAndPanel
        product :NewElectricalPanel
        product :NewElectricCircuitOutlet
        product :NewCircuitSwitchForCeilingFanOrLight
        product :NewCircuitGFCIOutlet
        product :Leviton15AmpDuplexOutlet
        product :SeventyCFMCeilingExhaustFan
        product :LyndhurstIndoorCeilingFan
        product :CommercialElectricLEDFlushmount
        product :ICAirtightHousing
    }

    section {
        name 'insulation'
        product :R13KraftFacedInsulationBatts15by93
        product :R19KraftFacedInsulationBatts15by93
        product :R21KraftFacedInsulationBatts15by93
        product :R30KraftFacedInsulationBatts15by93
        product :R38KraftFacedInsulationBatts15by93
        product :AtticR49KraftFacedInsulationBatts15by93
        product :R49BlownInAtticInsulation
        product :AirSealRoom
    }
}


addRoom2 {
    template_id :PlanPrep
    name "Plan and Prep"

 section {
        name 'plan'
        product :ArchitecturalDrawings
        product :SiteGradingPlan
        product :PercolationTest
        product :WellSepticSystemVerification
        product :PortableToilet
        product :BuildingPermit
        product :TermiteTreatment
        product :StructuralEngineerFoundation
    }

    section {
        name 'demo'
        product :FifteenYardTruckDumpster
        product :ThreeManCrew
        product :ThirtyYardDumpster
        product :RemoveMold
        product :RemoveAsbestosSidingOrShingles
    }

}
