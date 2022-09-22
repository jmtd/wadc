/*
 * sectors.h - part of WadC
 * Copyright © 2017 Jonathan Dowland <jon@dow.land>
 *
 * Distributed under the terms of the GNU GPL Version 2
 * See file LICENSE.txt
 *
 * sector type definitions
 */

light_normal            { 0  }
light_random_off        { 1  }
light_blink_half_s      { 2  }
light_blink_1s          { 3  }
light_blink_half_s_hurt { 4  } -- -10/20% health
sectortype_damage_10    { 5  } -- Damage  10% damage per second
sectortype_damage_5     { 7  } -- Damage  5% damage per second
light_oscillate         { 8  }
sectortype_secret       { 9  }
--10  Door    30 seconds after level start, ceiling closes like a door
--11  End 20% damage per second. When player dies, level ends
light_blink_05s_sync    { 12 }
light_blink_1s_sync     { 13 }
--14  Door    300 seconds after level start, ceiling opens like a door
--16  Damage  20% damage per second
light_flicker           { 17 }
