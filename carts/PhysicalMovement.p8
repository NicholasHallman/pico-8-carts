pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

left,right,up,down,fire1,fire2=0,1,2,3,4,5
black,dark_blue,dark_purple,dark_green,brown,dark_gray,light_gray,white,red,orange,yellow,green,blue,indigo,pink,peach=0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15

world = {
    gravity = 1;
}

player = {
    x = 128 / 2;
    y = 128 / 2;
    xforce = 0;
    yforce = 0;
    jumped = false;
    speed = 0.5;
    maxspeed = 3;
    currentframe = 1;
    walkanimation = {
        firstframe = 2;
        length = 5;
    };
    direction = 6;
    move = function(self)
        if(btn(left)) then 
            self.xforce += self.speed * -1 
            if(self.xforce < self.maxspeed * -1) then self.xforce = self.maxspeed * -1 end
        end
        if(btn(right)) then 
            self.xforce += self.speed 
            if(self.xforce > self.maxspeed) then self.xforce = self.maxspeed end
        end
        if(not btn(right) and not btn(left)) then
            if(self.xforce > 0) then 
                if(self.jumped) then 
                    self.xforce -= 0.1;
                else 
                    self.xforce -= 0.5;
                end 
            end
            if(self.xforce < 0) then 
                if(self.jumped) then 
                    self.xforce += 0.1;
                else 
                    self.xforce += 0.5;
                end 
            end
        end
        if(btn(fire1) and not self.jumped) then 
            self.yforce = -8
            self.jumped = true
        end
        if(self.xforce < 0.1 and self.xforce > -0.1) then
            self.xforce = 0
        end
        if(self.yforce < 0.1 and self.yforce > -0.1) then
            self.yforce = 0
        end
        self.x += self.xforce
        self.y += self.yforce
        if(self.y > 120) then 
            self.y = 120 
            self.yforce = 0
            self.jumped = false
        end
        self.yforce += world.gravity
    end;
    draw = function(self) 
        if(self.direction == right or self.direction == left) then
            self.currentframe += 1
        end
        if(self.currentframe > player.walkanimation.firstframe + player.walkanimation.length) then
            self.currentframe = player.walkanimation.firstframe
        end

    end;
}

function _update()
    player:move()
end

function _draw()
    rectfill(0,0,128,128,red)
    player:draw()
    
    
end
__gfx__
00000000000440000004400000044000000440000004400000044000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000ffff0000ffff0000ffff0000ffff0000ffff0000ffff00000000000000000000000000000000000000000000000000000000000000000000000000
0000000000f3f30000f3f30000f3f30000f3f30000f3f30000f3f300000000000000000000000000000000000000000000000000000000000000000000000000
0000000000ffff0000ffff0000ffff0000ffff0000ffff0000ffff00000000000000000000000000000000000000000000000000000000000000000000000000
000000000011111000111110001111100f11111f0f11111f00111110000000000000000000000000000000000000000000000000000000000000000000000000
000000000f11111f0f11111f0f11111f00111110001111100f11111f000000000000000000000000000000000000000000000000000000000000000000000000
00000000005005000050050005505000005550000005550000500500000000000000000000000000000000000000000000000000000000000000000000000000
00000000005005000050050000005000000500000050000000500050000000000000000000000000000000000000000000000000000000000000000000000000
