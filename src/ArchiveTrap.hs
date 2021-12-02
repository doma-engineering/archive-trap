{-# LANGUAGE OverloadedStrings #-}
module ArchiveTrap (red, green, relevant, secureGitRepo, computerType) where

import Turtle ( Text, FilePath, lsdepth, Shell, cat )
import Prelude hiding (FilePath)
import Turtle.Directory.Filter
    ( mkGreen,
      mkInfix,
      mkPrefix,
      mkRed,
      mkSuffix,
      Greenlist,
      Redlist,
      SimpleRule(..) )

import DevOps.Git ( mkRepo, Repo )

secureGitRepo :: Repo
secureGitRepo = mkRepo "git@github.com:do-ma/infrastructure.git"

computerType :: Text
computerType = "wsl"

red :: Maybe Redlist
red = Just $ mkRed [ mkInfix ".steam"
                   , mkSuffix ".swp"
                   , mkSuffix ".tmp"
                   , mkInfix ".git"
                   , mkSuffix "errors"
                   , mkSuffix ".netrc"
                   , mkSuffix "creds"
                   , mkSuffix "credentials"
                   , mkSuffix ".viminfo"
                   , mkSuffix "xmonad-x86_64-linux"
                   , mkSuffix ".png"
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
                       , linuxAnyUser (Just ".xmonad") Nothing
                       , linuxAnyUser Nothing (Just ".Xresources")
                       , linuxAnyUser Nothing (Just ".Xdemo")
                       , linuxAnyUser Nothing (Just ".ssh/config")
                       , linuxAnyUser Nothing (Just ".ssh/known_hosts")
                       , linuxAnyUser Nothing (Just ".tmux.conf")

                       -- Mail / Git stuff
                       , linuxAnyUser Nothing (Just ".muttrc")
                       , linuxAnyUser (Just ".mutt/includes") Nothing
                       , linuxAnyUser (Just ".mutt/tasks") Nothing

                       , linuxAnyUser Nothing (Just ".fetchmailrc")
                       , linuxAnyUser Nothing (Just ".procmailrc")
                       , linuxAnyUser Nothing (Just ".gpg.rc")
                       ]

relevant :: Shell FilePath
relevant = cat [lsdepth 1 3 "/etc/", lsdepth 1 3 "/home/"]

type Infix = FilePath
type Suffix = FilePath

linuxAnyUser :: Maybe Infix -> Maybe Suffix -> SimpleRule
linuxAnyUser xinf xsuf = SimpleRule {
  tdfr_prefix = Just "/home",
  tdfr_infix  = xinf,
  tdfr_suffix = xsuf,
  tdfr_exact  = Nothing
}
