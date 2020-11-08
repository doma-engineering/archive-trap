{-# LANGUAGE OverloadedStrings #-}

-- | Convenience conversion functions for Turtle
module Turtle.Convert ( t2l
                      , l2t
                      , t2p
                      , p2t
                      , t2pp
                      , pp2t
                      , p2pp
                      , pp2p ) where

import Turtle
import Prelude hiding ( FilePath )
import Data.Maybe ( fromJust )
import Data.Either.Combinators ( fromRight )

import qualified Prelude as P
import qualified Data.Text as T

t2l :: Text -> Line
t2l = fromJust . textToLine

l2t :: Line -> Text
l2t = lineToText

p2t :: FilePath -> Text
p2t = fromRight "/tmp/.non-existant" . toText

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
