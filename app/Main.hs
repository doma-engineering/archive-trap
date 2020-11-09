{-# LANGUAGE OverloadedStrings #-}
module Main where

import Lib

import Turtle
import Prelude hiding (FilePath)
import Turtle.Directory.Filter
import Turtle.Convert

import ArchiveTrap
import DevOps.Config

dryRun :: Shell FilePath
dryRun = simpleFilter relevant green red

main :: IO ()
main = do
  let tmpDir = texts2p [ "/", "tmp", "archive-trap-testing" ]
  putStrLn $ show tmpDir
  mktree tmpDir
  snapConfigs relevant green red tmpDir
  view $ dryRun
