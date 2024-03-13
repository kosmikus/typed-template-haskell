{-# OPTIONS_GHC -fplugin=Plugins.TypedTemplateHaskell #-}
{-# LANGUAGE TemplateHaskell #-}
module Example where

import Language.Haskell.TH

x :: Quote m => Code m Int
x = [| 2 |]

y :: Quote m => Code m Int
y = [| $(x) + $(x) |]

z :: Quote m => m Exp
z = [|| 2 ||]
