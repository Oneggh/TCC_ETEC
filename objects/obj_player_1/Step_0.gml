var dir_x = 0;
var dir_y = 0;

if keyboard_check(vk_right) || keyboard_check(ord("D")) dir_x = 1;
if keyboard_check(vk_left)  || keyboard_check(ord("A")) dir_x = -1;

if keyboard_check(vk_down)  || keyboard_check(ord("S")) dir_y = 1;
if keyboard_check(vk_up)    || keyboard_check(ord("W")) dir_y = -1;

x += dir_x * speed_walk;
y += dir_y * speed_walk;