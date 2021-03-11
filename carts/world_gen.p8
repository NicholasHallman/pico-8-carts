pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

left,right,up,down,fire1,fire2=0,1,2,3,4,5
black,dark_blue,dark_purple,dark_green,brown,dark_gray,light_gray,white,red,orange,yellow,green,blue,indigo,pink,peach=0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15

world = {
    width = 50;
    height = 50
}

points = {}

peeks = {}


function ispeak()
    return flr(rnd(50) + 0.5) == 1
end

function getpoints()
    for y=0,16 do
        points[y] = {}
        for x=0,16 do
            point = randompoint()
            point.x = x * 8 + point.x
            point.y = y * 8 + point.y
            point.c = blue
            points[y][x] = point;
        end
    end
end

function assign_peeks()
    for i=0,4 do
        point = {x = flr(rnd(15) + 0.5), y = flr(rnd(15) + 0.5)}
        dx = flr(rnd(2) + 0.5) - 1
        dy = flr(rnd(2) + 0.5) - 1
        for j=0,3 do
            mod = {}
            mod.x = (point.x + (dx)) % 16
            mod.y = (point.y + (dy)) % 16
            peeks[j + (i * 3)] = mod
            dx = flr(rnd(2) + 0.5) - 1
            dy = flr(rnd(2) + 0.5) - 1
        end
    end
end

function assign_sand()
    for peek in all(peeks) do
        for y=-2,2 do
            for x=-2,2 do
                d_x = (peek.x - x) % 16
                d_y = (peek.y - y) % 16
                points[d_y][d_x].c = peach
            end
        end
    end
end

function assign_grass()
    for peek in all(peeks) do
        for y=-1,1 do
            for x=-1,1 do
                d_x = (peek.x - x) % 16
                d_y = (peek.y - y) % 16
                points[d_y][d_x].c = dark_green
            end
        end
    end
end

function assign_mountain()
    for peek in all(peeks) do
        points[peek.y][peek.x].c = light_gray
    end
end

function assign_colors()
    assign_sand()
    assign_grass()
    assign_mountain()
end

function randompoint()
    return {
        x = flr(rnd(6)+0.5) + 1;
        y = flr(rnd(6)+0.5) + 1;
    }
end

function drawpoint(point)
    rect(point.x, point.y, point.x, point.y, white);
end

function drawpoints()
    for y=0,16 do
        for x=0,16 do
            drawpoint(points[y][x])
        end
    end
end

getpoints()

function _init()
    assign_peeks()
    assign_colors()
    drawpixels()
end

x = 0;
y = 0;

function _update60()

end

function _draw()
    drawpoints()
end

function drawgrid()
    for pos=0,16 do
        line(pos * 8,0,pos * 8,128,blue);
        line(0,pos * 8,128,pos * 8,blue);
    end
end

function drawpixels()
    for py=0,128 do
        for px=0,128 do
           drawpixel(px, py) 
        end
    end
end

function drawpixel(px, py) 
    pointx = flr(px / 8) % 16;
    pointy = flr(py / 8) % 16;


    left = pointx - 1 % 16;
    right = pointx + 1 % 16;
    up = pointy - 1 % 16;
    down = pointy + 1 % 16;

    if(left < 0) then
        left = 15
    end 
    if(up < 0) then
        up = 15
    end

    point = points[pointy][pointx]
    point_up = points[up][pointx]
    point_down = points[down][pointx]
    point_left = points[pointy][left]
    point_right = points[pointy][right]

    point_up_left = points[up][left]
    point_down_left = points[down][left]
    point_up_right = points[up][right]
    point_down_right = points[down][right]

    distances = {
        distance(point, {x = px; y = py}),
        distance(point_up, {x = px; y = py}),
        distance(point_down, {x = px; y = py}),
        distance(point_left, {x = px; y = py}),
        distance(point_right, {x = px; y = py}),

        distance(point_up_left, {x = px; y = py}),
        distance(point_down_left, {x = px; y = py}),
        distance(point_up_right, {x = px; y = py}),
        distance(point_down_right, {x = px; y = py}),

    }
    min = {d = 100; c = black}
    for dist in all(distances) do
        if(dist.d < min.d) then
            min = dist
        end
    end

    rect(px,py,px,py,min.c)
end

function distance(p1, p2) 
    dist = sqrt(( (p2.x - p1.x) ^ 2) + ( (p2.y - p1.y) ^ 2))
    return {d = dist; c = p1.c};
end

function drawmap()
    start = 0x6000;
    for y=0,129 do
        for x=0,64 do
            place = x + (y * 63);
            poke(start + place, 0x0052);
        end
    end
end