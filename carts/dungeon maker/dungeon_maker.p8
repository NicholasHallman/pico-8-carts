pico-8 cartridge // http://www.pico-8.com
version 29
__lua__

left,right,up,down,fire1,fire2=0,1,2,3,4,5
black,dark_blue,dark_purple,dark_green,brown,dark_gray,light_gray,white,red,orange,yellow,green,blue,indigo,pink,peach=0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15

title = "title"
pick_dice = "pick_dice"
roll = "roll_dice"
pre_place = "pre_place_dice"
place = "place_dice"

enter_room = "enter_room"
roll_encounter = "roll_encounter"
encounter = "run_encounter"
pick_next_room = "pick_next"

game_over = "gameover"

game = {
    state = "pick_dice",
    num_dice = 5,
    dice = {},
    cursor = {
        pos = {0,0},
        holding = nil
    },
    in_select = true
}

function normalise(p) 
    n = sqrt((p[1] ^ 2) + (p[2] ^ 2))
    return {
        p[1] / n,
        p[2] / n
    }
end

function _init()
    game.rooms = {}
    for i=1,8 do
        game.rooms[i] = {}
        for j=1,8 do
            game.rooms[i][j] = 0
        end
    end
end

-- ========= UPDATE =========

function update_dice_count()
    if btnp(❎) then 
        game.state = roll
        dice = {}
        for i=1,game.num_dice do
            dice[i] = {
                value = flr((rnd(5) + 1)+0.5),
                dir = { rnd(2) -1, rnd(2) -1 },
                x = rnd(112) + 8,
                y = rnd(112) + 8,
                momentum = 5,
                rot = 0
            }
            dice[i].dir = normalise(dice[i].dir)
        end
        game.dice = dice
        return
    end

    if btnp(up) then game.num_dice += 1 end
    if btnp(down) then game.num_dice -= 1 end

    if game.num_dice < 1 then game.num_dice = 1 end
    if game.num_dice > 20 then game.num_dice = 20 end
end

function update_roll()
    count = 0
    for dice in all(game.dice) do
        if dice.momentum > 0.2 then 
            -- check if the dice hit a wall
            if dice.x > 120 or dice.x < 0 then
                if dice.x > 120 then dice.x = 119 end
                if dice.x < 0 then dice.x = 1 end
                dice.value = flr((rnd(5) + 1)+0.5)
                dice.dir[1] *= -1
            end
            if dice.y > 120 or dice.y < 0 then 
                if dice.y > 120 then dice.y = 119 end
                if dice.y < 0 then dice.y = 1 end
                dice.value = flr((rnd(5) + 1)+0.5)
                dice.dir[2] *= -1
            end
            -- check if the die hit another die
            for other_dice in all(game.dice) do
                if other_dice.x != dice.x and other_dice.y != dice.y then 
                    x_prime = abs(other_dice.x - dice.x)
                    y_prime = abs(other_dice.y - dice.y)

                    if x_prime < 8 and y_prime < 8 then
                        dice.value = flr((rnd(5) + 1)+0.5)
                        if y_prime < x_prime then
                            dice.dir[1] *= -1
                        else 
                            dice.dir[2] *= -1
                        end
                    end
                end
            end
            dice.momentum -= (dice.momentum / 40)

            -- move the dice
            dice.x += dice.dir[1] * dice.momentum;
            dice.y += dice.dir[2] * dice.momentum;

        else
            count += 1
        end
    end
    if count == #game.dice then
        game.state = pre_place
    end
end

function update_pre_place()
    count = 0
    for i, dice in pairs(game.dice) do
        destination = { (9 * (i - 1)) , 120 } 
        if dice.x != destination[1] and dice.y != destination[2] then 
            if dice.x != destination[1] then
                dir = normalise({destination[1] - dice.x, destination[2] - dice.y})
                dice.x += dir[1]
                dice.y += dir[2]
            end
        else
            count += 1
        end
        if abs(dice.x - destination[1]) < 2 and abs(dice.y - destination[2]) < 2 then
            dice.x = destination[1]
            dice.y = destination[2]
        end
    end
    if count == #game.dice then
        game.state = place
        game.cursor.pos = {0, 120}
    end
end

function check_adj(i, j, value)
    if i > 1 then 
    game.rooms[i][j]
end

function update_place()
    grid_range = {33,97}
    -- selecting a die
    if game.in_select then
        if btnp(left) and game.cursor.pos[1] - 9 >= 0 then game.cursor.pos[1] -= 9 end
        if btnp(right) and game.cursor.pos[1] + 9 <= 128 then game.cursor.pos[1] += 9 end

        if btnp(up) then
            game.in_select = false
            game.cursor.pos = {grid_range[1], grid_range[2]-8}
        end
        if btnp(down) then
            game.in_select = false
            game.cursor.pos = {grid_range[1], grid_range[1]}
        end

        if btnp(❎) then
            for dice in all(game.dice) do
                if dice.x == game.cursor.pos[1] then
                    game.cursor.holding = dice
                    break;
                end
            end
        end
    elseif not game.in_select then
        if btnp(left) then game.cursor.pos[1] -= 8 end
        if btnp(right) then game.cursor.pos[1] += 8 end
        if btnp(up) then game.cursor.pos[2] -= 8 end
        if btnp(down) then game.cursor.pos[2] += 8 end

        if game.cursor.pos[1] < grid_range[1] then game.cursor.pos[1] = grid_range[1] end
        if game.cursor.pos[2] < grid_range[1] then 
            game.cursor.pos = {0, 120}
            game.in_select = true
        end
        if game.cursor.pos[1] >= grid_range[2] then game.cursor.pos[1] = grid_range[2] - 8 end
        if game.cursor.pos[2] >= grid_range[2] then 
            game.cursor.pos = {0, 120}
            game.in_select = true
        end

        if btnp(❎) then
            dice_value = game.cursor.holding.value
            game.cursor.holding.x = game.cursor.pos[1]
            game.cursor.holding.y = game.cursor.pos[2]
            i = ((game.cursor.pos[1] - grid_range[1]) / 8) + 1
            j = ((game.cursor.pos[2] - grid_range[1]) / 8) + 1
            printh('i: ' .. i .. ' j: ' .. j)
            if game.rooms[i][j] == 0 then
                check_adj(i,j)
                game.rooms[i][j] = dice_value
                game.cursor.holding = nil
                game.cursor.pos[2] = 120
                game.cursor.pos[1] = 0
            end
        end
    end
end

function _update60()
    if game.state == pick_dice then
        update_dice_count()
    elseif game.state == roll then
        update_roll()
    elseif game.state == pre_place then
        update_pre_place()
    elseif game.state == place then
        update_place()
    end
end

-- ========= DRAW =========

function draw_dice_select()
    -- draw the instructions
    -- draw the dice count
    print(game.num_dice, 64 - 2, 64 - 2)
    msg = "press ⬆️ and ⬇️"
    size = (128 - ((#msg + 2) * 4)) / 2
    print(msg,size,100,white)

    msg = "to pick the number of dice"
    size = (128 - (#msg * 4)) / 2
    print(msg,size,110,white)

    msg = "press ❎ to continue"
    size = (128 - ((#msg + 1) * 4)) / 2
    print(msg,size,120,white)
    
end

function draw_dice()
    hold = nil
    for dice in all(game.dice) do
        if game.cursor.holding != nil and game.cursor.holding == dice then
            hold = 63 + dice.value
        else
            num = 63 + dice.value
            spr(num,dice.x,dice.y)
        end
    end
    if hold != nil then 
        spr(hold,game.cursor.pos[1],game.cursor.pos[2])
    end
end

function draw_place()
    rectfill(0,119,128,128,dark_blue)
    for y=32,96,8 do
        line(32,y,96,y,dark_gray)
        line(y,32,y,96,dark_gray)
    end
    draw_dice()
    color = red
    if game.cursor.holding == nil then color = blue end
    rect(
        game.cursor.pos[1] - 1,
        game.cursor.pos[2] - 1,
        game.cursor.pos[1] + 7,
        game.cursor.pos[2] + 7,
        color
    )
end

function _draw()
    cls(black)
    if game.state == pick_dice then
        draw_dice_select()
    elseif game.state == roll or game.state == pre_place then
        draw_dice()
    elseif game.state == place then
        draw_place()
    end
end
__gfx__
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
77777770777777707777777077777770777777707777777077000770770007707700077077000770777777707777777000000000000000000000000000000000
77777770777771707777717071777170717771707177717077000770770007707700077077000770700000707000007000000000000000000000000000000000
77777770777777707777777077777770777777707777777077000770770007707700000000000000700000707000007000000000000000000000000000000000
77717770777777707771777077777770777177707177717077000770770007707700000000000000700000707000007000000000000000000000000000000000
77777770777777707777777077777770777777707777777077777770770007707700000000000000700000707000007000000000000000000000000000000000
77777770717777707177777071777170717771707177717077777770770007707777777077000770700000707000007000000000000000000000000000000000
77777770777777707777777077777770777777707777777077777770770007707777777077000770777777707777777000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000077777770777777707700077000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000077777770777777707700077000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000007770000000000000077000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000007770000000000000077000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000007770000000000000077000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000077777770777777707777777000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000077777770777777707777777000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000077777770000000007777777000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000077777770000000007777777000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000077777770000000000000077000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000077000770000000000000077000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000077000770000000000000077000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000077000770000000007700077000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000077000770000000007700077000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000077777770000000007777777000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000077777770000000007777777000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000077700000000000007700000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000077700000000000007700000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000077700000000000007700000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000077777770000000007700077000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000077777770000000007700077000000000000000000000000000000000000000000000000000000000
__map__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000006c5b5b5b4d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000006b4b4b4b7c00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000005c0000004c00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
