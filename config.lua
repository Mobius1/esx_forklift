Config = {}

Config.Locale = 'en'

Config.Enabled = true
Config.Debug = false
Config.DrawDistance = 50
Config.Pay = 25


Config.Props = {
    -- 'prop_boxpile_02b',
    'prop_boxpile_06a',
    'prop_boxpile_06b',
    'prop_boxpile_07d'
}

Config.Zones = {

    Locker = {
        Pos     = vector3(-293.05, -2604.34, 5.03),
        Color   = {r = 238, g = 238, b = 0},
        Size    = {x = 1.5, y = 1.5, z = 1.0},
        Type    = 1,    
    },

    Garage = {
        Pos     = vector3(-254.42, -2591.18, 5.03),
        Color   = {r = 238, g = 238, b = 0},
        Size    = {x = 1.5, y = 1.5, z = 1.0},
        Type    = 1,    
    },

    Return = {
        Pos     = vector3(-255.94, -2586.40, 5.03),
        Color   = {r = 238, g = 238, b = 0},
        Size    = {x = 2.0, y = 2.0, z = 1.0},
        Type    = 1,
    },

    FLT = {
        Pos     = vector3(-257.48, -2578.49, 5.03),
        Heading = 85.24
    },

    Pickup = {
        Pos = vector3(-248.95, -2571.79, 5.03),
        Headind = 180.00
    },

    Drop = {
        Color   = {r = 238, g = 238, b = 0},
        Size    = {x = 2.0, y = 2.0, z = 1.0},        
        Type    = 25
    },    
}

Config.Drops = {
    { Pos = vector3(-288.51120, -2459.24800, 6.30266), Heading = 140.10 },
    { Pos = vector3(-297.65290, -2451.62400, 6.30266), Heading = 140.10 },
    { Pos = vector3(-306.97400, -2443.72600, 6.30266), Heading = 140.10 },        
    { Pos = vector3(-315.86010, -2436.30500, 6.30266), Heading = 140.10 },
    { Pos = vector3(-288.82590, -2497.24900, 6.30266), Heading = 320.10 },
    { Pos = vector3(-298.07520, -2489.37500, 6.30266), Heading = 320.10 },
    { Pos = vector3(-307.21750, -2481.78500, 6.30266), Heading = 320.10 },
    { Pos = vector3(-316.51390, -2474.00400, 6.30266), Heading = 320.10 },
    { Pos = vector3(-334.88230, -2458.55300, 6.30266), Heading = 320.10 },
    { Pos = vector3(-229.54770, -2475.67100, 5.00000), Heading = 90.00 },
    { Pos = vector3(-222.73900, -2497.82000, 5.00000), Heading = 90.00 },
    { Pos = vector3(-216.05270, -2519.60300, 5.00000), Heading = 180.00 },
    { Pos = vector3(-244.06850, -2448.95800, 5.10360), Heading = 144.794 },
    { Pos = vector3(-235.43950, -2565.61700, 5.00000), Heading = 0.00 },
    { Pos = vector3(-240.27700, -2570.64200, 5.00000), Heading = 0.00 },     
    { Pos = vector3(-217.46040, -2608.23500, 5.00000), Heading = 90.00 },            
    { Pos = vector3(-285.60920, -2420.83900, 5.00000), Heading = 55.00 },            
    { Pos = vector3(-335.28360, -2439.03300, 5.00000), Heading = 50.00 },            
    { Pos = vector3(-362.77370, -2525.69300, 5.00000), Heading = 320.00 },            
    { Pos = vector3(-405.58660, -2489.09300, 5.00000), Heading = 320.00 },       
    { Pos = vector3(-441.08660, -2460.54600, 5.00000), Heading = 320.00 },     
    { Pos = vector3(-399.09210, -2674.35900, 5.00000), Heading = 45.00 },     
    { Pos = vector3(-367.15790, -2714.59800, 5.00000), Heading = 75.20 },     
    { Pos = vector3(-337.96840, -2619.52500, 5.00000), Heading = 225.00 },     
    { Pos = vector3(-350.32300, -2631.00000, 5.00000), Heading = 225.00 },     
    { Pos = vector3(-354.15500, -2635.01800, 5.00000), Heading = 225.00 },     
    { Pos = vector3(-373.85640, -2654.68300, 5.00000), Heading = 225.00 },     
    { Pos = vector3(-393.77090, -2674.59500, 5.00000), Heading = 225.00 }, 
    { Pos = vector3(-408.58540, -2635.99700, 5.00000), Heading = 225.00 }, 
    { Pos = vector3(-396.86680, -2623.72700, 5.00000), Heading = 225.00 }, 
    { Pos = vector3(-373.20210, -2600.43800, 5.00000), Heading = 225.00 }, 

    { Pos = vector3(-234.56760, -2659.05000, 5.00000), Heading = 0.00 },     
    { Pos = vector3(-219.85510, -2655.11200, 5.00000), Heading = 90.00 },     
    { Pos = vector3(-214.48660, -2649.13600, 5.00000), Heading = 0.00 },     
    { Pos = vector3(-226.54600, -2668.97000, 5.00000), Heading = 180.00 },     
    { Pos = vector3(-262.34100, -2693.94500, 5.00000), Heading = 45.00 },     
    { Pos = vector3(-272.64200, -2704.41600, 5.00000), Heading = 45.00 },

    { Pos = vector3(-341.95650, -2787.76900, 4.00000), Heading = 0.00 },     
    { Pos = vector3(-316.44940, -2781.03300, 4.00000), Heading = 90.00 },

    { Pos = vector3(-440.76200, -2795.76200, 6.30000), Heading = 45.00 },   
    { Pos = vector3(-449.57180, -2804.66800, 6.30000), Heading = 45.00 },   
    { Pos = vector3(-476.47150, -2831.52400, 6.30000), Heading = 45.00 },   
    { Pos = vector3(-494.56660, -2849.59600, 6.30000), Heading = 45.00 },   
    { Pos = vector3(-503.67370, -2858.63900, 6.30000), Heading = 45.00 },   
    { Pos = vector3(-462.39190, -2775.41200, 5.00000), Heading = 225.00 },   
    { Pos = vector3(-482.87890, -2795.95300, 5.00000), Heading = 225.00 },   
    { Pos = vector3(-469.63960, -2782.73400, 5.00000), Heading = 225.00 },   
    { Pos = vector3(-357.04200, -2800.43400, 5.00000), Heading = 315.00 },   
}