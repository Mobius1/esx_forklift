Utils = {}

Utils.DrawBlip = function(Type, ID, Text)
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