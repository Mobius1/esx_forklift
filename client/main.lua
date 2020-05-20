ESX = nil
Ready = false
Authorized = false
Player = {
    OnDuty = false,
    FLT = false,
    Working = false,
    Pallet = false,
    InRange = false,
    Delivered = 0
}

Threads = {
    Notification = false,
    FLT = false,
    Marker = false,
    Zone = false,
}

Zone = false
ShowHint = false
HintMessage = false

Citizen.CreateThread(function()
    while ESX == nil do
        Citizen.Wait(10)
        TriggerEvent("esx:getSharedObject", function(response)
            ESX = response
        end)
    end
    Wait(1000)
    while not ESX.IsPlayerLoaded() do
        Citizen.Wait(10)
    end
    Player.Data = ESX.GetPlayerData()

    if Player.Data.job.name == 'flt' then
        Authorized = true
        InitFLTJob()
    end
end)


RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    if job.name == 'flt' then
        Player.Data.job = job
        Player.OnDuty = false
        Authorized = true
        InitFLTJob()
    else
        RemoveBlips()
        Ready = false
        Authorized = false
        Threads = {
            Notification = false,
            FLT = false,
            Marker = false,
            Zone = false
        }
    end
end)

function InitFLTJob()


    -- local objs = ESX.Game.GetObjects()

    -- for k, v in pairs(objs) do
    --     if GetEntityModel(v) == 519908417 then
    --         ESX.Game.DeleteObject(v)
    --     end
    -- end

    ESX.TriggerServerCallback("esx_flt:ready", function(xPlayer, auth)
        if auth then
            Player.Data = xPlayer
            Player.Ped = PlayerPedId()
            Player.Pos = GetEntityCoords(Player.Ped)
            Ready = true

            if not Threads.Notification then
                StartNotificationThread()
            end

            if not Threads.FLT then
                StartFLTThread()
            end

            if not ThreadstMarker then
                StartMarkerThread()
            end

            if not Threads.Zone then
                StartZoneThread()
            end 
            
            if not Threads.Drop then
                StartDropThread()                
            end
        
            UpdateBlips()  
        end
    end)    
end

function StartNotificationThread()
    Threads.Notification = true
    -- Help Notification
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(1)
            if Ready and Authorized then
                if ShowHint and HintMessage then
                    ESX.ShowHelpNotification(HintMessage, 3000)
                end
            end
        end
    end)
end

function StartFLTThread()
    Threads.FLT = true
    -- Check player is in FLT
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(1)

            if Ready and Authorized and Player.FLT then
                if not IsPedSittingInVehicle(Player.Ped, Player.FLT.vehicle) then
                    Player.FLT.Active = false

                    DrawFLTBlip()
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
    end)
end

function StartMarkerThread()
    Threads.Marker = true
    -- Render Markers
    Citizen.CreateThread(function()
        while true do

            if Config.Debug then
                for k, Drop in pairs(Config.Drops) do
                    if not Drop.Entity then
                        ESX.Game.SpawnObject('prop_boxpile_09a', Drop.Pos, function(pallet)
                            SetEntityHeading(pallet, Drop.Heading)
                            PlaceObjectOnGroundProperly(pallet)
    
                            Wait(250)
    
                            Drop.Entity = pallet
    
                            Drop.Bounds = GetEntityBounds(pallet)

                            Drop.Blip = AddBlipForCoord(Drop.Pos.x, Drop.Pos.y, Drop.Pos.z)

                            SetBlipSprite(Drop.Blip, 1)
                            SetBlipAsShortRange(Drop.Blip, true)
                            SetBlipColour(Drop.Blip, 5)
                            SetBlipScale(Drop.Blip, 1.0)
                            BeginTextCommandSetBlipName("STRING")
                            AddTextComponentString("Pallet")
                            EndTextCommandSetBlipName(Drop.Blip)  

                            Wait(250)
                            ESX.Game.DeleteObject(pallet)
                        end)
                    else
                        DrawBox(Drop.Bounds[1], Drop.Bounds[2], Drop.Bounds[4], Drop.Bounds[3], 238, 238, 0, 100)

                        ESX.Game.Utils.DrawText3D(Drop.Pos, Drop.Pos.x .. ' | ' .. Drop.Pos.y .. ' | ' .. Drop.Heading, 1.00)
                    end
                end
            end


            if Ready and Authorized then
                if #(Config.Zones.Locker.Pos - Player.Pos) <= Config.DrawDistance then
                    DrawMarker(Config.Zones.Locker.Type, Config.Zones.Locker.Pos, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.Zones.Locker.Size.x, Config.Zones.Locker.Size.y, Config.Zones.Locker.Size.z, Config.Zones.Locker.Color.r, Config.Zones.Locker.Color.g, Config.Zones.Locker.Color.b, 100, false, true, 2, false, nil, nil, false)
                end

                if Player.OnDuty then
                    if not Player.FLT then
                        DrawMarker(Config.Zones.Garage.Type, Config.Zones.Garage.Pos, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.Zones.Garage.Size.x, Config.Zones.Garage.Size.y, Config.Zones.Garage.Size.z, Config.Zones.Garage.Color.r, Config.Zones.Garage.Color.g, Config.Zones.Garage.Color.b, 100, false, true, 2, false, nil, nil, false)
                    else
                        if Player.FLT.Active then
                            DrawMarker(Config.Zones.Return.Type, Config.Zones.Return.Pos, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.Zones.Return.Size.x, Config.Zones.Return.Size.y, Config.Zones.Return.Size.z, Config.Zones.Return.Color.r, Config.Zones.Return.Color.g, Config.Zones.Return.Color.b, 100, false, true, 2, false, nil, nil, false)
                        end
                    end

                    if Player.Pallet and Player.Pallet.Entity and not Player.Drop.PickedUp then
                        DrawMarker(0, vector3(Player.Pallet.InitCoords.x, Player.Pallet.InitCoords.y, Player.Pallet.InitCoords.z + 3.0), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.Zones.Return.Size.x, Config.Zones.Return.Size.y, Config.Zones.Return.Size.z, Config.Zones.Return.Color.r, Config.Zones.Return.Color.g, Config.Zones.Return.Color.b, 100, true, true, 2, false, nil, nil, false)
                    end

                    if Player.Drop and Player.Drop.PickedUp then
                        DrawBox(Player.Drop.Bounds[1], Player.Drop.Bounds[2], Player.Drop.Bounds[4], Player.Drop.Bounds[3], 238, 238, 0, 100)
                        DrawMarker(0, vector3(Player.Drop.Pos.x, Player.Drop.Pos.y, Player.Drop.Pos.z + 3.0), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.Zones.Return.Size.x, Config.Zones.Return.Size.y, Config.Zones.Return.Size.z, Config.Zones.Return.Color.r, Config.Zones.Return.Color.g, Config.Zones.Return.Color.b, 100, true, true, 2, false, nil, nil, false)
                    end
                end
            end       

            Citizen.Wait(0)
        end
    end)
end

function StartZoneThread()
    Threads.Zone = true
    -- In Marker Checks
    Citizen.CreateThread(function()
        while true do

            if Ready and Authorized then

                Zone = false
                ShowHint = false
                HintMessage = false                

                Player.Pos = GetEntityCoords(Player.Ped)

                if #(Config.Zones.Locker.Pos - Player.Pos) <= Config.DrawDistance then
                    local crdist = #(Config.Zones.Locker.Pos - Player.Pos) 

                    if crdist <= Config.Zones.Locker.Size.x then
                        Zone = 'Locker'
                        ShowHint = true
                        HintMessage = _U('change_clothes')
                    end
                end

                if Player.OnDuty then
                    local grdist = #(Config.Zones.Garage.Pos - Player.Pos) 
                    local rtdist = #(Config.Zones.Return.Pos - Player.Pos) 

                    if grdist <= Config.Zones.Garage.Size.x and not Player.FLT then
                        Zone = 'Garage'
                        ShowHint = true
                        HintMessage = _U('enter_flt')
                    end
                    
                    if rtdist <= Config.Zones.Garage.Size.x and Player.FLT and Player.FLT.Active then
                        Zone = 'Return'
                        ShowHint = true
                        HintMessage = _U('return_flt')
                    end  
                    
                    if Player.Working and Player.Drop then
                        local inAir = IsEntityInAir(Player.Pallet.Entity)
                        local atPallet = IsEntityAtEntity(Player.FLT.vehicle, Player.Pallet.Entity, 3.0, 3.0, 3.0, 0, 1, 0)

                        if not Player.Drop.PickedUp then
                            if atPallet and not Player.AtPallet then
                                Player.AtPallet = true
                                ESX.ShowNotification(_U('notif_pickup'))
                            end

                            if inAir then
                                Player.Drop.PickedUp = true
                                AddPalletBlip(Player.Drop)
                                ESX.ShowNotification(_U('notif_dropoff'))
                            end
                        end
                    end
                end

                if IsControlJustReleased(0, 38) then
                    if ShowHint then
                        if Zone == 'Locker' then
                            FLTMenu()
                        elseif Zone == 'Garage' then
                            FLTSpawn()
                        elseif Zone == 'Return' then
                            FLTReturn()
                        end
                    end
                end            
            end

            Citizen.Wait(0)
        end
    end)
end

function StartDropThread()
    Threads.Drop = true
    Citizen.CreateThread(function()
        while true do
            if Ready and Authorized then
                if Player.Working and Player.Drop then
                    local pcoords = GetEntityCoords(Player.Pallet.Entity)
                    local inAir = IsEntityInAir(Player.Pallet.Entity)   
                    local pdist = #(Player.Drop.Pos - pcoords)                 

                    -- Only do checks if player is close
                    if pdist <= 0.5 then      
                        if ValidDrop(inAir) then
                            FLTDrop()
                        end   
                    else
                        if not inAir then
                            DrawMarker(0, vector3(pcoords.x, pcoords.y, pcoords.z + 3.0), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.Zones.Return.Size.x, Config.Zones.Return.Size.y, Config.Zones.Return.Size.z, Config.Zones.Return.Color.r, Config.Zones.Return.Color.g, Config.Zones.Return.Color.b, 100, true, true, 2, false, nil, nil, false)
                        end                
                    end                
                end                
            end
            Citizen.Wait(0)
        end
    end)
end

function ValidDrop(inAir)
    local offset = 1.0
    local heading = GetEntityHeading(Player.Pallet.Entity) 
    local angle = math.abs(Player.Drop.Heading - heading)
    local atPallet = IsEntityAtEntity(Player.FLT.vehicle, Player.Pallet.Entity, 3.0, 3.0, 3.0, 0, 1, 0)

    local correctAngle = false
    if angle < offset or angle - 180 < offset then
        correctAngle = true
    end

    if correctAngle and not inAir and not atPallet then
        return true
    end

    return false
end

function RemoveBlips()
    for k, v in pairs(Config.Zones) do
        if v.Blip then
            RemoveBlip(v.Blip)
            v.Blip = nil
        end
    end
end

function UpdateBlips()
    if Player.Data.job.name ~= nil and Authorized then
        RemoveBlips()

        DrawBlip("Locker", 366, _U('locker_room'))

        if Player.OnDuty then
            if Player.FLT then
                if Player.FLT.Active then
                    DrawBlip("Return", 473, _U('warehouse_return'))
                end
    
                RemoveBlip(Config.Zones.Garage.Blip)
            else
                DrawBlip("Garage", 524, _U('warehouse_pickup'))
            end 
        end
    end
end

function DrawBlip(Type, ID, Text)
    local Zone = Config.Zones[Type]

    if Zone.Blip then
        RemoveBlip(Zone.Blip)
    end

    Zone.Blip = AddBlipForCoord(Zone.Pos.x, Zone.Pos.y, Zone.Pos.z)

    SetBlipSprite(Zone.Blip, ID)
    SetBlipAsShortRange(Zone.Blip, true)
    SetBlipColour(Zone.Blip, 5)
    SetBlipScale(Zone.Blip, 1.0)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(Text)
    EndTextCommandSetBlipName(Zone.Blip)  
end

function DrawFLTBlip()
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

function StartWork()
    Player.FLT.plate = GetVehicleNumberPlateText(GetVehiclePedIsIn(Player.Ped, false))
    Player.Working = true

    SpawnPallet()
end

function StopWork()
    RemovePallet()
end

function SpawnPallet()
    RemovePallet()

    if not Player.Pallet then
        Player.Pallet = {}

        local Points = GetPoints()
        local Pickup = Config.Drops[Points[1]]
        local prop = Config.Props[ math.random( #Config.Props ) ]

        ESX.Game.SpawnObject(prop, Pickup.Pos, function(pallet)

            if prop == 'prop_boxpile_02b' then
                Pickup.Heading = Pickup.Heading + 90
            end

            SetEntityHeading(pallet, Pickup.Heading)
            PlaceObjectOnGroundProperly(pallet)

            Wait(1000)

            Player.Pallet.Entity = pallet
            Player.Pallet.InitCoords = GetEntityCoords(pallet)

            Player.Drop = Config.Drops[Points[2]] 

            DrawDropOffPoint(prop)

            AddPalletBlip(Player.Pallet)
            
            ESX.ShowNotification(_U('pallet_pickup'))
        end)
    end
end

function DrawDropOffPoint(prop)
    ESX.Game.SpawnObject(prop, Player.Drop.Pos, function(pallet)
        SetEntityHeading(pallet, Player.Drop.Heading)
        PlaceObjectOnGroundProperly(pallet)
    
        Wait(250)
    
        Player.Drop.Bounds = GetEntityBounds(pallet)

        Wait(250)

        ESX.Game.DeleteObject(pallet)
    end)
end

function AddPalletBlip(Obj)
    local Message = ''
    if Obj.Entity ~= nil then
        Message = 'Pallet Pickup'
        Obj.Blip = AddBlipForEntity(Obj.Entity)
    else
        Message = 'Pallet Dropoff'
        Obj.Blip = AddBlipForCoord(Obj.Pos.x, Obj.Pos.y, Obj.Pos.z)
    end

    SetBlipSprite(Obj.Blip, 1)
    SetBlipAsShortRange(Obj.Blip, true)
    SetBlipColour(Obj.Blip, 5)
    SetBlipScale(Obj.Blip, 1.0)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(Message)
    EndTextCommandSetBlipName(Obj.Blip) 
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

function GetPoints()
    local points = {}
    math.randomseed( GetGameTimer() )
    for i = 1, 2 do
        table.insert(points, math.random( #Config.Drops ))
    end
    return points
end

function Reset(force)
    FLTReturn(force)
    RemovePallet()

    Player.OnDuty = false
    Player.FLT = false
    Player.Working = false
    Player.Pallet = false
    Player.InRange = false
    Player.Delivered = 0 
end

function FLTDrop()

    Zone = false
    ShowHint = false
    HintMessage = false

    Player.Delivered = Player.Delivered + 1
    PlaySoundFrontend(-1, "PICK_UP", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
    SpawnPallet()
end

function FLTSpawn()
    ESX.Game.SpawnVehicle('forklift', Config.Zones.FLT.Pos, Config.Zones.FLT.Heading, function(flt)
        SetVehicleNumberPlateText(flt, math.random(1000, 9999))
        Wait(100)
        Player.FLT = {
            vehicle = flt
        }

        UpdateBlips()    
        
        TaskWarpPedIntoVehicle(Player.Ped, flt, -1)
    end)
end

function FLTReturn(force)
    if Player.FLT then
        Player.Working = false
        print(Player.FLT.plate)
        print(GetVehicleNumberPlateText(GetVehiclePedIsIn(Player.Ped, false)))
        -- Player returned FLT to warehouse
        if force or (IsPedInAnyVehicle(Player.Ped) and Player.FLT.plate == GetVehicleNumberPlateText(GetVehiclePedIsIn(Player.Ped, false))) then
            TriggerServerEvent('esx_flt:getPaid', Player.Delivered * Config.Pay)

            ESX.Game.DeleteVehicle(Player.FLT.vehicle)
            Player.FLT = false
    
            UpdateBlips()
        else
            ESX.ShowNotification('~r~You need to return your FLT to get paid!')
        end
    end
end


-- Reset collectables on resource stop
AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then

        Reset(true)

        SetEntityCoords(Player.Ped, Config.Zones.Locker.Pos.x, Config.Zones.Locker.Pos.y, Config.Zones.Locker.Pos.z, 1, 0, 0, 1)

        if Config.Debug then
            for k, Drop in pairs(Config.Drops) do
                if Drop.Entity then
                    ESX.Game.DeleteObject(Drop.Entity)
                    Drop.Entity = false
                end
            end
        end        
    end
end)

menuIsOpen = false
function FLTMenu()								
    menuIsOpen = true
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

                SetEntityCoords(Player.Ped, Config.Zones.Garage.Pos.x, Config.Zones.Garage.Pos.y, Config.Zones.Garage.Pos.z, 1, 0, 0, 1)

                UpdateBlips()
            end)
        end
            menu.close()
            menuIsOpen = false
        end,
        function(data, menu)
            menu.close()
            menuIsOpen = false
        end
    )
end