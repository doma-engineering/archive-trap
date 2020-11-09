{-# LANGUAGE OverloadedStrings #-}
module ArchiveTrap (red, green, relevant) where

import Turtle
import Prelude hiding (FilePath)
import Turtle.Directory.Filter

linuxAnyUser :: Maybe FilePath -> Maybe FilePath -> SimpleRule
linuxAnyUser xinf xsuf = SimpleRule {
  tdfr_prefix = Just "/home",
  tdfr_infix  = xinf,
  tdfr_suffix = xsuf,
  tdfr_exact  = Nothing
}

red :: Maybe Redlist
red = Just $ mkRed [ mkInfix ".steam"
                   , mkSuffix ".swp"
                   , mkSuffix ".tmp"
                   ]

green :: Maybe Greenlist
green = Just $ mkGreen [ mkPrefix "/etc/nginx"
                       , linuxAnyUser Nothing (Just ".bashrc")
                       , linuxAnyUser (Just ".bashrc") Nothing
                       , linuxAnyUser (Just ".vim") Nothing
                       , linuxAnyUser (Just ".emacs") Nothing
                       , linuxAnyUser (Just ".xsession") Nothing
                       , linuxAnyUser (Just ".fonts") Nothing
                       , linuxAnyUser (Just ".xmonad") Nothing
                       , linuxAnyUser Nothing (Just ".Xresources")
                       , linuxAnyUser Nothing (Just ".Xdemo")
                       ]

-- We need to at least capture listing
-- of `/home/username` for default Greenlist to start matching
relevant :: Shell FilePath
relevant = lsdepth 1 3 "/"
