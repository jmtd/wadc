/*
 * hexen/lines.h - part of WadC
 * Copyright © 2016 Jonathan Dowland <jon@dow.land>
 *
 * Distributed under the terms of the GNU GPL Version 2
 * See file LICENSE.txt
 *
 * hexen/lines.h - hexen linedef definitions (flags etc.)
 */

repeat            { 512 }

/* activity flags (how action is triggered) */
walk              { 0 } -- default
use               { 1024 }
monster_walk      { 2048 }
projectile_hit    { 3072 }
push              { 4096 }
projectile_pass   { 5120 }
