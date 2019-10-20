{-# OPTIONS_GHC -fplugin=Plugins.TypedTemplateHaskell #-}
{-# LANGUAGE TemplateHaskell #-}
module Main where

import Example

main :: IO ()
main =
  print $y
