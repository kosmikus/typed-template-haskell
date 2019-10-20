module Plugins.TypedTemplateHaskell where

import Generics.SYB
import HsSyn
import GhcPlugins

plugin :: Plugin
plugin =
  defaultPlugin
    { parsedResultAction = parserPlugin }

parserPlugin ::
     [CommandLineOption]
  -> ModSummary
  -> HsParsedModule
  -> Hsc HsParsedModule
parserPlugin _ _ pm =
  return (pm { hpm_module = transform (hpm_module pm) })

-- | Just flips typed and untyped splices and quotes
transform :: Located (HsModule GhcPs) -> Located (HsModule GhcPs)
transform =
  everywhere (mkT goQuote . mkT goSplice)
  where
    goSplice :: HsSplice GhcPs -> HsSplice GhcPs
    goSplice (HsUntypedSplice _ dec id expr) = HsTypedSplice NoExt dec id expr
    goSplice (HsTypedSplice _ dec id expr) = HsUntypedSplice NoExt dec id expr
    goSplice x = x

    goQuote :: HsBracket GhcPs -> HsBracket GhcPs
    goQuote (ExpBr _ expr) = TExpBr NoExt expr
    goQuote (TExpBr _ expr) = ExpBr NoExt expr
    goQuote x = x
