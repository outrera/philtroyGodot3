# Philemon Troy and the Student Body Pageant

Philemon Troy and the Student Body Pageant is a point´n´click adventure/dating game in the vein of Leisure suit Larry. The version on GitHub will be censored to comply with TOS, the code and functionality will be the same as the full version.

Disclaimer: THIS IS A VERY BAREBONES GAME PROTYPE RIGHT NOW. DON`T DOWNLOAD THIS EXPECTING A GAME ANYWHERE NEAR COMPLETION. It´s basically a cube gliding around on a board, talking to other cubes :) To follow progress on art, go here: http://cultofape.com/album/?cws_album=6468617191931709873&cws_album_title=Phil%20Troy%20WIP

This Trello board is updated more frequently, if you want to track progress towards next release:
https://trello.com/b/MLCxDdmA/philemon-troy-and-the-student-body-pageant-roadmap

Near future plans:

Create a modular game engine (DIE - or Dynamic Interactive Engine) that can be extended with addons, and easily used for future games
Finish the dialogue and event system and make it an addon (ADDS - or Ape´s Dynamic Dialogue System)
Finish the dialogue editor (DIElog), because writing json-files for hand is killing me...
Create a bunch of json-files to test and validate the new dialogue and event functionality, find and eliminate weaknesses.

Actual game content will have to wait until at least june, as I expand and polish functionality that will enable my vision. Maybe create
a mini-game as a proof-of-concept? Also an important way to test Blender-Godot pipeline, using some simple environment and character models.

Some Google docs I´ve made to document code design:

Dynamic Interactive Engine (DIE)
https://docs.google.com/document/d/136s9Z87z-jAxGXymQQ2kSILJYRvtA6NvT7QcSoOp5Wk/edit?usp=sharing

Ape´s Dynamic Dialogue System (ADDS) – code document
https://docs.google.com/document/d/1Fk2ibcrorJhD-_Byec9JRJN6CGQvNFMw9pUllVV94jA/edit?usp=sharing

Ape´s Dynamic Dialogue System (ADDS) – dialogue JSON structure
https://docs.google.com/document/d/10JHm-Dq9DuULpQpPpKmPTZXTJBKEw0tCD9WauN_B3RE/edit?usp=sharing

DIElog – json based dialogue creator for the Dynamic Interactive Engine (DIE)
https://docs.google.com/document/d/1tceOjT8dSLx4fnuGmwi-P6tpnC-DcvGTiLniVz_p2RI/edit?usp=sharing

Updates:
=======

2017/05/09

Started converting the game to the Godot 3 API last week (for the fourth time..), and finished on monday of this week. After having
successfully restored all functionality from the 2.1 version I then started refactoring the code in a couple of ways:

1. Moved all UI functions from world.gd to a dedicated ui.gd
2. Renamed variables to make more sense.
3. Removed legacy variable from early development we don´t use anymore.
4. Restructured JSON-files to make them compatible with my plans for the event system

Furthermore, I´ve worked on completing the dialogue and event system, primarily by adding event overrides to global.gd (if one-off event
loaded, override location data when loading scene), and checks in dialogue.gd enabling loading of another json-file through the 
next-container instead of just the next branch within the same json, which opens more possibilities. Next it´s time to write some 
json-scripts to test location and event functionality.

I also added some opacity transition tween effect to the background blur when entering overlay UIs.

2017/08/31

So I keep adding and refining the dialogue system to better accommodate the event system I have planned.
I had a plan to follow, to have the event system done by the end of august, but I would honestly rather 
make a robust system than hurry this on..

There have been numerous small changes since the 20th. I just haven´t update the readme.

I have started to document my code, dialogue system docs below(incomplete, some parts not implemented yet):
https://docs.google.com/document/d/10JHm-Dq9DuULpQpPpKmPTZXTJBKEw0tCD9WauN_B3RE/edit?usp=sharing 

Now I have two weeks off work. I want to mainly work on replacing placeholder graphics with something more
presentable, but I will naturally have time to finish code functionality, too (finish dialogue system, code
event system). The goal to have a playable demo to present to online communities by the end of september 
still stands. This will be the first official alpha release (0.1.0)

2017/08/20

Functional map UI (clicking on map location will load respective scene)

2017/08/17 b (last update below was after midnight on the 16th:)

even more prepwork for events system

- store eventData in eventOverride
- added items to gameEvents.json for cancelling or not not showing up for event, to enable repercussions
- added global gameVars dictionary to hold variables affected by dialogue decisions
- added conditional to replies in dialogue.gd to alter eventData
- map_ui now emits a signal "exit_ui", which is emitted when clicking on a map item, closing the UI open
- the above called for making a ui_exit() function in world.gd, as to not duplicate functionality

NEXT is making map selection actually load a new scene. Event system groundwork is really starting to look more robust.
It really helps giving this alot of thought beforehand, then again it might fail miserably as soon as I hook everything up...
but I´m sure I´ll be able to fixt it up, if that happens.. I think :P

all this is basically the result of a few boring hours at work :)

2017/08/17

more prepwork for events system:

- add global.eventOverride
- created charData temp cache in dialogue.gd, to be able to override charData without overwriting it
- load gameEvents.json into global.eventData on ready
- check if event or not when global.load_scene()

I really think I need to get loading new scenes from map working before I continue, so I have something to work with

2017/08/16

Preparations toward event system

Been hard to focus, having to look for a new apartment. Luckily I was ahead of schedule before, so..

Alot of small changes in code, since my anxiety made it hard to work on bigger tasks. I did have the energy to think bout the upcoming events system though,
and a good json structure for what I want to do.

Basically events system will be based on different types of json files, with default values and overrides which can also be modified by relationship to characters. 
I think this makes for a dynamic system without making it too complex, but we´ll see when I try to actually make this work well in the gamecode...

- new events folder
- all events have their own json
- events can be one-offs or persistent
- each character has 5 default dialogues, depending on relationship value in charData
- charData holds default character dialogues
- locationData can override default dialogue
- eventData holds info on events that override default dialogue in both charData and locationData
- events can then change default dialogue (and other stuff in game, of course) depending on outcome
also
- calendar json controls event notifier system that pops up to the left of the screen, and the calendar

all this is still very much preliminary and might be changed, although I think it´s mostly in place. NOTHING IS HOOKED UP TO GAMECODE YET, though. This is all prep work.
That will be the task for this weekend.

2017/08/03

all submenus now go away on ESC.
made submenu UIs blocking, so game freezes when submenus are showing
changes in dialogue.gd, dialog is now dialogBox which is more descriptive
found out that I´m being kicked out of apartment, yay...

2017/08/02

Finally got the day/night cycle functionality working. When clicking on the calendar, NPCs and Objects (will) appear
in positions based on *location*.json
I´m sure some bug will creep up, but so far it looks good. Currently doesn´t really do much since *location*.json values
are mostly copied from day to day, but Ellie will move position going from morning to noon, so - working good enough! ;P

2017/08/01

Major (long overdue) reorganization of nodes and folder structure. Tedious job that needed to be done to make
future additions easier. With this, I think I can get back to implementing the day/night cycle functionality.

2017/07/31

Finished transferring NPCdialogue to global.charData

spent an hour chasing down a bug related to trying to set NPC identity data that wasn´t there...

Sanitized dialogue.gd by creating two container vars for common dictionary searches

branch = talkData["dialogue"][global.charData[npc]["branch"]]
replies = talkData["dialogue"][global.charData[npc]["branch"]]["replies"]

Looks a lot less convoluted now

next, make time progression actually do something, ie
- reload scene with data from location.json (which characters present, position, dialogue, branch)

next challenge (which I should have thought about)
- npcs should have different dialogues depending on time of day, meaning global.charData["dialogue"]
should be a 4 item array. Needs to be referenced correctly in dialogue.gd as well.. 

2017/07/30

prepared for day/night cycle functionality
- added "day", "month", "weekday", and "time" to gameData, which I moved to global.gd
- date label now dynamically updates with gametime progression
- click on calendar to progress time. Nothing happens, for now, except date label updating

created charData dictionary to hold json and branch info of all characters. Not hooked up to dialogue.gd yet..

started working on schoolbag and map UI. Just placeholder graphics and they won´t exit on esc yet..

also moved load_json() func to global.gd as it won´t be used by the dialogue script only

2017/07/29

Implemented 
- start and settings menu
- scene switching

Sanitized scene panel and world.gd script
- renamed nodes to better reflect their function
- grouped nodes under appropriate container 
- went through world.gd and renamed variables to follow camel case convention.

2017/07/28

- Moved all player script functions to player.gd from world.gd, further modularizing the game
- Cleaned up code, renamed "ui_elements" node to just "ui"
- created global.gd to handle higher level game functions, like quitting game/calling game menu/scene switching (for now)

2017/07/27

The last week has been spent (apart from a weekend on the French riviera:)extracting the dialogue system used in PhilTroy, expanding and modularizing it (for easier reutilization in other games) and putting it back into PhilTroy. The end result is called "Ape´s Dynamic Dialogue System" (or ADDS for short) This is an important step, which at first glance doesn´t seem all that significant, but the new features of this system are:

- NPCs remember what they´ve talked about before
- You can flip through replies and select reply with the keyboard
- You can alter game variables through dialogue choices
- Dialogue paging allows for longer dialogues
- custom talk animations per dialogue
- custom backgrounds per dialogue
- all dialogue functionality moved to its own script
- code was cleaned up for better readability

You can check the junkheap repository > extended dialogue system for full feature list.

ADDS will be made into a plugin, but that´s for later.

2017/07/16

Implemented simple turn and move towards functionality.
still some polishing needed. Player should move towards NPC before talking. ~~Turn speed should be relative to distance to target (with min and max speeds), and if close to target, player should turn without moving~~. Not hard to do, just need to take the time.

2017/07/09

version 0.0.2 alpha

- created a start_dialogue() function and moved over everything from load_json() that had nothing to do with actually loading a json (I might want to use it for other things tha dialogue...).
- started implementing RMB look at-functionality
- created a kill_dialogue() function since functionality is used more than once
- finished converting Player, NPC´s and objects to instanced asset scenes
- ESC to exit Phone UI and restore UI icons
- General code cleanup and reorganizing

2017/07/08

First alpha, let´s call it v0.0.1 :)
Very basic functionality, and placeholder graphics (or programmer art if you will;)

Features:

Move player around with mouseclick (be the testcube!)
UI hover effects
Dialogue system based on json
simple object and character collision

Manual:

LMB-click to initiate conversation
RMB-click to look at things, for more detalied descriptions
ESC to exit all UI dialogs
CTRL+Q to quit game
