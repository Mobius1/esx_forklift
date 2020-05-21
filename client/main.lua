ESX = nil

Ready = false

Player = {}
Player.Data = nil
Player.OnDuty = false
Player.FLT = false
Player.Working = false
Player.Pallet = false
Player.InRange = false
Player.Delivered = 0

Hint = {}
Hint.Display = false
Hint.Zone = false
Hint.Message = false

Points = nil

Message = {}
Message.Type = nil
Message.Display = false
Message.Ready = true
Message.Title = nil
Message.Message = nil


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

-- Init Job
function InitFLTJob()
    ESX.TriggerServerCallback("esx_flt:ready", function(xPlayer, auth)
        if auth then
            Player.Data = xPlayer
            Player.Ped = PlayerPedId()
            Player.Pos = GetEntityCoords(Player.Ped)
            Ready = true
        
            UpdateBlips()  
        end
    end)    
end

function StartWork()
    Player.FLT.Plate = GetVehicleNumberPlateText(GetVehiclePedIsIn(Player.Ped, false))
    Player.Working = true

    RemovePallet()
    SpawnPallet()
end

function SpawnPallet()

    if not Player.Pallet then
        Player.Pallet = {}

        GetSpawnPoints()

        local Pickup = Config.Drops[Points[1]]
        local prop = Config.Props[ math.random( #Config.Props ) ]

        ESX.Game.SpawnObject(prop, Pickup.Pos, function(pallet)
            SetEntityHeading(pallet, Pickup.Heading)
            PlaceObjectOnGroundProperly(pallet)

            Wait(1000)

            Player.Pallet.Entity = pallet
            Player.Pallet.InitCoords = GetEntityCoords(pallet)

            Player.Drop = Config.Drops[Points[2]] 

            DrawDropOffPoint(prop)

            AddPalletBlip(Player.Pallet)

            DisplayMessage('pickup')
        end)
    end
end

function RemovePallet()
    if Player.Pallet then
        ESX.Game.DeleteObject(Player.Pallet.Entity)

        RemoveBlip(Player.Pallet.Blip)
        RemoveBlip(Player.Drop.Blip)

        Player.Pallet = false
        Player.Drop = false
        Player.AtPallet = false
    end
end

function AddPalletBlip(Obj)
    local msg = ''
    if Obj.Entity ~= nil then
        msg = 'Pallet Pickup'
        Obj.Blip = AddBlipForEntity(Obj.Entity)
    else
        msg = 'Pallet Dropoff'
        Obj.Blip = AddBlipForCoord(Obj.Pos.x, Obj.Pos.y, Obj.Pos.z)
    end

    SetBlipSprite(Obj.Blip, 1)
    SetBlipAsShortRange(Obj.Blip, true)
    SetBlipColour(Obj.Blip, 5)
    SetBlipScale(Obj.Blip, 1.0)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(msg)
    EndTextCommandSetBlipName(Obj.Blip) 
end

function AddFLTBlip()
    if Player.FLT.Blip then
        RemoveBlip(Player.FLT.Blip)
    end    
    Player.FLT.Blip = AddBlipForEntity(Player.FLT.vehicle)

    SetBlipSprite(Player.FLT.Blip, 225)
    SetBlipAsShortRange(Player.FLT.Blip, true)
    SetBlipColour(Player.FLT.Blip, 5)
    SetBlipScale(Player.FLT.Blip, 1.0)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(_U('flt'))
    EndTextCommandSetBlipName(Player.FLT.Blip)  
end

function DrawDropOffPoint(prop)
    ESX.Game.SpawnObject(prop, Player.Drop.Pos, function(pallet)
        SetEntityHeading(pallet, Player.Drop.Heading)
        PlaceObjectOnGroundProperly(pallet)
    
        Wait(250)
    
        Player.Drop.Bounds = Utils.GetEntityBounds(pallet)

        Wait(250)

        ESX.Game.DeleteObject(pallet)
    end)
end

function GetSpawnPoints()
    points = {}
    math.randomseed( GetGameTimer() )
    for i = 1, 2 do
        local point = math.random( #Config.Drops )

        -- Check Point 1 for Duplicate
        if Points ~= nil and i == 1 then
            while point == points[2] do
                point = math.random( #Config.Drops )
            end
        end

        -- Check Point 2 for Duplicate
        if Points ~= nil and i == 2 then
            while point == points[1] do
                point = math.random( #Config.Drops )
            end
        end

        -- Check Point for Duplicate to last
        if Points ~= nil then
            while point == Points[i] do
                point = math.random( #Config.Drops )
            end
        end

        table.insert(points, point)
    end

    Points = points
end

function DisplayMessage(type)
    Message.Display = true
    Message.Type = type
end

-----------------------------
--       FLT ACTIONS       --
-----------------------------

-- Drop Pallet
function DeliverPallet()
    Hint.Zone = false
    Hint.Display = false
    Hint.Message = false

    -- Increment Deliveries
    Player.Delivered = Player.Delivered + 1

    -- Play Sound
    PlaySoundFrontend(-1, "PICK_UP", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)

    -- Show Delivery Message
    DisplayMessage('delivered')

    RemovePallet()

    Citizen.SetTimeout(6000, function()
        -- Spawn Next Pallet
        SpawnPallet()   
    end) 
end

-- Spawn the FLT
function SpawnFLT()
    ESX.Game.SpawnVehicle('dibzer_forklift', Config.Zones.FLT.Pos, Config.Zones.FLT.Heading, function(flt)
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

function ValidDrop()
    local offset = 1.0
    local angle = math.abs(Player.Drop.Heading - Player.Pallet.Heading)

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
--          BLIPS          --
-----------------------------

-- Update minimap blips
function UpdateBlips()
    RemoveBlips()

    -- Locker Room blip
    Utils.DrawBlip("Locker", 366, _U('locker_room'))

    if Player.OnDuty then
        if Player.FLT then
            if Player.FLT.Active then
                -- FLT return blip
                Utils.DrawBlip("Return", 473, _U('warehouse_return'))
            end

            RemoveBlip(Config.Zones.Garage.Blip)
        else
            -- FLT garage blip
            Utils.DrawBlip("Garage", 524, _U('warehouse_pickup'))
        end 
    end
end

-- Remove all minimap blips
function RemoveBlips()
    for k, v in pairs(Config.Zones) do
        if v.Blip then
            RemoveBlip(v.Blip)
            v.Blip = nil
        end
    end
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
    
    Hint.Display = false
    Hint.Zone = false
    Hint.Message = false
    
    Message = false
end

-- Reset collectables on resource stop
AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then

        Reset(true)

        if Config.Debug then
            SetEntityCoords(Player.Ped, Config.Zones.Locker.Pos.x, Config.Zones.Locker.Pos.y, Config.Zones.Locker.Pos.z, 1, 0, 0, 1)
            for k, Drop in pairs(Config.Drops) do
                if Drop.Entity then
                    ESX.Game.DeleteObject(Drop.Entity)
                    Drop.Entity = false
                end
            end
        end        
    end
end)


-------------------------------
--          THREADS          --
-------------------------------

-- Player Position Thread
Citizen.CreateThread(function()
    while true do
        if Ready and Player.Authorized then
            if not Player.Ped then
                Player.Ped = PlayerPedId()
            end
            Player.Pos = GetEntityCoords(Player.Ped)
        end
        Citizen.Wait(100)
    end
end)

Citizen.CreateThread(function()
    while true do
        if Ready and Player.Authorized then
            if Player.Working and Player.Drop then
                Player.Pallet.Heading = GetEntityHeading(Player.Pallet.Entity)
                Player.Pallet.Lifted = IsEntityInAir(Player.Pallet.Entity)
                Player.AtPallet = IsEntityAtEntity(Player.FLT.Entity, Player.Pallet.Entity, 3.0, 3.0, 3.0, 0, 1, 0)
            end
        end
        Citizen.Wait(0)
    end
end)

-- FLT Interaction Thread
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)

        if Ready and Player.Authorized then
            if Player.FLT then
                if not IsPedSittingInVehicle(Player.Ped, Player.FLT.Entity) then
                    Player.FLT.Active = false

                    AddFLTBlip()
                    RemoveBlip(Config.Zones.Return.Blip)
                else
                    if Player.FLT.Blip then
                        UpdateBlips()
                        RemoveBlip(Player.FLT.Blip)
                    end
                    Player.FLT.Active = true

                    if not Player.Working then
                        StartWork()
                    end
                end
            end
        end
    end
end)

-- On-screen Message Thread
Citizen.CreateThread(function()
    while true do
        if Message.Display then
            if Message.Type == 'delivered' then
                Message.Title = 'Pallet Delivered'
                Message.SubTitle = Player.Delivered .. ' Pallets Delivered'
            elseif Message.Type == 'pickup' then
                Message.Title = 'Collection Ready'
                Message.SubTitle = 'Go to the collection point'
            elseif Message.Type == 'dropoff' then
                Message.Title = 'Deliver The Pallet'
                Message.SubTitle = 'Take the pallet to the drop-off point'
            end

            Utils.RenderText(Message.Title, 7, 0.5, 0.25, 1.50, 238, 238, 0, 255)
            Utils.RenderText(Message.SubTitle, 4, 0.5, 0.33, 0.5)

            Citizen.SetTimeout(3000, function()
                Message.Type = nil
                Message.Title = nil
                Message.Message = nil
                Message.Display = false
            end)
        end
        Citizen.Wait(0)
    end
end)

-- Markers Thread
Citizen.CreateThread(function()
    while true do
        if Ready and Player.Authorized then
            if #(Config.Zones.Locker.Pos - Player.Pos) <= Config.DrawDistance then
                -- Locker Room Marker
                DrawMarker(Config.Zones.Locker.Type, Config.Zones.Locker.Pos, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.Zones.Locker.Size.x, Config.Zones.Locker.Size.y, Config.Zones.Locker.Size.z, Config.Zones.Locker.Color.r, Config.Zones.Locker.Color.g, Config.Zones.Locker.Color.b, 100, false, true, 2, false, nil, nil, false)
            end

            if Player.OnDuty then
                if not Player.FLT then
                    -- FLT Garage Marker
                    DrawMarker(Config.Zones.Garage.Type, Config.Zones.Garage.Pos, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.Zones.Garage.Size.x, Config.Zones.Garage.Size.y, Config.Zones.Garage.Size.z, Config.Zones.Garage.Color.r, Config.Zones.Garage.Color.g, Config.Zones.Garage.Color.b, 100, false, true, 2, false, nil, nil, false)
                else
                    if Player.FLT.Active then
                        -- FLT Return Marker
                        DrawMarker(Config.Zones.Return.Type, Config.Zones.Return.Pos, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.Zones.Return.Size.x, Config.Zones.Return.Size.y, Config.Zones.Return.Size.z, Config.Zones.Return.Color.r, Config.Zones.Return.Color.g, Config.Zones.Return.Color.b, 100, false, true, 2, false, nil, nil, false)
                    end
                end

                if Player.Drop and Player.Drop.PickedUp then
                    -- Delivery Point Ghost
                    Utils.DrawBox(Player.Drop.Bounds[1], Player.Drop.Bounds[2], Player.Drop.Bounds[4], Player.Drop.Bounds[3], 238, 238, 0, 100)

                    -- Delivery Point Marker
                    DrawMarker(0, vector3(Player.Drop.Pos.x, Player.Drop.Pos.y, Player.Drop.Pos.z + 3.0), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.Zones.Return.Size.x, Config.Zones.Return.Size.y, Config.Zones.Return.Size.z, Config.Zones.Return.Color.r, Config.Zones.Return.Color.g, Config.Zones.Return.Color.b, 100, true, true, 2, false, nil, nil, false)
                end
            end
        end       

        Citizen.Wait(0)
    end
end)

-- Delivery Thread
Citizen.CreateThread(function()
    while true do
        if Ready and Player.Authorized then
            if Player.Working and Player.Drop then
                local pcoords = GetEntityCoords(Player.Pallet.Entity) 
                local pdist = #(Player.Drop.Pos - pcoords)                 

                -- Only do checks if player is close
                if pdist <= 0.5 then      
                    if ValidDrop() then
                        DeliverPallet()
                    end   
                else
                    if not Player.AtPallet then
                        DrawMarker(0, vector3(pcoords.x, pcoords.y, pcoords.z + 3.0), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.Zones.Return.Size.x, Config.Zones.Return.Size.y, Config.Zones.Return.Size.z, Config.Zones.Return.Color.r, Config.Zones.Return.Color.g, Config.Zones.Return.Color.b, 100, true, true, 2, false, nil, nil, false)
                    end                
                end                
            end                
        end
        Citizen.Wait(0)
    end
end)


-- Zone Thread
Citizen.CreateThread(function()
    while true do
        if Ready and Player.Authorized then

            Hint.Zone = false
            Hint.Display = false
            Hint.Message = false                

            if #(Config.Zones.Locker.Pos - Player.Pos) <= Config.DrawDistance then
                local crdist = #(Config.Zones.Locker.Pos - Player.Pos) 

                if crdist <= Config.Zones.Locker.Size.x then
                    Hint.Zone = 'Locker'
                    Hint.Display = true
                    Hint.Message = _U('change_clothes')
                end
            end

            if Player.OnDuty then
                local grdist = #(Config.Zones.Garage.Pos - Player.Pos) 
                local rtdist = #(Config.Zones.Return.Pos - Player.Pos) 

                if grdist <= Config.Zones.Garage.Size.x and not Player.FLT then
                    Hint.Zone = 'Garage'
                    Hint.Display = true
                    Hint.Message = _U('enter_flt')
                end
                    
                if rtdist <= Config.Zones.Garage.Size.x and Player.FLT and Player.FLT.Active then
                    Hint.Zone = 'Return'
                    Hint.Display = true
                    Hint.Message = _U('return_flt')
                end  
                    
                if Player.Working and Player.Drop then
                    if Player.Pallet.Lifted and not Player.Drop.PickedUp then
                        Player.Drop.PickedUp = true
                        AddPalletBlip(Player.Drop)
                        
                        DisplayMessage('dropoff')
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

        Citizen.Wait(0)
    end
end)

-- Notification Thread
Citizen.CreateThread(function()
    while true do
        if Ready and Player.Authorized then
            if Hint.Display and Hint.Message then
                ESX.ShowHelpNotification(Hint.Message, 3000)
            end
        end
        Citizen.Wait(1)
    end
end)

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