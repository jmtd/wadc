WadC ("Wad Compiler")

Current maintainer: Jon Dowland
jon+wadc@alcopop.org
http://jmtd.net/wadc/

Originally by Aardappel
http://wouter.fov120.com/wadc/
wouter@fov120.com

version history:
================
1.2
---
* First release by Jon Dowland.
* Doom features:
  - friendly flag - toggle boom friendly monsters
  - impassable flag - toggle impassable 2s lines
  - midtex flag - toggle middle-textures on 2s lines
* new examples:
  - 1.2_features.wl - demo the new features above
  - entryway.wl - a recreation of Doom 2 MAP01 in WadC, thanks GreyGhost
1.1
---
* Doom features:
  - auto texturing (!)
  - zdoom/hexen wad format support, slopes etc.
  - "world coordinates" xoff alignment
  - explicit sector assignment
* UI features:
  - improved mouse editing & preview window
* language features:
  - eager evaluation of function arguments
  - global variables and objects
  - stacktraces in runtime error messages
  - new math functions: sin/asin
* distribution features:
  - more examples / useful include files
  - many small enhancements/fixes

1.0: first public release
-------------------------
* UI features:
  - generating code by drawing lines with the mouse (!)
  - zooming & panning
  - map rendering enhancements
* Doom features:
  - automatic splitting of overlapping lines (!)
  - curves with automatic texture alignment
  - inner sectors
  - thing/line/sector types
  - arches (experimental)
  - tag identifiers
* language features:
  - include files (with many Doom constants supplied)
  - a random choice operator
* distribution features:
  - more examples etc.
  - comes with source (GPL)

0.9: initial beta
-----------------
some may have seen this.



What is it?
===========
A programming language for the construction of Doom maps. Integrated 
environment, shows you what the map described by the program looks like at the 
press of a key, and gives visual feedback about errors. Saves .wad files that 
only need to be BSP'ed. The programming language is a cross between a macro 
preprocessor and a lazy functional programming language. Unless you enjoy
both programming & Doom editing, you are unlikely to be interested in this
software.


Requirements
============
- any computer that runs Java 1.1 or better
- any version of Doom
- a Doom nodebuilder (bsp 5.0 recommended)


Source code
===========
This distribution comes with full source, which is released under the
GPL (GNU Public License, see http://www.gnu.org/copyleft/gpl.txt).


Installation
============
Unpack the whole zip to any directory you like. Run "wadc.bat" (you may
need to adapt this to work on your system, on some systems "java" may be
"javaw", "jre" or "jrew"  instead). Note that you need some variety of
Java 1.1 or higher installed for  this to work, if you don't, go to
java.sun.com and download & install the latest JRE (or JDK). To play
the .wad files you create using WadC in Doom, you also need a nodebuilder.
I myself use BSP 5.0, get it from http://www.doomworld.com/files/editors.shtml


Using the GUI
=============
Assuming you got it to run, you will now see the main screen, divided in an
editor part (here you write the program), a 2d map view, and an output
pane (error messages and the like appear here).

The file menu takes care of loading & saving your programs, this should all
be pretty obvious. The default extension for a program is .wl ("Wad Language").
(all example source files and includes are located in the "examples" subdirectory).

In the program menu, "Run" runs your current program. You should do this 
frequently to see what your map looks like. If there were errors parsing your 
program the error will be shown in the output pane, and the cursor position in 
the source code after the point the error was discovered. If it parsed ok, your 
program will run which will generate a map. Runtime errors will be reported to 
the output pane, and some runtime errors that relate to particular lines or 
sectors will highlight the line or sector causing the error in red. In general 
these colours are use in the 2d view:

- white: one sided linedef
- grey: two sided linedef
- green: vertices & unassigned linedef (assigned to sector 0 upon saving a wad)
- red: line/sector that caused a runtime error
- purple: last line (and vertex) the program generated
- blue: things, and lines with special types
- yellow: newly drawn lines (press "Run" to make them green)
- dark grey: grid lines at 64 distance

You can zoom by left-clicking, and zoom out by right-clicking (in both cases,
where you click is made the new center of the map). Additionally you can pan
around by dragging the mouse, larger drags cause larger movements (you drag
whatever you grab to the position you release it on).

Instead of typing commands to draw lines, you can hold down control and click 
with the mouse (grid snap = 16 only, sorry), which will draw a line (or a curve 
if you hold down alt instead, or just step to a new position using shift) 
between the last vertex and where you clicked, and insert the code to draw this 
line at the end of the main function (so that, if you press "Run", it will 
regenerate itself correctly!). This needs atleast one starting line, and 
"standard.h" included. This is a very useful feature for drawing complex shapes, 
and for producing "glue code" between functions. After WadC has generated the 
code, you can copy it to another function etc. If you made a mistake in drawing 
you can simply delete the code from the edit window and try again (keep pressing
"Run" in between).

"Run / Save / Save Wad" runs the program as above, and if succesful writes the
sourcefile, and a .wad to the same directory and with the same name as the .wl
file. Before loading it up in Doom you have to run it through a nodebuilder.

"Run / Save / Save Wad / BSP/ DOOM" as above, but now also runs the nodebuilder
on it, and then your favourite doom port. You can set which bsp / doom port you
want to use and where they are located by modifying "wadc.cfg" in the src dir.
(this option doesn't always work well depending on which JDK is used,
alternatively use a batch file such as the launchdoom.bat provided)


The Language
============
For most people it will be easiest to think of the language as a powerful
macro language. It consists of a set of builtin functions that allow you
to draw lines and sectors and such, and a way to abstract over them using
a function.


Lexical stuff
-------------
The language just knows two literals, integers (23, 0, -1 etc.) and strings
("LITE5"), the latter sofar mainly used for texture names.

Identifiers are made up of lower or upper case characters, and are allowed to 
contain digits or "_".

The source is in free format (i.e. it doesn't matter how you layout your
code). Single line comments start with "--" and last for the rest of that line,
multiline comments is anything enclosed in /* */ (not nested).


Integer expressions
-------------------
The following builtin functions allow you to do simple operations on integers:

    add(x,y) sub(x,y) mul(x,y) div(x,y)

same as x+y x-y etc.

    eq(x,y) lessthaneq(x,y)

same as x==y and x<=y, returning 1 if true or 0 if false. To do other comparisons
simply rearange your code :)

    sin(x)
    asin(x)

sin takes an argument in degrees (not radians) *10, i.e. 90 degrees in 900. It
returns the 1.0 to -1.0 range as 1024 to -1024. asin performs the inverse
transformation over the same ranges.

If Then Else
------------
is an expression of the form "exp ? exp : exp" as in C/Java. For example

    lessthaneq(a,0) ? 0 : a

returns a, unless it is negative then it returns 0.


Concatenating expressions
-------------------------
Writing any two expressions seperated by a space simply creates a new 
expression, where the expressions get evaluated in order, but the result is the 
value of the second expression. This is equivalent to the "," operator in C/Java 
and makes sense if you want to evaluate a number of expressions which are 
actually statements (expressions that are used for their side effect, not for 
their result). For example:

    print("a = ") print(a) a

is one expression that first prints two things to the output pane, and returns 
"a" as the result of the whole. This can be used anywhere, for example in an if 
expression:

    lessthaneq(a,0) ? print(a) 0 : a

if for example you wanted to debug what "a" was when it is negative.


Bracketing expressions
----------------------
You can freely use "{" and "}" to bracket (groups of) expressions to make
more complex cases of if's clear in meaning. for example:

    a ? b : c d

both c and d are part of the else part of the if. To prevent this, write:

    { a ? b : c } d


Function/Macro definition
-------------------------
This is where the fun starts. WadC's functions are like macros because they don't
evaluate their arguments but just pass them on. But unlike macros they can do
things normally only functions can do like recursive calls.

To define a function that takes no arguments, simply write:

    name { exp }

This would allow you to use "name" everywhere and it would result in "exp" being 
evaluated. To add parameters, simply add them as a comma seperated list between 
parentheses, i.e.:

    name(a,b,c,...) { exp }

The parameter names you mention between the parentheses can now be used in
the "exp" part, and to use this function you have to specify values as
arguments. What is cool is that there are no restrictions to what you can
pass as arguments, it can even be any bit of code! As an example:

    twice(x) { x x }

    twice(print("heh"))

will print "heh" twice. In most languages you would pass the result of print(),
here you pass the actual code. This leads to new coding habits, for example in
designing a map you often need to do something different in a certain case of
your function. So instead of writing:

    dosomething(x) {
      blah(x)
      eq(x,0) ? print("something special has to happen here") : 0
    }

    dosomething(2)
    dosomething(1)
    dosomething(0)

You could write:

    dosomething(x,y) { blah(x) y }

    dosomething(2,0)
    dosomething(1,0)
    dosomething(0,print("something special has to happen here"))

You can disable this "lazy" way of argument evaluation by giving the
variable a name that starts with an "_", i.e.:

    twice(_x) { _x _x }

    twice(print("heh"))

will print "heh" just once. There are really very few cases where this
is needed (mostly in recursive functions).


Include files
-------------
You can include another WadC sourcecode file using "#", for example:

    #"standard.h"

this will include the file "standard.h" in your
program (actually, it will append it to the end of it, so if it has any
errors WadC will report linenumbers beyond the end of your file :)

Generally, ".h" is used for files that are only useful when included
somewhere (i.e. don't contain a "main" function) and ".wl" for normal
sources. "standard.h" contains useful macros, it should be included
in any program really.

WadC's set of standard include files contain a wide range of useful
language, doom & architectural macros that are very useful and speed
up editing a lot. You should make sure to get familiar with them:

    standard.h:     very basic language & doom macros for very common
                    things. Many of the macros here are easier to use
                    then the builtin features they are based upon.
                    
    decoration.h:
    spawns.h:
    pickups.h:
    monsters.h:     constant definitions for all doom things
    
    zdoom.h:        things that rely on zdoom features, such as slopes
                    and sloped arches.
    
    basic.h:        a set of higher level architectural building blocks
                    based on some conventions of composing sectors. good
                    to work with for bigger maps. Contains common doom map
                    prefabs for things like starts, end of level, monster
                    teleporting and placement, and room segments.


The choice operator
-------------------
The choice operator can be placed between one or more expressions,
and will make WadC choose one at random:

	print({ "hi!" | "hello!" | "how do you do!" })
	
will print one of the three strings at random, giving each 1/3rd a
chance of being picked. What is the use of this? Maps with (controlled)
random features maybe? you figure it out. Look at the "hexagon" sources
for an extensive example.

As a convention it is a good idea to bracket choice expressions with {}
as shown in the example above... but it is not needed. Choice expressions
may appear anywhere where the constituent expressions are valid.

Caveat: WadC makes its choice which expression to pick _when the function
they appear in is called_, not when they are supposed to be evaluated:

    blah {
      for(1,4,straight({ 64 | 32 }))
    }

will draw all 4 lines at length 64, or all at 32, but not a mixture.
This feature is there to make it easier to have a random choice be
repeated, which would otherwise be impossible. To force a random choice
at every iteration, use a function:

    len { 64 | 32 }

    blah {
      for(1,4,straight(len))
    }



Doom Specific Commands
======================
The bit you have been waiting for :)

First let me explain how evaluation and map construction works. At any
stage you always have a current vertex (and also a current line). Besides
that, you have an orientation, which is the direction you will draw in
if you draw a line. Unlike languages like Logo, you can't just look in
any direction, but just in 4: north, east, south, west. The thinking
behind this is that if you could move in an arbitrary angle, it would
be hard to keep track of your imaginary grid, and also that most maps
will have parts that can benefit from rotating to any of these 4 directions,
but more than that is hardly useful. Note that having these 4 directions
doesn't mean you can't draw lines in arbitrary directions, it only affects
which way you are looking. 

    rotright rotleft

rotate you 90 degrees, e.g. "north rotright" is equivalent
to "east".

    up down

control wether the "pen" is up or down. If it is down (default)
moving about will create linedefs (hint, use macros from standard.h
instead of these).

    step(forwards_backwards,sideways)

This is the main drawing command. It draws a line from the current
vertex to a new postion which will become the new current vertex.
The first value determines how many units to go forwards in the
direction you are looking, if it is negative you will go backwards.
The second parameter determines a sidestep from this, 0 means
straight ahead, positive numbers step towards the left, and negative
ones to the right. For example, if you were looking north, and wanted
to draw a line that goes 45 degrees across a 64 unit square towards
the north-east, you would write:

    step(64,-64)

Here you see why that 4 direction system is useful: if you were using
arbitrary angles you would have needed to write something like 
"rotate(45) step(mul(sqrt(2),64))" which would be horribly clumsy and
imprecise, assuming it would use floats.

To make creating linedefs easier, some shorter macros exists (defined
in "standard.h" to make life easier.

	curve(forward,sideways,subdivisions,xoffdir)

draws a 90 degree curve out of linesegments, the number of which is determined by
subdivisions. After the curve, the current orientation is rotated accordingly.
Curve automatically uses and increases the current xoff value to get perfect texturing,
and thus also allows multiple curves to be fitted together perfectly. Remember to
call xoff(0) after a series of curves to reset its value when needed.
xoffdir can be 1 or -1, and determines wether xoff values should be increasing
or decreasing.

    leftsector(floor,ceil,lightlevel)
    rightsector(floor,ceil,lightlevel)

create a new sector, with given floor/ceiling levels and light level.
the sector will be created from the last linedef drawn before this
command, and either to the left or the right of it (left means the
sector to the left, looking from the one before last vertex towards
the last vertex. Because making sectors always needs to be done after
the last line, it requires a bit of planning in your code (i.e. it
is a lot of hassle to make a sector out of something your are not
currently drawing, though it can be done (by overwriting any line of
it)). These commands can cause runtime errors if you ask to create
a sector out of something which is not closed off, or has some sidedef
already assigned to another sector etc. See also pitfalls below.

    innerleftsector(floor,ceil,lightlevel)
    innerrightsector(floor,ceil,lightlevel)
    popsector

same as the two commands above, but now as extra also assign the other
sidedef to the last sector created before this one, i.e. this new
sector is created inside the last sector.
popsector makes the sector before the last sector the one used for
attaching an innersector to, i.e. you can use this directly after
an innersector command if you want to place another innersector next
to the current one (rather than inside it).

    thing

Creates a thing of the current thingtype, with the current vertex
as position (default is playerstart). You can change the type of
thing being added by using

	setthing(type)

where type you have to take from uds.txt, or better still use
monsters.h / pickups.h / decoration.h / spawns.h include files instead.

	friendly

toggles the 'friendly' flag of monsters. Friendly monsters are a Boom
feature. 'friendly' defaults to off.

	linetype(type,tag)

Sets the current type & tag for lines being drawn. Needs to be reset to 0
manually. (see below for how to use tags).

	sectortype(type,tag)

sets current type & tag for the next sectors being creates. Needs to be reset
to 0 manually. (see below for how to use tags).

    linetypehexen(type,arg1,arg2,arg3,arg4,arg5)
    setthinghexen(type,arg1,arg2,arg3,arg4,arg5)

same as linetype & setthing above, only now for hexen/zdoom style wads. Using
any of these commands automatically changes the output wad to hexen format.
Note that arg1 in linetypehexen() is the same as tag in linetype(). To compile
maps produced this way, recommended is the version of bsp that comes with
"zeth". Check out zdoom.h for some useful macros.

    floor(flat)
    ceil(flat)
    top(texture)
    mid(texture)
    bot(texture)

Sets the current texture for any of these items. The first two require a name of 
a flat, the last 3 of a texture (not a patch). Names can be easily looked 
up/browsed in wintex using Advanced / Edit Texture when looking at a (texture) 
wad. Currently WadC doesn't check this is a valid texturename, it just uses it. 
The good side of this is that you can use custom texture wads by just using the 
correct names and adding the wad to -file. Who knows in the future WadC may 
support a texture browser and automatic saving of custom textures, but it is not 
a priority. bot/top/mid get assigned to both sidedefs upon creation of the 
linedef (using step), floor/ceil are assigned when leftsector/rightsector is 
executed.

By default, WadC automatically removes textures on doublesided linedefs.
You can toggle this on and off using the 'midtex' command:

    midtex

Tip: wrap all your texture uses in a function:

    lite5 { mid("LITE5") }

not only is it easier to write but it will make it extremely easy to experiment 
with alternative texture choices in a map.

    xoff(offset)
    yoff(offset)

set the current texture offsets (used on lines drawn). don't forget to set them
back to 0 when done.

    unpegged

sets both lower & upper unpegged. calling it again resets to normal.

    impassable

By default, two-sided lines are passable. Setting 'impassable' prevents this.

	arch(height,width,depth,subdivision,floor,lightlevel)

(experimental) makes an arch, of a certain base height, starting at a certain floor
level. width is across the arch, depth is into the arch, subdivision should divide
width, i.e. if width = 128, then subdivision = 64 gives you sectors of 2 units wide.
Arch adds to xoff automatically to reduce funny texturing. On the y axis it is best
if you precede arch by unpegged.

	mergesectors

turns sector merge mode on. In this mode WadC will check for existing sectors
with identical properties when creating a new sector, and if one exists,
assign the sidedefs of the new sector to the existing sector instead. This
will enable you to create maps with very few sectors :)
Only use this option when necessary, as GL doom ports seem to have a hard time
triangulating sectors like this.

	prunelines

when this is on, removes all linedefs (when saving) that have the same
sector on both sides, and linedefs with no sidedefs at all. This is often
used in combination with mergesectors, and avoids the "sidedefs assigned
to same sector" error.

    lastsector
    forcesector(index)
    
returns the index (not tag!) of the last sector created. you can use this
value with together with forcesector, to add sides to a sector which is not
spacially adjoining it. forcesector will force the next makesector command
to add sidedefs to the sector specified instead of creating a new one. The
properties specified in the makesector command (floor level etc) are ignored.

    mute
    
any following monsters will be muted. Calling it again switches it off again.

    easy
    hurtmeplenty
    ultraviolence

any following monsters (calls to "thing") are available only from the said skill
and upwards

    popsector

Clearly there are a few Doom specific types and flags missing, this will
come in future versions.


Line splitting/merging
----------------------
If either a line or a vertex is drawn on exactly the same location as an
existing line or vertex then the drawing command is ignored, i.e. if a
line is drawn multiple times, the properties of the first (textures etc.)
are remembered. This is useful for combining macros that draw complex
shapes.

But WadC supports a more advanced system for combining complex sectors:
for all horizontal and vertical lines it will automatically perform all
splitting of existing lines necessary, and insertion of vertices etc.
This means you can write macros that generate complex sectors, and
combine them with others, without having to worry how they match up.


"world coordinates" xoff alignment
----------------------------------
If you make maps with lots of detail, and thus many short lines,
setting xoff correctly for each of them becomes unmanageable. For
those kind of maps, you can use "world coordinates" to assign good
xoff values automatically.

    undefx

this command "undefines" the current xoff. undefined xoff coordinates
get set automatically by WadC according to the coordinates of the vertices
on both end points. so for example if you have 4 linedefs of length 16,
between vertices (0,0) (0,16) (0,32) etc, then the xoff will be
automatically set to 0, 16, 32 etc (or their negative equivalents,
depending on which direction the line is going). because (sadly)
doom doesn't support texture scale, this can only work for linedefs that
are parallel to either the x of y axis.

If you make your map with "undefx" in mind, i.e. by aligning architecture
to power of 2 grid coordinates, you can align a whole map automatically.
You can still use the xoff() command command for specific lines that you
want to align in specific ways, just make sure to undefx afterwards.

the curve() command is not affected by undefx, it uses its own alignment.



Position / Texture memory
-------------------------
This is a language feature specifically meant to make drawing complex
forms easier. Often you will draw a lot of lines and sectors and
change textures, and want to get back to a certain point to continue
drawing there. These two expression do just that:

    !name

Store the current position (vertex), orientation, and textures in the (global) 
variable "name".

    ^name

Go back to the position/orientation stored in "name" and restore the textures.


Tag Identifiers
---------------
These are especially useful in combination with the linetype & sectortype
commands. Simply use any identifier prefixed by a "$":

	linetype(88,$exitlift)
	sectortype(0,$exitlift)

whereever the same tag is used, a unique tag number is automatically generated and
used.


Auto texturing
--------------
This is a very powerful feature which lets you create "rules" that say
how a map should be textured, instead of doing it by hand.

Only surfaces that have the "?" texture assigned to them, will be auto textured
this has the advantage that you can still perform manual texturing in those cases
where you can't write a rule to express what you want. You can easily use
autotexall() to set all texture to "?".

You specify rules using the following command:

	autotex(type,size1,size2,size3,texture)

This reads: apply "texture" to any surfaces that are of type "type",
and comply with size constraints "size1", "size2" and "size3".

Note well, if you specify multiple rules, then the *LAST* one that is
applicable for a certain surface will be used. So you should start your
list of rules with the general ones, and work towards the specific cases.

if you write a set of rules where none are applicable to a certain
surface, the surface will be given some default texture, so make sure
your rules cover all cases.

type must be one of:

	"C" for ceiling
	"F" for floor
	"U" for top/upper
	"N" for middle/normal
	"L" for bottom/lower
	"W" for any of upper/normal/lower

Texture is a texture name as used in the texture commands above.

The size parameters for any wall surfaces (U/N/L) are:

    height, width, sector floor level

for floors, they are:

    sector height, sector floor level, sector bounds length

for ceilings, they are:

    sector height, sector ceiling level, sector bounds length

width is taken in axial size, i.e. a slanted wall drawn with step(64,32)
would have width 64. levels are +1000 to make them all positive. Sector
bounds length is the sum of the widths (i.e. axial) of all lines surrounding
a sector, so a 64 square sector has a bounds length of 256. 

if the size parameter is:

	>0, then the surface size must equal to it
	=0, then the surface size can be anything
	<0, then the surface size must bigger than -(this parameter).

If that sounds confusing, an example should make it a lot easier:


  autotex("L",0,0,0,"BRICK6")       -- default lower tex is brick6
  autotex("L",16,0,0,"BIGDOOR6")    -- unless they are 16 high (any width),
                                    -- then we use bigdoor6 as metal strip
                                    -- (for stairs etc).
                                
  autotex("N",0,0,0,"BRICK6")       -- default wall is brick6
  autotex("N",-192,0,0,"ROCK5")     -- unless they are higher than 192,
                                    -- then they are outside rocks
  autotex("N",0,16,0,"BROWNHUG")    -- very thin walls are metal strips
  autotex("N",64,16,1032,"LITE5")   -- all 64 high 16 wide walls at
                                    -- floorlevel 32 are lights
                                
  autotex("U",0,0,0,"BRICK6")       -- default upper is brick6

  autotex("C",0,0,0,"RROCK11")      -- default ceil
  autotex("C",-192,0,0,"F_SKY1")    -- unless its very high, then its sky
  autotex("C",0,0,256,"CEIL1_2")    -- all 64 square sectors have a ceiling light

  autotex("F",0,0,0,"SLIME13")      -- default floor
  autotex("F",0,984,0,"LAVA1")      -- all floors at -16 are lava1
  autotex("F",0,1064,0,"RROCK10")   -- all floors at 64 are rrock10
  autotex("F",96,-1064,0,"SLIME14") -- all floors at 64 or higher in a 96 high
                                    -- sector are slime14


Once you are able to set up a good set of rules, you'll be able to map
very fast, because 99% of texture application will be "right" without
manual tuning. You can improve the amount of texturing you can do this
way by planning your maps styles around this feature: for example making
all rooms that require a certain floor/ceiling be at a certain height etc.


variables and objects
---------------------
These features are here to make the language a bit more complete as a
general purpose programming language.

    set(varname, value)
    get(varname)

where varname is a string, and value can be anything. these functions
work like a set of global variables. Both return the current value.
Calling get before a set, will result in an error.

    onew

creates/returns a fresh object, with no fields in it yet. Objects are denoted
by integers, and thus pointer arithmetic is possible. Accessing an unallocated
object however results in an error.

    oset(object, fieldname, value)
    oget(object, fieldname)

Identical in behaviour to get/set, these 2 access fields in an object rather
than global variables.

See lisp.wl for an example of how to use these functions to create an
actual datatype, and a caveat on the usage of "onew".

Pitfalls
========
Here are some common things that can go wrong, and which can result in
runtime errors:

- if you get a "sidedef already assigned" error, and it is not obvious
  why (the current sector looks fine), it may be the case that for a
  previously constructed sector you accidentally made a sector out of
  the whole outside of the level (by choosing the wrong side). WadC doesn't
  detect wether something is inside or outside, and this will only show
  up when defining an adjoining sector.

