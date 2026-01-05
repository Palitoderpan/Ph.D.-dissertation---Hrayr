extensions [rnd csv] ;Use rnd extension to simulate draws from a Multinomial Distribution

globals [list1 list2 list3 list4
  list_profitsA list_profitsB list_profitsC list_profitsD
  list_cum_profits1 list_cum_profits2
  listchoice1 listchoice2 listchoice3 listchoice4 lchoice
  choiceA choiceB choiceC choiceD
  choiceA1A choiceA1B choiceA1C choiceA1D
  choiceA2A choiceA2B choiceA2C choiceA2D
  choiceA3A choiceA3B choiceA3C choiceA3D
  choiceA4A choiceA4B choiceA4C choiceA4D
  excessA excessB excessC excessD
  profits1 profits2 cum_profits1 cum_profits2 profitsA profitsB profitsC profitsD
  BMI1 BMI2 BMI3 BMI4
  bmiA1 bmiA2 bmiA3 bmiA4
  supplyA supplyB supplyC supplyD
  direct_costs indirect_costs total_direct_costs total_indirect_costs
  P1D P2D P3D P4D Prop_A4
  empirical-bmi-list simulated-bmi-list] ;List of global variables to draw plots

turtles-own[
  ;BMI
  junk_count
  healthy_count
  food_selection
  junk_supply
  healthy_supply
] ;List of variables for each agent: First four are for consumers, last two are for suppliers

breed [A1 autocontrolado_obesogenico]
breed [A2 autocontrolado_no_obesogenico]
breed [A3 impulsivo_obesogenico]
breed [A4 impulsivo_no_obesogenico] ;Four types of representative agents
breed [locales food_places] ;Two because there are two equivalence classes

A1-own [BMI]
A2-own [BMI]
A3-own [BMI]
A4-own [BMI]

to setup
  clear-all
  load-empirical-data
  setup-patches
  reset-ticks
  set list1 []
  set list2 []
  set list3 []
  set list4 []
  set listchoice1 []
  set listchoice2 []
  set listchoice3 []
  set listchoice4 []
  set lchoice []
  set BMI1 []
  set BMI2 []
  set BMI3 []
  set BMI4 []
  set list_profitsA []
  set list_profitsB []
  set list_profitsC []
  set list_profitsD []
  set list_cum_profits1 []
  set list_cum_profits2 []
  set P1D (1 - (P1A + P1B + P1C))
  ;print (word "Value of P1D is: " P1D)
  set P2D (1 - (P2A + P2B + P2C))
  ;print (word "Value of P2D is: " P2D)
  set P3D (1 - (P3A + P3B + P3C))
  ;print (word "Value of P3D is: " P3D)
  set P4D (1 - (P4A + P4B + P4C))
  ;print (word "Value of P4D is: " P4D)
  set Prop_A4 (1 - (Prop_A1 + Prop_A2 + Prop_A3))
  ;print (word "Value of Prop_A4 is: " Prop_A4)
  if (P1D < 0 or P1D > 1)
  [
    user-message (word "Invalid probability vector for Agent1. Double-check")
    stop
  ]
  if (P2D < 0 or P2D > 1)
  [
    user-message (word "Invalid probability vector for Agent2. Double-check")
    stop
  ]
  if (P3D < 0 or P3D > 1)
  [
    user-message (word "Invalid probability vector for Agent3. Double-check")
    stop
  ]
  if (P4D < 0 or P4D > 1)
  [
    user-message (word "Invalid probability vector for Agent4. Double-check")
    stop
  ]
  if (Prop_A4 < 0 or Prop_A4 > 1)
  [
    user-message (word "Invalid proportions of Agents. Double-check")
    stop
  ]
  create-A1 round Number_of_consumers * Prop_A1 ;Modify proportion of Agent 1 consumers (Obesogenic w/self-control)
  [
    set shape "person"
    set color orange
    set size 1
    setxy random-xcor random-ycor
    set junk_count 0
    set healthy_count 0
    set BMI random-normal meanBMI1 sdBMI1 ;Modify BMI of Agent 1 consumers (Obesogenic w/self-conttrol)
  ]
  create-A2 round Number_of_consumers * Prop_A2 ;Modify proportion of Agent 2 consumers (Non-obesogenic w/self-control)
  [
    set shape "person"
    set color white
    set size 1
    setxy random-xcor random-ycor
    set junk_count 0
    set healthy_count 0
    set BMI random-normal meanBMI2 sdBMI2 ;Modify BMI of Agent 2 consumers (Non-obesogenic w/self-control)
  ]
  create-A3 round Number_of_consumers * Prop_A3 ;Modify proportion of Agent 3 consumers (Obesogenic w/impulsivity)
  [
    set shape "person"
    set color red
    set size 1
    setxy random-xcor random-ycor
    set junk_count 0
    set healthy_count 0
    set BMI random-normal meanBMI3 sdBMI3 ;Modify BMI of Agent 3 consumers (Obesogenic w/impulsivity)
  ]
  create-A4 round Number_of_consumers * Prop_A4 ;Modify proportion of Agent 4 consumers (Non-obesogenic w/impulsivity)
  [
    set shape "person"
    set color yellow
    set size 1
    setxy random-xcor random-ycor
    set junk_count 0
    set healthy_count 0
    set BMI random-normal meanBMI4 sdBMI4 ;Modify BMI of Agent 4 consumers (Non-obesogenic w/impulsivity)
  ]
  create-locales 1
  [
    set shape "house"
    set color green
    set size 2.5
    setxy 15 15
    set junk_supply ((Supply_firm1 * Perc_junk_food_firm1) / 100)
    set healthy_supply (Supply_firm1 - junk_supply)
  ]
  create-locales 1
  [
    set shape "house"
    set color green
    set size 2.5
    setxy -15 -15
    set junk_supply ((Supply_firm2 * Perc_junk_food_firm2) / 100)
    set healthy_supply (Supply_firm2 - junk_supply)
  ]
  ;ifelse ((Prop_A1 + Prop_A2 + Prop_A3 + Prop_A4) != 1)
  ;  [
  ;    user-message "Warning: Proportions of agents must add up to one."
  ;  ]
  ;  [
  ;  ]
  ;ifelse ((Prop_A1 < 0) or  (Prop_A2 < 0) or (Prop_A3 < 0) or (Prop_A4 < 0))
  ;  [
  ;    user-message "Warning: Proportions must be non-negative."
  ;  ]
  ;  [
  ;  ]
  ifelse ((Prob_sick_underweight > 1) or (Prob_sick_underweight < 0) or (Prob_sick_overweight > 1) or (Prob_sick_overweight < 0) or
    (Prob_death_underweight > 1) or (Prob_death_underweight < 0) or (Prob_death_overweight > 1) or (Prob_death_overweight < 0))
  [
    user-message "Warning: Probabilities are values between 0 and 1."
  ]
  [
  ]
  ifelse (Prob_sick_overweight < Prob_sick_underweight)
  [
    user-message "Warning: The conditional probability of getting sick given a BMI > 25 is usually larger than the probability of getting sick given a BMI <= 25."
  ]
  [
  ]
  ifelse (Prob_death_overweight < Prob_death_underweight)
  [
    user-message "Warning: The conditional probability of dying prematurely given a BMI > 25 is usually larger than the probability of dying prematurely given a BMI <= 25."
  ]
  [
  ]
end

to go
  turtles-move-A1
  turtles-move-A2
  turtles-move-A3
  turtles-move-A4
  profits
  change-lambda
  change-BMI
  count-BMI
  economic-costs
  simulated-BMI
  set lchoice (sentence listchoice1 listchoice2 listchoice3 listchoice4)
  ;print (lchoice)
  set choiceA count turtles  with [food_selection = "A"]
  set choiceB count turtles  with [food_selection = "B"]
  set choiceC count turtles  with [food_selection = "C"]
  set choiceD count turtles  with [food_selection = "D"]
  set choiceA1A count turtles with [breed = A1 and (food_selection = "A")]
  set choiceA1B count turtles with [breed = A1 and (food_selection = "B")]
  set choiceA1C count turtles with [breed = A1 and (food_selection = "C")]
  set choiceA1D count turtles with [breed = A1 and (food_selection = "D")]
  set choiceA2A count turtles with [breed = A2 and (food_selection = "A")]
  set choiceA2B count turtles with [breed = A2 and (food_selection = "B")]
  set choiceA2C count turtles with [breed = A2 and (food_selection = "C")]
  set choiceA2D count turtles with [breed = A2 and (food_selection = "D")]
  set choiceA3A count turtles with [breed = A3 and (food_selection = "A")]
  set choiceA3B count turtles with [breed = A3 and (food_selection = "B")]
  set choiceA3C count turtles with [breed = A3 and (food_selection = "C")]
  set choiceA3D count turtles with [breed = A3 and (food_selection = "D")]
  set choiceA4A count turtles with [breed = A4 and (food_selection = "A")]
  set choiceA4B count turtles with [breed = A4 and (food_selection = "B")]
  set choiceA4C count turtles with [breed = A4 and (food_selection = "C")]
  set choiceA4D count turtles with [breed = A4 and (food_selection = "D")]
  set supplyA ((Supply_firm1 * (Perc_junk_food_firm1)) / 100)
  ;let supplyA (Supply_firm1 * lambda1)
  set supplyA round supplyA
  set supplyB ((Supply_firm1 * (100 - Perc_junk_food_firm1)) / 100)
  ;let supplyB ((Supply_firm1 * (1 - lambda1))
  set supplyB round supplyB
  set supplyC ((Supply_firm2 * (Perc_junk_food_firm2)) / 100)
  ;let supplyC (Supply_firm2 * lambda2)
  set supplyC round supplyC
  set supplyD ((Supply_firm2 * (100 - Perc_junk_food_firm2)) / 100)
  ;let supplyD ((Supply_firm2 * (1 - lambda2))
  set supplyD round supplyD
  set excessA (supplyA - choiceA)
  ;print (word "Tick " ticks ": excessA = " excessA)
  set excessB (supplyB - choiceB)
  ;print (word "Tick " ticks ": excessB = " excessB)
  set excessC (supplyC - choiceC)
  ;print (word "Tick " ticks ": excessC = " excessC)
  set excessD (supplyD - choiceD)
  ;print (word "Tick " ticks ": excessD = " excessD)

  if ticks = 200 [stop]
  tick
end

to setup-patches
  ask patches [set pcolor blue]
end

to change-lambda
  let mean-a 0
  let mean-b 0
  let mean-c 0
  let mean-d 0
  let var-a 1
  let var-b 1
  let var-c 1
  let var-d 1
  let lambda1 0.5
  let lambda2 0.5
  let validAB (length list_profitsA >= 4 and length list_profitsB >= 4)
  let validCD (length list_profitsC >= 4 and length list_profitsD >= 4)
  if validAB
  [
  set mean-a mean list_profitsA
  set mean-b mean list_profitsB
  set var-a variance list_profitsA
  set var-b variance list_profitsB
  let sd-a sqrt (var-a)
  let sd-b sqrt (var-b)
  let numerator1 sum (map [[x y] -> (x - mean-a) * (y - mean-b)] list_profitsA list_profitsB)
  let denominator1 sqrt (sum (map [x -> (x - mean-a) ^ 2] list_profitsA) * sum (map [y -> (y - mean-b) ^ 2] list_profitsB))
  ;print (word "Tick " ticks ": denominator1= " denominator1)
  if denominator1 > 0
    [
      ifelse denominator1 < 0.001
      [
        set lambda1 0.5
      ]
      [
      let rho1 (numerator1 / denominator1)
      ;print (word "Tick " ticks ": rho1= " rho1)
      let numerator-lambda1 (var-b - (rho1 * sd-a * sd-b))
      let denominator-lambda1 (var-a + var-b - (2 * rho1 * sd-a * sd-b))
      ifelse abs denominator-lambda1 < 0.001
      [
       set lambda1 0.5
      ]
      [
      set lambda1 (numerator-lambda1 / denominator-lambda1)
      if lambda1 < 0 or lambda1 > 1
        [
          ;print (word "Warning: lambda1 out of range: " lambda1)
          ;set lambda1 0.5
          set lambda1 max list 0.01 (min list lambda1 0.99)
          ;print (word "Warning: lambda1 out of range: " max list 0.01 (min list lambda1 0.99))
        ]
      ]
      ]
    ]
  ]
  if validCD
  [
  set mean-c mean list_profitsC
  set mean-d mean list_profitsD
  set var-c variance list_profitsC
  set var-d variance list_profitsD
  let sd-c sqrt (var-c)
  let sd-d sqrt (var-d)
  let numerator2 sum (map [[x y] -> (x - mean-c) * (y - mean-d)] list_profitsC list_profitsD)
  let denominator2 sqrt (sum (map [x -> (x - mean-c) ^ 2] list_profitsC) * sum (map [y -> (y - mean-d) ^ 2] list_profitsD))
  ;print (word "Tick " ticks ": denominator2= " denominator2)
  if denominator2 > 0
    [
      ifelse denominator2 < 0.01
      [
        set lambda2 0.5
      ]
      [
      let rho2 (numerator2 / denominator2)
      ;print (word "Tick " ticks ": rho2= " rho2)
      let numerator-lambda2 (var-d - (rho2 * sd-c * sd-d))
      let denominator-lambda2 (var-c + var-d - (2 * rho2 * sd-c * sd-d))
      ifelse abs denominator-lambda2 < 0.001
      [
       set lambda2 0.5
      ]
      [
      set lambda2 (numerator-lambda2 / denominator-lambda2)
      if lambda2 < 0 or lambda2 > 1
        [
          ;print (word "Warning: lambda2 out of range: " lambda2)
          ;set lambda2 0.5
          set lambda2 max list 0.01 (min list lambda2 0.99)
          ;print (word "Warning: lambda2 out of range: " max list 0.01 (min list lambda2 0.99))
        ]
      ]
      ]
    ]
  ]
  ;if not validAB
  ;[
  ;set lambda1 0.5
  ;]
  ;if not validCD
  ;[
  ;set lambda2 0.5
  ;]
  if ((ticks > 0) and (ticks mod 10 = 0))
  [
    ifelse (cum_profits1 < Expected_profit1)
    [
        set Perc_junk_food_firm1 max list 0.01 (min list 100 (lambda1 * 100))
        ;print (word "Tick " ticks ": Perc_junk_food_firm1 = " Perc_junk_food_firm1)
        ;set Expected_profit1 (((lambda1 * (mean-a) + (1 - lambda1) * (mean-b))) * 20)
        set cum_profits1 0
       if (ticks mod 40 = 0)
       [
        set Expected_profit1 (((lambda1 * (mean-a) + (1 - lambda1) * (mean-b))) * 20)
       ]
    ]
    [
      set cum_profits1 0
    ]
    ifelse (cum_profits2 < Expected_profit2)
    [
      set Perc_junk_food_firm2 max list 0.01 (min list 100 (lambda2 * 100))
      ;print (word "Tick " ticks ": Perc_junk_food_firm2 = " Perc_junk_food_firm2)
      ;set Expected_profit2 (((lambda2 * (mean-c) + (1 - lambda2) * (mean-d))) * 20)
      set cum_profits2 0
      if (ticks mod 40 = 0)
      [
        set Expected_profit2 (((lambda2 * (mean-c) + (1 - lambda2) * (mean-d))) * 20)
      ]
    ]
    [
      set cum_profits2 0
    ]
  ]
end

to load-empirical-data
  let raw csv:from-file "EmpiricalBMI.csv"
  if (is-string? item 0 raw) [set raw but-first raw]
  set empirical-bmi-list map first raw
  ;set empirical-bmi-list []
  ;file-open "EmpiricalBMI.csv"
  ;while [not file-at-end?]
  ;[
  ;  let val file-read-line
  ;  if not empty? val
  ;  [
  ;    let num read-from-string val
  ;    set empirical-bmi-list lput num empirical-bmi-list
  ;  ]
  ;]
  ;file-close
  ;print (empirical-bmi-list)
end

to profits
  if (excessA < 0 and excessB < 0)
  [
    set profits1 ((supplyA * price_junk_food) + (supplyB * price_healthy_food) - Costs_firm1)
    set profitsA (supplyA * price_junk_food)
    set profitsB (supplyB * price_healthy_food)
    set list_profitsA lput profitsA list_profitsA
    set list_profitsB lput profitsB list_profitsB
  ]
  if (excessA >= 0 and excessB >= 0)
  [
    set profits1 ((choiceA * price_junk_food) + (choiceB * price_healthy_food) - Costs_firm1)
    set profitsA (choiceA * price_junk_food)
    set profitsB (choiceB * price_healthy_food)
    set list_profitsA lput profitsA list_profitsA
    set list_profitsB lput profitsB list_profitsB
  ]
  if (excessA >= 0 and excessB < 0)
  [
    set profits1 ((choiceA * price_junk_food) + (supplyB * price_healthy_food) - Costs_firm1)
    set profitsA (choiceA * price_junk_food)
    set profitsB (supplyB * price_healthy_food)
    set list_profitsA lput profitsA list_profitsA
    set list_profitsB lput profitsB list_profitsB
  ]
  if (excessA < 0 and excessB >= 0)
  [
    set profits1 ((supplyA * price_junk_food) + (choiceB * price_healthy_food) - Costs_firm1)
    set profitsA (supplyA * price_junk_food)
    set profitsB (choiceB * price_healthy_food)
    set list_profitsA lput profitsA list_profitsA
    set list_profitsB lput profitsB list_profitsB
  ]
  if (excessC < 0 and excessD < 0)
  [
    set profits2 ((supplyC * price_junk_food2) + (supplyD * price_healthy_food2) - Costs_firm2)
    set profitsC (supplyC * price_junk_food2)
    set profitsD (supplyD * price_healthy_food2)
    set list_profitsC lput profitsC list_profitsC
    set list_profitsD lput profitsD list_profitsD
  ]
  if (excessC >= 0 and excessD >= 0)
  [
    set profits2 ((choiceC * price_junk_food2) + (choiceD * price_healthy_food2) - Costs_firm2)
    set profitsC (choiceC * price_junk_food2)
    set profitsD (choiceD * price_healthy_food2)
    set list_profitsC lput profitsC list_profitsC
    set list_profitsD lput profitsD list_profitsD
  ]
  if (excessC >= 0 and excessD < 0)
  [
    set profits2 ((choiceC * price_junk_food2) + (supplyD * price_healthy_food2) - Costs_firm2)
    set profitsC (choiceC * price_junk_food2)
    set profitsD (supplyD * price_healthy_food2)
    set list_profitsC lput profitsC list_profitsC
    set list_profitsD lput profitsD list_profitsD
  ]
  if (excessC < 0 and excessD >= 0)
  [
    set profits2 ((supplyC * price_junk_food2) + (choiceD * price_healthy_food2) - Costs_firm2)
    set profitsC (supplyC * price_junk_food2)
    set profitsD (choiceD * price_healthy_food2)
    set list_profitsC lput profitsC list_profitsC
    set list_profitsD lput profitsD list_profitsD
  ]
  set cum_profits1 (cum_profits1 + profits1)
  set cum_profits2 (cum_profits2 + profits2)
  set list_cum_profits1 lput cum_profits1 list_cum_profits1
  set list_cum_profits2 lput cum_profits2 list_cum_profits2
end

to-report draw-food-A1
  ;Modify probs for Agent 1 (Obesogenic w/self-control)
  let pairs (list
    (list "A" P1A)
    (list "B" P1B)
    (list "C" P1C)
    (list "D" P1D)
  )
  let food first rnd:weighted-one-of-list pairs [[p] -> last p]
  report food
end

to turtles-move-A1
  ask A1 [
  set food_selection draw-food-A1
  ifelse (food_selection = "A") or (food_selection = "C")
    [
      set junk_count junk_count + 1
    ]
    [
      set healthy_count healthy_count + 1
    ]
  ifelse (food_selection = "A") or (food_selection = "B")
  [
     setxy random-normal -10 1 random-normal -10 1
  ]
  [
     setxy random-normal 10 1 random-normal 10 1
  ]
  set list1 lput junk_count list1
  set listchoice1 lput food_selection listchoice1
  set BMI1 lput BMI BMI1
  ;print (BMI1)
  ]
end

to-report draw-food-A2
  ;Modify probs for Agent 2 (Non-obesogenic w/self-control)
  let pairs (list
    (list "A" P2A)
    (list "B" P2B)
    (list "C" P2C)
    (list "D" P2D)
  )
  let food first rnd:weighted-one-of-list pairs [[p] -> last p]
  report food
end

to turtles-move-A2
  ask A2 [
  set food_selection draw-food-A2
  ifelse (food_selection = "A") or (food_selection = "C")
    [
      set junk_count junk_count + 1
    ]
    [
      set healthy_count healthy_count + 1
    ]
  ifelse (food_selection = "A") or (food_selection = "B")
  [
     setxy random-normal -10 1 random-normal -10 1
  ]
  [
     setxy random-normal 10 1 random-normal 10 1
  ]
  set list2 lput junk_count list2
  set listchoice2 lput food_selection listchoice2
  set BMI2 lput BMI BMI2
  ]
end

to-report draw-food-A3
  ;Modify probs for Agent 3 (Obesogenic w/impulsivity)
  let pairs (list
    (list "A" P3A)
    (list "B" P3B)
    (list "C" P3C)
    (list "D" P3D)
  )
  let food first rnd:weighted-one-of-list pairs [[p] -> last p]
  report food
end

to turtles-move-A3
  ask A3 [
  set food_selection draw-food-A3
  ifelse (food_selection = "A") or (food_selection = "C")
    [
      set junk_count junk_count + 1
    ]
    [
      set healthy_count healthy_count + 1
    ]
  ifelse (food_selection = "A") or (food_selection = "B")
  [
     setxy random-normal -10 1 random-normal -10 1
  ]
  [
     setxy random-normal 10 1 random-normal 10 1
  ]
  set list3 lput junk_count list3
  set listchoice3 lput food_selection listchoice3
  set BMI3 lput BMI BMI3
  ]
end

to-report draw-food-A4
  ;Modify probs for Agent 4 (Non-obesogenic w/impulsivity)
  let pairs (list
    (list "A" P4A)
    (list "B" P4B)
    (list "C" P4C)
    (list "D" P4D)
  )
  let food first rnd:weighted-one-of-list pairs [[p] -> last p]
  report food
end

to turtles-move-A4
  ask A4 [
  set food_selection draw-food-A4
  ifelse (food_selection = "A") or (food_selection = "C")
    [
      set junk_count junk_count + 1
    ]
    [
      set healthy_count healthy_count + 1
    ]
  ifelse (food_selection = "A") or (food_selection = "B")
  [
     setxy random-normal -10 1 random-normal -10 1
  ]
  [
     setxy random-normal 10 1 random-normal 10 1
  ]
  set list4 lput junk_count list4
  set listchoice4 lput food_selection listchoice4
  set BMI4 lput BMI BMI4
  ]
end

to change-BMI
  ;let supplyA ((Supply_firm1 * (Perc_junk_food_firm1)) / 100)
  ;let supplyA (Supply_firm1 * lambda1)
  ;set supplyA round supplyA
  ;let supplyB ((Supply_firm1 * (100 - Perc_junk_food_firm1)) / 100)
  ;let supplyB ((Supply_firm1 * (1 - lambda1))
  ;set supplyB round supplyB
  ;let supplyC ((Supply_firm2 * (Perc_junk_food_firm2)) / 100)
  ;let supplyC (Supply_firm2 * lambda2)
  ;set supplyC round supplyC
  ;let supplyD ((Supply_firm2 * (100 - Perc_junk_food_firm2)) / 100)
  ;let supplyD ((Supply_firm2 * (1 - lambda2))
  ;set supplyD round supplyD
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;1st possibility: Supply exceeds or equals demand for all goods -> Everybody's BMI is affected according to choice
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  if ( excessA >= 0 and excessB >= 0 and excessC >= 0 and excessD >= 0)
      [
        ask turtles with [breed = A1 and (food_selection = "A" or food_selection = "C" )]
        [
          set BMI BMI + 0.09
        ]
        ask turtles with [breed = A1 and (food_selection = "B" or food_selection = "D")]
        [
          set BMI BMI - 0.05
        ]
        ask turtles with [breed = A2 and (food_selection = "A" or food_selection = "C" )]
        [
          set BMI BMI + 0.06
        ]
        ask turtles with [breed = A2 and (food_selection = "B" or food_selection = "D")]
        [
          set BMI BMI - 0.07
        ]
        ask turtles with [breed = A3 and (food_selection = "A" or food_selection = "C" )]
        [
          set BMI BMI + 0.12
        ]
        ask turtles with [breed = A3 and (food_selection = "B" or food_selection = "D")]
        [
          set BMI BMI - 0.045
        ]
        ask turtles with [breed = A4 and (food_selection = "A" or food_selection = "C" )]
        [
          set BMI BMI + 0.07
        ]
        ask turtles with [breed = A4 and (food_selection = "B" or food_selection = "D")]
        [
          set BMI BMI - 0.06
        ]
      ]
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;2nd possibility: Demand exceeds supply for junk food place1 -> Not everyone's BMI is affected according to choice
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  if (excessA < 0 and excessB >= 0 and excessC >= 0 and excessD >= 0)
      [

        while [supplyA > 0]
        [
          let rand-numb random 4 + 1
          if (rand-numb = 1 and choiceA1A > 0)
          [
            set supplyA supplyA - 1
            set choiceA1A choiceA1A - 1
            ask n-of 1 turtles with [breed = A1 and food_selection = "A"]
            [
              set BMI BMI + 0.09
            ]
          ]
          if (rand-numb = 2 and choiceA2A > 0)
          [
            set supplyA supplyA - 1
            set choiceA2A choiceA2A - 1
            ask n-of 1 turtles with [breed = A2 and food_selection = "A"]
            [
              set BMI BMI + 0.06
            ]
          ]
          if (rand-numb = 3 and choiceA3A > 0)
          [
            set supplyA supplyA - 1
            set choiceA3A choiceA3A - 1
            ask n-of 1 turtles with [breed = A3 and food_selection = "A"]
            [
              set BMI BMI + 0.12
            ]
          ]
          if (rand-numb = 4 and choiceA4A > 0)
          [
            set supplyA supplyA - 1
            set choiceA4A choiceA4A - 1
            ask n-of 1 turtles with [breed = A4 and food_selection = "A"]
            [
              set BMI BMI + 0.07
            ]
          ]
        ]


        ask turtles with [breed = A1 and food_selection = "C" ]
        [
          set BMI BMI + 0.09
        ]
        ask turtles with [breed = A1 and (food_selection = "B" or food_selection = "D")]
        [
          set BMI BMI - 0.05
        ]
        ask turtles with [breed = A2 and food_selection = "C" ]
        [
          set BMI BMI + 0.06
        ]
        ask turtles with [breed = A2 and (food_selection = "B" or food_selection = "D")]
        [
          set BMI BMI - 0.07
        ]
        ask turtles with [breed = A3 and food_selection = "C" ]
        [
          set BMI BMI + 0.12
        ]
        ask turtles with [breed = A3 and (food_selection = "B" or food_selection = "D")]
        [
          set BMI BMI - 0.045
        ]
        ask turtles with [breed = A4 and food_selection = "C" ]
        [
          set BMI BMI + 0.07
        ]
        ask turtles with [breed = A4 and (food_selection = "B" or food_selection = "D")]
        [
          set BMI BMI - 0.06
        ]
      ]
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;3rd possibility: Demand exceeds supply for healthy food place1 -> Not everyone's BMI is affected according to choice
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  if (excessA >= 0 and excessB < 0 and excessC >= 0 and excessD >= 0)
      [

        while [supplyB > 0]
        [
          let rand-numb random 4 + 1
          if (rand-numb = 1 and choiceA1B > 0)
          [
            set supplyB supplyB - 1
            set choiceA1B choiceA1B - 1
            ask n-of 1 turtles with [breed = A1 and food_selection = "B"]
            [
              set BMI BMI - 0.05
            ]
          ]
          if (rand-numb = 2 and choiceA2B > 0)
          [
            set supplyB supplyB - 1
            set choiceA2B choiceA2B - 1
            ask n-of 1 turtles with [breed = A2 and food_selection = "B"]
            [
              set BMI BMI - 0.07
            ]
          ]
          if (rand-numb = 3 and choiceA3B > 0)
          [
            set supplyB supplyB - 1
            set choiceA3B choiceA3B - 1
            ask n-of 1 turtles with [breed = A3 and food_selection = "B"]
            [
              set BMI BMI - 0.045
            ]
          ]
          if (rand-numb = 4 and choiceA4B > 0)
          [
            set supplyB supplyB - 1
            set choiceA4B choiceA4B - 1
            ask n-of 1 turtles with [breed = A4 and food_selection = "B"]
            [
              set BMI BMI - 0.06
            ]
          ]
        ]

        ask turtles with [breed = A1 and (food_selection = "A" or food_selection = "C")]
        [
          set BMI BMI + 0.09
        ]
        ask turtles with [breed = A1 and food_selection = "D"]
        [
          set BMI BMI - 0.05
        ]
        ask turtles with [breed = A2 and (food_selection = "A" or food_selection = "C")]
        [
          set BMI BMI + 0.06
        ]
        ask turtles with [breed = A2 and food_selection = "D"]
        [
          set BMI BMI - 0.07
        ]
        ask turtles with [breed = A3 and (food_selection = "A" or food_selection = "C")]
        [
          set BMI BMI + 0.12
        ]
        ask turtles with [breed = A3 and food_selection = "D"]
        [
          set BMI BMI - 0.045
        ]
        ask turtles with [breed = A4 and (food_selection = "A" or food_selection = "C")]
        [
          set BMI BMI + 0.07
        ]
        ask turtles with [breed = A4 and food_selection = "D"]
        [
          set BMI BMI - 0.06
        ]
      ]
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;4th possibility: Demand exceeds supply for junk food place2 -> Not everyone's BMI is affected according to choice
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  if (excessA >= 0 and excessB >= 0 and excessC < 0 and excessD >= 0)
      [

        while [supplyC > 0]
        [
          let rand-numb random 4 + 1
          if (rand-numb = 1 and choiceA1C > 0)
          [
            set supplyC supplyC - 1
            set choiceA1C choiceA1C - 1
            ask n-of 1 turtles with [breed = A1 and food_selection = "C"]
            [
              set BMI BMI + 0.09
            ]
          ]
          if (rand-numb = 2 and choiceA2C > 0)
          [
            set supplyC supplyC - 1
            set choiceA2C choiceA2C - 1
            ask n-of 1 turtles with [breed = A2 and food_selection = "C"]
            [
              set BMI BMI + 0.06
            ]
          ]
          if (rand-numb = 3 and choiceA3C > 0)
          [
            set supplyC supplyC - 1
            set choiceA3C choiceA3C - 1
            ask n-of 1 turtles with [breed = A3 and food_selection = "C"]
            [
              set BMI BMI + 0.12
            ]
          ]
          if (rand-numb = 4 and choiceA4C > 0)
          [
            set supplyC supplyC - 1
            set choiceA4C choiceA4C - 1
            ask n-of 1 turtles with [breed = A4 and food_selection = "C"]
            [
              set BMI BMI + 0.07
            ]
          ]
        ]

        ask turtles with [breed = A1 and food_selection = "A" ]
        [
          set BMI BMI + 0.09
        ]
        ask turtles with [breed = A1 and (food_selection = "B" or food_selection = "D")]
        [
          set BMI BMI - 0.05
        ]
        ask turtles with [breed = A2 and food_selection = "A" ]
        [
          set BMI BMI + 0.06
        ]
        ask turtles with [breed = A2 and (food_selection = "B" or food_selection = "D")]
        [
          set BMI BMI - 0.07
        ]
        ask turtles with [breed = A3 and food_selection = "A" ]
        [
          set BMI BMI + 0.12
        ]
        ask turtles with [breed = A3 and (food_selection = "B" or food_selection = "D")]
        [
          set BMI BMI - 0.045
        ]
        ask turtles with [breed = A4 and food_selection = "A" ]
        [
          set BMI BMI + 0.07
        ]
        ask turtles with [breed = A4 and (food_selection = "B" or food_selection = "D")]
        [
          set BMI BMI - 0.06
        ]
      ]
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;5th possibility: Demand exceeds supply for healthy food place2 -> Not everyone's BMI is affected according to choice
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  if (excessA >= 0 and excessB >= 0 and excessC >= 0 and excessD < 0)
      [

        while [supplyD > 0]
        [
          let rand-numb random 4 + 1
          if (rand-numb = 1 and choiceA1D > 0)
          [
            set supplyD supplyD - 1
            set choiceA1D choiceA1D - 1
            ask n-of 1 turtles with [breed = A1 and food_selection = "D"]
            [
              set BMI BMI - 0.05
            ]
          ]
          if (rand-numb = 2 and choiceA2D > 0)
          [
            set supplyD supplyD - 1
            set choiceA2D choiceA2D - 1
            ask n-of 1 turtles with [breed = A2 and food_selection = "D"]
            [
              set BMI BMI - 0.07
            ]
          ]
          if (rand-numb = 3 and choiceA3D > 0)
          [
            set supplyD supplyD - 1
            set choiceA3D choiceA3D - 1
            ask n-of 1 turtles with [breed = A3 and food_selection = "D"]
            [
              set BMI BMI - 0.045
            ]
          ]
          if (rand-numb = 4 and choiceA4D > 0)
          [
            set supplyD supplyD - 1
            set choiceA4D choiceA4D - 1
            ask n-of 1 turtles with [breed = A4 and food_selection = "D"]
            [
              set BMI BMI - 0.06
            ]
          ]
        ]

        ask turtles with [breed = A1 and (food_selection = "A" or food_selection = "C")]
        [
          set BMI BMI + 0.09
        ]
        ask turtles with [breed = A1 and food_selection = "B"]
        [
          set BMI BMI - 0.05
        ]
        ask turtles with [breed = A2 and (food_selection = "A" or food_selection = "C")]
        [
          set BMI BMI + 0.06
        ]
        ask turtles with [breed = A2 and food_selection = "B"]
        [
          set BMI BMI - 0.07
        ]
        ask turtles with [breed = A3 and (food_selection = "A" or food_selection = "C")]
        [
          set BMI BMI + 0.12
        ]
        ask turtles with [breed = A3 and food_selection = "B"]
        [
          set BMI BMI - 0.045
        ]
        ask turtles with [breed = A4 and (food_selection = "A" or food_selection = "C")]
        [
          set BMI BMI + 0.07
        ]
        ask turtles with [breed = A4 and food_selection = "B"]
        [
          set BMI BMI - 0.06
        ]
      ]
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;6th possibility: Demand exceeds supply for junk & healthy food place1 -> Not everyone's BMI is affected according to choice
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  if (excessA < 0 and excessB < 0 and excessC >= 0 and excessD >= 0)
      [

        while [supplyA > 0]
        [
          let rand-numb random 4 + 1
          if (rand-numb = 1 and choiceA1A > 0)
          [
            set supplyA supplyA - 1
            set choiceA1A choiceA1A - 1
            ask n-of 1 turtles with [breed = A1 and food_selection = "A"]
            [
              set BMI BMI + 0.09
            ]
          ]
          if (rand-numb = 2 and choiceA2A > 0)
          [
            set supplyA supplyA - 1
            set choiceA2A choiceA2A - 1
            ask n-of 1 turtles with [breed = A2 and food_selection = "A"]
            [
              set BMI BMI + 0.06
            ]
          ]
          if (rand-numb = 3 and choiceA3A > 0)
          [
            set supplyA supplyA - 1
            set choiceA3A choiceA3A - 1
            ask n-of 1 turtles with [breed = A3 and food_selection = "A"]
            [
              set BMI BMI + 0.12
            ]
          ]
          if (rand-numb = 4 and choiceA4A > 0)
          [
            set supplyA supplyA - 1
            set choiceA4A choiceA4A - 1
            ask n-of 1 turtles with [breed = A4 and food_selection = "A"]
            [
              set BMI BMI + 0.07
            ]
          ]
        ]

        while [supplyB > 0]
        [
          let rand-numb random 4 + 1
          if (rand-numb = 1 and choiceA1B > 0)
          [
            set supplyB supplyB - 1
            set choiceA1B choiceA1B - 1
            ask n-of 1 turtles with [breed = A1 and food_selection = "B"]
            [
              set BMI BMI - 0.05
            ]
          ]
          if (rand-numb = 2 and choiceA2B > 0)
          [
            set supplyB supplyB - 1
            set choiceA2B choiceA2B - 1
            ask n-of 1 turtles with [breed = A2 and food_selection = "B"]
            [
              set BMI BMI - 0.07
            ]
          ]
          if (rand-numb = 3 and choiceA3B > 0)
          [
            set supplyB supplyB - 1
            set choiceA3B choiceA3B - 1
            ask n-of 1 turtles with [breed = A3 and food_selection = "B"]
            [
              set BMI BMI - 0.045
            ]
          ]
          if (rand-numb = 4 and choiceA4B > 0)
          [
            set supplyB supplyB - 1
            set choiceA4B choiceA4B - 1
            ask n-of 1 turtles with [breed = A4 and food_selection = "B"]
            [
              set BMI BMI - 0.06
            ]
          ]
        ]

        ask turtles with [breed = A1 and food_selection = "C" ]
        [
          set BMI BMI + 0.09
        ]
        ask turtles with [breed = A1 and food_selection = "D"]
        [
          set BMI BMI - 0.05
        ]
        ask turtles with [breed = A2 and food_selection = "C" ]
        [
          set BMI BMI + 0.06
        ]
        ask turtles with [breed = A2 and food_selection = "D"]
        [
          set BMI BMI - 0.07
        ]
        ask turtles with [breed = A3 and food_selection = "C" ]
        [
          set BMI BMI + 0.12
        ]
        ask turtles with [breed = A3 and food_selection = "D"]
        [
          set BMI BMI - 0.045
        ]
        ask turtles with [breed = A4 and food_selection = "C" ]
        [
          set BMI BMI + 0.07
        ]
        ask turtles with [breed = A4 and food_selection = "D"]
        [
          set BMI BMI - 0.06
        ]
      ]
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;7th possibility: Demand exceeds supply for junk food place1 & place2 -> Not everyone's BMI is affected according to choice
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  if (excessA < 0 and excessB >= 0 and excessC < 0 and excessD >= 0)
      [
        while [supplyA > 0]
        [
          let rand-numb random 4 + 1
          if (rand-numb = 1 and choiceA1A > 0)
          [
            set supplyA supplyA - 1
            set choiceA1A choiceA1A - 1
            ask n-of 1 turtles with [breed = A1 and food_selection = "A"]
            [
              set BMI BMI + 0.09
            ]
          ]
          if (rand-numb = 2 and choiceA2A > 0)
          [
            set supplyA supplyA - 1
            set choiceA2A choiceA2A - 1
            ask n-of 1 turtles with [breed = A2 and food_selection = "A"]
            [
              set BMI BMI + 0.06
            ]
          ]
          if (rand-numb = 3 and choiceA3A > 0)
          [
            set supplyA supplyA - 1
            set choiceA3A choiceA3A - 1
            ask n-of 1 turtles with [breed = A3 and food_selection = "A"]
            [
              set BMI BMI + 0.12
            ]
          ]
          if (rand-numb = 4 and choiceA4A > 0)
          [
            set supplyA supplyA - 1
            set choiceA4A choiceA4A - 1
            ask n-of 1 turtles with [breed = A4 and food_selection = "A"]
            [
              set BMI BMI + 0.07
            ]
          ]
        ]

        while [supplyC > 0]
        [
          let rand-numb random 4 + 1
          if (rand-numb = 1 and choiceA1C > 0)
          [
            set supplyC supplyC - 1
            set choiceA1C choiceA1C - 1
            ask n-of 1 turtles with [breed = A1 and food_selection = "C"]
            [
              set BMI BMI + 0.09
            ]
          ]
          if (rand-numb = 2 and choiceA2C > 0)
          [
            set supplyC supplyC - 1
            set choiceA2C choiceA2C - 1
            ask n-of 1 turtles with [breed = A2 and food_selection = "C"]
            [
              set BMI BMI + 0.06
            ]
          ]
          if (rand-numb = 3 and choiceA3C > 0)
          [
            set supplyC supplyC - 1
            set choiceA3C choiceA3C - 1
            ask n-of 1 turtles with [breed = A3 and food_selection = "C"]
            [
              set BMI BMI + 0.12
            ]
          ]
          if (rand-numb = 4 and choiceA4C > 0)
          [
            set supplyC supplyC - 1
            set choiceA4C choiceA4C - 1
            ask n-of 1 turtles with [breed = A4 and food_selection = "C"]
            [
              set BMI BMI + 0.07
            ]
          ]
        ]

        ask turtles with [breed = A1 and (food_selection = "B" or food_selection = "D")]
        [
          set BMI BMI - 0.05
        ]
        ask turtles with [breed = A2 and (food_selection = "B" or food_selection = "D")]
        [
          set BMI BMI - 0.07
        ]
        ask turtles with [breed = A3 and (food_selection = "B" or food_selection = "D")]
        [
          set BMI BMI - 0.045
        ]
        ask turtles with [breed = A4 and (food_selection = "B" or food_selection = "D")]
        [
          set BMI BMI - 0.06
        ]
      ]
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;8th possibility: Demand exceeds supply for junk food place1 & healthy food place2 -> Not everyone's BMI is affected according to choice
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  if (excessA < 0 and excessB >= 0 and excessC >= 0 and excessD < 0)
      [

        while [supplyA > 0]
        [
          let rand-numb random 4 + 1
          if (rand-numb = 1 and choiceA1A > 0)
          [
            set supplyA supplyA - 1
            set choiceA1A choiceA1A - 1
            ask n-of 1 turtles with [breed = A1 and food_selection = "A"]
            [
              set BMI BMI + 0.09
            ]
          ]
          if (rand-numb = 2 and choiceA2A > 0)
          [
            set supplyA supplyA - 1
            set choiceA2A choiceA2A - 1
            ask n-of 1 turtles with [breed = A2 and food_selection = "A"]
            [
              set BMI BMI + 0.06
            ]
          ]
          if (rand-numb = 3 and choiceA3A > 0)
          [
            set supplyA supplyA - 1
            set choiceA3A choiceA3A - 1
            ask n-of 1 turtles with [breed = A3 and food_selection = "A"]
            [
              set BMI BMI + 0.12
            ]
          ]
          if (rand-numb = 4 and choiceA4A > 0)
          [
            set supplyA supplyA - 1
            set choiceA4A choiceA4A - 1
            ask n-of 1 turtles with [breed = A4 and food_selection = "A"]
            [
              set BMI BMI + 0.07
            ]
          ]
        ]

        while [supplyD > 0]
        [
          let rand-numb random 4 + 1
          if (rand-numb = 1 and choiceA1D > 0)
          [
            set supplyD supplyD - 1
            set choiceA1D choiceA1D - 1
            ask n-of 1 turtles with [breed = A1 and food_selection = "D"]
            [
              set BMI BMI - 0.05
            ]
          ]
          if (rand-numb = 2 and choiceA2D > 0)
          [
            set supplyD supplyD - 1
            set choiceA2D choiceA2D - 1
            ask n-of 1 turtles with [breed = A2 and food_selection = "D"]
            [
              set BMI BMI - 0.07
            ]
          ]
          if (rand-numb = 3 and choiceA3D > 0)
          [
            set supplyD supplyD - 1
            set choiceA3D choiceA3D - 1
            ask n-of 1 turtles with [breed = A3 and food_selection = "D"]
            [
              set BMI BMI - 0.045
            ]
          ]
          if (rand-numb = 4 and choiceA4D > 0)
          [
            set supplyD supplyD - 1
            set choiceA4D choiceA4D - 1
            ask n-of 1 turtles with [breed = A4 and food_selection = "D"]
            [
              set BMI BMI - 0.06
            ]
          ]
        ]

        ask turtles with [breed = A1 and food_selection = "B"]
        [
          set BMI BMI - 0.05
        ]
        ask turtles with [breed = A2 and food_selection = "B"]
        [
          set BMI BMI - 0.07
        ]
        ask turtles with [breed = A3 and food_selection = "B"]
        [
          set BMI BMI - 0.045
        ]
        ask turtles with [breed = A4 and food_selection = "B"]
        [
          set BMI BMI - 0.06
        ]
        ask turtles with [breed = A1 and food_selection = "C" ]
        [
          set BMI BMI + 0.09
        ]
        ask turtles with [breed = A2 and food_selection = "C" ]
        [
          set BMI BMI + 0.06
        ]

        ask turtles with [breed = A3 and food_selection = "C" ]
        [
          set BMI BMI + 0.12
        ]
        ask turtles with [breed = A4 and food_selection = "C" ]
        [
          set BMI BMI + 0.07
        ]
      ]
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;9th possibility: Demand exceeds supply for healthy food place1 & junk food place2 -> Not everyone's BMI is affected according to choice
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  if (excessA >= 0 and excessB < 0 and excessC < 0 and excessD >= 0)
      [

        while [supplyB > 0]
        [
          let rand-numb random 4 + 1
          if (rand-numb = 1 and choiceA1B > 0)
          [
            set supplyB supplyB - 1
            set choiceA1B choiceA1B - 1
            ask n-of 1 turtles with [breed = A1 and food_selection = "B"]
            [
              set BMI BMI - 0.05
            ]
          ]
          if (rand-numb = 2 and choiceA2B > 0)
          [
            set supplyB supplyB - 1
            set choiceA2B choiceA2B - 1
            ask n-of 1 turtles with [breed = A2 and food_selection = "B"]
            [
              set BMI BMI - 0.07
            ]
          ]
          if (rand-numb = 3 and choiceA3B > 0)
          [
            set supplyB supplyB - 1
            set choiceA3B choiceA3B - 1
            ask n-of 1 turtles with [breed = A3 and food_selection = "B"]
            [
              set BMI BMI - 0.045
            ]
          ]
          if (rand-numb = 4 and choiceA4B > 0)
          [
            set supplyB supplyB - 1
            set choiceA4B choiceA4B - 1
            ask n-of 1 turtles with [breed = A4 and food_selection = "B"]
            [
              set BMI BMI - 0.06
            ]
          ]
        ]

        while [supplyC > 0]
        [
          let rand-numb random 4 + 1
          if (rand-numb = 1 and choiceA1C > 0)
          [
            set supplyC supplyC - 1
            set choiceA1C choiceA1C - 1
            ask n-of 1 turtles with [breed = A1 and food_selection = "C"]
            [
              set BMI BMI + 0.09
            ]
          ]
          if (rand-numb = 2 and choiceA2C > 0)
          [
            set supplyC supplyC - 1
            set choiceA2C choiceA2C - 1
            ask n-of 1 turtles with [breed = A2 and food_selection = "C"]
            [
              set BMI BMI + 0.06
            ]
          ]
          if (rand-numb = 3 and choiceA3C > 0)
          [
            set supplyC supplyC - 1
            set choiceA3C choiceA3C - 1
            ask n-of 1 turtles with [breed = A3 and food_selection = "C"]
            [
              set BMI BMI + 0.12
            ]
          ]
          if (rand-numb = 4 and choiceA4C > 0)
          [
            set supplyC supplyC - 1
            set choiceA4C choiceA4C - 1
            ask n-of 1 turtles with [breed = A4 and food_selection = "C"]
            [
              set BMI BMI + 0.07
            ]
          ]
        ]

        ask turtles with [breed = A1 and food_selection = "A" ]
        [
          set BMI BMI + 0.09
        ]
        ask turtles with [breed = A1 and food_selection = "D"]
        [
          set BMI BMI - 0.05
        ]
        ask turtles with [breed = A2 and food_selection = "A" ]
        [
          set BMI BMI + 0.06
        ]
        ask turtles with [breed = A2 and food_selection = "D"]
        [
          set BMI BMI - 0.07
        ]
        ask turtles with [breed = A3 and food_selection = "A" ]
        [
          set BMI BMI + 0.12
        ]
        ask turtles with [breed = A3 and food_selection = "D"]
        [
          set BMI BMI - 0.045
        ]
        ask turtles with [breed = A4 and food_selection = "A" ]
        [
          set BMI BMI + 0.07
        ]
        ask turtles with [breed = A4 and food_selection = "D"]
        [
          set BMI BMI - 0.06
        ]
      ]
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;10th possibility: Demand exceeds supply for healthy food place1 & place2  -> Not everyone's BMI is affected according to choice
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  if (excessA >= 0 and excessB < 0 and excessC >= 0 and excessD < 0)
      [

        while [supplyB > 0]
        [
          let rand-numb random 4 + 1
          if (rand-numb = 1 and choiceA1B > 0)
          [
            set supplyB supplyB - 1
            set choiceA1B choiceA1B - 1
            ask n-of 1 turtles with [breed = A1 and food_selection = "B"]
            [
              set BMI BMI - 0.05
            ]
          ]
          if (rand-numb = 2 and choiceA2B > 0)
          [
            set supplyB supplyB - 1
            set choiceA2B choiceA2B - 1
            ask n-of 1 turtles with [breed = A2 and food_selection = "B"]
            [
              set BMI BMI - 0.07
            ]
          ]
          if (rand-numb = 3 and choiceA3B > 0)
          [
            set supplyB supplyB - 1
            set choiceA3B choiceA3B - 1
            ask n-of 1 turtles with [breed = A3 and food_selection = "B"]
            [
              set BMI BMI - 0.045
            ]
          ]
          if (rand-numb = 4 and choiceA4B > 0)
          [
            set supplyB supplyB - 1
            set choiceA4B choiceA4B - 1
            ask n-of 1 turtles with [breed = A4 and food_selection = "B"]
            [
              set BMI BMI - 0.06
            ]
          ]
        ]

        while [supplyD > 0]
        [
          let rand-numb random 4 + 1
          if (rand-numb = 1 and choiceA1D > 0)
          [
            set supplyD supplyD - 1
            set choiceA1D choiceA1D - 1
            ask n-of 1 turtles with [breed = A1 and food_selection = "D"]
            [
              set BMI BMI - 0.05
            ]
          ]
          if (rand-numb = 2 and choiceA2D > 0)
          [
            set supplyD supplyD - 1
            set choiceA2D choiceA2D - 1
            ask n-of 1 turtles with [breed = A2 and food_selection = "D"]
            [
              set BMI BMI - 0.07
            ]
          ]
          if (rand-numb = 3 and choiceA3D > 0)
          [
            set supplyD supplyD - 1
            set choiceA3D choiceA3D - 1
            ask n-of 1 turtles with [breed = A3 and food_selection = "D"]
            [
              set BMI BMI - 0.045
            ]
          ]
          if (rand-numb = 4 and choiceA4D > 0)
          [
            set supplyD supplyD - 1
            set choiceA4D choiceA4D - 1
            ask n-of 1 turtles with [breed = A4 and food_selection = "D"]
            [
              set BMI BMI - 0.06
            ]
          ]
        ]

        ask turtles with [breed = A1 and (food_selection = "A" or food_selection = "C")]
        [
          set BMI BMI + 0.09
        ]
        ask turtles with [breed = A2 and (food_selection = "A" or food_selection = "C")]
        [
          set BMI BMI + 0.06
        ]
        ask turtles with [breed = A3 and (food_selection = "A" or food_selection = "C")]
        [
          set BMI BMI + 0.12
        ]
        ask turtles with [breed = A4 and (food_selection = "A" or food_selection = "C")]
        [
          set BMI BMI + 0.07
        ]
      ]
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;11th possibility: Demand exceeds supply for junk & healthy food place2 -> Not everyone's BMI is affected according to choice
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  if (excessA >= 0 and excessB >= 0 and excessC < 0 and excessD < 0)
      [

        while [supplyC > 0]
        [
          let rand-numb random 4 + 1
          if (rand-numb = 1 and choiceA1C > 0)
          [
            set supplyC supplyC - 1
            set choiceA1C choiceA1C - 1
            ask n-of 1 turtles with [breed = A1 and food_selection = "C"]
            [
              set BMI BMI + 0.09
            ]
          ]
          if (rand-numb = 2 and choiceA2C > 0)
          [
            set supplyC supplyC - 1
            set choiceA2C choiceA2C - 1
            ask n-of 1 turtles with [breed = A2 and food_selection = "C"]
            [
              set BMI BMI + 0.06
            ]
          ]
          if (rand-numb = 3 and choiceA3C > 0)
          [
            set supplyC supplyC - 1
            set choiceA3C choiceA3C - 1
            ask n-of 1 turtles with [breed = A3 and food_selection = "C"]
            [
              set BMI BMI + 0.12
            ]
          ]
          if (rand-numb = 4 and choiceA4C > 0)
          [
            set supplyC supplyC - 1
            set choiceA4C choiceA4C - 1
            ask n-of 1 turtles with [breed = A4 and food_selection = "C"]
            [
              set BMI BMI + 0.07
            ]
          ]
        ]

        while [supplyD > 0]
        [
          let rand-numb random 4 + 1
          if (rand-numb = 1 and choiceA1D > 0)
          [
            set supplyD supplyD - 1
            set choiceA1D choiceA1D - 1
            ask n-of 1 turtles with [breed = A1 and food_selection = "D"]
            [
              set BMI BMI - 0.05
            ]
          ]
          if (rand-numb = 2 and choiceA2D > 0)
          [
            set supplyD supplyD - 1
            set choiceA2D choiceA2D - 1
            ask n-of 1 turtles with [breed = A2 and food_selection = "D"]
            [
              set BMI BMI - 0.07
            ]
          ]
          if (rand-numb = 3 and choiceA3D > 0)
          [
            set supplyD supplyD - 1
            set choiceA3D choiceA3D - 1
            ask n-of 1 turtles with [breed = A3 and food_selection = "D"]
            [
              set BMI BMI - 0.045
            ]
          ]
          if (rand-numb = 4 and choiceA4D > 0)
          [
            set supplyD supplyD - 1
            set choiceA4D choiceA4D - 1
            ask n-of 1 turtles with [breed = A4 and food_selection = "D"]
            [
              set BMI BMI - 0.06
            ]
          ]
        ]

        ask turtles with [breed = A1 and food_selection = "A" ]
        [
          set BMI BMI + 0.09
        ]
        ask turtles with [breed = A1 and food_selection = "B"]
        [
          set BMI BMI - 0.05
        ]
        ask turtles with [breed = A2 and food_selection = "A" ]
        [
          set BMI BMI + 0.06
        ]
        ask turtles with [breed = A2 and food_selection = "B"]
        [
          set BMI BMI - 0.07
        ]
        ask turtles with [breed = A3 and food_selection = "A" ]
        [
          set BMI BMI + 0.12
        ]
        ask turtles with [breed = A3 and food_selection = "B"]
        [
          set BMI BMI - 0.045
        ]
        ask turtles with [breed = A4 and food_selection = "A" ]
        [
          set BMI BMI + 0.07
        ]
        ask turtles with [breed = A4 and food_selection = "B"]
        [
          set BMI BMI - 0.06
        ]
      ]
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;12th possibility: Demand exceeds supply for junk food place1 & place2 & healthy food place1 -> Not everyone's BMI is affected according to choice
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  if (excessA < 0 and excessB < 0 and excessC < 0 and excessD >= 0)
      [

        while [supplyA > 0]
        [
          let rand-numb random 4 + 1
          if (rand-numb = 1 and choiceA1A > 0)
          [
            set supplyA supplyA - 1
            set choiceA1A choiceA1A - 1
            ask n-of 1 turtles with [breed = A1 and food_selection = "A"]
            [
              set BMI BMI + 0.09
            ]
          ]
          if (rand-numb = 2 and choiceA2A > 0)
          [
            set supplyA supplyA - 1
            set choiceA2A choiceA2A - 1
            ask n-of 1 turtles with [breed = A2 and food_selection = "A"]
            [
              set BMI BMI + 0.06
            ]
          ]
          if (rand-numb = 3 and choiceA3A > 0)
          [
            set supplyA supplyA - 1
            set choiceA3A choiceA3A - 1
            ask n-of 1 turtles with [breed = A3 and food_selection = "A"]
            [
              set BMI BMI + 0.12
            ]
          ]
          if (rand-numb = 4 and choiceA4A > 0)
          [
            set supplyA supplyA - 1
            set choiceA4A choiceA4A - 1
            ask n-of 1 turtles with [breed = A4 and food_selection = "A"]
            [
              set BMI BMI + 0.07
            ]
          ]
        ]

        while [supplyB > 0]
        [
          let rand-numb random 4 + 1
          if (rand-numb = 1 and choiceA1B > 0)
          [
            set supplyB supplyB - 1
            set choiceA1B choiceA1B - 1
            ask n-of 1 turtles with [breed = A1 and food_selection = "B"]
            [
              set BMI BMI - 0.05
            ]
          ]
          if (rand-numb = 2 and choiceA2B > 0)
          [
            set supplyB supplyB - 1
            set choiceA2B choiceA2B - 1
            ask n-of 1 turtles with [breed = A2 and food_selection = "B"]
            [
              set BMI BMI - 0.07
            ]
          ]
          if (rand-numb = 3 and choiceA3B > 0)
          [
            set supplyB supplyB - 1
            set choiceA3B choiceA3B - 1
            ask n-of 1 turtles with [breed = A3 and food_selection = "B"]
            [
              set BMI BMI - 0.045
            ]
          ]
          if (rand-numb = 4 and choiceA4B > 0)
          [
            set supplyB supplyB - 1
            set choiceA4B choiceA4B - 1
            ask n-of 1 turtles with [breed = A4 and food_selection = "B"]
            [
              set BMI BMI - 0.06
            ]
          ]
        ]

        while [supplyC > 0]
        [
          let rand-numb random 4 + 1
          if (rand-numb = 1 and choiceA1C > 0)
          [
            set supplyC supplyC - 1
            set choiceA1C choiceA1C - 1
            ask n-of 1 turtles with [breed = A1 and food_selection = "C"]
            [
              set BMI BMI + 0.09
            ]
          ]
          if (rand-numb = 2 and choiceA2C > 0)
          [
            set supplyC supplyC - 1
            set choiceA2C choiceA2C - 1
            ask n-of 1 turtles with [breed = A2 and food_selection = "C"]
            [
              set BMI BMI + 0.06
            ]
          ]
          if (rand-numb = 3 and choiceA3C > 0)
          [
            set supplyC supplyC - 1
            set choiceA3C choiceA3C - 1
            ask n-of 1 turtles with [breed = A3 and food_selection = "C"]
            [
              set BMI BMI + 0.12
            ]
          ]
          if (rand-numb = 4 and choiceA4C > 0)
          [
            set supplyC supplyC - 1
            set choiceA4C choiceA4C - 1
            ask n-of 1 turtles with [breed = A4 and food_selection = "C"]
            [
              set BMI BMI + 0.07
            ]
          ]
        ]

        ask turtles with [breed = A1 and food_selection = "D"]
        [
          set BMI BMI - 0.05
        ]
        ask turtles with [breed = A2 and food_selection = "D"]
        [
          set BMI BMI - 0.07
        ]
        ask turtles with [breed = A3 and food_selection = "D"]
        [
          set BMI BMI - 0.045
        ]
        ask turtles with [breed = A4 and food_selection = "D"]
        [
          set BMI BMI - 0.06
        ]
      ]
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;13th possibility: Demand exceeds supply for junk & healthy food place1 & healthy food place2 -> Not everyone's BMI is affected according to choice
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  if (excessA < 0 and excessB < 0 and excessC >= 0 and excessD < 0)
      [

        while [supplyA > 0]
        [
          let rand-numb random 4 + 1
          if (rand-numb = 1 and choiceA1A > 0)
          [
            set supplyA supplyA - 1
            set choiceA1A choiceA1A - 1
            ask n-of 1 turtles with [breed = A1 and food_selection = "A"]
            [
              set BMI BMI + 0.09
            ]
          ]
          if (rand-numb = 2 and choiceA2A > 0)
          [
            set supplyA supplyA - 1
            set choiceA2A choiceA2A - 1
            ask n-of 1 turtles with [breed = A2 and food_selection = "A"]
            [
              set BMI BMI + 0.06
            ]
          ]
          if (rand-numb = 3 and choiceA3A > 0)
          [
            set supplyA supplyA - 1
            set choiceA3A choiceA3A - 1
            ask n-of 1 turtles with [breed = A3 and food_selection = "A"]
            [
              set BMI BMI + 0.12
            ]
          ]
          if (rand-numb = 4 and choiceA4A > 0)
          [
            set supplyA supplyA - 1
            set choiceA4A choiceA4A - 1
            ask n-of 1 turtles with [breed = A4 and food_selection = "A"]
            [
              set BMI BMI + 0.07
            ]
          ]
        ]

        while [supplyB > 0]
        [
          let rand-numb random 4 + 1
          if (rand-numb = 1 and choiceA1B > 0)
          [
            set supplyB supplyB - 1
            set choiceA1B choiceA1B - 1
            ask n-of 1 turtles with [breed = A1 and food_selection = "B"]
            [
              set BMI BMI - 0.05
            ]
          ]
          if (rand-numb = 2 and choiceA2B > 0)
          [
            set supplyB supplyB - 1
            set choiceA2B choiceA2B - 1
            ask n-of 1 turtles with [breed = A2 and food_selection = "B"]
            [
              set BMI BMI - 0.07
            ]
          ]
          if (rand-numb = 3 and choiceA3B > 0)
          [
            set supplyB supplyB - 1
            set choiceA3B choiceA3B - 1
            ask n-of 1 turtles with [breed = A3 and food_selection = "B"]
            [
              set BMI BMI - 0.045
            ]
          ]
          if (rand-numb = 4 and choiceA4B > 0)
          [
            set supplyB supplyB - 1
            set choiceA4B choiceA4B - 1
            ask n-of 1 turtles with [breed = A4 and food_selection = "B"]
            [
              set BMI BMI - 0.06
            ]
          ]
        ]

        while [supplyD > 0]
        [
          let rand-numb random 4 + 1
          if (rand-numb = 1 and choiceA1D > 0)
          [
            set supplyD supplyD - 1
            set choiceA1D choiceA1D - 1
            ask n-of 1 turtles with [breed = A1 and food_selection = "D"]
            [
              set BMI BMI - 0.05
            ]
          ]
          if (rand-numb = 2 and choiceA2D > 0)
          [
            set supplyD supplyD - 1
            set choiceA2D choiceA2D - 1
            ask n-of 1 turtles with [breed = A2 and food_selection = "D"]
            [
              set BMI BMI - 0.07
            ]
          ]
          if (rand-numb = 3 and choiceA3D > 0)
          [
            set supplyD supplyD - 1
            set choiceA3D choiceA3D - 1
            ask n-of 1 turtles with [breed = A3 and food_selection = "D"]
            [
              set BMI BMI - 0.045
            ]
          ]
          if (rand-numb = 4 and choiceA4D > 0)
          [
            set supplyD supplyD - 1
            set choiceA4D choiceA4D - 1
            ask n-of 1 turtles with [breed = A4 and food_selection = "D"]
            [
              set BMI BMI - 0.06
            ]
          ]
        ]

        ask turtles with [breed = A1 and food_selection = "C" ]
        [
          set BMI BMI + 0.09
        ]
        ask turtles with [breed = A2 and food_selection = "C" ]
        [
          set BMI BMI + 0.06
        ]
        ask turtles with [breed = A3 and food_selection = "C" ]
        [
          set BMI BMI + 0.12
        ]
        ask turtles with [breed = A4 and food_selection = "C" ]
        [
          set BMI BMI + 0.07
        ]
      ]
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;14th possibility: Demand exceeds supply for junk food place1 & junk & healthy food place2 -> Not everyone's BMI is affected according to choice
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  if (excessA < 0 and excessB >= 0 and excessC < 0 and excessD < 0)
      [

        while [supplyA > 0]
        [
          let rand-numb random 4 + 1
          if (rand-numb = 1 and choiceA1A > 0)
          [
            set supplyA supplyA - 1
            set choiceA1A choiceA1A - 1
            ask n-of 1 turtles with [breed = A1 and food_selection = "A"]
            [
              set BMI BMI + 0.09
            ]
          ]
          if (rand-numb = 2 and choiceA2A > 0)
          [
            set supplyA supplyA - 1
            set choiceA2A choiceA2A - 1
            ask n-of 1 turtles with [breed = A2 and food_selection = "A"]
            [
              set BMI BMI + 0.06
            ]
          ]
          if (rand-numb = 3 and choiceA3A > 0)
          [
            set supplyA supplyA - 1
            set choiceA3A choiceA3A - 1
            ask n-of 1 turtles with [breed = A3 and food_selection = "A"]
            [
              set BMI BMI + 0.12
            ]
          ]
          if (rand-numb = 4 and choiceA4A > 0)
          [
            set supplyA supplyA - 1
            set choiceA4A choiceA4A - 1
            ask n-of 1 turtles with [breed = A4 and food_selection = "A"]
            [
              set BMI BMI + 0.07
            ]
          ]
        ]

        while [supplyC > 0]
        [
          let rand-numb random 4 + 1
          if (rand-numb = 1 and choiceA1C > 0)
          [
            set supplyC supplyC - 1
            set choiceA1C choiceA1C - 1
            ask n-of 1 turtles with [breed = A1 and food_selection = "C"]
            [
              set BMI BMI + 0.09
            ]
          ]
          if (rand-numb = 2 and choiceA2C > 0)
          [
            set supplyC supplyC - 1
            set choiceA2C choiceA2C - 1
            ask n-of 1 turtles with [breed = A2 and food_selection = "C"]
            [
              set BMI BMI + 0.06
            ]
          ]
          if (rand-numb = 3 and choiceA3C > 0)
          [
            set supplyC supplyC - 1
            set choiceA3C choiceA3C - 1
            ask n-of 1 turtles with [breed = A3 and food_selection = "C"]
            [
              set BMI BMI + 0.12
            ]
          ]
          if (rand-numb = 4 and choiceA4C > 0)
          [
            set supplyC supplyC - 1
            set choiceA4C choiceA4C - 1
            ask n-of 1 turtles with [breed = A4 and food_selection = "C"]
            [
              set BMI BMI + 0.07
            ]
          ]
        ]

        while [supplyD > 0]
        [
          let rand-numb random 4 + 1
          if (rand-numb = 1 and choiceA1D > 0)
          [
            set supplyD supplyD - 1
            set choiceA1D choiceA1D - 1
            ask n-of 1 turtles with [breed = A1 and food_selection = "D"]
            [
              set BMI BMI - 0.05
            ]
          ]
          if (rand-numb = 2 and choiceA2D > 0)
          [
            set supplyD supplyD - 1
            set choiceA2D choiceA2D - 1
            ask n-of 1 turtles with [breed = A2 and food_selection = "D"]
            [
              set BMI BMI - 0.07
            ]
          ]
          if (rand-numb = 3 and choiceA3D > 0)
          [
            set supplyD supplyD - 1
            set choiceA3D choiceA3D - 1
            ask n-of 1 turtles with [breed = A3 and food_selection = "D"]
            [
              set BMI BMI - 0.045
            ]
          ]
          if (rand-numb = 4 and choiceA4D > 0)
          [
            set supplyD supplyD - 1
            set choiceA4D choiceA4D - 1
            ask n-of 1 turtles with [breed = A4 and food_selection = "D"]
            [
              set BMI BMI - 0.06
            ]
          ]
        ]

        ask turtles with [breed = A1 and food_selection = "B"]
        [
          set BMI BMI - 0.05
        ]
        ask turtles with [breed = A2 and food_selection = "B"]
        [
          set BMI BMI - 0.07
        ]
        ask turtles with [breed = A3 and food_selection = "B"]
        [
          set BMI BMI - 0.045
        ]
        ask turtles with [breed = A4 and food_selection = "B"]
        [
          set BMI BMI - 0.06
        ]
      ]
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;15th possibility: Demand exceeds supply for healthy food place1 & junk & healthy food place2 -> Not everyone's BMI is affected according to choice
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  if (excessA >= 0 and excessB < 0 and excessC < 0 and excessD < 0)
      [

        while [supplyB > 0]
        [
          let rand-numb random 4 + 1
          if (rand-numb = 1 and choiceA1B > 0)
          [
            set supplyB supplyB - 1
            set choiceA1B choiceA1B - 1
            ask n-of 1 turtles with [breed = A1 and food_selection = "B"]
            [
              set BMI BMI - 0.05
            ]
          ]
          if (rand-numb = 2 and choiceA2B > 0)
          [
            set supplyB supplyB - 1
            set choiceA2B choiceA2B - 1
            ask n-of 1 turtles with [breed = A2 and food_selection = "B"]
            [
              set BMI BMI - 0.07
            ]
          ]
          if (rand-numb = 3 and choiceA3B > 0)
          [
            set supplyB supplyB - 1
            set choiceA3B choiceA3B - 1
            ask n-of 1 turtles with [breed = A3 and food_selection = "B"]
            [
              set BMI BMI - 0.045
            ]
          ]
          if (rand-numb = 4 and choiceA4B > 0)
          [
            set supplyB supplyB - 1
            set choiceA4B choiceA4B - 1
            ask n-of 1 turtles with [breed = A4 and food_selection = "B"]
            [
              set BMI BMI - 0.06
            ]
          ]
        ]

        while [supplyC > 0]
        [
          let rand-numb random 4 + 1
          if (rand-numb = 1 and choiceA1C > 0)
          [
            set supplyC supplyC - 1
            set choiceA1C choiceA1C - 1
            ask n-of 1 turtles with [breed = A1 and food_selection = "C"]
            [
              set BMI BMI + 0.09
            ]
          ]
          if (rand-numb = 2 and choiceA2C > 0)
          [
            set supplyC supplyC - 1
            set choiceA2C choiceA2C - 1
            ask n-of 1 turtles with [breed = A2 and food_selection = "C"]
            [
              set BMI BMI + 0.06
            ]
          ]
          if (rand-numb = 3 and choiceA3C > 0)
          [
            set supplyC supplyC - 1
            set choiceA3C choiceA3C - 1
            ask n-of 1 turtles with [breed = A3 and food_selection = "C"]
            [
              set BMI BMI + 0.12
            ]
          ]
          if (rand-numb = 4 and choiceA4C > 0)
          [
            set supplyC supplyC - 1
            set choiceA4C choiceA4C - 1
            ask n-of 1 turtles with [breed = A4 and food_selection = "C"]
            [
              set BMI BMI + 0.07
            ]
          ]
        ]

        while [supplyD > 0]
        [
          let rand-numb random 4 + 1
          if (rand-numb = 1 and choiceA1D > 0)
          [
            set supplyD supplyD - 1
            set choiceA1D choiceA1D - 1
            ask n-of 1 turtles with [breed = A1 and food_selection = "D"]
            [
              set BMI BMI - 0.05
            ]
          ]
          if (rand-numb = 2 and choiceA2D > 0)
          [
            set supplyD supplyD - 1
            set choiceA2D choiceA2D - 1
            ask n-of 1 turtles with [breed = A2 and food_selection = "D"]
            [
              set BMI BMI - 0.07
            ]
          ]
          if (rand-numb = 3 and choiceA3D > 0)
          [
            set supplyD supplyD - 1
            set choiceA3D choiceA3D - 1
            ask n-of 1 turtles with [breed = A3 and food_selection = "D"]
            [
              set BMI BMI - 0.045
            ]
          ]
          if (rand-numb = 4 and choiceA4D > 0)
          [
            set supplyD supplyD - 1
            set choiceA4D choiceA4D - 1
            ask n-of 1 turtles with [breed = A4 and food_selection = "D"]
            [
              set BMI BMI - 0.06
            ]
          ]
        ]

        ask turtles with [breed = A1 and food_selection = "A" ]
        [
          set BMI BMI + 0.09
        ]
        ask turtles with [breed = A2 and food_selection = "A" ]
        [
          set BMI BMI + 0.06
        ]
        ask turtles with [breed = A3 and food_selection = "A" ]
        [
          set BMI BMI + 0.12
        ]
        ask turtles with [breed = A4 and food_selection = "A" ]
        [
          set BMI BMI + 0.07
        ]
      ]
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;16th possibility: Demand exceeds supply for all goods -> Not everyone's BMI is affected according to choice
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  if (excessA < 0 and excessB < 0 and excessC < 0 and excessD < 0)
      [
        while [supplyA > 0]
        [
          let rand-numb random 4 + 1
          if (rand-numb = 1 and choiceA1A > 0)
          [
            set supplyA supplyA - 1
            set choiceA1A choiceA1A - 1
            ask n-of 1 turtles with [breed = A1 and food_selection = "A"]
            [
              set BMI BMI + 0.09
            ]
          ]
          if (rand-numb = 2 and choiceA2A > 0)
          [
            set supplyA supplyA - 1
            set choiceA2A choiceA2A - 1
            ask n-of 1 turtles with [breed = A2 and food_selection = "A"]
            [
              set BMI BMI + 0.06
            ]
          ]
          if (rand-numb = 3 and choiceA3A > 0)
          [
            set supplyA supplyA - 1
            set choiceA3A choiceA3A - 1
            ask n-of 1 turtles with [breed = A3 and food_selection = "A"]
            [
              set BMI BMI + 0.12
            ]
          ]
          if (rand-numb = 4 and choiceA4A > 0)
          [
            set supplyA supplyA - 1
            set choiceA4A choiceA4A - 1
            ask n-of 1 turtles with [breed = A4 and food_selection = "A"]
            [
              set BMI BMI + 0.07
            ]
          ]
        ]

        while [supplyB > 0]
        [
          let rand-numb random 4 + 1
          if (rand-numb = 1 and choiceA1B > 0)
          [
            set supplyB supplyB - 1
            set choiceA1B choiceA1B - 1
            ask n-of 1 turtles with [breed = A1 and food_selection = "B"]
            [
              set BMI BMI - 0.05
            ]
          ]
          if (rand-numb = 2 and choiceA2B > 0)
          [
            set supplyB supplyB - 1
            set choiceA2B choiceA2B - 1
            ask n-of 1 turtles with [breed = A2 and food_selection = "B"]
            [
              set BMI BMI - 0.07
            ]
          ]
          if (rand-numb = 3 and choiceA3B > 0)
          [
            set supplyB supplyB - 1
            set choiceA3B choiceA3B - 1
            ask n-of 1 turtles with [breed = A3 and food_selection = "B"]
            [
              set BMI BMI - 0.045
            ]
          ]
          if (rand-numb = 4 and choiceA4B > 0)
          [
            set supplyB supplyB - 1
            set choiceA4B choiceA4B - 1
            ask n-of 1 turtles with [breed = A4 and food_selection = "B"]
            [
              set BMI BMI - 0.06
            ]
          ]
        ]

        while [supplyC > 0]
        [
          let rand-numb random 4 + 1
          if (rand-numb = 1 and choiceA1C > 0)
          [
            set supplyC supplyC - 1
            set choiceA1C choiceA1C - 1
            ask n-of 1 turtles with [breed = A1 and food_selection = "C"]
            [
              set BMI BMI + 0.09
            ]
          ]
          if (rand-numb = 2 and choiceA2C > 0)
          [
            set supplyC supplyC - 1
            set choiceA2C choiceA2C - 1
            ask n-of 1 turtles with [breed = A2 and food_selection = "C"]
            [
              set BMI BMI + 0.06
            ]
          ]
          if (rand-numb = 3 and choiceA3C > 0)
          [
            set supplyC supplyC - 1
            set choiceA3C choiceA3C - 1
            ask n-of 1 turtles with [breed = A3 and food_selection = "C"]
            [
              set BMI BMI + 0.12
            ]
          ]
          if (rand-numb = 4 and choiceA4C > 0)
          [
            set supplyC supplyC - 1
            set choiceA4C choiceA4C - 1
            ask n-of 1 turtles with [breed = A4 and food_selection = "C"]
            [
              set BMI BMI + 0.07
            ]
          ]
        ]

        while [supplyD > 0]
        [
          let rand-numb random 4 + 1
          if (rand-numb = 1 and choiceA1D > 0)
          [
            set supplyD supplyD - 1
            set choiceA1D choiceA1D - 1
            ask n-of 1 turtles with [breed = A1 and food_selection = "D"]
            [
              set BMI BMI - 0.05
            ]
          ]
          if (rand-numb = 2 and choiceA2D > 0)
          [
            set supplyD supplyD - 1
            set choiceA2D choiceA2D - 1
            ask n-of 1 turtles with [breed = A2 and food_selection = "D"]
            [
              set BMI BMI - 0.07
            ]
          ]
          if (rand-numb = 3 and choiceA3D > 0)
          [
            set supplyD supplyD - 1
            set choiceA3D choiceA3D - 1
            ask n-of 1 turtles with [breed = A3 and food_selection = "D"]
            [
              set BMI BMI - 0.045
            ]
          ]
          if (rand-numb = 4 and choiceA4D > 0)
          [
            set supplyD supplyD - 1
            set choiceA4D choiceA4D - 1
            ask n-of 1 turtles with [breed = A4 and food_selection = "D"]
            [
              set BMI BMI - 0.06
            ]
          ]
        ]
      ]
end

to count-BMI
  set bmiA1 0
  set bmiA2 0
  set bmiA3 0
  set bmiA4 0
  ask A1 [if BMI > 25 [set bmiA1 bmiA1 + 1]]
  ask A2 [if BMI > 25 [set bmiA2 bmiA2 + 1]]
  ask A3 [if BMI > 25 [set bmiA3 bmiA3 + 1]]
  ask A4 [if BMI > 25 [set bmiA4 bmiA4 + 1]]
end

to economic-costs
  let number_overweight (bmiA1 + bmiA2 + bmiA3 + bmiA4)
  let number_sick_underweight (Prob_sick_underweight * (Number_of_consumers - number_overweight))
  let number_sick_overweight (Prob_sick_overweight * number_overweight)
  let diff_sick (number_sick_overweight - number_sick_underweight)
  let number_sick (number_sick_overweight + number_sick_underweight)
  let number_deaths_overweight (Prob_death_overweight * number_overweight)
  let number_deaths_underweight (Prob_death_underweight * (Number_of_consumers - number_overweight))
  let diff_deaths (number_deaths_overweight - number_deaths_underweight)
  let number_deaths (number_deaths_overweight + number_deaths_underweight)
  let diff_days_absent (diff_sick * number_days_absent)
  let sum_days_absent (number_sick * number_days_absent)
  let absent_costs (diff_days_absent * min_wage)
  let death_costs (diff_deaths * number_days_worked * min_wage)
  let total_absent_costs (sum_days_absent * min_wage)
  let total_death_costs (number_deaths * number_days_worked * min_wage)
  set direct_costs (cost_treatment_sick * diff_sick) + (funeral * diff_deaths)
  set total_direct_costs (cost_treatment_sick * number_sick) + (funeral * number_deaths)
  set indirect_costs (absent_costs + death_costs)
  set total_indirect_costs (total_absent_costs + total_death_costs)
end

to-report get-direct-costs
  report direct_costs
end

to-report get-indirect-costs
  report indirect_costs
end

to-report get-total-direct-costs
  report total_direct_costs
end

to-report get-total_indirect-costs
  report total_indirect_costs
end

to-report simulated-bmi-list-a1
  report (sort [BMI] of turtles with [breed = A1])
end

to-report simulated-bmi-list-a2
  report (sort [BMI] of turtles with [breed = A2])
end

to-report simulated-bmi-list-a3
  report (sort [BMI] of turtles with [breed = A3])
end

to-report simulated-bmi-list-a4
  report (sort [BMI] of turtles with [breed = A4])
end

to simulated-BMI
  set simulated-bmi-list (sentence simulated-bmi-list-a1 simulated-bmi-list-a2 simulated-bmi-list-a3 simulated-bmi-list-a4)
  ;print (simulated-bmi-list)
end

to-report compute-MSE [ series1 series2 ]
  let l1 length series1
  let l2 length series2
  let l min (list l1 l2)
  let minlist []
  let maxlist []
  if (l = l1) [set minlist series1 set maxlist series2]
  if (l = l2) [set minlist series2 set maxlist series1]
  set maxlist sublist maxlist 0 l
  let sqd-errors (map [ [?1 ?2] -> (abs ?1 - ?2) ^ 2] maxlist minlist)
  let mse (sum sqd-errors) / l
  report mse
  print (mse)
end
@#$#@#$#@
GRAPHICS-WINDOW
344
10
781
448
-1
-1
13.0
1
10
1
1
1
0
1
1
1
-16
16
-16
16
1
1
1
ticks
30.0

BUTTON
3
10
66
43
NIL
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

SLIDER
0
63
172
96
Perc_junk_food_firm1
Perc_junk_food_firm1
1
99
97.0
1
1
NIL
HORIZONTAL

SLIDER
0
96
172
129
Perc_junk_food_firm2
Perc_junk_food_firm2
1
99
93.0
1
1
NIL
HORIZONTAL

INPUTBOX
0
494
155
554
Price_junk_food
78.0
1
0
Number

INPUTBOX
0
553
155
613
Price_healthy_food
82.0
1
0
Number

INPUTBOX
192
10
347
70
Number_of_consumers
18741.0
1
0
Number

INPUTBOX
0
132
155
192
Supply_firm1
9933.0
1
0
Number

INPUTBOX
0
191
155
251
Supply_firm2
8808.0
1
0
Number

INPUTBOX
0
252
155
312
Expected_profit1
635712.0
1
0
Number

INPUTBOX
0
313
155
373
Expected_profit2
352320.0
1
0
Number

INPUTBOX
0
374
155
434
Costs_firm1
731068.8
1
0
Number

INPUTBOX
0
434
155
494
Costs_firm2
669408.0
1
0
Number

BUTTON
97
11
160
44
NIL
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

PLOT
809
310
1008
461
Junk food choices
Time
Frequency
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"Agent 1" 1.0 0 -3844592 true "" "plot mean list1"
"Agent 2" 1.0 0 -865067 true "" "plot mean list2"
"Agent 3" 1.0 0 -2674135 true "" "plot mean list3"
"Agent 4" 1.0 0 -1184463 true "" "plot mean list4"

PLOT
1069
10
1269
160
Demand
Time
Frequency
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"junk1" 1.0 0 -16777216 true "" "plot count turtles with [food_selection = \"A\"]"
"healthy1" 1.0 0 -15040220 true "" "plot count turtles with [food_selection = \"B\"]"
"junk2" 1.0 0 -2674135 true "" "plot count turtles with [food_selection = \"C\"]"
"healthy2" 1.0 0 -14730904 true "" "plot count turtles with [food_selection = \"D\"]"

PLOT
1069
160
1269
310
Excess supply
NIL
NIL
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"junk1" 1.0 0 -16777216 true "" "plot excessA"
"healthy1" 1.0 0 -15040220 true "" "plot excessB"
"junk2" 1.0 0 -2674135 true "" "plot excessC"
"healthy2" 1.0 0 -14985354 true "" "plot excessD"

PLOT
1318
10
1518
160
Profits
Time
Profits
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"Firm 1" 1.0 0 -16777216 true "" "plot profits1"
"Firm 2" 1.0 0 -2674135 true "" "plot profits2"

PLOT
1320
310
1520
460
Cumulative profits
Time
Accum. profits
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"Firm 1" 1.0 0 -16777216 true "" "plot cum_profits1"
"Firm 2" 1.0 0 -2674135 true "" "plot cum_profits2"

PLOT
809
160
1009
310
Body Mass Index
Time
BMI
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"Agent 1" 1.0 0 -955883 true "" "plot mean BMI1"
"Agent 2" 1.0 0 -1264960 true "" "plot mean BMI2"
"Agent 3" 1.0 0 -2674135 true "" "plot mean BMI3"
"Agent 4" 1.0 0 -1184463 true "" "plot mean BMI4"

PLOT
1318
160
1518
310
Income by food-type
Time
Profits
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"junk1" 1.0 0 -16777216 true "" "plot profitsA"
"healthy1" 1.0 0 -14439633 true "" "plot profitsB"
"junk2" 1.0 0 -2674135 true "" "plot profitsC"
"healthy2" 1.0 0 -14730904 true "" "plot profitsD"

INPUTBOX
190
111
345
171
Prop_A1
0.07
1
0
Number

INPUTBOX
190
170
345
230
Prop_A2
0.28
1
0
Number

INPUTBOX
190
230
345
290
Prop_A3
0.16
1
0
Number

PLOT
808
10
1008
160
#Overweight
Time
Frequency
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"Agent 1" 1.0 0 -955883 true "" "plot bmiA1"
"Agent 2" 1.0 0 -1264960 true "" "plot bmiA2"
"Agent 3" 1.0 0 -2674135 true "" "plot bmiA3"
"Agent 4" 1.0 0 -1184463 true "" "plot bmiA4"

INPUTBOX
192
336
347
396
Prob_sick_underweight
0.0895
1
0
Number

INPUTBOX
192
396
347
456
Prob_sick_overweight
0.1385
1
0
Number

PLOT
1069
310
1269
460
Costs
Time
Money
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"Direct costs" 1.0 0 -16777216 true "" "plot direct_costs"
"Indirect costs" 1.0 0 -2674135 true "" "plot indirect_costs"
"Total direct" 1.0 0 -14439633 true "" "plot total_direct_costs"
"Total indirect " 1.0 0 -13791810 true "" "plot total_indirect_costs"

INPUTBOX
192
455
347
515
Prob_death_underweight
0.126
1
0
Number

INPUTBOX
192
514
347
574
Prob_death_overweight
0.151
1
0
Number

INPUTBOX
620
449
781
509
cost_treatment_sick
61972.78
1
0
Number

INPUTBOX
620
508
781
568
min_wage
278.8
1
0
Number

INPUTBOX
621
568
782
628
funeral
9332.0
1
0
Number

PLOT
870
483
1070
633
Perecentage_junk
Time
Percentage
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"%JunkFirm1" 1.0 0 -16777216 true "" "plot Perc_junk_food_firm1"
"%JunkFirm2" 1.0 0 -2674135 true "" "plot Perc_junk_food_firm2"

INPUTBOX
0
613
155
673
Price_junk_food2
75.0
1
0
Number

INPUTBOX
0
672
155
732
Price_healthy_food2
85.0
1
0
Number

INPUTBOX
1550
19
1705
79
P1A
0.21
1
0
Number

INPUTBOX
1549
80
1704
140
P1B
0.32
1
0
Number

INPUTBOX
1549
141
1704
201
P1C
0.18
1
0
Number

INPUTBOX
1713
20
1868
80
P2A
0.18
1
0
Number

INPUTBOX
1713
81
1868
141
P2B
0.35
1
0
Number

INPUTBOX
1713
143
1868
203
P2C
0.16
1
0
Number

INPUTBOX
1552
237
1707
297
P3A
0.18
1
0
Number

INPUTBOX
1552
299
1707
359
P3B
0.35
1
0
Number

INPUTBOX
1552
361
1707
421
P3C
0.16
1
0
Number

INPUTBOX
1715
237
1870
297
P4A
0.18
1
0
Number

INPUTBOX
1715
299
1870
359
P4B
0.35
1
0
Number

INPUTBOX
1715
362
1870
422
P4C
0.16
1
0
Number

INPUTBOX
1548
446
1703
506
meanBMI1
26.8
1
0
Number

INPUTBOX
1714
447
1869
507
sdBMI1
5.2
1
0
Number

INPUTBOX
1548
507
1703
567
meanBMI2
23.5
1
0
Number

INPUTBOX
1713
508
1868
568
sdBMI2
4.1
1
0
Number

INPUTBOX
1549
569
1704
629
meanBMI3
27.2
1
0
Number

INPUTBOX
1715
569
1870
629
sdBMI3
4.2
1
0
Number

INPUTBOX
1549
632
1704
692
meanBMI4
23.9
1
0
Number

INPUTBOX
1717
632
1872
692
sdBMI4
4.2
1
0
Number

INPUTBOX
622
629
777
689
number_days_worked
240.0
1
0
Number

INPUTBOX
621
690
776
750
number_days_absent
20.0
1
0
Number

@#$#@#$#@
## WHAT IS BEING MODELED?

This ABM was developed in order to represent the National Autonomous University of Mexico (UNAM), Campus CU's food market. Food is either "junk" or "healthy", and the consumption of either one affects agents' Body Mass Index (BMI), and, in consequence, the economic costs associated with being overweight in comparison to the costs of being lean. Consumers are classified according to one of four types, and suppliers are classified according to one of two types.

## HOW TO USE THE MODEL?

Specify the numeric value for all of the model's parameters in the interface before clicking "Setup" and "Go".

## HOW TO INTERPRET THE OUTPUTS?

The outputs that are plotted pertain variables accross time either for consumers or suppliers:
Consumers' outputs: Number of overweight people (by agent type), average BMI by agent type, cummulative junk food choices (by agent type), demand of each food type (aggregate), and economic costs (direct & indirect, comparing fat vs lean, or aggregating both).
Suppliers' outputs: Excess supply by food type, profits by supplier type, income by food type, cummulative profits by supplier type, and what percentage of the total food supply is junk food (by supplier type).
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
false
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
NetLogo 6.4.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
<experiments>
  <experiment name="experiment" repetitions="10" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <metric>get-direct-costs</metric>
    <enumeratedValueSet variable="Number_of_consumers">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Costs_firm1">
      <value value="500"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Costs_firm2">
      <value value="500"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Supply_firm1">
      <value value="5000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Price_healthy_food2">
      <value value="55"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="min_wage">
      <value value="207.44"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Price_junk_food">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Supply_firm2">
      <value value="5000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Expected_profit1">
      <value value="100000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Perc_junk_food_firm2">
      <value value="60"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Price_junk_food2">
      <value value="45"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cost_treatment_sick">
      <value value="40000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="funeral">
      <value value="100000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Prop_A1">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Prob_sick_underweight">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Prob_death_underweight">
      <value value="0.05"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Expected_profit2">
      <value value="100000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Price_healthy_food">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Prop_A2">
      <value value="0.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Prob_death_overweight">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Prob_sick_overweight">
      <value value="0.9"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Prop_A3">
      <value value="0.3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Perc_junk_food_firm1">
      <value value="60"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Prop_A4">
      <value value="0.4"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="experiment2" repetitions="10" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <metric>get-direct-costs</metric>
    <metric>get-indirect-costs</metric>
    <enumeratedValueSet variable="Number_of_consumers">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Costs_firm1">
      <value value="500"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Costs_firm2">
      <value value="500"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Supply_firm1">
      <value value="5000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Price_healthy_food2">
      <value value="55"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="min_wage">
      <value value="207.44"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Price_junk_food">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Supply_firm2">
      <value value="5000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Expected_profit1">
      <value value="100000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Perc_junk_food_firm2">
      <value value="60"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Price_junk_food2">
      <value value="45"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cost_treatment_sick">
      <value value="40000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="funeral">
      <value value="100000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Prop_A1">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Prob_sick_underweight">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Prob_death_underweight">
      <value value="0.05"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Expected_profit2">
      <value value="100000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Price_healthy_food">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Prop_A2">
      <value value="0.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Prob_death_overweight">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Prob_sick_overweight">
      <value value="0.9"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Prop_A3">
      <value value="0.3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Perc_junk_food_firm1">
      <value value="60"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Prop_A4">
      <value value="0.4"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="SenitivityAnalysisBaseline" repetitions="100" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <metric>get-direct-costs</metric>
    <metric>get-indirect-costs</metric>
    <metric>get-total-direct-costs</metric>
    <metric>get-total_indirect-costs</metric>
    <metric>Perc_junk_food_firm1</metric>
    <metric>Perc_junk_food_firm2</metric>
    <runMetricsCondition>ticks mod 10 = 0</runMetricsCondition>
    <enumeratedValueSet variable="Number_of_consumers">
      <value value="18741"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P2A">
      <value value="0.18"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Costs_firm1">
      <value value="731068.8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P2B">
      <value value="0.35"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Supply_firm1">
      <value value="9933"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Costs_firm2">
      <value value="669408"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P3A">
      <value value="0.18"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Price_healthy_food2">
      <value value="85"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Expected_profit1">
      <value value="635712"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P2C">
      <value value="0.16"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Price_junk_food2">
      <value value="75"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Supply_firm2">
      <value value="8808"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number_days_worked">
      <value value="240"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="funeral">
      <value value="9332"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sdBMI2">
      <value value="4.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sdBMI3">
      <value value="4.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Prop_A1">
      <value value="0.07"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Prob_death_underweight">
      <value value="0.126"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sdBMI4">
      <value value="4.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Price_healthy_food">
      <value value="82"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P1A">
      <value value="0.21"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Prob_death_overweight">
      <value value="0.151"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P1B">
      <value value="0.32"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Prob_sick_overweight">
      <value value="0.1385"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P4C">
      <value value="0.16"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P1C">
      <value value="0.18"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sdBMI1">
      <value value="5.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="min_wage">
      <value value="278.8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Price_junk_food">
      <value value="78"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Perc_junk_food_firm2">
      <value value="93"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cost_treatment_sick">
      <value value="61972.78"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number_days_absent">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P3B">
      <value value="0.35"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Prob_sick_underweight">
      <value value="0.0895"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P4A">
      <value value="0.18"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Expected_profit2">
      <value value="352320"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="meanBMI1">
      <value value="26.8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="meanBMI2">
      <value value="23.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P3C">
      <value value="0.16"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P4B">
      <value value="0.35"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="meanBMI3">
      <value value="27.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="meanBMI4">
      <value value="23.9"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Prop_A2">
      <value value="0.28"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Prop_A3">
      <value value="0.16"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Perc_junk_food_firm1">
      <value value="97"/>
    </enumeratedValueSet>
  </experiment>
</experiments>
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
