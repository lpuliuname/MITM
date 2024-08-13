local Class = require (fuccboi_path .. '/libraries/classic/classic')
local Tilemap = Class:extend()

function Tilemap:tilemapNew()

end

function Tilemap:createTiledMapEntities(tilemap)
    for _, object in ipairs(tilemap.objects) do
        if object.type == 'Solid' then
            self:createEntity('Solid', object.x + tilemap.x - tilemap.w/2 + object.width/2, 
                              object.y + tilemap.y - tilemap.h/2 + object.height/2,
                             {body_type = 'static', w = object.width, h = object.height})
        else
            local settings = {}
            settings.name = object.name
            settings.shape = object.shape
            settings.width, settings.height = object.width, object.height
            settings.rotation = object.rotation
            settings.visible = object.visible
            for k, v in pairs(object.properties) do settings[k] = v end
            self:createEntity(object.type, object.x + tilemap.x - tilemap.w/2 + object.width/2, 
                              object.y + tilemap.y - tilemap.h/2 + object.height/2, settings) 
        end
    end
end

function Tilemap:generateCollisionSolids(tilemap)
    -- New solid_grid copy to be marked over
    local grid = {}
    for i = 1, #tilemap.solid_grid do
        grid[i] = {}
        for j = 1, #tilemap.solid_grid[i] do
            grid[i][j] = tilemap.solid_grid[i][j]
        end
    end

    -- Create all edges
    local edges = {}
    local mx, my = tilemap.tile_width, tilemap.tile_height
    for i = 1, #grid do
        for j = 1, #grid[i] do
            if grid[i][j] ~= 0 then
                local x, y = mx*(j-1) + mx/2, my*(i-1) + my/2
                local v0 = {x = x - mx/2, y = y + my/2}
                local v1 = {x = x - mx/2, y = y - my/2}
                local v2 = {x = x + mx/2, y = y - my/2}
                local v3 = {x = x + mx/2, y = y + my/2}
                table.insert(edges, {v0, v1})
                table.insert(edges, {v1, v2})
                table.insert(edges, {v2, v3})
                table.insert(edges, {v3, v0})
            end
        end
    end

    local isEdgeEqual = function(e1, e2)
        local d1 = (e1[1].x - e2[2].x)*(e1[1].x - e2[2].x) + (e1[1].y - e2[2].y)*(e1[1].y - e2[2].y)
        local d2 = (e2[1].x - e1[2].x)*(e2[1].x - e1[2].x) + (e2[1].y - e1[2].y)*(e2[1].y - e1[2].y)
        if d1 < 0.25 and d2 < 0.25 then return true end
    end

    -- Go through all edges and delete all instances of the ones that appear more than once
    local marked_for_deletion = {}
    for i, e1 in ipairs(edges) do
        for j, e2 in ipairs(edges) do
            if isEdgeEqual(e1, e2) then
                table.insert(marked_for_deletion, i)
                table.insert(marked_for_deletion, j)
            end
        end
    end
    marked_for_deletion = self.fg.fn.unique(marked_for_deletion)
    table.sort(marked_for_deletion, function(a, b) return a < b end)
    for i = #marked_for_deletion, 1, -1 do table.remove(edges, marked_for_deletion[i]) end

    local findEdge = function(edge_list, point)
        for i, edge in ipairs(edge_list) do
            local d = (edge[1].x - point.x)*(edge[1].x - point.x) + (edge[1].y - point.y)*(edge[1].y - point.y)
            if d < 0.25 then return i end
        end
    end

    -- Remove extra edges
    local edge_list_size, last_edge_list_size = #edges, 0
    while edge_list_size ~= last_edge_list_size do
        edge_list_size = #edges
        for _, edge in ipairs(edges) do
            local p1 = edge[1]
            local p2 = edge[2]
            local i = findEdge(edges, edge[2])
            local p3 = nil
            if i then 
                p3 = edges[i][2] 
                if math.abs((p1.y - p2.y)*(p1.x - p3.x) - (p1.y - p3.y)*(p1.x - p2.x)) <= 0.025 then
                    edge[2].x, edge[2].y = p3.x, p3.y
                    table.remove(edges, i)
                    break
                end
            end
        end
        last_edge_list_size = #edges
    end

    -- Tag groups
    local function edgeTag(tag, edge)
        edge.tag = tag
        local next_edge = findEdge(edges, edge[2])
        while next_edge and not edges[next_edge].tag do
            edges[next_edge].tag = tag
            next_edge = findEdge(edges, edges[next_edge][2])
        end
    end

    local current_tag = 1
    for _, edge in ipairs(edges) do
        if not edge.tag then
            edgeTag(current_tag, edge)
            current_tag = current_tag + 1
        end
    end

    current_tag = current_tag - 1

    local getTagShape = function(edges, tag)
        local temp_edges = self.fg.fn.select(self.fg.utils.table.copy(edges), function(key, value) return value.tag == tag end)
        local vertices = {}
        local edge = table.remove(temp_edges, 1)
        table.insert(vertices, edge[1].x)
        table.insert(vertices, edge[1].y)
        local next_edge = findEdge(temp_edges, edge[2])
        while next_edge do
            edge = table.remove(temp_edges, next_edge)
            table.insert(vertices, edge[1].x)
            table.insert(vertices, edge[1].y)
            next_edge = findEdge(temp_edges, edge[2])
        end
        if #temp_edges == 0 then return vertices end
    end

    -- Figure out which tags are holes
    local shapes = {}
    for i = 1, current_tag do 
        shapes[i] = getTagShape(edges, i)
    end

    local hole_tags = {}
    for i, s1 in ipairs(shapes) do
        for j, s2 in ipairs(shapes) do
            if i ~= j then
                if self.fg.mlib.polygon.isPolygonInside(s1, s2) then
                    table.insert(hole_tags, j)
                end
            end
        end
    end
    hole_tags = self.fg.fn.unique(hole_tags)

    -- Find zero width points 
    holes = {}
    for i, shape in ipairs(shapes) do
        if self.fg.fn.contains(hole_tags, i) then
            table.insert(holes, {shape = self.fg.utils.table.copy(shape), tag = i})
        end
    end

    all_points = {}
    for i, shape in ipairs(shapes) do
        local points = self.fg.utils.table.copy(shape)
        for j = 1, #points do table.insert(all_points, {point = points[j], tag = i}) end
    end

    local zero_width_points = {}
    for _, shape in ipairs(holes) do
        local min_d, min_i, min_j = 10000, 0, 0
        for i = 1, #shape.shape, 2 do
            for j = 1, #all_points, 2 do
                if all_points[j].tag ~= shape.tag then
                    local d = self.fg.mlib.line.getDistance(shape.shape[i], shape.shape[i+1], all_points[j].point, all_points[j+1].point)
                    if d < min_d then min_d = d; min_i = i; min_j = j end
                end
            end
        end
        table.insert(zero_width_points, {x = shape.shape[min_i], y = shape.shape[min_i+1]})
        table.insert(zero_width_points, {x = all_points[min_j].point, y = all_points[min_j+1].point})
    end

    local getTileValue = function(x, y)
        local i, j = math.floor(y/my)+1, math.floor(x/mx)+1
        return grid[i][j]
    end

    -- Make zero width channels
    local additional_edges = {}
    for i = 1, #zero_width_points, 2 do
        local hole_point = zero_width_points[i]
        local out_point = zero_width_points[i+1]
        local mid_point = {x = (hole_point.x + out_point.x)/2, y = (hole_point.y + out_point.y)/2}
        if getTileValue(mid_point.x, mid_point.y) ~= 0 then
            local out_edge = {self.fg.utils.table.copy(hole_point), self.fg.utils.table.copy(out_point)}
            local in_edge = {self.fg.utils.table.copy(out_point), self.fg.utils.table.copy(hole_point)}
            table.insert(additional_edges, out_edge)
            table.insert(additional_edges, in_edge)
        end
    end
    for _, edge in ipairs(additional_edges) do table.insert(edges, edge) end

    local findEdges = function(edge_list, point)
        local edges = {}
        for i, edge in ipairs(edge_list) do
            local d = (edge[1].x - point.x)*(edge[1].x - point.x) + (edge[1].y - point.y)*(edge[1].y - point.y)
            if d < 0.25 then table.insert(edges, i) end
        end
        return edges
    end

    local isPointEqual = function(p1, p2)
        local d = (p1.x - p2.x)*(p1.x - p2.x) + (p1.y - p2.y)*(p1.y - p2.y)
        if d < 0.25 then return true end
    end

    -- Define shape's vertices from edges 
    local vertices = {}
    local edge = edges[1]
    local shape_n = 1
    local i = 1
    while #edges > 0 do
        vertices[shape_n] = {}
        i = 1
        local edge, next_edge, ne_ids = nil, nil, nil
        repeat
            edge = edges[i]
            table.insert(vertices[shape_n], edge[1].x)
            table.insert(vertices[shape_n], edge[1].y)
            table.remove(edges, i)
            ne_ids = findEdges(edges, edge[2])
            local found = false
            for _, id in ipairs(ne_ids) do
                if not isPointEqual(edges[id][2], edge[1]) and not edges[id].tag then
                    i = id
                    found = true
                    break
                end
            end
            if not found then
                for _, id in ipairs(ne_ids) do
                    if not isPointEqual(edges[id][2], edge[1]) and edges[id].tag then
                        i = id
                        break
                    end
                end
            end
        until #ne_ids <= 0
        shape_n = shape_n + 1
    end

    -- Create solids
    for _, v in ipairs(vertices) do
        local vs = {}
        for i = 1, #v do table.insert(vs, v[i]) end
        if #vs >= 6 then
            self:createEntity('Solid', tilemap.x - tilemap.w/2, tilemap.y - tilemap.h/2, {body_type = 'static', shape = 'chain', loop = true, vertices = vs})
        end
    end
end

return Tilemap
