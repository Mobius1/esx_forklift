-- Get the bounding box of an entity
function GetEntityBounds(entity)
    local min, max = GetModelDimensions(GetEntityModel(entity))
    local pad = 0

    return {
        GetOffsetFromEntityInWorldCoords(entity, min.x - pad, min.y - pad, min.z - pad), -- REAR LEFT
        GetOffsetFromEntityInWorldCoords(entity, max.x + pad, min.y - pad, min.z - pad), -- REAR RIGHT
        GetOffsetFromEntityInWorldCoords(entity, max.x + pad, max.y + pad, min.z - pad), -- FRONT RIGHT
        GetOffsetFromEntityInWorldCoords(entity, min.x - pad, max.y + pad, min.z - pad), -- FRONT LEFT
    }
end


function DrawBox(p1, p2, p3, p4, r, g, b, a)
    local offset = 0.05
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


    -- BOTTOM
    -- DrawPoly(p1.x, p1.y, p1.z + offset, p2.x, p2.y, p2.z + offset, p3.x, p3.y, p3.z + offset, r, g, b, a)
    -- DrawPoly(p4.x, p4.y, p4.z + offset, p3.x, p3.y, p3.z + offset, p2.x, p2.y, p2.z + offset, r, g, b, a)   

    -- BACK
    -- DrawPoly(p1.x, p1.y, p1.z + offset, p1.x, p1.y, p1.z + offset + side, p2.x, p2.y, p2.z + offset + side, r, g, b, a)
    -- DrawPoly(p2.x, p2.y, p2.z + offset + side, p2.x, p2.y, p2.z + offset, p1.x, p1.y, p1.z + offset, r, g, b, a)

    -- FRONT
    -- DrawPoly(p3.x, p3.y, p3.z + offset, p3.x, p3.y, p3.z + offset + side, p4.x, p4.y, p4.z + offset + side, r, g, b, a)
    -- DrawPoly(p4.x, p4.y, p4.z + offset + side, p4.x, p4.y, p4.z + offset, p3.x, p3.y, p3.z + offset, r, g, b, a) 
    
    -- LEFT
    -- DrawPoly(p2.x, p2.y, p2.z + offset, p2.x, p2.y, p2.z + offset + side, p4.x, p4.y, p4.z + offset + side, r, g, b, a)
    -- DrawPoly(p4.x, p4.y, p4.z + offset, p4.x, p4.y, p4.z + offset + side, p2.x, p2.y, p2.z + offset + side, r, g, b, a)

    -- DrawPoly(p4.x, p4.y, p4.z + offset + side, p4.x, p4.y, p4.z + offset, p2.x, p2.y, p2.z + offset, r, g, b, a)
    -- DrawPoly(p2.x, p2.y, p2.z + offset + side, p2.x, p2.y, p2.z + offset, p4.x, p4.y, p4.z + offset, r, g, b, a)

    -- RIGHT
    -- DrawPoly(p3.x, p3.y, p3.z + offset, p3.x, p3.y, p3.z + offset + side, p1.x, p1.y, p1.z + offset + side, r, g, b, a)
    -- DrawPoly(p1.x, p1.y, p1.z + offset, p1.x, p1.y, p1.z + offset + side, p3.x, p3.y, p3.z + offset + side, r, g, b, a)
    
    -- DrawPoly(p1.x, p1.y, p1.z + offset + side, p1.x, p1.y, p1.z + offset, p3.x, p3.y, p3.z + offset, r, g, b, a)
    -- DrawPoly(p3.x, p3.y, p3.z + offset + side, p3.x, p3.y, p3.z + offset, p1.x, p1.y, p1.z + offset, r, g, b, a)    
  
 
end