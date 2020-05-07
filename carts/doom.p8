pico-8 cartridge // http://www.pico-8.com
version 16
__lua__

left,right,up,down,fire1,fire2=0,1,2,3,4,5
black,dark_blue,dark_purple,dark_green,brown,dark_gray,light_gray,white,red,orange,yellow,green,blue,indigo,pink,peach=0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15

room = {
    {x1 = 128/4; y1 = 128/4; x2 = 128/4 * 3; y2 = 128/4};
}

player = {
    x = 64;
    y = 64;
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

        --printh('x1z1 (' .. r.x1 .. ', ' .. r.z1 .. ')' .. ' x2z2 (' .. r.x2 .. ', ' .. r.z2 .. ')')
        if(r.z1 > 0.1 or r.z2 > 0.1 ) then
            if(r.z1 < 0.1 and r.z2 > 0.1) then 
                nr = intersect(r.x1, r.z1, r.x2, r.z2, 0.1, 0.1, 100, 100)
                printh('('..nr.x..','..nr.z..')')
                r.x1 = nr.x
                r.z1 = nr.z
            end
            if(r.z1 > 0.1 and r.z2 < 0.1) then 
                nr = intersect(r.x1, r.z1, r.x2, r.z2, -0.1, 0.1, -100, 100)
                printh('('..nr.x..','..nr.z..')')
                r.x2 = nr.x
                r.z2 = nr.z
            end
            p = {}

            p.x1 = 16 * r.x1 / r.z1 * -1
            p.x2 = 16 * r.x2 / r.z2 * -1

            p.t1 = (64 / r.z1 * -1)
            p.t2 = (64 / r.z2 * -1)

            p.b1 = ((-1 * 64) / r.z1 * -1)
            p.b2 = ((-1 * 64) / r.z2 * -1)


            line(p.x1 + 64, p.t1 + 64, p.x2 + 64, p.t2 + 64, white)
            line(p.x1 + 64, p.b1 + 64, p.x2 + 64, p.b2 + 64, white)

            line(p.x1 + 64, p.t1 + 64, p.x1 + 64, p.b1 + 64, white)
            line(p.x2 + 64, p.t2 + 64, p.x2 + 64, p.b2 + 64, white)
        end
    end
end



function intersect(x1,y1,x2,y2,x3,y3,x4,y4)
    i = {}
    i.x = ((((x1 * y2) - (y1 * x2)) * (x3 - x4)) - ((x1 - x2) * ((x3 * y4) - (y3 * x4)))) / (((x1 - x2) * (y3 - y4)) - ((y1 - y2) * (x3 - x4)))
    i.z = ((((x1 * y2) - (y1 * x2)) * (y3 - y4)) - ((y1 - y2) * ((x3 * y4) - (y3 * x4)))) / (((x1 - x2) * (y3 - y4)) - ((y1 - y2) * (x3 - x4)))
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
