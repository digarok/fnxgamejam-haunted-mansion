10 print "Welcome to the Haunted Mansion"
20 set_locations()
30 player_loc = 1






rem Main loop - input & parsing
100 print "" : print "You are in the " ;loc$(player_loc)
120 input "> "; in$
130 valid_cmd = false
140 if left$(in$,2) = "go"
145  valid_cmd = true : cmd_go()
150 endif 


190 if valid_cmd = false then print "What do you mean?"
200 goto 100

500 proc cmd_go()
505 buf = 0
510 if right$(in$,5) = "north" then buf=loc_dir(player_loc,0)
520 if right$(in$,5) = "south" then buf=loc_dir(player_loc,1)
530 if right$(in$,4) = "east" then buf=loc_dir(player_loc,2)
540 if right$(in$,4) = "west" then buf=loc_dir(player_loc,3)
550 if buf <> 0
555  player_loc = buf 
560 else 
565  print "You cannot go in that direction."
570 endif
600 endproc

2999 end
rem SKIP 0, zero is a special "nil" location
3000 proc set_locations()
3005 loc_len=9 : dim loc$(loc_len) : dim loc_dir(loc_len,6)
3010 for n = 1 to loc_len: read v$ : loc$(n) = v$
3015 read loc_dir(n,0), loc_dir(n,1), loc_dir(n,2), loc_dir(n,3), loc_dir(n,5), loc_dir(n,5)
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
3120 data "Outside"         ,0,0,0,0,0,0