pico-8 cartridge // http://www.pico-8.com
version 16
__lua__

left,right,up,down,fire1,fire2=0,1,2,3,4,5
black,dark_blue,dark_purple,dark_green,brown,dark_gray,light_gray,white,red,orange,yellow,green,blue,indigo,pink,peach=0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15

room = {
    {x1 = 350; y1 = 350; x2 = 350; y2 = 450; c = blue};
    {x1 = 450; y1 = 350; x2 = 350; y2 = 350; c = yellow};
    {x1 = 350; y1 = 450; x2 = 450; y2 = 450; c = red};
    {x1 = 450; y1 = 450; x2 = 450; y2 = 350; c = green};
}

player = {
    x = 400;
    y = 400;
    dir = 180;
    angle = function (self) 
        return (self.dir % 360)/360 
    end;
}

function _init()
    
end

function _update60()
    if(btn(up)) then 
        player.y += cos(player:angle())
        player.x += sin(player:angle())
    end
    if(btn(down)) then 
        player.y -= cos(player:angle())
        player.x -= sin(player:angle())
    end
    if(btn(left)) then 
        player.dir += 1
    end
    if(btn(right)) then 
        player.dir -= 1
    end
end

function _draw()
    cls(black)
    troom = {}
    buffer = {}
    -- transform the walls relative to the player
    for wall in all(room) do
        -- transform model co-ordinates to world co-ordinates
        w = clone(wall)
        w.x1 -= player.x
        w.x2 -= player.x
        w.y1 -= player.y
        w.y2 -= player.y

        r = {}
        -- y become z because it si how far away the object is from the player
        r.x1 = (cos(player:angle()) * w.x1) - (sin(player:angle()) * w.y1)  
        r.z1 = (sin(player:angle()) * w.x1) + (cos(player:angle()) * w.y1)  

        r.x2 = (cos(player:angle()) * w.x2) - (sin(player:angle()) * w.y2)  
        r.z2 = (sin(player:angle()) * w.x2) + (cos(player:angle()) * w.y2) 

        r.c = wall.c

        troom[#troom + 1] = r

        line(r.x1 + 64, r.z1 + 64, r.x2 + 64, r.z2 + 64, wall.c)
        printh('x1z1 (' .. r.x1 .. ', ' .. r.z1 .. ')' .. ' x2z2 (' .. r.x2 .. ', ' .. r.z2 .. ')')
        line(0 + 64, 0 + 64, 0 + 64 + ((128 - 64) * 5), 500, white)
        line(0 + 64, 0 + 64, 0 + 64 + ((1 - 64) * 5), 500, white)
    end
    -- raycast
    for pixel=1,128 do
        angle = ((pixel) - 64) * 5
        ray = {slope = 500 / angle, intercept = 0}
        buffer[pixel] = {empty=true; depth=500; color=black;}
        for wall in all(troom) do
            -- y = mx + b
            slope = (wall.z2 - wall.z1) / (wall.x2 - wall.x1)
            w = {slope = slope; intercept = wall.z1 - (slope * wall.x1) }
            x = (ray.intercept - w.intercept) / (w.slope - ray.slope)
            p = {x = x; z = w.slope * x - w.intercept}
            
            if(p.x > wall.x1 and p.x < wall.x2) then
                distance = p.z * -1
                if(distance > 0.1 and distance < buffer[pixel].depth) then 
                    if(pixel == 128) then 
                        print(distance)
                    end
                    buffer[pixel].depth = distance 
                    buffer[pixel].color = wall.c
                    buffer[pixel].empty = false
                end
            end
        end
        if(buffer[pixel].depth > 500) then buffer[pixel].depth = 0; buffer[pixel].empty = true; end
        if(not buffer[pixel].empty) then
            height = 128 / sqrt(buffer[pixel].depth)
            line(pixel, (128 - height) / 2, pixel, ((128 - height) / 2) + height, buffer[pixel].color)
        end
        
    end
end

function cross_product(a, b, c, d)
    return (a * d) - (c * b)
end


function intersect(x1,y1,x2,y2,x3,y3,x4,y4)
    i = {}
    i.x = cross_product(cross_product(x1, y1, x2, y2), cross_product(x1, 1, x2, 1), cross_product(x3, y3, x4, y4), cross_product(x3, 1, x4, 1)) / cross_product(cross_product(x1, 1, x2, 1), cross_product(y1, 1, y2, 1), cross_product(x3, 1, x4, 1), cross_product(y3, 1, y4, 1))
    i.z = cross_product(cross_product(x1, y1, x2, y2), cross_product(y1, 1, y2, 1), cross_product(x3, y3, x4, y4), cross_product(y3, 1, y4, 1)) / cross_product(cross_product(x1, 1, x2, 1), cross_product(y1, 1, y2, 1), cross_product(x3, 1, x4, 1), cross_product(y3, 1, y4, 1))
    return i
end

function clone(points)
    a = {}
    a.x1 = points.x1
    a.x2 = points.x2
    a.y1 = points.y1
    a.y2 = points.y2
    return a
end

__gfx__
bbbbbbbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bbbbbbbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bbbbbbbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bbbbbbbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bbbbbbbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bbbbbbbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bbbbbbbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bbbbbbbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000