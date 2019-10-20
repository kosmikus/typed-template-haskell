{-# OPTIONS_GHC -fplugin=Plugins.TypedTemplateHaskell #-}
{-# LANGUAGE TemplateHaskell #-}
module Example where

import Language.Haskell.TH

type Syntax a = Q (TExp a)

x :: Syntax Int
x = [| 2 |]

y :: Syntax Int
y = [| $(x) + $(x) |]
