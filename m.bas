10 print "Welcome to the Haunted Mansion"
20 setLocations()
30 player_loc = 1






rem Main loop
100 print "You are in the " ;locs$(player_loc)




2999 end
3000 proc setLocations()
3010 locs_len=8: dim locs$(locs_len)
rem SKIP 0, zero is a special "nil" location
3020 for n = 1 to locs_len: read v$ : locs$(n) = v$ : next
3025 endproc

3030 data "Foyer"
3040 data "Kitchen"
3050 data "Living Room"
3060 data "Green House"
3080 data "Small Bedroom"
3090 data "Large Bedroom"
3100 data "Upstairs Hallway"
3110 data "Attic"
