{-# LANGUAGE GeneralizedNewtypeDeriving, TemplateHaskell, BangPatterns #-}

module Pirates.Types where

import Data.Accessor.Monad.MTL.State
import Data.Accessor.Template


-- Ints are the class
data ShipClass = Boat | Cutter | Brig | Regular Int | Wide Int


-- WindDir always specifies the direction the wind is coming _from_
type WindDir = Course
data Course = N | S | E | W | NE | SE | SW | NW
  deriving (Eq, Show)


data WindSpeed = Calm | Light | Moderate | Strong
  deriving (Eq, Show)


data Ship {
      shipClass_    :: !Int
    , shipName_     :: !String
    , shipId_       :: !Int

    , captain_      :: !Sailor
    , crew_         :: ![Sailor]
    , guns_         :: ![Cannon]

    , hullDamage_   :: !Int
    , hullStrength_ :: !Int
    , rigDamage_    :: !Int
    , rigStrength_  :: !Int
    , steering_     :: !Int -- always 36 Damage Control actions to repair

    , width_        :: !Int -- inches
    , length_       :: !Int -- inches

    , course_       :: !Course
    , posx_         :: !Double -- +/- inches from center of map
    , posy_         :: !Double -- +/- inches from center of map

    , orders_       :: ![Order]
}


data Order = Sail !Int | Turn !Course
  deriving (Eq, Show)


data Sailor {
      sailorName_ :: !String
    , sailorId_   :: !Int
    , traits_     :: ![Trait]
    , holding_    :: ![Item]
    , alive_      :: !Bool
}


data Trait = Captain | ExpertSailor | ExpertGunner | ExpertMarksman | ExpertSwordsman

data Item = Musket | Pistol | Cutlass | Hook | Axe

data Cannon {
      loading_     :: !Int  -- number of crew actions required before ready to fire (2 after firing, 0 when ready)
    -- , cannon_x_    :: !Int  -- measured from port bow corner
    -- , cannon_y_    :: !Int  -- as above
    , destroyed_   :: !Bool
    , orientation_ :: !Orientation
    , cannonId_    :: !Int
}

data Orientation = Port | Starboard

