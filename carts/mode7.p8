pico-8 cartridge // http://www.pico-8.com
version 27
__lua__

left,right,up,down,fire1,fire2=0,1,2,3,4,5
black,dark_blue,dark_purple,dark_green,brown,dark_gray,light_gray,white,red,orange,yellow,green,blue,indigo,pink,peach=0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15

player = {
    x = 0;
    y = 0;
    direction = up;
}

function _init()
    
end

function _update60()
    if(btn(up)) then 
        player.y -= 1 
        player.direction = up
    end
    if(btn(down)) then 
        player.y += 1 
        player.direction = down
    end
    if(btn(left)) then 
        player.x -= 1
        player.direction = left 
    end
    if(btn(right)) then 
        player.x += 1 
        player.direction = right
    end
end

function _draw()
    cls(black)
    drawMap()
    drawPlayer()
end

function drawPlayer()
    if(player.direction == up or player.direction == down) then
        spr(5,64,64)
    else 
        turn = false
        if(player.direction == left) then
            turn = true
        end
        spr(5 + 16, 64, 64, 1, 1, turn, false)
        
    end
end

-- ------------------------ -- (0,0,128,0)
-- ------------------------ -- (0,1,128,1)

function drawMap()
    for screeny=0,100 do
        diffy = 128 - screeny
        t = {
            x1 = 0;
            x2 = 128;
            y1 = diffy;
            y2 = diffy;
            mx = ((player.x / 8) + 64);
            my = (((diffy + player.y) / 8) + 32);
            mdx = (1 / 8) ;
            mdy = 0;
        }
        tline(t.x1, t.y1, t.x2, t.y2, t.mx, t.my, t.mdx, t.mdy)        
    end
end

__gfx__
00000000111111115555555500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000111111115555555500000000000000000044440000444400004444000044440000000000000000000000000000000000000000000000000000000000
00000000111111115555555500000000000000000044440000444400004444000044440000000000000000000000000000000000000000000000000000000000
0000000011111111555555550000000000000000004444000f44440000444400004444f000000000000000000000000000000000000000000000000000000000
00000000111111115555555500000000000000000f8888f0008888000f8888f00088880000000000000000000000000000000000000000000000000000000000
000000001111111155555555000000000000000000eeee0000eeeef000eeee000feeee0000000000000000000000000000000000000000000000000000000000
00000000111111115555555500000000000000000090090000e000000090090000000e0000000000000000000000000000000000000000000000000000000000
00000000111111115555555500000000000000000000000000900000000000000000090000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000044440000444400004444000044440000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000004fff00004fff00004fff00004fff0000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000004fff00004ffff0004fff00004fff0000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000088880000888800008888000f888f0000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000efee0000feee9000efee0000eeee0000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000090090009000000009009000000900000000000000000000000000000000000000000000000000000000000
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
20202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020
20202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020
20101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010
20101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010
20101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010
20101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010
20101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010
20101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010
20101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010
20101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010
20101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010
20101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010
20101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010
20101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010
20101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010
20101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010
20202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020
20202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020
20101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010
20101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010
20101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010
20101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010
20101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010
20101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010
20101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010
20101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010
20101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010
20101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010
20101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010
20101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010
20101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010
20101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010
20202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020
20202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020
20101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010
20101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010
20101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010
20101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010
20101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010
20101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010
20101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010
20101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010
20101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010
20101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010
20101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010
20101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010
20101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010
20101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010
20202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020
20202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020
20101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010
20101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010
20101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010
20101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010
20101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010
20101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010
20101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010
20101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010
20101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010
20101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010
20101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010
20101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010
20101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010
20101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010
__map__
0202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202
0201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101
0201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101
0201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101
0201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101
0201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101
0201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101
0201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101
0202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202
0201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101
0201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101
0201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101
0201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101
0201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101
0201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101
0201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101
0202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202
0201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101
0201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101
0201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101
0201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101
0201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101
0201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101
0201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101
0202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202
0201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101
0201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101
0201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101
0201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101
0201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101
0201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101
0201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101020101010101010102010101010101010201010101010101
