{-# LANGUAGE OverloadedStrings #-}
module Main where

import Control.Monad (void)

import Turtle
    ( Alternative(empty), mktree, proc, shell )
import Prelude hiding (FilePath)
import Turtle.Directory.Filter ()
import Turtle.Convert ( p2t, texts2p )

import ArchiveTrap ( computerType, green, red, relevant, secureGitRepo )
import DevOps.Config ( snapConfigs )
import DevOps.Git ( hostnameBranch, Branch(getBranch), getRepo )

main :: IO ()
main = do
  let tmpDir = texts2p [ "/", "tmp", "archive-trap-secure" ]
  putStrLn $ show tmpDir
  mktree tmpDir
  --proc "git" ["clone", "git@github.com:do-ma/infrastructure.git", p2t tmpDir] empty
  proc "git" ["clone", getRepo secureGitRepo, p2t tmpDir] empty
  brbrbr <- hostnameBranch
  let branch = computerType <> "/" <> getBranch brbrbr
  shell ( "cd " <> p2t tmpDir <> " && git checkout " <> branch <> " || git checkout -b " <> branch) empty
  --shell ( "cd " <> p2t tmpDir <> " && git checkout -b " <> computerType <> "/" <> branch ) empty
  snapConfigs relevant green red tmpDir
  void $ shell ( "cd " <> p2t tmpDir <> " && git add . && git commit -am 'Auto-commit' && git push origin " <> branch ) empty
