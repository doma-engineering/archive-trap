{-# LANGUAGE NamedFieldPuns, DeriveGeneric, DeriveAnyClass, DerivingStrategies #-}
-- | Ways to filter file trees.
-- Features:
--    - Greenlists
--    - Redlists
--    - Wildcard support
--
-- If both greenlist and redlist are present, the following rules apply:
--    - “Red” trumps “green”
--    - “tdfr_exact” trumps any wildcard (“tdfr_prefix, tdfr_infix, tdfr_suffix”)
module Turtle.Directory.Filter ( Greenlist()
                               , Redlist()

                               , mkGreen
                               , mkRed
                               , include
                               , exclude

                               , simpleFilter

                               , mkPrefix
                               , mkInfix
                               , mkSuffix
                               , exactly ) where

import Turtle
import Turtle.Convert
import Prelude hiding (FilePath)

import Control.Foldl ( Fold(..) )

import qualified Control.Foldl as Foldl
import qualified Data.Text as T

-- Common

-- | SimpleRule has fragments of FilePaths that will eventually get translated
-- to Text.
--
-- We use FilePath, not Pattern here because we want to (eventually??) perform
-- platform-agnostic path-based green/red-listing.
data SimpleRule =
  SimpleRule { tdfr_prefix :: Maybe FilePath
             , tdfr_infix :: Maybe FilePath
             , tdfr_suffix :: Maybe FilePath
             , tdfr_exact :: Maybe FilePath }
    deriving (Eq, Ord, Show)

mkSimpleRule :: SimpleRule
mkSimpleRule = SimpleRule Nothing Nothing Nothing Nothing

mkPrefix :: FilePath -> SimpleRule
mkPrefix x = SimpleRule (Just x) Nothing Nothing Nothing

mkInfix :: FilePath -> SimpleRule
mkInfix x = SimpleRule Nothing (Just x) Nothing Nothing

mkSuffix :: FilePath -> SimpleRule
mkSuffix x = SimpleRule Nothing Nothing (Just x) Nothing

exactly :: FilePath -> SimpleRule
exactly x = SimpleRule Nothing Nothing Nothing (Just x)

-- TODO: Loot this function
filterIntoList :: (a -> Bool) -> Fold a [a]
filterIntoList f = Foldl.prefilter f Foldl.list

simpleFilter :: Shell FilePath -> Maybe Greenlist -> Maybe Redlist -> Shell FilePath
simpleFilter _ Nothing Nothing = select []
simpleFilter sfp (Just g) Nothing =
  fold sfp (filterIntoList $ simplyAllow g) >>= select
simpleFilter sfp Nothing (Just r) =
  fold sfp (filterIntoList $ simplyDeny r) >>= select
simpleFilter sfp (Just g) (Just r) =
  fold sfp (filterIntoList $ simplyDecide g r) >>= select

-- | simplyAllow will allow empty wildcards (Nothing / Nothing / ..)
simplyAllow :: Greenlist -> FilePath -> Bool
simplyAllow = simplyAllowDo True
simplyAllowDo False _ _ = False
simplyAllowDo True
              ( Greenlist ( (SimpleRule {tdfr_exact = Just needle }:srs) ) )
              haystack =
  simplyAllowDo (needle == haystack)
                (Greenlist srs)
                haystack
simplyAllowDo True
              (Greenlist (sr@SimpleRule { tdfr_prefix = Just needle }:srs))
              haystack =
  simplyAllowDo (p2t needle `T.isPrefixOf` p2t haystack)
                (Greenlist ((sr { tdfr_prefix = Nothing }):srs))
                haystack
simplyAllowDo True
              ( Greenlist ( (sr@SimpleRule { tdfr_suffix = Just needle }):srs ) )
              haystack =
  simplyAllowDo (p2t needle `T.isSuffixOf` p2t haystack)
                ( Greenlist ( (sr { tdfr_suffix = Nothing }):srs ) )
                haystack
-- Leaving the computation with the worst asymptotics to the end
simplyAllowDo True
              ( Greenlist ( (sr@SimpleRule { tdfr_infix = Just needle }):srs ) )
              haystack =
  simplyAllowDo (p2t needle `T.isInfixOf` p2t haystack)
                (Greenlist (sr { tdfr_infix = Nothing }:srs)) haystack
simplyAllowDo True
              ( Greenlist ( (SimpleRule { tdfr_prefix = Nothing
                               , tdfr_infix  = Nothing
                               , tdfr_suffix = Nothing
                               , tdfr_exact  = Nothing }):srs ) )
              haystack =
  simplyAllowDo True (Greenlist srs) haystack

-- | simplyDeny will deny empty wildcards (Nothing / Nothing / ..)
simplyDeny :: Redlist -> FilePath -> Bool
simplyDeny (Redlist srs) fp = not $ simplyAllowDo True (Greenlist srs) fp

-- | If both allow and deny, simplyDecide will deny (adhering to “red” trumps “green”)
simplyDecide :: Greenlist -> Redlist -> FilePath -> Bool
simplyDecide g r fp =
  if (denied (simplyDeny r fp))
    then deny
    else (simplyAllow g fp)
  where
    denied False = True
    denied True = False
    deny = False

-- Green

include :: Greenlist -> SimpleRule -> Greenlist
include = undefined

newtype Greenlist = Greenlist [SimpleRule]
  deriving (Eq, Ord, Show)

getGreenlist :: Greenlist -> [SimpleRule]
getGreenlist (Greenlist xs) = xs

mkGreen :: [SimpleRule] -> Greenlist
mkGreen = Greenlist

-- Red

exclude :: Redlist -> SimpleRule -> Redlist
exclude = undefined

newtype Redlist = Redlist [SimpleRule]
  deriving (Eq, Ord, Show)

getRedlist :: Redlist -> [SimpleRule]
getRedlist (Redlist xs) = xs

mkRed :: [SimpleRule] -> Redlist
mkRed = Redlist

