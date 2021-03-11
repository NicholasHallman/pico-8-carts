pico-8 cartridge // http://www.pico-8.com
version 16
__lua__

camera = {
    x = 0,
    y = 0,
    z = 0,
    quat = {
      0, 0, 0
    }
}

objects = {
  {
    -- sphere, x:0, y:0, z:20, r:5, color: dark_blue
    0, 0, 0, 20, 5, 1
  }
}

lights = {

}

function intercepts_sphere(sphere)
  ray_to_o = {
    x = sphere[1] - camera.x,
    y = sphere[2] - camera.y,
    z = sphere[3] - camera.z
  }
end

function cast_ray(x, y, dir)
  color = 0;
  for object in all(objects) do
    -- check if the ray intercepts the object
    if object[1] == 0 then intercepts_sphere(object) end
  end
  return color;
end

function _init()
  screen = {}
  for y=0,127 do
    for x=0,64 do
      screen_pos = (x) + (y * 64) 
      rx = x * 2
      if screen_pos >= 8192 then 
        printh(x .. ", " .. y)
        return
      end
      dir_1 = { -1 + (y / 64), -1 + (rx / 64), 1}
      dist_dir_1 = sqrt( dir_1[1] ^ 2 + dir_1[2] ^ 2 + dir_1[3] ^ 2)
      dir_1 = {
        dir_1[1] / dist_dir_1,
        dir_1[2] / dist_dir_1,
        dir_1[3] / dist_dir_1
      }

      dir_2 = { -1 + (y / 64), -1 + ((rx + 1) / 64), 1}
      dist_dir_2 = sqrt( dir_2[1] ^ 2 + dir_2[2] ^ 2 + dir_2[3] ^ 2)
      dir_2 = {
        dir_2[1] / dist_dir_2,
        dir_2[2] / dist_dir_2,
        dir_2[3] / dist_dir_2
      }

      color_even = cast_ray(0, 0, dir_1)
      color_odd = cast_ray(0, 0, dir_2)

      printh(screen_pos)
      c = color_even
      c += color_odd<<4
      poke(0x6000 + screen_pos, c)
    end
  end 
  
  -- blit the colors to the screen
end