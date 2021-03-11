pico-8 cartridge // http://www.pico-8.com
version 16
__lua__

left,right,up,down,fire1,fire2=0,1,2,3,4,5
black,dark_blue,dark_purple,dark_green,brown,dark_gray,light_gray,white,red,orange,yellow,green,blue,indigo,pink,peach=0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15

camera = { 
    pos = {0, 0, 0, 1},
    dir = {0, 0, 1, 1}
}

line_count = 0


function v_minus_v(v1, v2)
    return { 
        v1[1] - v2[1], 
        v1[2] - v2[2], 
        v1[3] - v2[3], 
        1
    }
end

function cross(v1, v2)
    return {
        (v1[2] * v2[3]) - (v1[3] * v2[2]),
        (v1[3] * v2[1]) - (v1[1] * v2[3]),
        (v1[1] * v2[2]) - (v1[2] * v2[1]),
        1
    }
end

function dot(v1,v2)
    return (v1[1] * v2[1]) + (v1[2] * v2[2]) + (v1[3] * v2[3]) 
end

function normalize(v)
    d = sqrt((v[1]^2) + (v[2]^2) + (v[3]^2))
    return {
        v[1]/d,
        v[2]/d,
        v[3]/d,
        1
    }
end

function s_x_v(s, v)
    return {
        s * v[1],
        s * v[2],
        s * v[3],
        1
    }
end

function v_x_m(v, m)
    result = {}
    i = 1
    for row in all(m) do
        result[i] = (row[1] * v[1]) + (row[2] * v[2]) + (row[3] * v[3]) + (row[4] * v[4]) 
        i += 1;
    end

    return result
end 

function m_x_m(m1, m2)
    result = {} 
    for i=1,#m1 do
        row = {}
        for j = 1,#m1 do
            value = 0
            for k = 1,#m1 do
                row_elm = m1[i][k]
                colm_elm = m2[k][j]
                value += row_elm * colm_elm
            end
            row[#row+1] = value
        end
        result[#result+1] = row
    end
    return result
end

function get_scale_m(scale)
    return {
        {scale[1], 0, 0, 0},
        {0, scale[2], 0, 0},
        {0, 0, scale[3], 0},
        {0, 0, 0, 1},
    }
end

function get_trans_m(pos) 
    return {
        {1, 0, 0, pos[1]},
        {0, 1, 0, pos[2]},
        {0, 0, 1, pos[3]},
        {0, 0, 0, 1},
    }
end

function make_rot_m(deg, axis)
    if axis == 'x' then
        return {
            {1, 0, 0, 0},
            {0, cos(deg), -sin(deg), 0},
            {0, sin(deg), cos(deg), 0},
            {0, 0, 0, 1},
        }
    elseif axis == 'y' then
        return {
            {cos(deg), 0, sin(deg), 0},
            {0, 1, 0, 0},
            {-sin(deg), 0, cos(deg), 0},
            {0, 0, 0, 1},
        }
    elseif axis == 'z' then
         return {
            {cos(deg), -sin(deg), 0, 0},
            {sin(deg), cos(deg), 0, 0},
            {0, 0, 1, 0},
            {0, 0, 0, 1},
        }
    end
end

function get_rot_m(rot) 
    xm = make_rot_m(rot[1], 'x')
    ym = make_rot_m(rot[2], 'y')
    zm = make_rot_m(rot[3], 'z')

    return m_x_m( m_x_m(zm, ym), xm)
end

function get_view_m()
    -- get the rotation matrix
    r = get_rot_m(camera.dir)
    t = get_trans_m(camera.pos)
    -- apply the cameras position
    return m_x_m(r, t)
end

function get_model_m(pos, rot, scale)
    r = get_rot_m(rot)
    t = get_trans_m(pos)
    s = get_scale_m(scale)
    
    return m_x_m(m_x_m(t, s), r)
end

function make_cube(pos, color) 
    return {
        points = {
            {5, 5, 5, 1},
            {5, 5, -5, 1},
            {-5, 5, -5, 1},
            {-5, 5, 5, 1},
            {5, -5, 5, 1},
            {5, -5, -5, 1},
            {-5, -5, -5, 1},
            {-5, -5, 5, 1}
        },
        order = {
            1,2,3,
            3,4,1,
            1,5,6,
            6,2,1,
            2,6,7,
            7,3,2,
            3,7,8,
            8,4,3,
            7,8,5,
            5,6,7,
            4,1,5,
            5,8,4
        },
        pos = pos,
        scale = {1, 1, 1},
        rot = {0, 0, 0},
        color = color
    }
end

objects = {}

time = 0

function _init() 
    objects[#objects+1] = make_cube({0, 0, 20}, blue)
end

function print_m(m)
    printh(" ===== MATRIX ===== ")
    printh("| " .. m[1][1] .. " " .. m[1][2] .. " " .. m[1][3] .. " " .. m[1][4] .. " |")
    printh("| " .. m[2][1] .. " " .. m[2][2] .. " " .. m[2][3] .. " " .. m[2][4] .. " |")
    printh("| " .. m[3][1] .. " " .. m[3][2] .. " " .. m[3][3] .. " " .. m[3][4] .. " |")
    printh("| " .. m[4][1] .. " " .. m[4][2] .. " " .. m[4][3] .. " " .. m[4][4] .. " |")
end

function v_to_string(v)
    return "| " .. v[1] .. " " .. v[2] .. " " .. v[3] .. " |"
end

function l_to_string(l)
    return "(" .. l[1][1].. ", " .. l[1][2] .. ", " .. l[2][1] .. ", " .. l[2][2] .. ")"
end

function _update()
    if btn(up) then 
        camera.pos[3] -= cos(camera.dir[2]) * 0.5
        camera.pos[1] += sin(camera.dir[2]) * 0.5
    end
    if btn(down) then 
        camera.pos[3] += cos(camera.dir[2]) * 0.5
        camera.pos[1] -= sin(camera.dir[2]) * 0.5
    end

    if btn(left) then 
        camera.dir[2] -= 0.01 
        if(camera.dir[2]) < 0 then camera.dir[2] = 1 end
    end
    if btn(right) then 
        camera.dir[2] += 0.01 
        if(camera.dir[2]) > 1 then camera.dir[2] = 0 end
    end
end

function copy_point(p)
    local n
    n = {}
    for i,v in pairs(p) do
        n[i] = v
    end
    return n
end

function purge_nil(table)
    copy = {}
    for v in all(table) do
        if v != nil then copy[#copy+1] = v end
    end
    return copy
end

function project(line)
    p1 = line[1]
    p2 = line[2]

    f1 = {p1[1],p1[2],p1[3]}
    f2 = {p2[1],p2[2],p2[3]}

    p1z = p1[3]
    p2z = p2[3]

    if p1z == 0 then p1z = 0.001 end
    if p2z == 0 then p2z = 0.001 end

    if (p1[3] < 0.1 and p2[3] < 0.1) then
        return nil 
    elseif (p1[3] < 0.1 and p2[3] > 0.1) then
        t = (0.1 - p1[3]) / p2z
        f1[1] = p1[1] + (t * p2[1])
        f1[2] = p1[2] + (t * p2[2])
        f1[3] = 0.1
    elseif (p2[3] < 0.1 and p1[3] > 0.1) then
        t = (0.1 - p2[3]) / p1z
        f2[1] = p2[1] + (t * p1[1])
        f2[2] = p2[2] + (t * p1[2])
        f2[3] = 0.1
    end
    -- projection
    t1 = {}
    t2 = {}

    t1[1] = ceil((f1[1] / (f1[3] / 64)) + 64)
    t1[2] = ceil((f1[2] / (f1[3] / 64)) + 64)
    t1[3] = ceil(f1[3])

    t2[1] = ceil((f2[1] / (f2[3] / 64)) + 64)
    t2[2] = ceil((f2[2] / (f2[3] / 64)) + 64)
    t2[3] = ceil(f2[3])
    return {t1,t2}
end

function draw_line(p1, p2, color)
    -- frustrum culling
    t = project({p1,p2})
    if t == nil then return end
    t1 = { t[1][1], t[1][2], t[1][3] }
    t2 = { t[2][1], t[2][2], t[2][3] }

    line_count += 1
    line(t1[1], t1[2], t2[1], t2[2], color)
end

function draw_debug()
    print('cpu: ' .. (stat(1) * 100) .. "%",0,0,white)
end

function find_max_min(values)
    max = 0
    min = 128
    if #values == 0 then return {0,0} end
    for v in all(values) do
        if v != nil and v > max then
            max = v
        end
        if v != nil and v < min then
            min = v
        end
    end
    return { max, min }
end

function get_normal(p1, p2, p3)
    local u
    local v
    u = v_minus_v(p1, p2)
    v = v_minus_v(p1, p3)
    return normalize(cross(u, v))
end

function x_intercept(y, l)
    if l == nil then return nil end
    p1 = l[1]
    p2 = l[2]

    x1 = l[1][1]
    y1 = l[1][2]

    x2 = l[2][1]
    y2 = l[2][2]

    rise = y2 - y1
    run = x2 - x1
    if run == 0 then run = 1 end

    m = rise / run;
    b = - (m * x2) + y2
    x = ceil((y - b) / m)
    if (x >= x1 and x <= x2) or (x <= x1 and x >= x2) then
        return x
    end
    return nil
end

function draw_face(object)
    order = object.order
    object.rot[1] = time
    vm = m_x_m(get_view_m(), get_model_m(object.pos, object.rot, object.scale))
    for o=1,#order,3 do
        -- in local space get the intersections
        local p1
        local p2
        local p3
        local lines
        local y_lines

        p1 = v_x_m(object.points[order[o]], vm)
        p2 = v_x_m(object.points[order[o+1]], vm)
        p3 = v_x_m(object.points[order[o+2]], vm)

        n = get_normal(p1, p2, p3)
        c = normalize(camera.dir)
        a = dot(c, n)

        -- printh('n ' .. v_to_string(n))
        if a >= 0 then return end

        lines = purge_nil({
            project({p1,p2}),
            project({p2,p3}),
            project({p3,p1})
        })
        if #lines > 0 then 
            y_lines = {}
            for line in all(lines) do
                -- printh('===== lines =====')
                -- printh('line: ' .. v_to_string(line[1]))
                -- printh('line: ' .. v_to_string(line[2]))
                y_lines[#y_lines+1] = line[1][2]
                y_lines[#y_lines+1] = line[2][2]
            end
            y_max_min = find_max_min(y_lines)
            if y_max_min[1] > 128 then y_max_min[1] = 128 end
            if y_max_min[2] < 0 then y_max_min[2] = 0 end
            -- from the min to the max
            for y=y_max_min[2],y_max_min[1] do
                intercepts = {}
                for line in all(lines) do
                    intercepts[#intercepts+1] = x_intercept(y, line)
                end
                x_max_min = find_max_min(intercepts)
                if x_max_min[1] > 128 then x_max_min[1] = 128 end
                if x_max_min[2] < 0 then x_max_min[2] = 0 end

                line_count += 1
                line(x_max_min[2], y, x_max_min[1], y, white)
            end
        end
    end
end

function _draw() 
    cls(black)
    
    time -= 0.005
    if time < 0 then time = 1 end

    for object in all(objects) do
        draw_face(object)
    end

    -- draw a wireframe
    for object in all(objects) do
        order = object.order
        vm = m_x_m(get_view_m(), get_model_m(object.pos, object.rot, object.scale))
        for o=1,#order,3 do
            -- a triangle
            local p1
            local p2
            local p3
            p1 = v_x_m(object.points[order[o]], vm)
            p2 = v_x_m(object.points[order[o+1]], vm)
            p3 = v_x_m(object.points[order[o+2]], vm)
            
            draw_line(p1,p2,object.color)
            draw_line(p2,p3,object.color)
            draw_line(p3,p1,object.color)
        end
    end

    printh('lines drawn: ' .. line_count)
    line_count = 0
    
    draw_debug()
end