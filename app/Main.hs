{-# LANGUAGE OverloadedStrings #-}
module Main where

import Control.Monad (void)

import Turtle
    ( Alternative(empty), mktree, proc, shell )
import Prelude hiding (FilePath)
import Turtle.Directory.Filter ()
import Turtle.Convert ( p2t, texts2p )

import ArchiveTrap ( computerType, green, red, relevant )
import DevOps.Config ( snapConfigs )
import DevOps.Git ( hostnameBranch, Branch(getBranch) )

main :: IO ()
main = do
  let tmpDir = texts2p [ "/", "tmp", "archive-trap-secure" ]
  putStrLn $ show tmpDir
  mktree tmpDir
  proc "git" ["clone", "git@github.com:do-ma/infrastructure.git", p2t tmpDir] empty
  brbrbr <- hostnameBranch
  let branch = getBranch brbrbr
  shell ( "cd " <> p2t tmpDir <> " && git checkout -b " <> computerType <> "/" <> branch ) empty
  snapConfigs relevant green red tmpDir
  void $ shell ( "cd " <> p2t tmpDir <> " && git add . && git commit -am 'Auto-commit' && git push origin " <> computerType <> "/" <> branch ) empty
