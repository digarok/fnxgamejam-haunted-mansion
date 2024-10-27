5 REM - Haunted Mansion by Dagen Brock

10 loc_cnt=9 : dim loc$(loc_cnt) : dim loc_exit(loc_cnt,6) : dim loc_desc$(loc_cnt) : dim loc_desc2$(loc_cnt)
20 obj_cnt = 4 : dim obj_desc$(obj_cnt) : dim obj_loc(obj_cnt)
30 restore
50 init_display()
60 print "Welcome to the Haunted Mansion"
70 set_locations()
80 player_loc = 1: wolf_act = true: player_alive = true : fridge_open = false : lamp_lit = false
90 set_objects()







rem Main loop - input & parsing
100 display_room()
110 if player_alive = false then goto 350
120 print "" : input "> "; in$ : print ""
130 valid_cmd = false
140 if left$(in$,2) = "go" then cmd_go()
150 if left$(in$,3) = "inv" then cmd_inventory()
160 if left$(in$,4) = "look" then cmd_look_objects()
170 if left$(in$,4) = "take" then cmd_take_object()
171 if left$(in$,3) = "get" then cmd_take_object()
180 if left$(in$,4) = "drop" then cmd_drop_object()
190 if left$(in$,4) = "help" then cmd_help()
191 if left$(in$,1) = "?" then cmd_help()
210 if in$ = "open fridge" then cmd_open_fridge()
220 if in$ = "light lamp" then cmd_light_lamp()
221 if in$ = "turn on lamp" then cmd_light_lamp()
230 if left$(in$,3) = "eat" then cmd_nope()
240 if left$(in$,3) = "quit" then end




290 if valid_cmd = false then print "What do you mean?"
300 goto 100

REM ************ player death
350 print "": print "You are dead.": print ""
360 input "Would you like to play again? (y/n) "; in$ : print ""
370 if in$ = "y" then goto 50
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
455 print "Try using commands like: go, take, drop, inventory, light, unlock."
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
546 if right$(in$,4) = "down" then buf=loc_exit(player_loc,5)
550 if buf <> 0
555  player_loc = buf
556  if player_loc = 9 then wolf_steps = 3 
560 else 
565  print "You cannot go in that direction."
570 endif
600 endproc

REM ************************************* cmd_look_objects()
700 proc cmd_look_objects()
701 valid_cmd = true
710 for i=1 TO obj_cnt
720 if obj_loc(i)=player_loc then print "You see "; obj_desc$(i) 
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
915  obj_loc(obj) = player_loc : print "You have tossed aside "; obj_desc$(obj); "."
920 else
925  print "You don't have that object."
930 endif
935 endproc
 

REM ************************************* cmd_take_object()
950 proc cmd_take_object()
951 valid_cmd = true
955 identify_object_strings()
REM the above sets `obj` to object number in string or 0
960 if obj_loc(obj) = player_loc
965  obj_loc(obj) = 0 : print "You have picked up "; obj_desc$(obj)
966  if obj = 3 then loc_desc2$(player_loc) = "It smells and there's an empty open fridge. The foyer is west."
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
1041  print "Thankfully, the smell wasn't coming from in there."
1045  loc_desc2$(player_loc) = "It stinks in here. There's a nice looking raw steak inside of the fridge."
1050  obj_loc(3) = 2 : fridge_open = true
1060 endif
1070 endproc

REM ************************************* cmd_light_lamp
1100 proc cmd_light_lamp()
1101 valid_cmd = true
1110 lamp_lit = true
1120 loc_desc2$(1) = "Stairs lead to a second floor, and with your lit lamp you can make your way up!"
1130 loc_exit(1,4) = 5 :rem upstairs hallway
1140 print "Your lamp is lit! You feel a little less afraid."
1150 endproc


2000 proc display_room()
2010 print "" : cprint chr$(16);chr$(17); chr$(18); chr$(19); chr$(20); : print " ";loc$(player_loc)
2020 print "" : print "You are in "; loc_desc$(player_loc) : print "": print loc_desc2$(player_loc)
2030 if player_loc = 9 then handle_wolf()
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
3035 data "a mostly empty foyer. There are doors to the east and the west."
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
3075 data "a hallway with doors to the east and west."
3076 data "There's also another set of stairs leading up."
3080 data "Small Bedroom"   ,0,0,5,0,0,0
3085 data "a small bedroom with creaky floors."
3086 data "It smells a bit moldy in here."
3090 data "Large Bedroom"   ,0,0,0,5,0,0
3095 data "a great bedroom full of strange art which makes you uncomfortable."
3096 data "The windows rattle as thunder rumbles through the house."
3110 data "Attic"           ,0,0,0,0,0,5
3115 data "an attic full of newspapers, magazines, and boxes covered in cobwebs."
3116 data "The area flashes brightly as lightning strikes outside."
3120 data "Back Yard"       ,0,2,0,0,0,0
3125 data "the back yard standing outside the kitchen door to your south."
3126 data "Across the garden path to the north you see a dim light inside the greenhouse."

REM ************************************* set_objects()
3500 proc set_objects()
3510 rem objects and their locations (0=player,99=hidden)
3530 for i = 1 to obj_cnt: read obj_loc(i), obj_desc$(i): next
3540 move_key = int(rnd(1)*2) : obj_loc(1) = obj_loc(1) - move_key
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