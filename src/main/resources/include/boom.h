/*
 * boom.h - part of WadC
 * Copyright © 2016 Jonathan Dowland <jon@dow.land>
 *
 * Distributed under the terms of the GNU GPL Version 2
 * See file LICENSE.txt
 *
 * Boom-specific stuff, including generalised sector & linedef calculators
 *
 * Flag value constants are defined below. Where a flag is binary,
 * we don't bother defining constants for it.
*/

#"math.h"

/* boom linedef types *******************************************************/

enable_friction { 223 }
enable_wind { 224 }

/* generalised linedef types ************************************************/

-- constants for all types
trigger_w1   { 0 }
trigger_wr   { 1 }
trigger_s1   { 2 }
trigger_sr   { 3 }
trigger_g1   { 4 }
trigger_gr   { 5 }
trigger_d1   { 6 }
trigger_dr   { 7 }

speed_slow   { 0 }
speed_normal { 1 }
speed_fast   { 2 }
speed_turbo  { 3 }

-- constants for floors or ceilings
nochange       { 0 }
change_zero    { 1 }
change_texture { 2 }
change_type    { 3 }

model_trig    { 0 }
model_numeric { 1 }
-- model field overloaded for monster activation flag if change is 0

-- constants for floors
floor_target_HnF { 0 } -- Highest neighbouring Floor
floor_target_LnF { 1 } -- Lowest neighbouring Floor
floor_target_NnF { 2 } -- Nearest neighbouring Floor
floor_target_LnC { 3 } -- Lowest neighbouring Ceiling
floor_target_C   { 4 } -- Ceiling
floor_target_sT  { 5 } -- shortest lower texture
floor_target_24  { 6 } -- 24 units
floor_target_32  { 7 } -- 32 units

-- constants for ceilings
ceiling_target_HnC { 0 }
ceiling_target_LnC { 1 }
ceiling_target_NnC { 2 }
ceiling_target_HnF { 3 }
ceiling_target_F   { 4 }
ceiling_target_sT  { 5 }
ceiling_target_24  { 6 }
ceiling_target_32  { 7 }

-- constants for doors and locked doors
door_open_delay_close { 0 }
door_open   { 1 }

-- constants for unlocked doors
door_close_delay_open { 2 }
door_close  { 3 }

door_delay_1s  { 0 }
door_delay_4s  { 1 }
door_delay_9s  { 2 }
door_delay_30s { 3 }

-- constants for locked doors
lock_any          { 0 }
lock_red_card     { 1 }
lock_blue_card    { 2 }
lock_yellow_card  { 3 }
lock_red_skull    { 4 }
lock_blue_skull   { 5 }
lock_yellow_skull { 6 }
lock_all          { 7 }

-- constants for lifts
lift_delay_1s  { 0 }
lift_delay_3s  { 1 }
lift_delay_5s  { 2 }
lift_delay_10s { 3 }

lift_target_LnF        { 0 }
lift_target_NnF        { 1 }
lift_target_LnC        { 2 }
lift_target_LnF_to_HnF { 3 } -- perpetual

-- constants for stair builders
stair_step_4  { 0 }
stair_step_8  { 1 }
stair_step_16 { 2 }
stair_step_24 { 3 }

genfloor(trigger, speed, model_or_monster, direction_up, target, change, crush) {
    add(0x6000,
    add(trigger,
    add(lshift(speed, 3),
    add(lshift(model_or_monster, 5),
    add(lshift(direction_up, 6),
    add(lshift(target, 7),
    add(lshift(change, 10),
        lshift(crush, 12)
    )))))))
}

genceiling(trigger, speed, model_or_monster, direction_up, target, change, crush) {
    add(0x4000,
    add(trigger,
    add(lshift(speed, 3),
    add(lshift(model_or_monster, 5),
    add(lshift(direction_up, 6),
    add(lshift(target, 7),
    add(lshift(change, 10),
        lshift(crush, 12)
    )))))))
}

gendoor(trigger, speed, kind, monster, delay) {
    add(0x3c00,
    add(trigger,
    add(lshift(speed, 3),
    add(lshift(kind, 5),
    add(lshift(monster, 7),
        lshift(delay, 8)
    )))))
}

gen_locked_door(trigger, speed, kind, lock, skull_card_are_equivalent) {
    add(0x3800,
    add(trigger,
    add(lshift(speed, 3),
    add(lshift(kind, 5),
    add(lshift(lock, 6),
        lshift(skull_card_are_equivalent, 9)
    )))))
}

genlift(trigger, target, delay, monster, speed) {
    add(0x3400,
    add(trigger,
    add(lshift(target, 8),
    add(lshift(delay, 6),
    add(lshift(monster, 5),
        lshift(speed, 3)
    )))))
}

gen_stairs(trigger, speed, monster, step, direction_up, ignore_texture_changes) {
    add(0x3000,
    add(trigger,
    add(lshift(speed, 3),
    add(lshift(monster, 5),
    add(lshift(step, 6),
    add(lshift(direction_up, 8),
        lshift(ignore_texture_changes, 9)
    ))))))
}

gen_crusher(trigger, speed, monster, silent) {
    add(0x2F80,
    add(trigger,
    add(lshift(speed, 3),
    add(lshift(monster, 5),
        lshift(silent, 6)
    ))))
}

/* generalised sector types *************************************************/

-- the light values from vanilla doom sector types for lighting are re-used
-- for boom generalised sectors. See sectors.h

-- boom additions

damage_5pers  { 32 }
damage_10pers { 64 }
damage_20pers { 96 }

-- zdoom (and UDMF) shift the generalised sector bits up 3 places to not limit the
-- range prior to just 16 types
zdoom_shift { 3 }

gen_sector(light, damage, is_secret, friction_enabled, wind_enabled) {
    add(light,
    lshift(
    add(damage,
    add(lshift(is_secret, 7),
    add(lshift(friction_enabled, 8),
        lshift(wind_enabled, 9)
    ))), is_hexenformat ? zdoom_shift : 0)
    )
}
