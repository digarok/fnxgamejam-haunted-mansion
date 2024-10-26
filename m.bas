5 init_display()
10 print "Welcome to the Haunted Mansion"
20 set_locations()
30 player_loc = 1
40 set_objects()






rem Main loop - input & parsing
100 print "" : print "You are in the " ;loc$(player_loc)
120 input "> "; in$
130 valid_cmd = false
140 if left$(in$,2) = "go" then valid_cmd = true : cmd_go()
150 if left$(in$,3) = "inv" then valid_cmd = true : cmd_inventory()
160 if left$(in$,4) = "look" then valid_cmd = true : cmd_look_objects()
170 if left$(in$,4) = "take" then valid_cmd = true : cmd_take_object()
171 if left$(in$,3) = "get" then valid_cmd = true : cmd_take_object()
180 if left$(in$,4) = "drop" then valid_cmd = true : cmd_drop_object()



190 if valid_cmd = false then print "What do you mean?"
200 goto 100

REM ************************************* cmd_go()
500 proc cmd_go()
505 buf = 0
510 if right$(in$,5) = "north" then buf=loc_exit(player_loc,0)
520 if right$(in$,5) = "south" then buf=loc_exit(player_loc,1)
530 if right$(in$,4) = "east" then buf=loc_exit(player_loc,2)
540 if right$(in$,4) = "west" then buf=loc_exit(player_loc,3)
550 if buf <> 0
555  player_loc = buf 
560 else 
565  print "You cannot go in that direction."
570 endif
600 endproc

REM ************************************* cmd_look_objects()
700 proc cmd_look_objects()
710 for i=1 TO obj_cnt
720 if obj_loc(i)=player_loc then print "You see "; obj_desc$(i) 
730 next
740 endproc


REM ************************************* cmd_inventory()
800 proc cmd_inventory()
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
905 identify_object_strings()
910 if obj_loc(obj) = 0 
915  obj_loc(obj) = player_loc : print "You have tossed aside "; obj_desc$(obj); "."
920 else
925  print "You don't have that object."
930 endif
935 endproc
 

REM ************************************* cmd_take_object()
950 proc cmd_take_object()
955 identify_object_strings()
REM the above sets `obj` to object number in string or 0
960 if obj_loc(obj) = player_loc
965  obj_loc(obj) = 0 : print "You have picked up "; obj_desc$(obj)
970 else
975   print "You don't see that object in here." 
980 endif
990 endproc

2999 end

REM ************************************* set_locations()
rem SKIP 0, zero is a special "nil" location
3000 proc set_locations()
3005 loc_cnt=9 : dim loc$(loc_cnt) : dim loc_exit(loc_cnt,6)
3010 for n = 1 to loc_cnt: read v$ : loc$(n) = v$
3015 read loc_exit(n,0), loc_exit(n,1), loc_exit(n,2), loc_exit(n,3), loc_exit(n,5), loc_exit(n,5)
3020 next
3025 endproc

rem name, n,s,e,w,u,d - some rooms are initially blocked (0)
3030 data "Foyer"           ,0,0,2,3,0,0
3040 data "Kitchen"         ,0,0,0,1,0,0
3050 data "Living Room"     ,0,0,1,0,0,0
3060 data "Green House"     ,0,2,0,0,0,0
3080 data "Small Bedroom"   ,0,0,6,0,0,0
3090 data "Large Bedroom"   ,0,0,0,6,0,0
3100 data "Upstairs Hallway",0,0,5,7,8,1
3110 data "Attic"           ,0,0,0,0,0,6
3120 data "Back Yard"       ,0,0,0,0,0,0

REM ************************************* set_objects()
3500 proc set_objects()
3510 rem objects and their locations (0=player,99=hidden)
3520 obj_cnt = 4 : dim obj_desc$(obj_cnt) : dim obj_loc(obj_cnt)
3530 for i = 1 to obj_cnt: read obj_loc(i), obj_desc$(i): next
3540 move_key = int(rnd(1)*2) : obj_loc(1) = obj_loc(1) - move_key
3590 endproc
3600 data 8,"a key", 4,"a lamp", 99,"a raw steak", 1,"a fidget spinner"

REM ************************************* identify_object_strings()
3700 proc identify_object_strings()
3710 obj = 0
3720 if right$(in$,3) = "key" then obj=1
3730 if right$(in$,4) = "lamp" then obj=2
3740 if right$(in$,3) = "steak" then obj=3
3750 if right$(in$,7) = "spinner" then obj=4
3790 endproc

REM ************************************* init_display()
5555 proc init_display()
5556 cls:bitmap on:bitmap clear $2: text "Haunted Mansion"dim 2 color 3 to 50,5
5557 print "":print"":print "":print "":print "":print ""
5558 endproc