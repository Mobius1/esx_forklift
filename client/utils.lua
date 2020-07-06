Utils = {}

Utils.AddBlip = function(Obj, ID, Text, Coords)
    if Obj.Blip then
        RemoveBlip(Obj.Blip)
    end

    if Coords ~= nil then
        Obj.Blip = AddBlipForCoord(Obj.Pos.x, Obj.Pos.y, Obj.Pos.z)
    else
        Obj.Blip = AddBlipForEntity(Obj.Entity)
    end

    SetBlipSprite(Obj.Blip, ID)
    SetBlipAsShortRange(Obj.Blip, true)
    SetBlipColour(Obj.Blip, 5)
    SetBlipScale(Obj.Blip, 1.0)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(Text)
    EndTextCommandSetBlipName(Obj.Blip)  
end

Utils.DrawZoneBlip = function(Type, ID, Text)
    local Zone = Config.Zones[Type]

    if Zone.Blip then
        RemoveBlip(Zone.Blip)
    end

    if Type == 'Pickup' then
        Zone.Blip = AddBlipForEntity(Zone.Entity)
    else
        Zone.Blip = AddBlipForCoord(Zone.Pos.x, Zone.Pos.y, Zone.Pos.z)
    end

    SetBlipSprite(Zone.Blip, ID)
    SetBlipAsShortRange(Zone.Blip, true)
    SetBlipColour(Zone.Blip, 5)
    SetBlipScale(Zone.Blip, 1.0)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(Text)
    EndTextCommandSetBlipName(Zone.Blip)  
end


-- Get the bounding box of an entity
Utils.GetEntityBounds = function(entity)
    local min, max = GetModelDimensions(GetEntityModel(entity))
    local pad = 0.00

    return {
        GetOffsetFromEntityInWorldCoords(entity, min.x - pad, min.y - pad, min.z - pad), -- REAR LEFT
        GetOffsetFromEntityInWorldCoords(entity, max.x + pad, min.y - pad, min.z - pad), -- REAR RIGHT
        GetOffsetFromEntityInWorldCoords(entity, max.x + pad, max.y + pad, min.z - pad), -- FRONT RIGHT
        GetOffsetFromEntityInWorldCoords(entity, min.x - pad, max.y + pad, min.z - pad), -- FRONT LEFT
    }
end

Utils.DrawBox = function(p1, p2, p3, p4, r, g, b, a)
    local offset = 0.00
    local side = 1.5
    
    DrawLine(p1.x, p1.y, p1.z + offset, p2.x, p2.y, p2.z + offset, 255, 255, 255, 255)
    DrawLine(p3.x, p3.y, p3.z + offset, p4.x, p4.y, p4.z + offset, 255, 255, 255, 255)
    DrawLine(p1.x, p1.y, p1.z + offset, p3.x, p3.y, p3.z + offset, 255, 255, 255, 255)
    DrawLine(p2.x, p2.y, p2.z + offset, p4.x, p4.y, p4.z + offset, 255, 255, 255, 255)
    
    DrawLine(p1.x, p1.y, p1.z + offset, p1.x, p1.y, p1.z + offset + side, 255, 255, 255, 255)   
    DrawLine(p2.x, p2.y, p2.z + offset, p2.x, p2.y, p2.z + offset + side, 255, 255, 255, 255)   
    DrawLine(p3.x, p3.y, p3.z + offset, p3.x, p3.y, p3.z + offset + side, 255, 255, 255, 255)   
    DrawLine(p4.x, p4.y, p4.z + offset, p4.x, p4.y, p4.z + offset + side, 255, 255, 255, 255)   

    DrawLine(p1.x, p1.y, p1.z + offset + side, p2.x, p2.y, p2.z + offset + side, 255, 255, 255, 255)
    DrawLine(p3.x, p3.y, p3.z + offset + side, p4.x, p4.y, p4.z + offset + side, 255, 255, 255, 255)
    DrawLine(p1.x, p1.y, p1.z + offset + side, p3.x, p3.y, p3.z + offset + side, 255, 255, 255, 255)
    DrawLine(p2.x, p2.y, p2.z + offset + side, p4.x, p4.y, p4.z + offset + side, 255, 255, 255, 255)    
end

Utils.TranslateVector = function(p, dir, dist)
    local angle = math.rad(dir - 90)
    local x = p.x + dist * math.cos(angle)
    local y = p.y + dist * math.sin(angle)
    return vector3(x, y, p.z)
end

Utils.RenderText = function(text, font, x, y, scale, r, g, b, a)
    if x == nil then  x = 0.5 end
    if y == nil then y = 0.5 end 
    if r == nil then r = 255 end   
    if g == nil then g = 255 end   
    if b == nil then b = 255 end   
    if a == nil then a = 255 end   

    SetTextFont(font)
    SetTextProportional(7)
    SetTextCentre(true)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextDropShadow()
    SetTextEdge(4, 0, 0, 0, 255)
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x,y)
end

Utils.RenderDebugText = function(x, y, text, scale)
    SetTextFont(4)
    SetTextProportional(7)
    SetTextScale(scale, scale)
    SetTextColour(255, 255, 255, 255)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextDropShadow()
    SetTextEdge(4, 0, 0, 0, 255)
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x, y)
end

Utils.RenderDebugHud = function(Zones, Player, Distance)

    local y = 0.40

    local pickup = "false"
    local pdist = 0.00

    if Zones.Pickup.Active then
        pickup = "true"

        if Distance.Pickup then
            pdist = math.floor(Distance.Pickup * 100) / 100
        end        
    end

    local drop = "false"
    local ddist = 0.00

    if Zones.Drop.Active then
        drop = "true"

        if Distance.Drop then
            ddist = math.floor(Distance.Drop * 100) / 100
        end           
    end 
    
    local pickedup = "false"

    if Zones.Drop.PickedUp then
        pickedup = "true"
    end

    local lifted = "false"
    local health = 'N/A'

    if Player.Pallet then
        if Player.Pallet.Lifted then
            lifted = "true"
        end
        
        if Zones.Drop.Active then
            health = Player.Pallet.Health / 10 .. "%"
        end
    end    

    Utils.RenderDebugText(0.05, y, 'Pickup Point', 0.35)
    y = y + 0.02
    Utils.RenderDebugText(0.05, y, 'Ready:                   ~g~' .. pickup, 0.35)
    y = y + 0.02
    Utils.RenderDebugText(0.05, y, 'Distance:               ~g~' .. pdist .. 'm', 0.35)     
    y = y + 0.04
    Utils.RenderDebugText(0.05, y, 'Delivery Point', 0.35)
    y = y + 0.02
    Utils.RenderDebugText(0.05, y, 'Ready:                   ~g~' .. drop, 0.35)
    y = y + 0.02
    Utils.RenderDebugText(0.05, y, 'Distance:               ~g~' .. ddist .. 'm', 0.35)    
    y = y + 0.04
    Utils.RenderDebugText(0.05, y, 'Pallet', 0.35)
    y = y + 0.02
    Utils.RenderDebugText(0.05, y, 'Lifted:                    ~g~' .. lifted, 0.35)      
    y = y + 0.02
    Utils.RenderDebugText(0.05, y, 'Picked Up:             ~g~' .. pickedup, 0.35)    
    y = y + 0.02
    Utils.RenderDebugText(0.05, y, 'Health:                   ~g~' .. health, 0.35)         
    y = y + 0.02
end

Utils.GetCentreOfVectors = function(v1, v2)
    return vector3((v1.x+v2.x)/2.0,(v1.y+v2.y)/2.0,(v1.z+v2.z)/2.0)
end

Utils.PlayAnimation = function(animDict, animName, ped)

    if ped == nil then
        ped = Player.Ped
    end

    if not HasAnimDictLoaded(animDict) then
        RequestAnimDict(animDict)
        while not HasAnimDictLoaded(animDict) do
            Wait(0)
        end
    end
    
    TaskPlayAnim(ped, animDict, animName, 8.0, 1.0, 3000, 16, 0.0, false, false, true)
    RemoveAnimDict(animDict)
end

Utils.FacePedToEntity = function(ped, entity)
    -- Position you want ped to face
    local positionToFace = GetEntityCoords(entity)

    -- Current ped position
    local pedPos = GetEntityCoords(ped)

    -- Position diff
    local x = positionToFace.x - pedPos.x
    local y = positionToFace.y - pedPos.y

    -- Calculate heading
    local heading = GetHeadingFromVector_2d(x, y)
        
    -- Set the ped's new heading
    SetEntityHeading(ped, heading)
end