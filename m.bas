5 REM - Haunted Mansion by Dagen Brock

10 cls: prompt_options()
20 loc_cnt=9 : dim loc$(loc_cnt) : dim loc_exit(loc_cnt,6) : dim loc_desc$(loc_cnt) : dim loc_desc2$(loc_cnt)
25 obj_cnt = 4 : dim obj_desc$(obj_cnt) : dim obj_loc(obj_cnt)

30 restore
50 init_display()
55 if graphics_on then gfx_title()
60 print "Welcome to the Haunted Mansion" : print "": print ""

70 player_loc = 1 : player_alive = true : player_hidden = false : player_win = false
75 wolf_act = true : ghost_act = true : fridge_open = false : lamp_lit = false
80 set_locations() : set_objects()


rem Main loop - input & parsing
100 if player_win = true then goto 320
105 display_room()
110 if player_alive = false then goto 350
120 print "" : input "> "; in$ : print ""
130 valid_cmd = false
REM note we check many alternates
140 if left$(in$,2) = "go" then cmd_go()
141 if in$ = "north" then in$ = "go north" : cmd_go()
142 if in$ = "south" then in$ = "go south" : cmd_go()
143 if in$ = "east" then in$ = "go east" : cmd_go()
144 if in$ = "west" then in$ = "go west" : cmd_go()
145 if in$ = "up" then in$ = "go up" : cmd_go()
146 if in$ = "down" then in$ = "down" : cmd_go()

150 if left$(in$,3) = "inv" then cmd_inventory()
160 if left$(in$,4) = "look" then cmd_look_objects()
170 if left$(in$,4) = "take" then cmd_take_object()
171 if left$(in$,3) = "get" then cmd_take_object()
180 if left$(in$,4) = "drop" then cmd_drop_object()
181 if left$(in$,5) = "throw" then cmd_drop_object()
190 if left$(in$,4) = "help" then cmd_help()
191 if left$(in$,1) = "?" then cmd_help()
200 if left$(in$,6) = "unlock" then cmd_unlock()
210 if in$ = "open fridge" then cmd_open_fridge()
220 if in$ = "light lamp" then cmd_light_lamp()
221 if in$ = "turn on lamp" then cmd_light_lamp()
222 if in$ = "run" then cmd_run()
223 if in$ = "hide" then cmd_hide()
230 if left$(in$,3) = "eat" then cmd_nope()
240 if left$(in$,3) = "quit" then end




290 if valid_cmd = false then print "What do you mean?" :print  ""
300 goto 100


REM ************ player win
320 print "": print "You are free.": print ""
330 input "Would you like to play again? (y/n) "; in$ : print ""
340 if in$ = "y" then goto 30
345 print "": print "Goodbye!" : end


REM ************ player death
350 print "": print "You are dead.": print ""
360 input "Would you like to play again? (y/n) "; in$ : print ""
370 if in$ = "y" then goto 30
380 print "": print "Goodbye!" : end


REM ************************************* cmd_nope()
400 proc cmd_nope()
401 valid_cmd = true
405 n = int(rnd(1)*3)
410 if n = 0 then print "Nope."
420 if n = 1 then print "No way."
430 if n = 2 then print "Nah."
435 endproc

REM ************************************* cmd_help()
450 proc cmd_help()
451 valid_cmd = true
455 print "Try using commands like: go, take, drop, inventory, light, unlock, run, hide."
460 print "I only understand lowercase words."
465 endproc

REM ************************************* cmd_go()
500 proc cmd_go()
501 valid_cmd = true
505 buf = 0
510 if right$(in$,5) = "north" then buf=loc_exit(player_loc,0)
520 if right$(in$,5) = "south" then buf=loc_exit(player_loc,1)
530 if right$(in$,4) = "east" then buf=loc_exit(player_loc,2)
540 if right$(in$,4) = "west" then buf=loc_exit(player_loc,3)
545 if right$(in$,2) = "up" then buf=loc_exit(player_loc,4)
546 if right$(in$,8) = "upstairs" then buf=loc_exit(player_loc,4)
547 if right$(in$,4) = "down" then buf=loc_exit(player_loc,5)
548 if right$(in$,10) = "downstairs" then buf=loc_exit(player_loc,5)
550 if buf <> 0
551  if buf = 5 then if player_loc = 1 then ghost_steps = 5
555  player_loc = buf
556  if player_loc = 9 then wolf_steps = 3 
557  player_hidden = false
558  if player_loc = 10 then player_win = true
560 else 
565  print "You cannot go in that direction."
570 endif
600 endproc

REM ************************************* cmd_look_objects()
700 proc cmd_look_objects()
701 valid_cmd = true
705 found_obj = false
710 for i=1 TO obj_cnt
720 if obj_loc(i)=player_loc then print "  You see "; obj_desc$(i) :print ""
730 next
740 endproc


REM ************************************* cmd_inventory()
800 proc cmd_inventory()
801 valid_cmd = true
810 print "You are carrying: "
820 empty_inv = true
830 for i = 1 to obj_cnt
840  if obj_loc(i) = 0
850   empty_inv = false
860   print " "; obj_desc$(i)
870  endif
880 next
890 if empty_inv=true then print " ... nothing"
895 endproc


REM ************************************* cmd_drop_object()
900 proc cmd_drop_object()
901 valid_cmd = true
905 identify_object_strings()
906 if obj = 2 then if lamp_lit = true then print "You can't drop a lit lamp!": goto 935
910 if obj_loc(obj) = 0 
915  obj_loc(obj) = player_loc : print "  You have tossed aside "; obj_desc$(obj); "." : print ""
920 else
925  print "You don't have that object.": print ""
930 endif
935 endproc
 

REM ************************************* cmd_take_object()
950 proc cmd_take_object()
951 valid_cmd = true
955 identify_object_strings()
REM the above sets `obj` to object number in string or 0
960 if obj_loc(obj) = player_loc
963  obj_loc(obj) = 0 : print "  You have picked up "; obj_desc$(obj) : print ""
964  if obj = 3 then loc_desc2$(player_loc) = "It smells and there's an empty open fridge. The foyer is west."
965  if obj = 1 
966   print "": print "  YES, You got the KEY!":print "": print "As you pick it up the storm lessens and the house feels a little less gloomy."
967   print "": print "You only need to go out the front door to finally escape this trap of a house." : print ""
968   ghost_act = false : loc_desc2$(1) = "Stairs lead to a second floor, the door out is south, but it's still locked!"
969  endif
970 else
975   print "You don't see that object in here." 
980 endif
990 endproc

REM ************************************* cmd_open_fridge
1000 proc cmd_open_fridge()
1001 valid_cmd = true
1005 if fridge_open = true then goto 1070
1010 if player_loc <> 2
1020  print "What fridge are you talking about?"
1030 else
1040  print "You've done it!  You opened the fridge!" : print ""
1041  print "Thankfully, the smell wasn't coming from in there.": print ""
1045  loc_desc2$(player_loc) = "It stinks in here. There's a nice looking raw steak inside of the fridge."
1050  obj_loc(3) = 2 : fridge_open = true
1060 endif
1070 endproc

REM ************************************* cmd_light_lamp
1100 proc cmd_light_lamp()
1101 valid_cmd = true
1105 if obj_loc(2) <> 0 then print "You don't have one." : goto 1150
1110 lamp_lit = true
1120 loc_desc2$(1) = "Stairs lead to a second floor, and with your lit lamp you can make your way up!"
1130 loc_exit(1,4) = 5 :rem upstairs hallway
1140 print "  Your lamp is lit! You feel a little less afraid.": print ""
1150 endproc



REM ************************************* cmd_hide()
1200 proc cmd_hide()
1201 valid_cmd = true
1210 if player_loc < 6 then print "There's nowhere to hide in this area." : goto 1280
1211 if player_loc >8 then print "That won't help you here." : goto 1280
1212 if ghost_act = false then print "There's no need." : goto 1280
1220 player_hidden = true
1230 if player_loc = 8 
1240  print "You've found a spot in-between a stack of boxes to hide."
1250 else 
1260  print "You dive under the bed as quitely as you can and hide in the darkess."
1270 endif
1280 endproc

REM ************************************* cmd_run()
1300 proc cmd_run()
1301 valid_cmd = true
1310 if ghost_act = false then print "You don't need to do that." : goto 1350
1311 if player_loc < 5 then print "There's no need." : goto 1350
1312 if player_loc >8 then print "That won't help here." : goto 1350
1320 print "" : print "You bravely run away!" : print "" :print "Panting and out of breath, you're back at the bottom of the stairs."
1321 print "" : print "You're safe here, but you still can't unlock the front door so you should"
1322 print "consider working up the courage to explore more upstairs.": print ""
1330 player_loc = 1
1350 endproc


REM ************************************* cmd_unlock()
1400 proc cmd_unlock()
1401 valid_cmd = true
1405 print ""
1410 if obj_loc(1) <> 0 then print "You don't have a key." : goto 1450
1411 if player_loc <> 1 then print "Unlock what?  Maybe this isn't the place" : goto 1450
1420 print "Without a moment of hesitation, you unlock the door. Freedom feels close.": print ""
1430 loc_exit(1,1) = 10
1440 loc_desc2$(1) = "Stairs lead to a second floor, but the south exit door is unlocked!"
1450 endproc


2000 proc display_room()
2010 box_string(loc$(player_loc))
2020 print "" : print "You are in "; loc_desc$(player_loc) : print "": print loc_desc2$(player_loc)
2030 if player_loc = 9 then handle_wolf()
2040 if player_loc >= 5 then if player_loc <= 8 then handle_ghost()
2100 endproc

2500 proc handle_wolf()
2505 print ""
2510 if wolf_act = false
2520  print "The werewolf has gone away."
2530 else
2535  if obj_loc(3) = 9 :rem steak
2540   print "As soon as the steak hits the ground you see a dark blur leap across the path."
2541   print "":print "The monster snatches the meat and bounds over a fence, running into the night."
2542   print "":print "The path to the greenhouse is now safe to traverse."
2543   wolf_act = false : wolf_steps = 99 : loc_exit(9,0)=4
2550  endif
2565  if obj_loc(4) = 9 :rem spinner
2566   print "As your fidget spinner hits the ground, it gleams in the moonlight."
2567   print "":print "This draws the horrible werewolf right to you, immediately it tears into you."
2568   print "":print "You fall to the ground in a warm pool of blood as the world fades away.": player_alive = false
2570  else
2575   wolf_steps = wolf_steps -1
2580   if wolf_steps = 2 then print "You heard something horrifying. You should go back inside!"
2585   if wolf_steps = 1 then print "You hear growling and feel the ground shaking. Leave!"
2590   if wolf_steps = 0
2595    print "You hear a slashing noise and see pieces of your face flying off as a werewolf"
2596    print "":print "tears you to bits. You fall down to a fury of blows as the world fades to black."
2597    player_alive = false : REM U DED LOL
2600   endif
2610  endif
2620 endif
2630 endproc

2700 proc handle_ghost()
2705 print ""
2710 if ghost_act = false
2720  print "The coast is clear.  You should get out of this place!"
2730 else
2740  if player_hidden = true then ghost_steps = 6: print "The specter has moved away.  You should get going."
2750  ghost_steps = ghost_steps - 1
2755  if ghost_steps = 4 then print " ... "
2760  if ghost_steps = 3 then print "You felt a chill. Something, not human, is approaching..."
2770  if ghost_steps = 2 then print "What was that?!  You definitely heard a noise. It's not safe here."
2780  if ghost_steps = 1 then print "It's COMING!  Run or hide, NOW!"
2790  if ghost_steps = 0
2800   print "There's a horrible crackling noise as the evil specter enters your body and "
2810   print "breaks all your bones from the inside. Luckily you have an immediate"
2820   print "heart attack and die from the pain.  ... wait no, that's not lucky at all."
2830   print "" : print "Maybe next time you should run or hide."
2840   player_alive = false : REM LOL DIE MOAR BRO!
2850  endif
2860 endif
2870 endproc


2999 end

REM ************************************* set_locations()
rem SKIP 0, zero is a special "nil" location
3000 proc set_locations()
3010 for n = 1 to loc_cnt: read loc$(n)
3015 read loc_exit(n,0), loc_exit(n,1), loc_exit(n,2), loc_exit(n,3), loc_exit(n,4), loc_exit(n,5)
3017 read loc_desc$(n), loc_desc2$(n)
3020 next
3025 endproc

rem name, n,s,e,w,u,d - some rooms are initially blocked (0)
3030 data "Foyer"           ,0,0,2,3,0,0
3035 data "a mostly empty foyer. There are doors to the east and west."
3036 data "Stairs lead to a second floor, but it's too dark to go up without some light!"
3040 data "Kitchen"         ,9,0,0,1,0,0
3045 data "a fairly cute kitchen. A door leads north to a grand estate garden."
3046 data "But what's that smell? Maybe something in the fridge."
3050 data "Living Room"     ,0,0,1,0,0,0
3055 data "a dark room full of dusty books and furniture. There's nothing here."
3056 data "You feel the a draft from the windows as the storm starts to blow harder."
3060 data "Green House"     ,0,2,0,0,0,0
3064 data "a rustic greenhouse. Moonlight shines in from above."
3065 data "The exit is to the south."
3070 data "Upstairs Hallway",0,0,7,6,8,1
3075 data "a hallway with large wood doors to the east and west."
3076 data "There's also another set of stairs leading up and the stairs back down."
3080 data "Small Bedroom"   ,0,0,5,0,0,0
3085 data "a small bedroom with creaky floors."
3086 data "It smells a bit moldy in here. The hallway is back to your east."
3090 data "Large Bedroom"   ,0,0,0,5,0,0
3095 data "a great bedroom full of strange art which makes you uncomfortable."
3096 data "The windows rattle as thunder rumbles through the house. You can exit west."
3110 data "Attic"           ,0,0,0,0,0,5
3115 data "an attic full of newspapers, magazines, and boxes covered in cobwebs."
3116 data "The area flashes brightly as lightning strikes outside. Stairs lead back down."
3120 data "Back Yard"       ,0,2,0,0,0,0
3125 data "the back yard standing outside the kitchen door to your south."
3126 data "Across the garden path to the north you see a dim light inside the greenhouse."

REM ************************************* set_objects()
3500 proc set_objects()
3510 rem objects and their locations (0=player,99=hidden)
3530 for i = 1 to obj_cnt: read obj_loc(i), obj_desc$(i): next
3540 move_key = int(rnd(1)*3) : obj_loc(1) = obj_loc(1) - move_key
3590 endproc
3600 data 8,"a key", 4,"an unlit lamp", 99,"a raw steak", 1,"a fidget spinner"

REM ************************************* identify_object_strings()
3700 proc identify_object_strings()
3710 obj = 0
3720 if right$(in$,3) = "key" then obj=1
3730 if right$(in$,4) = "lamp" then obj=2
3740 if right$(in$,5) = "steak" then obj=3
3750 if right$(in$,7) = "spinner" then obj=4
3790 endproc

REM ************************************* init_display()
5555 proc init_display()
5556 cls:bitmap on:bitmap clear $2: text "Haunted Mansion"dim 2 color 3 to 50,5
5557 print "":print"":print "":print "":print "":print ""
5558 endproc

REM ************************************* gfx_title()
6000 proc gfx_title()
6005 bitmap on
6006 print "Loading...";
6010 bload "title.img",$030000
6020 bload "title.pal",$7C00
6030 poke 1,1
6040 for i=0 to 254
6050  poke $D000+(i*4),peek($7C00+(i*4))
6060  poke $D001+(i*4),peek($7C01+(i*4))
6070  poke $D002+(i*4),peek($7C02+(i*4))
6080 next
6090 poke 1,0:poke $d103,$03
6095 cls: for i=1 to 64: print "" : next
6100 endproc

REM ************************************* box_string(s$)
7000 proc box_string(s$)
7010 l = len(s$)
7020 cprint chr$($a9);: for i = 0 to l+1 : cprint chr$($ad); : next : cprint chr$($aa)
7030 cprint chr$($ae); " "; s$; " "; chr$($ae)
7040 cprint chr$($ab);: for i = 0 to l+1 : cprint chr$($ad); : next : cprint chr$($ac)
7100 endproc

REM ************************************* prompt_options()
9000 proc prompt_options()
9010 print "":print "":print spc(15);:input "Would you like graphics? (y/N)",in$
9020 if in$ = "y" then graphics_on = true
9025 print "":print spc(20); "Graphics: ";
9026 if graphics_on then print "on"
9027 if graphics_on = false then print "off"
9030 print "":print spc(16);:input "Would you like sound? (y/N)",in$
9040 if in$ = "y" then sound_on = true
9045 print "":print spc(20); "Sound: ";
9046 if sound_on then print "on"
9027 if sound_on = false then print "off"
9050 endproc
