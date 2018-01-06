globals [
  distancetraveled ; how far the car will have traveled at a given time
  WH               ; wheel y cooridinate (so that it is just touching the ground)
  rotsneeded       ; how many rotations a given wheel will need to complete in order to have gone one meter
  ]
to setup
  clear-all
  ask patches [set pcolor gray]                                    ; Makes everything white
  ask patches with [pycor < 10] [set pcolor black]                 ; add a black ground
  ask patches with [pxcor = 110 and pycor < 10] [set pcolor white] ; add finish line
  ask patches with [pxcor = 10 and pycor < 10] [set pcolor white]  ; add starting line
  if Driven_Wheel_Type = "Big" [                                   ; this will figure out what wheel has been selected and then build the wheel accordingly (this one is if the user has selected the big wheel)
    create-turtles 1 [setxy 10 14.85 set color gray set shape "wheel" set size 11 set heading 0] ; creates large wheel
    set WH 14.85                  ; necessary variable for animation to operate properly further on down the road
    set rotsneeded 3.13297135609  ; necessary variable for animation to operate properly further on down the road
  ]
  if Driven_Wheel_Type = "Small"[                                  ; this will figure out what wheel has been selected and then build the wheel accordingly (this one is if the user has selected the small wheel)
    create-turtles 1 [setxy 10 12.55 set color gray set shape "wheel" set size 6.25 set heading 0]
    set WH 12.55                  ; necessary variable for animation to operate properly further on down the road
    set rotsneeded 4.55704919376  ; necessary variable for animation to operate properly further on down the road
  ]
  reset-ticks                                   ; resets ticks (1 millisecond intervals)
  ask patch 64 45 [set plabel "Total Current:"] ; All these set up the display, I'm not going to comment all of them because that is simply a waste of time. If you can't figure out what they do then you shouldn't be looking at the code.
  ask patch 74 45 [set plabel "0"]              ; sets up left display
  ask patch 77 45 [set plabel "amps"]
  ask patch 64 42 [set plabel "Total Voltage:"]
  ask patch 74 42 [set plabel "0"]
  ask patch 77 42 [set plabel "volts"]
  ask patch 73 39 [set plabel "Distance:     1 meter (100 cm)"]
  ask patch 64 36 [set plabel "Base Weight (Force):"]
  ask patch 74 36 [set plabel "0"]
  ask patch 78 36 [set plabel "newtons"]
  ask patch 64 33 [set plabel "Work:"]
  ask patch 74 33 [set plabel "0"]
  ask patch 77 33 [set plabel "joules"]

  ask patch 90 45 [set plabel "Linear Velocity:"] ;sets up right display
  ask patch 100 45 [set plabel "0"]
  ask patch 103 45 [set plabel "mps"]
  ask patch 90 42 [set plabel "Angular Velocity:"]
  ask patch 100 42 [set plabel "0"]
  ask patch 103 42 [set plabel "rps"]
  ask patch 90 36 [set plabel "Mechanical Power:"]
  ask patch 100 36 [set plabel "0"]
  ask patch 103 36 [set plabel "watts"]
  ask patch 90 39 [set plabel "Electrical Power:"]
  ask patch 100 39 [set plabel "0"]
  ask patch 103 39 [set plabel "watts"]
  ask patch 90 33 [set plabel "Pre-Det Time:"]
  ask patch 100 33 [set plabel "0"]
  ask patch 103 33 [set plabel "secs"]

  ask patch 90 4 [set plabel "Distance Traveled:"] ;sets up lower dynamic display.
  ask patch 100 4 [set plabel "0"]
  ask patch 102 4 [set plabel "cm"]
  ask patch 90 2 [set plabel "Degrees Rotated:"]
  ask patch 100 2 [set plabel "0"]
  ask patch 104 2 [set plabel "degrees"]
end

to test                         ; the true set up area, you push this button and it will update and calculate the values live.
  let currenttime ticks * 0.001 ; variable declaration, currenttime is the current time in seconds.
  let TC 0                      ; variable declaration, total current (amps)
  let TV 0                      ; variable declaration, total voltage (volts)
  let mwatts 0                  ; variable declaration, mechanical power (in watts)
  let work 0                    ; variable declaration, work (in joules)
  let time 0                    ; variable declaration, time (in seconds)
  let ewatts 0                  ; variable declaration, electrical power (in waats)
  let weight 0                  ; variable declaration, weight (newtons)
  let deg 0                     ; variable declaration, what degree the wheel is currently at (degrees)
  let linearvelocity 0          ; variable declaration, the linear velocity of the wheel (meters per second)
  let baseweight 0.00980665 * Weight_of_Base ; variable declaration, this takes the user's input of the weight of the base and converts it from grams to newtons.
  let kill false                ; variable declaration, kill is used next to terminate the program before it encounters a pesky divide by zero error.


  ask patches with [pycor > 10 and pycor < 30 and pxcor < 20] [set plabel ""] ; removes any error messages.
  if Solar_Cells + Hydrogen_Cells = 0 [ ; Finds the possibility of a divide by zero error before it happens. This part targets the fuel cells.
    ask patch 13 22 [set plabel "No Power Source"] ; If they have no power source selected, let them know.
    set kill true ; kill the program after checking for any other problems.
  ]
  if Efficiency < 1 [ ; Finds the possibility of a divide by zero error before it happens. This part targets the efficiency.
    ask patch 16 24 [set plabel "Broken Motor (Zero Efficiency)"] ; If they have an efficiency of zero, let them know.
    set kill true ; kill the program after checking for any other problems.
  ]
  if baseweight = 0 [ ; Finds the possibility of a divide by zero error before it happens. This part targets the base weight.
    ask patch 14 26 [set plabel "Impossibly Light Base"] ; If they have a base made of nothing, let them know.
    set kill true ; kill the program, all problems have been checked for.
  ]
  if kill = true [ ; if there was a possible divide by zero error, kill the program.
    stop           ; kills the program
  ]



  if Wiring_Config = "Series" [ ; checks if wiring is set to series then calculates total current and voltage accordingly.
    set TC (Solar_Cells * .1273 + Hydrogen_Cells * .1062) / (Hydrogen_Cells + Solar_Cells) ; gets the average current of the cells.
    set TV (Solar_Cells * 2.85 + Hydrogen_Cells * .89)                                     ; gets the sum of the voltage of the cells.
  ]
  if Wiring_Config = "Parallel" [ ; checks if wiring is set to parallel then calculates total current and voltage accordingly.
    set TV (Solar_Cells * 2.85 + Hydrogen_Cells * .89) / (Hydrogen_Cells + Solar_Cells) ; gets the average of the voltage of the cells.
    set TC (Solar_Cells * .1273 + Hydrogen_Cells * .1062)                               ; gets the sum of the current of the cells.
  ]
  set ewatts TC * TV                                                 ; finds the electrical power by using the equation 'Power = Current * Voltage'
  set mwatts ewatts * (Efficiency / 100)                             ; uses the efficiency of the design/motor and the electrical power to calculate mechanical power
  set weight baseweight + Hydrogen_Cells * 1.41 + Solar_Cells * 0.52 ; finds the weight of the car, multiplying the number of solar cells and hydrogen cells by their respective weights in newtons and adding that to the weight of the base of the car, also in newtons
  set work weight * 1                                                ; finds work using the equation 'Work = Force * Distance' in which distance will be a constant of one meter and force will be the weight of the car in newtons.
  set time work / mwatts                                             ; finds time by reorganizing the equation 'Power = Work / Time' into 'Time = Work / Power'
  set linearvelocity 1 / time                                        ; finds the linear velocity using the equation 'Linear Velocity = Distance / Time' in which the distance will always be one meter and the time has been calculated in the previous equation.
  if currenttime > 0 [                                               ; the if statement avoids a divide by zero errror caused by ticks (or time) being zero.
    set deg ((rotsneeded * 360) * (ticks / time)) / 100              ; sets the degree that the wheel should currently be at by using stoichometry and a percent ratio.
  ]
                                       ; The following set values into the display table
  ask patch 74 45 [set plabel TC]      ; displays the value for total current
  ask patch 74 42 [set plabel TV]      ; displays the value for total voltage
  ask patch 74 36 [set plabel weight]  ; displays the value for weight
  ask patch 74 33 [set plabel work]    ; displays the value for work
  ask patch 100 45 [set plabel linearvelocity * 10] ; displays the value for linear velocity (multiplied by ten because of milliseconds being the interval here.)
  ask patch 100 42 [set plabel ((rotsneeded * 360) / (time / 10)) * 0.0174533] ; displays the value for the angular velocity of the wheel, multiplying by 0.0174533 to put it into radians. Calculated by taking the total degrees it will turn (the rotations needed * 360 deg) then diving by time.
  ask patch 100 36 [set plabel mwatts]          ; displays the value for mechanical power
  ask patch 100 39 [set plabel ewatts]          ; displays the value for electrical power
  ask patch 100 33 [set plabel time / 10]       ; displays the value for the total time it will take to travel one meter.
  ask patch 100 4 [set plabel distancetraveled] ; displays the value for the current distance the wheel has traveled
  ask patch 100 2 [set plabel deg]              ; displays the value for the current angle the wheel is at.
end




to go
  let currenttime ticks * 0.001 ; variable declaration, currenttime is the current time in seconds.
  let TC 0                      ; variable declaration, total current (amps)
  let TV 0                      ; variable declaration, total voltage (volts)
  let mwatts 0                  ; variable declaration, mechanical power (in watts)
  let work 0                    ; variable declaration, work (in joules)
  let time 0                    ; variable declaration, time (in seconds)
  let ewatts 0                  ; variable declaration, electrical power (in waats)
  let weight 0                  ; variable declaration, weight (newtons)
  let deg 0                     ; variable declaration, what degree the wheel is currently at (degrees)
  let linearvelocity 0          ; variable declaration, the linear velocity of the wheel (meters per second)
  let baseweight 0.00980665 * Weight_of_Base ; variable declaration, this takes the user's input of the weight of the base and converts it from grams to newtons.
  let kill false                ; variable declaration, kill is used next to terminate the program before it encounters a pesky divide by zero error.


  ask patches with [pycor > 10 and pycor < 30 and pxcor < 20] [set plabel ""] ; removes any error messages.
  if Solar_Cells + Hydrogen_Cells = 0 [ ; Finds the possibility of a divide by zero error before it happens. This part targets the fuel cells.
    ask patch 13 22 [set plabel "No Power Source"] ; If they have no power source selected, let them know.
    set kill true ; kill the program after checking for any other problems.
  ]
  if Efficiency < 1 [ ; Finds the possibility of a divide by zero error before it happens. This part targets the efficiency.
    ask patch 16 24 [set plabel "Broken Motor (Zero Efficiency)"] ; If they have an efficiency of zero, let them know.
    set kill true ; kill the program after checking for any other problems.
  ]
  if baseweight = 0 [ ; Finds the possibility of a divide by zero error before it happens. This part targets the base weight.
    ask patch 14 26 [set plabel "Impossibly Light Base"] ; If they have a base made of nothing, let them know.
    set kill true ; kill the program, all problems have been checked for.
  ]
  if kill = true [ ; if there was a possible divide by zero error, kill the program.
    stop           ; kills the program
  ]



  if Wiring_Config = "Series" [ ; checks if wiring is set to series then calculates total current and voltage accordingly.
    set TC (Solar_Cells * .1273 + Hydrogen_Cells * .1062) / (Hydrogen_Cells + Solar_Cells) ; gets the average current of the cells.
    set TV (Solar_Cells * 2.85 + Hydrogen_Cells * .89)                                     ; gets the sum of the voltage of the cells.
  ]
  if Wiring_Config = "Parallel" [ ; checks if wiring is set to parallel then calculates total current and voltage accordingly.
    set TV (Solar_Cells * 2.85 + Hydrogen_Cells * .89) / (Hydrogen_Cells + Solar_Cells) ; gets the average of the voltage of the cells.
    set TC (Solar_Cells * .1273 + Hydrogen_Cells * .1062)                               ; gets the sum of the current of the cells.
  ]
  set ewatts TC * TV                                                 ; finds the electrical power by using the equation. 'Power = Current * Voltage'
  set mwatts ewatts * (Efficiency / 100)                             ; uses the efficiency of the design/motor and the electrical power to calculate mechanical power.
  set weight baseweight + Hydrogen_Cells * 1.41 + Solar_Cells * 0.52 ; finds the weight of the car, multiplying the number of solar cells and hydrogen cells by their respective weights in newtons and adding that to the weight of the base of the car, also in newtons.
  set work weight * 1                                                ; finds work using the equation 'Work = Force * Distance' in which distance will be a constant of one meter and force will be the weight of the car in newtons.
  set time work / mwatts                                             ; finds time by reorganizing the equation. 'Power = Work / Time' into 'Time = Work / Power'
  set linearvelocity 1 / time                                        ; finds the linear velocity using the equation 'Linear Velocity = Distance / Time' in which the distance will always be one meter and the time has been calculated in the previous equation.
  if currenttime > 0 [                                               ; the if statement avoids a divide by zero errror caused by ticks (or time) being zero.
    set deg ((rotsneeded * 360) * (ticks / time)) / 100              ; sets the degree that the wheel should currently be at by using stoichometry and a percent ratio.
  ]
  set distancetraveled distancetraveled + linearvelocity ; sets the current distance traveled to the previous distance that had been traversed plus the linear velocity.

  ask turtles [if shape = "wheel"[set heading deg]] ; make the wheel face the angle it should be facing at this point in time based on the ratio in the deg variable's setup. (THIS COMMAND IS WHERE IT TURNS)
  ask turtles [if shape = "wheel"[setxy xcor + linearvelocity WH]] ; make the wheel move forward (along the X axis) at the speed of the linear velocity. Then make sure it stays at the right height for it's type. (WH) (THIS COMMAND IS WHERE IT MOVES)

  tick ; next tick, next millisecond.

  wait 0.001 ; ticks are in milliseconds.

                                       ; The following set values into the display table.
  ask patch 74 45 [set plabel TC]      ; displays the value for total current.
  ask patch 74 42 [set plabel TV]      ; displays the value for total voltage.
  ask patch 74 36 [set plabel weight]  ; displays the value for weight.
  ask patch 74 33 [set plabel work]    ; displays the value for work.
  ask patch 100 45 [set plabel linearvelocity * 10] ; displays the value for linear velocity (multiplied by ten because of milliseconds being the interval here.)
  ask patch 100 42 [set plabel ((rotsneeded * 360) / (time / 10)) * 0.0174533] ; displays the value for the angular velocity of the wheel, multiplying by 0.0174533 to put it into radians. Calculated by taking the total degrees it will turn (the rotations needed * 360 deg) then diving by time.
  ask patch 100 36 [set plabel mwatts]          ; displays the value for mechanical power.
  ask patch 100 39 [set plabel ewatts]          ; displays the value for electrical power.
  ask patch 100 33 [set plabel time / 10]       ; displays the value for the total time it will take to travel one meter.
  ask patch 100 4 [set plabel distancetraveled] ; displays the value for the current distance the wheel has traveled.
  ask patch 100 2 [set plabel deg]              ; displays the value for the current angle the wheel is at.

  if distancetraveled > 99.99999999999 [ ; terminate the program when the wheel has gone one meter.
    ask patch 90 6 [set plabel "Time:"]        ; display the time it took to go one meter.
    ask patch 100 6 [set plabel ticks * 0.001] ; display the time it took to go one meter. (converts ticks from milliseconds to seconds.)
    ask patch 103 6 [set plabel "secs"]        ; display the time it took to go one meter.
    stop]                                      ; terminate program.
end
@#$#@#$#@
GRAPHICS-WINDOW
209
11
1429
552
-1
-1
10.0
1
10
1
1
1
0
1
1
1
0
120
0
50
0
0
1
ticks
60.0

BUTTON
31
214
181
247
RESET
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
31
284
181
317
INITIATE RUN PHASE
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

CHOOSER
5
413
204
458
Wiring_Config
Wiring_Config
"Parallel" "Series"
1

SLIDER
6
465
203
498
Efficiency
Efficiency
0
100
44
1
1
NIL
HORIZONTAL

TEXTBOX
24
127
205
227
Changing the settings during the 'run' phase will give innacurrate results. \nUse the 'test' phase to see the relation between the inputs.
12
0.0
1

SLIDER
3
328
206
361
Hydrogen_Cells
Hydrogen_Cells
0
10
0
1
1
NIL
HORIZONTAL

SLIDER
4
372
205
405
Solar_Cells
Solar_Cells
0
10
1
1
1
NIL
HORIZONTAL

CHOOSER
5
507
204
552
Driven_Wheel_Type
Driven_Wheel_Type
"Big" "Small"
0

BUTTON
31
249
181
282
TEST PHASE
test
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

TEXTBOX
167
675
317
693
NIL
11
0.0
1

TEXTBOX
124
511
274
529
(requires reset)
11
0.0
1

SLIDER
5
559
1430
592
Weight_of_Base
Weight_of_Base
0
5000
706
1
1
NIL
HORIZONTAL

TEXTBOX
119
575
269
593
(grams)
11
0.0
1

TEXTBOX
356
14
768
80
HYDROGEN & SOLAR CAR SIMULATOR
18
0.0
1

TEXTBOX
765
95
1370
151
____________________________________________________________________________________
11
0.0
1

TEXTBOX
766
126
1423
182
____________________________________________________________________________________
11
0.0
1

TEXTBOX
766
155
1340
211
____________________________________________________________________________________
11
0.0
1

TEXTBOX
767
186
1328
242
____________________________________________________________________________________
11
0.0
1

TEXTBOX
326
444
1634
532
<-------------------------------------------------------------- ONE METER ------------------------------------------------------------>
18
99.9
1

@#$#@#$#@
## WHAT IS IT?

This is a simulation of a hydrogen and or solar powered car.

## HOW IT WORKS

First the user modifies the variables for the car.
- The weight of the car.
- How it is wired. (parallel or series)
- How many hydrogen and or solar cells it uses.
- The efficieny of the car.

From those variables, the program can calculate the total current, total voltage, electrical power, the total weight in newtons, the work done by the car, the mechanical power, the linear velocity of the car and angular velocity of the wheel.

It then uses the values it calculated to make the wheel turn and move the length of a meter. Reporting the time in seconds in the end.

## HOW TO USE IT

Begin by clicking the 'RESET' button, this will reset or setup the enviroment.

Then continue by entering the following variables.
- The weight of the car.
- How it is wired. (parallel or series)
- How many hydrogen and or solar cells it uses.
- The efficieny of the car.

You can press the 'TEST PHASE' button to see how changing the variables will modify the results before you run the simulation.

Once you are satisfied with how you have set up the variables, press the 'INITIATE RUN PHASE' button to begin the simulation. Do not changes the variables while the simulation is running, as it may return faulty data.

## CREDITS

Noah Boursier
12/3/16
POE 2016-2017
Activity 1.3.4
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

hydrogencell
false
6
Rectangle -13791810 true false 30 30 270 285
Rectangle -13791810 true false 30 15 135 60
Rectangle -13791810 true false 150 15 150 30
Rectangle -13791810 true false 165 15 270 45
Rectangle -13345367 true false 135 30 165 285
Rectangle -13345367 true false 30 45 135 60
Rectangle -13345367 true false 30 105 135 120
Rectangle -13345367 true false 30 165 135 180
Rectangle -13345367 true false 30 225 135 240
Rectangle -13345367 true false 165 225 270 240
Rectangle -13345367 true false 165 165 270 180
Rectangle -13345367 true false 165 105 270 120
Rectangle -13345367 true false 165 45 270 60

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

solarcell
false
6
Rectangle -7500403 true false 0 150 300 165
Rectangle -16777216 true false 0 135 300 150
Rectangle -16777216 true false 0 120 300 135
Rectangle -7500403 true false 0 120 15 150
Rectangle -7500403 true false 75 120 90 150
Rectangle -7500403 true false 150 120 165 150
Rectangle -7500403 true false 210 120 225 150
Rectangle -16777216 true false 285 120 300 150
Rectangle -16777216 true false 210 120 225 150
Rectangle -7500403 true false 225 120 240 150

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
true
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269
Circle -16777216 false false 3 3 294
Circle -7500403 true true 136 233 30
Circle -7500403 true true 135 37 30

wheeldeal
true
6
Circle -16777216 true false 0 0 300
Circle -7500403 true false 33 33 234
Line -7500403 false 180 105 150 120

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270

@#$#@#$#@
NetLogo 5.2.1
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180

@#$#@#$#@
0
@#$#@#$#@
