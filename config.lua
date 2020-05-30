Config = {}

Config.Locale = 'en'

Config.Enabled = true
Config.Debug = false
Config.DrawDistance = 50
Config.Pay = 25
Config.Vehicle = 'forklift'
Config.DamageLimit = 20.00

Config.Props = {
    'prop_boxpile_06a',
    'prop_boxpile_06b',
    'prop_boxpile_07d'
}

Config.Zones = {
    Locker = {
        Pos     = vector3(9.62, -2658.71, 5.00),
        Color   = {r = 238, g = 238, b = 0},
        Size    = {x = 1.25, y = 1.25, z = 1.0},
        Type    = 1,    
    },

    Garage = {
        Pos     = vector3(34.13, -2657.20, 5.00),
        Color   = {r = 238, g = 238, b = 0},
        Size    = {x = 1.5, y = 1.5, z = 1.0},
        Type    = 1,    
    },

    Return = {
        Pos     = vector3(34.13, -2657.20, 5.00),
        Color   = {r = 238, g = 238, b = 0},
        Size    = {x = 2.0, y = 2.0, z = 1.0},
        Type    = 1,
    },

    FLT = {
        Pos     = vector3(34.59, -2650.65, 5.00),
        Heading = 0.00
    },

    Pickup = {
        Color   = {r = 238, g = 238, b = 0},
        Size    = {x = 1.5, y = 1.5, z = 1.0},
        Bounce  = true,
        Type    = 0
    },

    Drop = {
        Color   = {r = 238, g = 238, b = 0},
        Size    = {x = 1.5, y = 1.5, z = 1.0},
        Bounce  = true,
        Type    = 0
    },    
}

Config.Points = {

    -- Berth 25
    { Pos = vector3(-288.51120, -2459.24800, 6.30266), Heading = 320.00 },
    { Pos = vector3(-297.65290, -2451.62400, 6.30266), Heading = 320.00 },
    { Pos = vector3(-306.97400, -2443.72600, 6.30266), Heading = 320.00 },        
    { Pos = vector3(-315.86010, -2436.30500, 6.30266), Heading = 320.00 },
    { Pos = vector3(-269.89760, -2474.78100, 6.30266), Heading = 320.00 },    
    { Pos = vector3(-288.82590, -2497.24900, 6.30266), Heading = 140.00 },
    { Pos = vector3(-298.07520, -2489.37500, 6.30266), Heading = 140.00 },
    { Pos = vector3(-307.21750, -2481.78500, 6.30266), Heading = 140.00 },
    { Pos = vector3(-316.51390, -2474.00400, 6.30266), Heading = 140.00 },
    { Pos = vector3(-334.88230, -2458.55300, 6.30266), Heading = 140.00 },
    { Pos = vector3(-331.14260, -2434.48500, 5.00000), Heading = 50.00 }, 
    { Pos = vector3(-335.28360, -2439.03300, 5.00000), Heading = 50.00 }, 

    -- Berth 153 (Post OP)
    { Pos = vector3(-440.76200, -2795.76200, 6.30000), Heading = 45.00 },   
    { Pos = vector3(-449.57180, -2804.66800, 6.30000), Heading = 45.00 },   
    { Pos = vector3(-476.47150, -2831.52400, 6.30000), Heading = 45.00 },   
    { Pos = vector3(-494.56660, -2849.59600, 6.30000), Heading = 45.00 },   
    { Pos = vector3(-503.67370, -2858.63900, 6.30000), Heading = 45.00 },
    { Pos = vector3(-462.39190, -2775.41200, 5.00000), Heading = 225.00 },   
    { Pos = vector3(-482.87890, -2795.95300, 5.00000), Heading = 225.00 },   
    { Pos = vector3(-469.63960, -2782.73400, 5.00000), Heading = 225.00 },         
    
    -- Train Shed
    { Pos = vector3(-337.96840, -2619.52500, 5.00000), Heading = 225.00 },     
    { Pos = vector3(-350.32300, -2631.00000, 5.00000), Heading = 225.00 }, 
    { Pos = vector3(-354.15500, -2635.01800, 5.00000), Heading = 225.00 }, 
    { Pos = vector3(-373.85640, -2654.68300, 5.00000), Heading = 225.00 },
    { Pos = vector3(-393.77090, -2674.59500, 5.00000), Heading = 225.00 }, 
    { Pos = vector3(-399.09210, -2674.35900, 5.00000), Heading = 45.00 },
    { Pos = vector3(-367.15790, -2714.59800, 5.00000), Heading = 75.20 },   

    -- Octopus Ship
    { Pos = vector3(-408.58540, -2635.99700, 5.00000), Heading = 225.00 }, 
    { Pos = vector3(-396.86680, -2623.72700, 5.00000), Heading = 225.00 }, 
    { Pos = vector3(-373.20210, -2600.43800, 5.00000), Heading = 225.00 }, 
    
    { Pos = vector3(-362.77370, -2525.69300, 5.00000), Heading = 320.00 },            
    { Pos = vector3(-405.58660, -2489.09300, 5.00000), Heading = 320.00 },       
    { Pos = vector3(-441.08660, -2460.54600, 5.00000), Heading = 320.00 },    
    
    -- Unknown
    { Pos = vector3(-235.43950, -2565.61700, 5.00000), Heading = 0.00 },
    { Pos = vector3(-240.27700, -2570.64200, 5.00000), Heading = 0.00 }, 
    { Pos = vector3(-217.46040, -2608.23500, 5.00000), Heading = 90.00 },     

    -- Building 1
    { Pos = vector3(-234.56760, -2659.05000, 5.00000), Heading = 0.00 },     
    { Pos = vector3(-219.85510, -2655.11200, 5.00000), Heading = 90.00 },     
    { Pos = vector3(-214.48660, -2649.13600, 5.00000), Heading = 0.00 },     
    { Pos = vector3(-226.54600, -2668.97000, 5.00000), Heading = 180.00 }, 

    -- Building 3
    { Pos = vector3(-285.99300, -2717.83800, 5.00000), Heading = 45.00 }, 
    { Pos = vector3(-316.97200, -2723.73000, 5.00000), Heading = 315.00 }, 
    { Pos = vector3(-306.27470, -2734.49800, 5.00000), Heading = 315.00 }, 
    { Pos = vector3(-300.41140, -2732.46700, 5.00000), Heading = 45.00 }, 
    { Pos = vector3(-310.57680, -2699.39700, 5.00000), Heading = 315.00 },  

    -- Building 4
    { Pos = vector3(-262.34100, -2693.94500, 5.00000), Heading = 45.00 },     
    { Pos = vector3(-272.64200, -2704.41600, 5.00000), Heading = 45.00 },    

    -- next to builing 1
    { Pos = vector3(-167.93000, -2658.92100, 5.00000), Heading = 270.00 },
    { Pos = vector3(-168.82170, -2686.81700, 5.00000), Heading = 270.00 },
    { Pos = vector3(-169.24210, -2707.41700, 5.00000), Heading = 270.00 },
    { Pos = vector3(-155.87800, -2717.43000, 5.00000), Heading = 0.00 },

    -- D-Rail
    { Pos = vector3(-112.59520, -2637.43900, 5.00000), Heading = 180.00 },
    { Pos = vector3(-128.25250, -2706.13100, 5.00000), Heading = 270.00 },
    { Pos = vector3(-128.17990, -2698.59200, 5.00000), Heading = 270.00 },
    { Pos = vector3(-128.06780, -2676.56300, 5.00000), Heading = 270.00 },
    { Pos = vector3(-128.21660, -2669.74300, 5.00000), Heading = 270.00 },
    { Pos = vector3(-128.16860, -2662.41700, 5.00000), Heading = 270.00 },  
    { Pos = vector3(-108.59960, -2691.59300, 5.00000), Heading = 90.00 },  
    { Pos = vector3(-98.80044, -2637.25600, 5.00000), Heading = 180.00 }, 
    { Pos = vector3(-91.88831, -2742.07900, 5.00000), Heading = 90.00 },   

    -- Walker
    { Pos = vector3(-31.97238, -2653.66400, 5.00000), Heading = 0.00 },
    { Pos = vector3(-57.16412, -2659.63200, 5.00000), Heading = 0.00 },
    { Pos = vector3(-28.47571, -2665.28300, 5.00000), Heading = 270.00 },
    { Pos = vector3(-28.69450, -2679.03400, 5.00000), Heading = 270.00 },    

    -- Pacific Brit
    { Pos = vector3(89.01086, -2675.16000, 5.00000), Heading = 0.00 },
    { Pos = vector3(84.91182, -2675.10100, 5.00000), Heading = 0.00 },
    { Pos = vector3(80.63327, -2675.06700, 5.00000), Heading = 0.00 },

    -- Class-A Lines (Workplace)
    { Pos = vector3(51.79316, -2719.11300, 5.00000), Heading = 270.00 },
    { Pos = vector3(51.92499, -2715.49800, 5.00000), Heading = 270.00 },
    { Pos = vector3(51.97153, -2711.76700, 5.00000), Heading = 270.00 },

    -- Port Security
    { Pos = vector3(-316.44940, -2781.03300, 4.00000), Heading = 270.00 },
    { Pos = vector3(-341.95650, -2787.76900, 4.00000), Heading = 0.00 },     

    { Pos = vector3(-353.65680, -2800.52600, 5.00000), Heading = 45.00 }, 
    { Pos = vector3(-357.04200, -2800.43400, 5.00000), Heading = 315.00 },
    { Pos = vector3(-365.87320, -2788.73400, 5.00000), Heading = 270.00 }, 
    { Pos = vector3(-366.03740, -2784.58300, 5.00000), Heading = 270.00 },
    { Pos = vector3(-369.00560, -2777.11500, 5.00000), Heading = 315.00 },  
    { Pos = vector3(-371.29460, -2774.78700, 5.00000), Heading = 315.00 },  
    { Pos = vector3(-373.52640, -2772.48500, 5.00000), Heading = 315.00 },   

    -- Trailer
    { Pos = vector3(-216.05270, -2519.60300, 5.00000), Heading = 180.00 },
    { Pos = vector3(-222.73900, -2497.82000, 5.00000), Heading = 90.00 },
    { Pos = vector3(-229.54770, -2475.67100, 5.00000), Heading = 90.00 },
    { Pos = vector3(-224.49350, -2519.71700, 5.00000), Heading = 180.00 },      
}


-----------------------------
--          Props          --
-----------------------------

Config.Population = {
    Enabled = true,
    Peds = {
        { x = 29.73, y = -2659.19, z = 5.00, h = 90.00, anim = "WORLD_HUMAN_WELDING" },
        { x = 38.78, y = -2660.30, z = 5.00, h = 270.00, anim = "WORLD_HUMAN_WELDING" },
        { x = 10.14, y = -2667.49, z = 5.00, h = 90.00, anim = "WORLD_HUMAN_WELDING" },
        { x = 29.73, y = -2667.49, z = 5.00, h = 90.00, anim = "WORLD_HUMAN_WELDING" },
        { x = 9.06, y = -2664.05, z = 5.00, h = 270.00, anim = "WORLD_HUMAN_HANG_OUT_STREET" },
        { x = 10.23, y = -2664.17, z = 5.00, h = 77.04, anim = "WORLD_HUMAN_HANG_OUT_STREET" },
        { x = 23.12, y = -2637.86, z = 5.00, h = 186.00, anim = "WORLD_HUMAN_HANG_OUT_STREET" },
        { x = 22.19, y = -2638.75, z = 5.00, h = 314.00, anim = "WORLD_HUMAN_HANG_OUT_STREET" },
        { x = 23.58, y = -2639.04, z = 5.00, h = 40.00, anim = "WORLD_HUMAN_HANG_OUT_STREET" },
        { x = 13.40, y = -2654.54, z = 5.00, h = 0.00, anim = "WORLD_HUMAN_JANITOR" },
        { x = 8.41, y = -2653.74, z = 5.00, h = 0.00, anim = "WORLD_HUMAN_SMOKING" },
        { x = 14.24, y = -2664.20, z = 5.00, h = 230.00, anim = "CODE_HUMAN_MEDIC_KNEEL" },
        { x = 15.46, y = -2663.82, z = 5.00, h = 140.00, anim = "CODE_HUMAN_MEDIC_KNEEL" },
        { x = 14.17, y = -2665.48, z = 5.00, h = 327.00, anim = "WORLD_HUMAN_CLIPBOARD" },
        { x = 42.77, y = -2649.36, z = 5.00, h = 217.00, anim = "WORLD_HUMAN_CLIPBOARD" },
    },
    Radio = { x = 8.60, y = -2658.69, z = 7.50, h = 90.00, model = 'prop_boombox_01' }
}