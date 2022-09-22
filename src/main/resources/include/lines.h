/*
 * lines.h - part of WadC
 * Copyright © 2016 Jonathan Dowland <jon@dow.land>
 *
 * Distributed under the terms of the GNU GPL Version 2
 * See file LICENSE.txt
 *
 * line flag and type definitions
 */


/* line flag definitions ****************************************************/

secret_line    { 32 }
blocks_sound   { 64 }
never_automap  { 128 }
always_automap { 256 }

/* vanilla types ************************************************************/

-- floors

floor_w1_up_LnC              { 5  }
floor_s1_up_NnF              { 18 }
floor_w1_down_HnF            { 19 }
floor_s1_down_LnF            { 23 }
floor_g1_up_LnC              { 24 }
floor_w1_up_SlT              { 30 }
floor_w1_down_fast_HnF_plus8 { 36 }
floor_w1_down_LnF_TxTy       { 37 }
floor_w1_down_LnF            { 38 }
floor_sr_down_HnF            { 45 }
floor_s1_up_LnC_minus8       { 55 }
floor_w1_up_LnC_minus8       { 56 }
floor_w1_up_24               { 58 }
floor_w1_up_24_TxTy          { 59 }
floor_sr_down_LnF            { 60 }
floor_sr_up_LnC              { 64 }
floor_sr_up_LnC_minus8       { 65 }
floor_sr_down_fast_HnC_plus8 { 69 }
floor_sr_down_fast_HnF_plus8 { 70 }
floor_s1_down_fast_Hnf_plus8 { 71 }
floor_wr_down_LnF            { 82 }
floor_wr_down_HnF            { 83 }
floor_wr_down_LnF_TxTy       { 84 }
floor_wr_up_LnC              { 91 }
floor_wr_up_24               { 92 }
floor_wr_up_24_TxTy          { 93 }
floor_wr_up_LnC_minus8       { 94 }
floor_wr_up_SlT              { 96 }
floor_wr_down_HnF_plus8      { 98 }
floor_s1_up_LnC              { 101 }
floor_s1_down_HnF            { 102 }
floor_w1_up_NnF              { 119 }
floor_wr_up_NnF              { 128 }
floor_wr_up_fast_NnF         { 129 }
floor_w1_up_fast_NnF         { 130 }
floor_s1_up_fast_NnF         { 131 }
floor_sr_up_fast_NnF         { 132 }
floor_s1_up_512              { 140 }

-- XXX: ceilings

ceiling_w1_down_8f           { 44 }

-- platforms

sr_lift { 62 }
-- XXX can't be bothered to type more in

-- crushers

crusher_w1_fast   { 6 }
crusher_w1_slow   { 25 }
crusher_s1_slow   { 49 }
crusher_w1_stop   { 57 }
crusher_wr_slow   { 73 }
crusher_wr_stop   { 74 }
crusher_wr_fast   { 77 }
crusher_w1_silent { 141 }

-- XXX stairbuilders

stairs_w1_slow_8  { 8 }
stairs_w1_fast_16 { 100 }

-- XXX lighting

light_w1_255  { 13 }
light_w1_35   { 35 }
light_w1_maxN { 12 }
light_w1_minN { 104 }
light_w1_blink{ 17 }

-- exits

exit_s1_normal { 11 }
exit_s1_secret { 51 }
exit_w1_normal { 52 }
exit_w1_secret { 124 }

-- teleporters

teleport_w1 { 39 }
teleport_wr { 97 }
teleport_w1_monsteronly { 125 }
teleport_wr_monsteronly { 126 }

-- XXX donuts

-- doors

door_w1_openclose { 2 }

-- decorative

wall_scroll_left { 48 }
