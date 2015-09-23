WadC ("Wad Compiler") by Aardappel

http://hosted.gamesinferno.com/aardappel/wadc/
aardappel@planetquake.com

recently added features since first beta:
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
- any computer that runs Java, or windows
- any version of Doom
- a Doom nodebuilder
- recommended: WinTex or similar


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
I myself used BSP 2.3, get it from http://www.doomworld.com/files/editors.shtml


Using the GUI
=============
Assuming you got it to run, you will now see the main screen, divided in an
editor part (here you write the program), a 2d map view, and an output
pane (error messages and the like appear here).

The file menu takes care of loading & saving your programs, this should all
be pretty obvious. The default extension for a program is .wl ("Wad Language").
(all example source files and includes are located in the "wl" subdirectory).

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
- blue: things
- yellow: newly drawn lines (press "Run" to make them green)

You can zoom by left-clicking, and zoom out by right-clicking (in both cases,
where you click is made the new center of the map). Additionally you can pan
around by dragging the mouse, larger drags cause larger movements (you drag
whatever you grab to the position you release it on).

Instead of typing commands to draw lines, you can hold down control and click 
with the mouse (grid snap = 16 only, sorry), which will draw a line (or a curve 
if you hold down alt instead) between the last vertex and where you clicked, and 
insert the code to draw this line at the end of the main function (so that, if 
you press "Run", it will regenerate itself correctly!). This needs atleast one 
starting line, and "standard.h" included. This is a very useful feature for 
drawing complex shapes, and for producing "glue code" between functions. After 
WadC has generated the code, you can copy it to another function etc. If you 
made a mistake in drawing you can simply delete the code from the edit window 
and try again.

"Save Wad" writes a .wad to the same directory and with the same name as the .wl
file. Before loading it up in Doom you have to run it through a nodebuilder.

"Save/BSP/DOOM" saves the wad file, then runs the nodebuilder on it, and then
your favourite doom port. You can set which bsp / doom port you want to use
and where they are located by modifying "wadc.cfg" in the src dir. (this option
doesn't always work well depending on which JDK is used, alternatively use a
batch file such as the launchdoom.bat provided)


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
contain digits or "_" but not as first character.

The source is in free format (i.e. it doesn't matter how you layout your
code), and comments start with "--" and last for the rest of that line.


Integer expressions
-------------------
The following builtin functions allow you to do simple operations on integers:

        add(x,y) sub(x,y) mul(x,y) div(x,y)

same as x+y x-y etc.

        eq(x,y) lessthaneq(x,y)

same as x==y and x<=y, returning 1 if true or 0 if false. To do other comparisons
simply rearange your code :)


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


Include files
-------------
You can include another WadC sourcecode file using "#", for example:

#"wl/standard.h"

this will include the file "standard.h" in the directory "wl" in your
program (actually, it will append it to the end of it, so if it has any
errors WadC will report linenumbers beyond the end of your file :)

Generally, ".h" is used for files that are only useful when included
somewhere (i.e. don't contain a "main" function) and ".wl" for normal
sources. "standard.h" contains useful macros, it should be included
in any program really.


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

        north east south west

these commands position you in an absolute direction

        rotright rotleft

rotate you 90 degrees, e.g. "north rotright" is equivalent
to "east".

        up down

control wether the "pen" is up or down. If it is down (default)
moving about will create linedefs. Vertices are always created.

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

	curve(forward,sideways,subdivisions)

draws a 90 degree curve out of linesegments, the number of which is determined by
subdivisions. After the curve, the current orientation is rotated accordingly.
Curve automatically uses and increases the current xoff value to get perfect texturing,
and thus also allows multiple curves to be fitted together perfectly. Remember to
call xoff(0) after a series of curves to reset its value when needed. 

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

same as the two commands above, but now as extra also assign the other
sidedef to the last sector created before this one, i.e. this new
sector is created inside the last sector.

        thing

Creates a thing of the current thingtype, with the current vertex
as position (default is playerstart). You can change the type of
thing being added by using

	setthing(id)

where "id" you have to take from uds.txt, or better still use
monsters.h / pickups.h / decoration.h / spawns.h include files instead.

	linetype(type,tag)

Sets the current type & tag for lines being drawn. Needs to be reset to 0
manually. (see below for how to use tags).

	sectortype(type,tag)

sets current type & tag for the next sectors being creates. Needs to be reste
to 0 manually. (see below for how to use tags).

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
executed. WadC automatically removes textures on doublesided linedefs upon 
saving the wad, and currently there is no support for transparent textures etc. 
The upside is that it is impossible to create a wad with missing texture HOMs. 
Tip: wrap all your texture uses in a function:

        lite5 { mid("LITE5") }

not only is it easier to write but it will make it extremely easy to experiment 
with alternative texture choices in a map.

        xoff(offset)
        yoff(offset)

set the current texture offsets. don't forget to set them back to 0 when done.

        unpegged

sets both lower & upper unpegged. calling it again resets to normal.

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

    mute
    
any following monsters will be muted. Calling it again switches it off again.

    easy
    hurtmeplenty
    ultraviolence

any following monsters (calls to "thing") are available only from the said skill
and upwards

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

