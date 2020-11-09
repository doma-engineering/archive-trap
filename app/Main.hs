{-# LANGUAGE OverloadedStrings #-}
module Main where

import Control.Monad (void)

import Turtle
import Prelude hiding (FilePath)
import Turtle.Directory.Filter
import Turtle.Convert

import ArchiveTrap
import DevOps.Config
import DevOps.Git

main :: IO ()
main = do
  let tmpDir = texts2p [ "/", "tmp", "archive-trap-secure" ]
  putStrLn $ show tmpDir
  mktree tmpDir
  proc "git" ["clone", getRepo secureGitRepo, p2t tmpDir] empty
  brbrbr <- hostnameBranch
  let branch = getBranch brbrbr
  shell ( "cd " <> p2t tmpDir <> " && git checkout -b " <> computerType <> "/" <> branch ) empty
  snapConfigs relevant green red tmpDir
  void $ shell ( "cd " <> p2t tmpDir <> " && git add . && git commit -am 'Auto-commit' && git push origin " <> computerType <> "/" <> branch ) empty
