ESX = nil

Ready               = false
Stop                = true

Player              = {}
Player.Data         = nil
Player.OnDuty       = false
Player.FLT          = false
Player.Working      = false
Player.Pallet       = false
Player.InRange      = false
Player.Delivered    = 0

Hint                = {}
Hint.Display        = false
Hint.Zone           = false
Hint.Message        = false

Distance            = {}

Zones               = Config.Zones

Citizen.CreateThread(function()
    while ESX == nil do
        Citizen.Wait(10)
        TriggerEvent("esx:getSharedObject", function(esx)
            ESX = esx
        end)
    end

    Wait(1000)

    while not ESX.IsPlayerLoaded() do
        Citizen.Wait(10)
    end

    Player.Data = ESX.GetPlayerData()

    if Player.Data.job.name == 'flt' then
        Player.Authorized = true
        InitFLTJob()
    end
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    if job.name == 'flt' then
        Player.Data = ESX.GetPlayerData()
        Player.Data.job = job
        InitFLTJob()
    else
        StopFLTJob()
    end
end)

-- Init Job
function InitFLTJob()
    ESX.TriggerServerCallback("esx_flt:ready", function(xPlayer, auth)
        if auth then
            Player.Data = xPlayer
            Player.Ped = PlayerPedId()
            Player.Pos = GetEntityCoords(Player.Ped)
            Player.OnDuty = false
            Player.Authorized = true           
            
            Message = {}
            Message.Type = nil
            Message.Display = false
            Message.Ready = true
            Message.Title = nil
            Message.Message = nil            

            Ready = true
            Stop = false

            GetDistances()
            InitThreads()
            UpdateBlips()
        end
    end)    
end

function StopFLTJob()
    if Ready then
        Reset(true)

        RemoveBlips()        

        if Config.Debug then
            SetEntityCoords(Player.Ped, Config.Zones.Locker.Pos.x, Config.Zones.Locker.Pos.y, Config.Zones.Locker.Pos.z, 1, 0, 0, 1)
        end        

        Depopulate()
        
        if Config.Debug then
            -- SetEntityCoords(Player.Ped, Config.Zones.Locker.Pos.x, Config.Zones.Locker.Pos.y, Config.Zones.Locker.Pos.z, 1, 0, 0, 1)
            for i = 1, #Config.Points do
                local Point = Config.Points[i]
                if Point.Entity then
                    ESX.Game.DeleteObject(Point.Entity)
                    Point.Entity = false
                end
            end
        end 
        
        local objs = ESX.Game.GetObjects()

        for i = 1, #objs do
            local v = objs[i]

            if GetEntityModel(v) == GetHashKey(Config.Pallet) then
                ESX.Game.DeleteObject(v)
            end
        end

        Ready = false

        -- Set this to true to break out of thread loops
        Stop = true
    end 
end

function StartWork()
    Player.FLT.Plate = GetVehicleNumberPlateText(GetVehiclePedIsIn(Player.Ped, false))
    Player.Working = true

    RemovePallet()
    Wait(1000)
    SpawnPallet()
end

function DrawDropOffPoint()
    ESX.Game.SpawnObject(Config.Pallet, Zones.Drop.Pos, function(pallet)
        SetEntityHeading(pallet, Zones.Drop.Heading)
        SetEntityAsMissionEntity(pallet, true, true)
        PlaceObjectOnGroundProperly(pallet)
    
        Wait(250)
    
        Zones.Drop.Bounds = Utils.GetEntityBounds(pallet)

        Wait(250)

        ESX.Game.DeleteObject(pallet)

        local pedPos = Utils.TranslateVector(Zones.Drop.Pos, Zones.Drop.Heading - 90, 2.2)

        RequestModel(0x867639D1)
        while ( not HasModelLoaded(0x867639D1) ) do
            Wait(1)
        end

        local center = Utils.GetCentreOfVectors(Zones.Drop.Bounds[4], Zones.Drop.Bounds[3])
        local Heading = GetHeadingFromVector_2d(center.x - pedPos.x, center.y - pedPos.y)

        local ped = CreatePed('PED_TYPE_CIVMALE', 0x867639D1, pedPos.x, pedPos.y, pedPos.z, Heading, false, false)
        TaskStartScenarioInPlace(ped, 'WORLD_HUMAN_CLIPBOARD', 0, true)    
        SetModelAsNoLongerNeeded(0x867639D1)   
        
        Zones.Drop.Ped = ped
    end)
end

function GetSpawnPoints()
    math.randomseed(GetGameTimer())
    local shuffled = {}
    local points = {}

    for i = 1, #Config.Points do
        local pos = math.random(1, #shuffled+1)
        table.insert(shuffled, pos, Config.Points[i])
    end 

    table.insert(points, shuffled[1])
    table.insert(points, shuffled[2])

    return points
end

function DisplayMessage(type)
    Message.Display = true
    Message.Type = type
end

function GetDistances()
    for Name, Zone in pairs(Zones) do
        if Zone.Pos ~= nil then
            Distance[Name] = #(Zone.Pos - Player.Pos)
        end
    end
end

--------------------------------
--       PALLET ACTIONS       --
-------------------------------

-- Spawn collection
function SpawnPallet()

    if not Player.Pallet then
        Player.Pallet = {}

        local Points = GetSpawnPoints()

        Zones.Pickup.Active = true
        Zones.Pickup.Pos = Points[1].Pos
        Zones.Pickup.Heading = Points[1].Heading

        ESX.Game.SpawnObject(Config.Pallet, Zones.Pickup.Pos, function(pallet)
            SetEntityHeading(pallet, Zones.Pickup.Heading)
            SetEntityAsMissionEntity(pallet, true, true)
            PlaceObjectOnGroundProperly(pallet)

            Player.Pallet.Ready = false

            Wait(1000)

            Player.Pallet.Entity = pallet
            Zones.Pickup.Entity = pallet

            Zones.Drop.Ready = true
            Zones.Drop.Pos = Points[2].Pos
            Zones.Drop.Heading = Points[2].Heading

            Utils.DrawZoneBlip("Pickup", 1, "Pallet Collection Point")

            DrawDropOffPoint()

            DisplayMessage('pickup')

            PlaySoundFrontend(-1, "End_Squelch", "CB_RADIO_SFX", 1)
        end)
    end
end

-- Remove pallet
function RemovePallet()
    if Player.Pallet then
        ESX.Game.DeleteObject(Player.Pallet.Entity)

        RemoveBlip(Player.Pallet.Blip)
        RemoveBlip(Zones.Drop.Blip)

        Player.Pallet = false

        Zones.Drop.Ready = false
        Zones.Drop.Active = false
        Zones.Drop.Pos = nil
        Zones.Drop.Heading = nil

        Zones.Pickup.Active = false
        Zones.Pickup.Pos = nil
        Zones.Pickup.Heading = nil     
        
        Zones.Drop.PickedUp = false

        Player.AtPallet = false
    end
end

-- Pick up the pallet
function PickupPallet()
    Zones.Drop.Active = true
    Zones.Drop.PickedUp = true
    
    Zones.Pickup.Active = false
    Zones.Pickup.Pos = nil
    Zones.Pickup.Heading = nil

    Utils.DrawZoneBlip("Drop", 1, "Pallet Delivery Point")
                                
    DisplayMessage('dropoff')    
end

-- Wreck the pallet
function WreckPallet()
    -- Play Sound
    PlaySoundFrontend(-1, "LOSER", "HUD_AWARDS", 1)

    -- Stop FLT
    SetVehicleHandbrake(Player.FLT.Entity, true)
    
    -- Play animation
    Utils.PlayAnimation("anim@mp_player_intcelebrationmale@face_palm", "face_palm")

    -- Show Delivery Message
    DisplayMessage('wrecked')
    
    ResetDelivery()
end

-- Delivery the pallet
function DeliverPallet()
    -- Increment Deliveries
    Player.Delivered = Player.Delivered + 1

    -- Play Sound
    PlaySoundFrontend(-1, "PICK_UP", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)

    -- Show Delivery Message
    DisplayMessage('delivered')

    ResetDelivery()
end

-- Reset delivery
function ResetDelivery()
    Hint.Zone = false
    Hint.Display = false
    Hint.Message = false
    
    Zones.Drop.Ready = false
    Zones.Drop.Active = false
    Zones.Drop.Pos = nil
    Zones.Drop.heading = nil
    
    local ped = false
    if Zones.Drop.Ped then
        ped = Zones.Drop.Ped
    end
    
    RemovePallet()

    Citizen.SetTimeout(3000, function()
        SetVehicleHandbrake(Player.FLT.Entity, false)
    end)
    
    Citizen.SetTimeout(6000, function()
    
        if ped then
            DeleteEntity(ped)
        end
    
        -- Spawn Next Pallet
        SpawnPallet()   
    end) 
end

-- Check pallet is placed correctly
function ValidDrop()
    if not Zones.Drop.PickedUp then
        return false
    end
    local offset = 1.0
    local angle = math.abs(Zones.Drop.Heading - Player.Pallet.Heading)

    local correctAngle = false
    if angle < offset or angle - 180 < offset then
        correctAngle = true
    end

    if correctAngle and not Player.Pallet.Lifted and not Player.AtPallet then
        return true
    end

    return false
end


-----------------------------
--       FLT ACTIONS       --
-----------------------------

-- Spawn the FLT
function SpawnFLT()
    ESX.Game.SpawnVehicle(Config.Vehicle, Config.Zones.FLT.Pos, Config.Zones.FLT.Heading, function(flt)
        SetVehicleNumberPlateText(flt, math.random(1000, 9999))
        Wait(100)

        Player.FLT = {
            Entity = flt
        }

        UpdateBlips()    
        
        TaskWarpPedIntoVehicle(Player.Ped, flt, -1)
    end)
end

-- Return your FLT
function StoreFLT(force)
    if Player.FLT then
        Player.Working = false

        -- Player returned FLT to warehouse
        if force or (IsPedInAnyVehicle(Player.Ped) and Player.FLT.Plate == GetVehicleNumberPlateText(GetVehiclePedIsIn(Player.Ped, false))) then
            TriggerServerEvent('esx_flt:getPaid', Player.Delivered * Config.Pay)

            ESX.Game.DeleteVehicle(Player.FLT.Entity)
            Player.FLT = false
    
            UpdateBlips()

            RemovePallet()
        else
            ESX.ShowNotification('~r~You need to return your FLT to get paid!')
        end
    end
end

-----------------------------
--          BLIPS          --
-----------------------------

-- Update minimap blips
function UpdateBlips()
    RemoveBlips()

    -- Locker Room blip
    Utils.DrawZoneBlip("Locker", 366, _U('locker_room'))

    if Zones.Pickup.Active then
        Utils.DrawZoneBlip("Pickup", 1, "Pallet Pickup Point")
    end   
    
    if Zones.Drop.Active then
        if Zones.Drop.PickedUp then
            Utils.DrawZoneBlip("Drop", 1, "Pallet Dropoff Point")
        end
    end     

    if Player.OnDuty then
        if Player.FLT then
            if Player.FLT.Active then
                -- FLT return blip
                Utils.DrawZoneBlip("Return", 473, _U('warehouse_return'))
            end

            RemoveBlip(Config.Zones.Garage.Blip)
        else
            -- FLT garage blip
            Utils.DrawZoneBlip("Garage", 524, _U('warehouse_pickup'))
        end 
    end
end

-- Remove all minimap blips
function RemoveBlips()
    for i = 1, #Zones do
        local v = Zones[i]
        if v.Blip then
            RemoveBlip(v.Blip)
            v.Blip = nil
        end
    end
end


-------------------------------
--        POPULATION         --
-------------------------------

function Populate()
    for i = 1, #Config.Population.Peds do
        local v = Config.Population.Peds[i]
        RequestModel( 0x867639D1 )
        while ( not HasModelLoaded( 0x867639D1 ) ) do
            Citizen.Wait( 1 )
        end

        local ped = CreatePed('PED_TYPE_CIVMALE', 0x867639D1, v.x, v.y, v.z, v.h, false, false)
        TaskStartScenarioInPlace(ped, v.anim, 0, true)
        -- SetPedComponentVariation(Player.Ped, 0, 5, 0, 2)

        SetEntityAsMissionEntity(ped, true, true)

        v.Ped = ped
    end

    
    Citizen.CreateThread(function()
        local model = GetHashKey(Config.Population.Radio.model)
        RequestModel(model)
        while not HasModelLoaded(model) do
            Citizen.Wait(0)
        end            
        local radio = CreateObject(model, Config.Population.Radio.x, Config.Population.Radio.y, Config.Population.Radio.z, true, false, false)
        SetEntityHeading(radio, Config.Population.Radio.h)
        SetEntityAsMissionEntity(radio, true, true)
        PlaceObjectOnGroundProperly(radio)
        LinkStaticEmitterToEntity("SE_Script_Placed_Prop_Emitter_Boombox", radio)
        SetEmitterRadioStation("SE_Script_Placed_Prop_Emitter_Boombox", GetRadioStationName(1))
        SetStaticEmitterEnabled("SE_Script_Placed_Prop_Emitter_Boombox", true)

        Config.Population.Radio.Entity = radio
    end)  
    
    Config.Population.Populated = true
end

function Depopulate()
    -- Remove peds
    for i = 1, #Config.Population.Peds do
        local v = Config.Population.Peds[i]
        if v.Ped then
            DeleteEntity(v.Ped)
        end
    end

    -- Remove radio
    if Config.Population.Radio.Entity then
        DeleteObject(Config.Population.Radio.Entity)
    end

    Config.Population.Populated = false
end


-------------------------------
--          THREADS          --
-------------------------------

function InitThreads()
    StartPositionThread()
    StartPalletThread()
    StartInteractionThread()
    StartMessageThread()
    StartMarkerThread()
    StartDeliveryThread()
    StartZoneThread()
    StartNotificationThread()
    
    if Config.Debug then
        StartDebugThread()
    end
end

-- Player Position Thread
function StartPositionThread()
    Citizen.CreateThread(function()
        while true do
            if Ready and Player.Authorized then
                if not Player.Ped or ( Player.Ped and Player.Ped ~= PlayerPedId() ) then
                    Player.Ped = PlayerPedId()
                end
                Player.Pos = GetEntityCoords(Player.Ped)
    
                -- Spawn peds and props when close
                if Config.Population.Enabled then
                    if Distance.Locker < Config.DrawDistance then
                        if not Config.Population.Populated then
                            Populate()
                        end
                    else
                        if Config.Population.Populated then
                            Depopulate()
                        end
                    end
                end

                GetDistances()
            end
    
            if Stop then return end
    
            Citizen.Wait(100)
        end
    end)    
end

-- Pallet Thread
function StartPalletThread()
    Citizen.CreateThread(function()
        while true do
            if Ready and Player.Authorized then
                if Player.Working and Zones.Drop.Ready then
                    if Player.Pallet then
                        Player.AtPallet = IsEntityAtEntity(Player.FLT.Entity, Player.Pallet.Entity, 3.0, 3.0, 3.0, 0, 1, 0)
                    end

                    Player.Pallet.Health = GetEntityHealth(Player.Pallet.Entity)

                    if Zones.Drop.Active then
                        Player.Pallet.Heading = GetEntityHeading(Player.Pallet.Entity)
                        Player.Pallet.Lifted = IsEntityInAir(Player.Pallet.Entity)

                        if (Player.Pallet.Health / 10) <= Config.DamageLimit then
                            WreckPallet()
                        end
                    end
                end
            end
            if Stop then return end        
            Citizen.Wait(0)
        end
    end)
end

-- FLT Interaction Thread
function StartInteractionThread()
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(1)

            if Ready and Player.Authorized then
                if Player.FLT then
                    if not IsPedSittingInVehicle(Player.Ped, Player.FLT.Entity) then
                        Player.FLT.Active = false

                        -- FLT blip
                        Utils.AddBlip(Player.FLT, 255, _U('flt'))

                        RemoveBlip(Zones.Return.Blip)
                    else
                        if Player.FLT.Blip then
                            UpdateBlips()
                            RemoveBlip(Player.FLT.Blip)
                        end
                        Player.FLT.Active = true

                        -- Start work when player enters FLT
                        if not Player.Working then
                            StartWork()
                        end
                    end
                end
            end

            if Stop then return end        
        end
    end)
end

-- On-screen Message Thread
function StartMessageThread()
    Citizen.CreateThread(function()
        while true do
            if Ready and Player.Authorized then
                if Message and Message.Display then
                    local Color = { r = 238, g = 238, b = 0 }
                    if Message.Type == 'delivered' then
                        Message.Title = 'Pallet Delivered'
                        Message.SubTitle = Player.Delivered .. ' Pallets Delivered'
                    elseif Message.Type == 'pickup' then
                        Message.Title = 'Collection Ready'
                        Message.SubTitle = 'Go to the collection point'
                    elseif Message.Type == 'dropoff' then
                        Message.Title = 'Deliver The Pallet'
                        Message.SubTitle = 'Take the pallet to the drop-off point'
                    elseif Message.Type == 'wrecked' then
                        Message.Title = 'Pallet Wrecked!'
                        Message.SubTitle = 'You\'ve been fined for damaging customer goods!'
                        Color = { r = 255, g = 0, b = 0 }
                    end

                    Utils.RenderText(Message.Title, 7, 0.5, 0.25, 1.50, Color.r, Color.g, Color.b, 255)
                    Utils.RenderText(Message.SubTitle, 4, 0.5, 0.33, 0.5)

                    Citizen.SetTimeout(3000, function()
                        Message.Type = nil
                        Message.Title = nil
                        Message.Message = nil
                        Message.Display = false
                    end)
                end
            end
            if Stop then return end        
            Citizen.Wait(0)
        end
    end)
end

-- Markers Thread
function StartMarkerThread()
    Citizen.CreateThread(function()
        while true do
            if Ready and Player.Authorized then
                if Distance.Locker <= Config.DrawDistance then
                    -- Locker Room Marker
                    DrawMarker(Zones.Locker.Type, Zones.Locker.Pos, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Zones.Locker.Size.x, Zones.Locker.Size.y, Zones.Locker.Size.z, Zones.Locker.Color.r, Zones.Locker.Color.g, Zones.Locker.Color.b, 100, false, true, 2, false, nil, nil, false)
                end

                if Player.OnDuty then
                    if not Player.FLT then
                        if Distance.Garage <= Config.DrawDistance then
                            -- FLT Garage Marker
                            DrawMarker(Zones.Garage.Type, Zones.Garage.Pos, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Zones.Garage.Size.x, Zones.Garage.Size.y, Zones.Garage.Size.z, Zones.Garage.Color.r, Zones.Garage.Color.g, Zones.Garage.Color.b, 100, false, true, 2, false, nil, nil, false)
                        end
                    else
                        if Player.FLT.Active then
                            if Distance.Return <= Config.DrawDistance then
                                -- FLT Return Marker
                                DrawMarker(Zones.Return.Type, Zones.Return.Pos, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Zones.Return.Size.x, Zones.Return.Size.y, Zones.Return.Size.z, Zones.Return.Color.r, Zones.Return.Color.g, Zones.Return.Color.b, 100, false, true, 2, false, nil, nil, false)
                            end
                        end
                    end

                    if Zones.Drop.Ready then
                        if Zones.Drop.PickedUp then
                            if Distance.Drop <= Config.DrawDistance then
                                -- Delivery Point Ghost
                                Utils.DrawBox(Zones.Drop.Bounds[1], Zones.Drop.Bounds[2], Zones.Drop.Bounds[4], Zones.Drop.Bounds[3], 238, 238, 0, 100)

                                -- Delivery Point Marker
                                DrawMarker(0, vector3(Zones.Drop.Pos.x, Zones.Drop.Pos.y, Zones.Drop.Pos.z + 3.0), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Zones.Return.Size.x, Zones.Return.Size.y, Zones.Return.Size.z, Zones.Return.Color.r, Zones.Return.Color.g, Zones.Return.Color.b, 100, true, true, 2, false, nil, nil, false)
                            end
                        end
                    end
                end
            end       
            if Stop then return end
            Citizen.Wait(0)
        end
    end)
end

-- Delivery Thread
function StartDeliveryThread()
    Citizen.CreateThread(function()
        while true do
            if Ready and Player.Authorized then
                if Player.Working and Zones.Drop.Ready then
                    local pcoords = GetEntityCoords(Player.Pallet.Entity) 
                    local pdist = #(Zones.Drop.Pos - pcoords) 
                    
                    if not Player.Pallet.Ready then
                        if pdist < 50 then
                            Player.Pallet.Ready = true

                            -- If pallet is far from player, collisions might not be loaded so it'll fall through floor
                            PlaceObjectOnGroundProperly(Player.Pallet.Entity)
                        end
                    end

                    if Player.AtPallet then
                        Zones.Drop.Active = true
                    end


                    -- Only do checks if player is close
                    if Zones.Drop.Active and pdist <= 0.5 then      
                        if ValidDrop() then
                            DeliverPallet()
                        end   
                    else
                        if not Player.AtPallet then
                            if Distance.Pickup < Config.DrawDistance then
                                DrawMarker(0, vector3(pcoords.x, pcoords.y, pcoords.z + 3.0), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Zones.Return.Size.x, Zones.Return.Size.y, Zones.Return.Size.z, Zones.Return.Color.r, Zones.Return.Color.g, Zones.Return.Color.b, 100, true, true, 2, false, nil, nil, false)
                            end
                        end                
                    end 
                end                
            end
            if Stop then return end        
            Citizen.Wait(0)
        end
    end)
end

-- Zone Thread
function StartZoneThread()
    Citizen.CreateThread(function()
        while true do
            if Ready and Player.Authorized then

                Hint.Zone = false
                Hint.Display = false
                Hint.Message = false                

                if Distance.Locker <= Zones.Locker.Size.x then
                    Hint.Zone = 'Locker'
                    Hint.Display = true
                    Hint.Message = _U('change_clothes')
                end

                if Player.OnDuty then
                    if Distance.Garage <= Zones.Garage.Size.x and not Player.FLT then
                        Hint.Zone = 'Garage'
                        Hint.Display = true
                        Hint.Message = _U('enter_flt')
                    end
                        
                    if Distance.Return <= Zones.Garage.Size.x and Player.FLT and Player.FLT.Active then
                        Hint.Zone = 'Return'
                        Hint.Display = true
                        Hint.Message = _U('return_flt')
                    end  
                        
                    if Player.Working and Zones.Drop.Ready then
                        if Player.Pallet.Lifted and not Zones.Drop.PickedUp then
                            PickupPallet()
                        end
                    end
                end

                if IsControlJustReleased(0, 38) then
                    if Hint.Display then
                        if Hint.Zone == 'Locker' then
                            OpenFLTMenu()
                        elseif Hint.Zone == 'Garage' then
                            SpawnFLT()
                        elseif Hint.Zone == 'Return' then
                            StoreFLT()
                        end
                    end
                end            
            end
            if Stop then return end
            Citizen.Wait(1)
        end
    end)
end

-- Notification Thread
function StartNotificationThread()
    Citizen.CreateThread(function()
        while true do
            if Ready and Player.Authorized then
                if Hint.Display and Hint.Message then
                    ESX.ShowHelpNotification(Hint.Message, 3000)
                end
            end
            if Stop then return end        
            Citizen.Wait(1)
        end
    end)
end

function StartDebugThread()
    Citizen.CreateThread(function()
        while true do
            if Ready and Player.Authorized then
                Utils.RenderDebugHud(Zones, Player, Distance)

                for i = 1, #Config.Points do
                    local Point = Config.Points[i]
                    if Point.Debug == nil then
                        Point.Debug = {
                            Spawned = false,
                            Ped = false
                        }
                    end

                    local dist = #(Point.Pos - Player.Pos)

                    if not Point.Debug.Spawned then
                        if dist < Config.DrawDistance then
                            ESX.Game.SpawnObject('prop_boxpile_07d', Point.Pos, function(pallet)
                                SetEntityHeading(pallet, Point.Heading)
                                -- SetEntityAsMissionEntity(pallet, true, true)
                                PlaceObjectOnGroundProperly(pallet)

                                Point.Debug.Spawned = true
                
                                Wait(250)
                
                                Point.Debug.Bounds = Utils.GetEntityBounds(pallet)
            
                                Wait(250)
            
                                ESX.Game.DeleteObject(pallet)
                            end)
                        end
                    else
                        if Point.Debug.Bounds ~= nil then
                            if dist < Config.DrawDistance then
                                Utils.DrawBox(Point.Debug.Bounds[1], Point.Debug.Bounds[2], Point.Debug.Bounds[4], Point.Debug.Bounds[3], 238, 238, 0, 100)
                            end
                        end
                    end
                end
            end
            Citizen.Wait(0)
        end
    end)
end

----------------------------
--          MENU          --
----------------------------

function OpenFLTMenu()								
    ESX.UI.Menu.CloseAll()		
    
    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'locker',
        {
            title    = "Change Clothes",
            elements = {
                {label = "Clock In", value = 'work_wear'},
                {label = "Clock Out", value = 'offduty_wear'}
            }
        },
        function(data, menu)
        if data.current.value == 'offduty_wear' then
            Player.OnDuty = false
            ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
                TriggerEvent('skinchanger:loadSkin', skin)

                ESX.ShowNotification(_U('notif_offduty'))

                UpdateBlips()

                Reset()
            end)
        elseif data.current.value == 'work_wear' then
            Player.OnDuty = true
            ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
                if skin.sex == 0 then
                    TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_male)
                else
                    TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_female)
                end

                ESX.ShowNotification(_U('notif_onduty'))

                if Config.Debug then
                    SetEntityCoords(Player.Ped, Config.Zones.Garage.Pos.x, Config.Zones.Garage.Pos.y, Config.Zones.Garage.Pos.z, 1, 0, 0, 1)
                end

                UpdateBlips()
            end)
        end
            menu.close()
        end,
        function(data, menu)
            menu.close()
        end
    )
end

-----------------------------
--          RESET          --
-----------------------------

-- Reset Job
function Reset(force)
    StoreFLT(force)
    RemovePallet()

    Player.Data = nil
    Player.OnDuty = false
    Player.FLT = false
    Player.Working = false
    Player.Pallet = false
    Player.InRange = false
    Player.Delivered = 0

    Zones.Drop.Active = false
    Zones.Pickup.Active = false

    Zones.Drop.Pos = nil
    Zones.Pickup.Pos = nil

    Zones.Drop.Heading = nil
    Zones.Pickup.Heading = nil  
    
    Zones.Drop.PickedUp = false
    
    Hint.Display = false
    Hint.Zone = false
    Hint.Message = false
    
    Message = false
end

-- Reset collectables on resource stop
AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        StopFLTJob()       
    end
end)