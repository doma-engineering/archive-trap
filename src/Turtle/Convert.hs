{-# LANGUAGE OverloadedStrings #-}

-- | Convenience conversion functions for Turtle
module Turtle.Convert ( t2l
                      , l2t
                      , t2p
                      , p2t
                      , t2pp
                      , pp2t
                      , p2pp
                      , pp2p

                      , texts2p
                      , joinPaths
                      ) where

import Turtle
    ( Text, FilePath, Line, fromText, toText, lineToText, textToLine )
import Prelude hiding ( FilePath )

import Data.Maybe ( fromJust )
import Data.Either.Combinators ( fromRight )
import Data.List (intersperse)

import qualified Prelude as P
import qualified Data.Text as T

t2l :: Text -> Line
t2l = fromJust . textToLine

l2t :: Line -> Text
l2t = lineToText

p2t :: FilePath -> Text
p2t = fromRight "/dev/null" . toText

t2p :: Text -> FilePath
t2p = fromText

p2pp :: FilePath -> P.FilePath
p2pp = T.unpack . p2t

pp2p :: P.FilePath -> FilePath
pp2p = t2p . T.pack

t2pp :: Text -> P.FilePath
t2pp = T.unpack

pp2t :: P.FilePath -> Text
pp2t = T.pack

texts2p :: [Text] -> FilePath
texts2p ts = fromText $ T.concat joined
  where
    joined = intersperse "/" ts

{-- This shit is super-buggy. I'll support Windows 10 when I can be fucked work out this currentOS bullshit

texts2p :: [Text] -> FilePath
texts2p xs = ( t2p . fromRight "/dev/null" . F.toText . F.concat) $ F.fromText <$> xs
--}

joinPaths :: [FilePath] -> FilePath
joinPaths = texts2p . (fmap (fromRight "" . toText))
