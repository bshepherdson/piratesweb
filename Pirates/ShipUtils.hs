
module Pirates.ShipUtils (
   classNumber
  ,courseDiff
  ,shipSpeed
  ) where

import Pirates.Types


classNumber :: Ship -> Int
classNumber s = case shipClass_ s of
                  Boat      -> 0
                  Cutter    -> 1
                  Brig      -> 2
                  Regular n -> n
                  Wide    n -> n


-- base speed in inches
baseSpeed :: ShipClass -> Int
baseSpeed Boat        = 4
baseSpeed Cutter      = 12
baseSpeed Brig        = 12
baseSpeed (Regular 2) = 10
baseSpeed (Wide 3)    = 10
baseSpeed (Regular 3) = 12
baseSpeed (Wide 4)    = 12
baseSpeed (Regular 4) = 14
baseSpeed (Wide 6)    = 14
baseSpeed (Regular 5) = 16
baseSpeed (Wide 7)    = 16
baseSpeed (Wide 8)    = 16


-- number of points difference between two courses (or wind directions)
courseDiff :: Course -> Course -> Int
courseDiff c1 c2 | base <= 4 = base
                 | otherwise = 8 - base
  where base = abs (c1-c2)


-- TODO: Brigs and Cutters have different sail layouts and different formulae
-- takes the ship's course and wind direction, and base speed and gives its speed
adjustForWindDir :: ShipClass -> Course -> WindDir -> Int -> Int
adjustForWindDir Cutter c w | diff == 1 || diff == 4 = subtract 2 -- slightly less with the wind or on close reach
                            | diff == 2 || diff == 3 = id
                            | 
adjustForWindDir sc c w | diff >= 3 = id -- maximum speed when heading away from the wind
                        | diff == 2 = subtract 2 -- abeam
                        | diff == 1 = subtract 6 -- close reach
                        | diff == 0 = const 0    -- into the wind
  where diff = courseDiff c w

adjustForWindSpeed :: WindSpeed -> Int -> Int
adjustForWindSpeed Calm     = const 0
adjustForWindSpeed Light    = (`div` 2)
adjustForWindSpeed Moderate = id
adjustForWindSpeed Strong   = (* 2)


adjustForDamage :: Ship -> Int -> Int
adjustForDamage s | rigDamage_ s == rigStrength_ s = const 0
                  | otherwise                      = subtract $ (rigDamage_ s `div` classNumber s) - 1

-- brings it all together to compute a final, true speed: wind direction and speed, ship class, damage
shipSpeed :: Ship -> WindDir -> WindSpeed -> Int
shipSpeed s wd ws = adjustForWindSpeed ws . adjustForDamage s . adjustForWindDir (shipClass_ s) (course_ s) wd . baseSpeed . shipClass_ $ s


