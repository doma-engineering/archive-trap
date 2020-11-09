{-# LANGUAGE OverloadedStrings #-}
module ArchiveTrap (red, green, relevant, secureGitRepo, computerType) where

import Turtle
import Prelude hiding (FilePath)
import Turtle.Directory.Filter

import DevOps.Git

secureGitRepo :: Repo
secureGitRepo = mkRepo "doma.git:do-ma/infrastructure.git"

computerType :: Text
computerType = "laptop"

red :: Maybe Redlist
red = Just $ mkRed [ mkInfix ".steam"
                   , mkSuffix ".swp"
                   , mkSuffix ".tmp"
                   , mkInfix ".git"
                   , mkSuffix "errors"
                   ]

green :: Maybe Greenlist
green = Just $ mkGreen [ mkPrefix "/etc/nginx"
                       , mkPrefix "/etc/hosts"
                       , mkPrefix "/etc/hostname"
                       , mkPrefix "/etc/cron"
                       , linuxAnyUser Nothing (Just ".bashrc")
                       , linuxAnyUser (Just ".bashrc") Nothing
                       , linuxAnyUser (Just ".vim") Nothing
                       , linuxAnyUser (Just ".emacs") Nothing
                       , linuxAnyUser (Just ".xsession") Nothing
                       --, linuxAnyUser (Just ".fonts") Nothing
                       , linuxAnyUser (Just ".xmonad") Nothing
                       , linuxAnyUser Nothing (Just ".Xresources")
                       , linuxAnyUser Nothing (Just ".Xdemo")
                       , linuxAnyUser Nothing (Just ".ssh/config")
                       , linuxAnyUser Nothing (Just ".ssh/known_hosts")
                       ]

relevant :: Shell FilePath
relevant = lsdepth 1 4 "/"

linuxAnyUser :: Maybe FilePath -> Maybe FilePath -> SimpleRule
linuxAnyUser xinf xsuf = SimpleRule {
  tdfr_prefix = Just "/home",
  tdfr_infix  = xinf,
  tdfr_suffix = xsuf,
  tdfr_exact  = Nothing
}
