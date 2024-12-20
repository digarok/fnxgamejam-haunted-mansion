5 REM Haunted Mansion by Dagen Brock
6 REM https://github.com/digarok/fnxgamejam-haunted-mansion
7 REM  part of the October 2024 F256 Game Jam
8 REM  big thanks to dwsJason for organizing!

10 cls: prompt_options() 
20 loc_cnt=9 : dim loc$(loc_cnt) : dim loc_exit(loc_cnt,6) : dim loc_desc$(loc_cnt) : dim loc_desc2$(loc_cnt)
25 obj_cnt = 4 : dim obj_desc$(obj_cnt) : dim obj_loc(obj_cnt)
30 if graphics_on then set_gfx_files()

50 restore
55 init_display()

70 player_loc = 1 : player_alive = true : player_hidden = false : player_win = false
75 wolf_act = true : ghost_act = true : fridge_open = false : lamp_lit = false : last_loc=0
80 set_locations() : set_objects()
85 if graphics_on then for i=1 to 60 : print:next
90 intro_story()


rem Main loop - input & parsing
100 if player_win = true then goto 320
110 display_room()
120 if player_alive = false then goto 340
130 print:input "> ";in$ :print
140 cmd_ok = false
REM note we check many alternates
150 if left$(in$,2) = "go" then cmd_go()
151 if in$ = "north" then in$ = "go north" : cmd_go()
152 if in$ = "south" then in$ = "go south" : cmd_go()
153 if in$ = "east" then in$ = "go east" : cmd_go()
154 if in$ = "west" then in$ = "go west" : cmd_go()
155 if in$ = "up" then in$ = "go up" : cmd_go()
156 if in$ = "down" then in$ = "down" : cmd_go()

160 if left$(in$,3) = "inv" then cmd_inventory()
170 if left$(in$,4) = "look" then cmd_look_objects()
180 if left$(in$,4) = "take" then cmd_take_object()
181 if left$(in$,3) = "get" then cmd_take_object()
190 if left$(in$,4) = "drop" then cmd_drop_object()
191 if left$(in$,5) = "throw" then cmd_drop_object()
192 if left$(in$,4) = "toss" then cmd_drop_object()
200 if left$(in$,6) = "unlock" then cmd_unlock()
210 if in$ = "open fridge" then cmd_open_fridge()
211 if in$ = "open refridgerator" then cmd_open_fridge()
220 if left$(in$,5) = "light" then cmd_light_lamp()
221 if left$(in$,7) = "turn on" then cmd_light_lamp()
222 if in$ = "run" then cmd_run()
223 if in$ = "hide" then cmd_hide()
230 if left$(in$,3) = "eat" then cmd_nope()
231 if left$(in$,3) = "jump" then cmd_nope()
232 if left$(in$,3) = "die" then cmd_nope()
240 if left$(in$,3) = "quit" then end
250 if left$(in$,4) = "help" then cmd_help()
251 if left$(in$,1) = "?" then cmd_help()

290 if cmd_ok = false then print "What do you mean?":print
300 goto 100


REM ************ player win
320 end_story()
330 goto 350
REM ************ player death
340 print: print "You are dead.": print
REM ************ play again?
350 input "Would you like to play again? (y/n) "; in$ : print
360 if in$ = "y" then goto 50
370 print: print "Goodbye!" : bitmap off: end

REM ********************* cmd_nope()
400 proc cmd_nope()
401 cmd_ok = true
410 print "Nope.":print
440 endproc

REM ********************* cmd_help()
450 proc cmd_help()
451 cmd_ok = true
455 print "Try using commands like: go, take, drop, inventory, light, unlock, run, hide."
460 print:print "I only understand lowercase words.":print
465 endproc

REM ********************* cmd_go()
500 proc cmd_go()
501 cmd_ok = true
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
555  last_loc = player_loc : player_loc = buf
556  if player_loc = 9 then wolf_steps = 3 
557  player_hidden = false
558  if player_loc = 10 then player_win = true
560 else 
565  print "You cannot go in that direction.":print
570 endif
600 endproc

REM ********************* cmd_look_objects()
700 proc cmd_look_objects()
701 cmd_ok = true
705 found_obj = false
710 for i=1 TO obj_cnt
720 if obj_loc(i)=player_loc then print "  You see ";obj_desc$(i): print
730 next
740 endproc


REM ********************* cmd_inventory()
800 proc cmd_inventory()
801 cmd_ok = true
810 print "You are carrying: ":print
820 empty_inv = true
830 for i = 1 to obj_cnt
840  if obj_loc(i) = 0
850   empty_inv = false
860   print "  "; obj_desc$(i)
870  endif
880 next
890 if empty_inv=true then print " ... nothing"
893 print
895 endproc


REM ********************* cmd_drop_object()
900 proc cmd_drop_object()
901 cmd_ok = true
905 identify_object_strings()
906 if obj = 2 then if lamp_lit = true then print "You can't drop a lit lamp!": goto 935
910 if obj_loc(obj) = 0 
915  obj_loc(obj) = player_loc : print "  You have tossed aside "; obj_desc$(obj); ".":print
920 else
925  print "You don't have that object.":print
930 endif
935 endproc
 
REM ********************* cmd_take_object()
950 proc cmd_take_object()
951 cmd_ok = true
955 identify_object_strings()
REM the above sets `obj` to object number in string or 0
960 if obj_loc(obj) = player_loc
963  obj_loc(obj) = 0 : print "  You have picked up "; obj_desc$(obj):print
964  if obj = 3 then loc_desc2$(player_loc) = "It smells and there's an empty open fridge. The foyer is west."
965  if obj = 1 
966   print:print "  YES, You got the KEY!":print:print "As you pick it up the storm lessens and the house feels a little less gloomy."
967   print:print "You only need to go out the front door to finally escape this trap of a house." : print
968   ghost_act = false : loc_desc2$(1) = "Stairs lead to a second floor, the door out is south, but it's still locked!"
969  endif
970 else
975   print "You don't see that object in here." 
980 endif
990 endproc

REM ********************* cmd_open_fridge
1000 proc cmd_open_fridge()
1001 cmd_ok = true
1005 if fridge_open = true then goto 1070
1010 if player_loc <> 2
1020  print "What fridge are you talking about?":print
1030 else
1040  print "You've done it! You opened the fridge! Great success." : print
1041  print "Thankfully, the smell wasn't coming from in there. But you see something.": print
1045  loc_desc2$(player_loc) = "It stinks in here. There's a nice looking raw steak inside of the fridge."
1050  obj_loc(3) = 2 : fridge_open = true
1060 endif
1070 endproc

REM ********************* cmd_light_lamp
1100 proc cmd_light_lamp()
1101 cmd_ok = true
1105 if obj_loc(2) <> 0 then print "You don't have one." : goto 1150
1110 lamp_lit = true
1120 loc_desc2$(1) = "Stairs lead to a second floor, and with your lit lamp you can make your way up!"
1130 loc_exit(1,4) = 5 :rem upstairs hallway
1140 print "  Your lamp is lit! You feel a little less afraid.": print
1150 endproc

REM ********************* cmd_hide()
1200 proc cmd_hide()
1201 cmd_ok = true
1210 if player_loc < 6 then print "There's nowhere to hide in this area.":print:goto 1280
1211 if player_loc >8 then print "That won't help you here.":print:goto 1280
1212 if ghost_act = false then print "There's no need.":print:goto 1280
1220 player_hidden = true
1230 if player_loc = 8 
1240  print "You've found a spot in-between a stack of boxes to hide."
1250 else 
1260  print "You dive under the bed as quitely as you can and hide in the darkess."
1270 endif
1280 endproc

REM ********************* cmd_run()
1300 proc cmd_run()
1301 cmd_ok = true
1310 if ghost_act = false then print "You don't need to do that." : goto 1350
1311 if player_loc < 5 then print "There's no need." : goto 1350
1312 if player_loc >8 then print "That won't help here." : goto 1350
1320 print: print "You bravely run away!" : print:print "Panting and out of breath, you're back at the bottom of the stairs."
1321 print: print "You're safe here, but you still can't unlock the front door so you should"
1322 print "consider working up the courage to explore more upstairs.": print
1330 player_loc = 1
1350 endproc

REM ********************* cmd_unlock()
1400 proc cmd_unlock()
1401 cmd_ok = true
1405 print
1410 if obj_loc(1) <> 0 then print "You don't have a key." : goto 1450
1411 if player_loc <> 1 then print "Unlock what?  Maybe this isn't the place" : goto 1450
1420 print "Without a moment of hesitation, you unlock the door. Freedom feels close.": print
1430 loc_exit(1,1) = 10
1440 loc_desc2$(1) = "Stairs lead to a second floor, but the south exit door is unlocked!"
1450 endproc


2000 proc display_room()
2010 box_string(loc$(player_loc))
2020 print: print "You are in "; loc_desc$(player_loc) :print: print loc_desc2$(player_loc)
2030 if player_loc = 9 then handle_wolf()
2040 if player_loc >= 5 then if player_loc <= 8 then handle_ghost()
2050 if graphics_on
2055  poke 1,2
2056  for i = 80*15 to (80*33)-1: poke $c000+i,$20 :next
2057  poke 1,0
2060  if player_loc <> last_loc
2070   adr = room_gfx_loc(player_loc)
2080   memcopy adr,$9600 to $010000
2090   memcopy adr+$9600,$400 to $007C00
2100   memcopy $019600,320*120 poke $01
rem copy_pal()
2110   poke 1,1
2111   for i=0 to 254
2112    poke $D000+(i*4),peek($7C00+(i*4))
2113    poke $D001+(i*4),peek($7C01+(i*4))
2114    poke $D002+(i*4),peek($7C02+(i*4))
2115   next
2116  poke 1,0

2120  endif
2190 endif
2200 endproc

2500 proc handle_wolf()
2505 print
2510 if wolf_act = false
2520  print "The werewolf has gone away."
2530 else
2535  if obj_loc(3) = 9 :rem steak
2540   print "As soon as the steak hits the ground you see a dark blur leap across the path."
2541   print:print "The monster snatches the meat and bounds over a fence, running into the night."
2542   print:print "The path to the greenhouse is now safe to traverse."
2543   wolf_act = false : wolf_steps = 99 : loc_exit(9,0)=4
2550  endif
2565  if obj_loc(4) = 9 :rem spinner
2566   print "As your fidget spinner hits the ground, it gleams in the moonlight."
2567   print:print "This draws the horrible werewolf right to you, immediately it tears into you."
2568   print:print "You fall to the ground in a warm pool of blood as the world fades away.": player_alive = false
2570  else
2575   wolf_steps = wolf_steps -1
2580   if wolf_steps = 2 then print "You heard something horrifying. You should go back inside!"
2585   if wolf_steps = 1 then print "You hear growling and feel the ground shaking. Leave!"
2590   if wolf_steps = 0
2595    print "You hear a slashing noise and see pieces of your face flying off as a werewolf"
2596    print:print "tears you to bits. You fall down to a fury of blows as the world fades to black."
2597    player_alive = false : REM U DED LOL
2600   endif
2610  endif
2620 endif
2630 endproc

2700 proc handle_ghost()
2705 print
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
2830   print: print "Maybe next time you should run or hide."
2840   player_alive = false : REM LOL DIE MOAR BRO!
2850  endif
2860 endif
2870 endproc


2999 end

REM ********************* set_locations()
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
3060 data "Green House"     ,0,9,0,0,0,0
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

REM ********************* set_objects()
3500 proc set_objects()
rem objects and their locations (0=player,99=hidden)
3530 for i = 1 to obj_cnt: read obj_loc(i), obj_desc$(i): next
3540 move_key = int(rnd(1)*3) : obj_loc(1) = obj_loc(1) - move_key
3590 endproc
3600 data 8,"a key", 4,"a lamp", 99,"a raw steak", 1,"a fidget spinner"

REM ********************* identify_object_strings()
3700 proc identify_object_strings()
3710 obj = 0
3720 if right$(in$,3) = "key" then obj=1
3730 if right$(in$,4) = "lamp" then obj=2
3740 if right$(in$,5) = "steak" then obj=3
3745 if right$(in$,4) = "meat" then obj=3
3750 if right$(in$,7) = "spinner" then obj=4
3790 endproc

REM ********************* init_display()
5555 proc init_display()
5556 cls:bitmap on:bitmap clear $2: text "Haunted Mansion"dim 2 color 3 to 50,5
5557 print:print:print:print:print:print
5558 endproc

REM ********************* intro_story()
5600 proc intro_story()
5610 box_string("The Story")
5620 print : print "While walking home from a party, a thunderstorm suddenly builds up around you."
5625 print "It starts immediately pouring rain on you.  You have to duck under the stoop"
5630 print "of a beautiful old mansion to keep dry, but then you notice the door is open."
5635 print:print "Stepping inside to ask the owners if you can wait out the downpour,"
5640 print "the door suddenly shuts behind you locking you inside!": print
5650 print "You must find the key to open that door in order to leave the house!": print
5660 print "Be careful. You might not be alone.":print:print
5670 print:input "Press return to start.",in$:cls:for i=1 to 7:print:next
5680 if graphics_on then for i = 1 to 60 :print:next
5690 endproc

REM ********************* end_story()
5700 proc end_story()
5703 if graphics_on
5704  bload "outside.bin",$010000
5705  memcopy $019600,$400 to $007C00
5706  poke 1,1
5707  for i=0 to 254
5708   poke $D000+(i*4),peek($7C00+(i*4)):poke $D001+(i*4),peek($7C01+(i*4)):poke $D002+(i*4),peek($7C02+(i*4))
5709  next
5710  cls:for i= 1 to 60:print:next
5711  poke 1,02100 : memcopy $019600,320*120 poke $01
5712 endif

5715 box_string("The End!")
5716 if graphics_on then cls: for i=1 to 60 : print : next
5720 print:print "You walk outside and finally breath a sigh of relief.":print
5725 print "You start walking home. Thankfully the sky has cleared.  It's actually a "
5730 print "beautiful evening.": print
5735 print "You start to wonder if that all really happened. Did you really see something?":print
5740 print "Surely no one would ever believe this. Maybe it's time to invest in an umbrella."
5750 if obj_loc(4) = 0 
5755  print: print "You feel something in your pocket and reach for it. It's a fidget spinner."
5760  print: print "You give it a spin and can't help but laugh as you enjoy the walk home."
5765 endif
5770 print:print spc(35);"THE END":print:print:print spc(27); "Thank you for playing!!!":print:print
5780 endproc

REM ********************* box_string(s$)
7000 proc box_string(s$)
7010 l = len(s$)
7020 cprint chr$($a9);: for i = 0 to l+1 : cprint chr$($ad); : next : cprint chr$($aa)
7030 cprint chr$($ae); " "; s$; " "; chr$($ae)
7040 cprint chr$($ab);: for i = 0 to l+1 : cprint chr$($ad); : next : cprint chr$($ac)
7100 endproc

REM ********************* prompt_options()
9000 proc prompt_options()
9010 print:print:print spc(15);:input "Would you like graphics? (y/N)",in$
9020 if in$ = "y" then graphics_on = true
9050 endproc

9100 proc set_gfx_files()
9110 dim room_gfx$(10):dim room_gfx_loc(10)
9120 room_gfx$(0) = ""
9130 room_gfx$(1) = "foyer": room_gfx_loc(1) = $022C00
9140 room_gfx$(2) = "kitchen": room_gfx_loc(2) = $022C00 + ($9A00*1)
9150 room_gfx$(3) = "lr": room_gfx_loc(3) = $022C00 + ($9A00*2)
9160 room_gfx$(4) = "greenhouse": room_gfx_loc(4) = $022C00 + ($9A00*3)
9170 room_gfx$(5) = "hallway": room_gfx_loc(5) = $022C00 + ($9A00*4)
9180 room_gfx$(6) = "smallbr": room_gfx_loc(6) = $022C00 + ($9A00*5)
9190 room_gfx$(7) = "largebr": room_gfx_loc(7) =$022C00 + ($9A00*6)
9200 room_gfx$(8) = "attic": room_gfx_loc(8) = $022C00 + ($9A00*7)
9210 room_gfx$(9) = "backyard": room_gfx_loc(9) = $022C00 + ($9A00*8)

9290 print "LoADiNG ..."
9300 for i = 1 to 9
9310  print room_gfx$(i) + ".bin",room_gfx_loc(i)
9320  bload room_gfx$(i) + ".bin",room_gfx_loc(i)
9399 next
9400 endproc