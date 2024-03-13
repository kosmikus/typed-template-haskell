module Plugins.TypedTemplateHaskell where

import Generics.SYB
import GHC.Plugins
import GHC.Hs

plugin :: Plugin
plugin =
  defaultPlugin
    { parsedResultAction = parserPlugin }

parserPlugin ::
     [CommandLineOption]
  -> ModSummary
  -> ParsedResult
  -> Hsc ParsedResult
parserPlugin _ _ pr =
  return (pr { parsedResultModule = (parsedResultModule pr) { hpm_module = transform (hpm_module (parsedResultModule pr)) } })

-- | Just flips typed and untyped splices and quotes
transform :: Located (HsModule GhcPs) -> Located (HsModule GhcPs)
transform =
  everywhere (mkT go)
  where
    go :: HsExpr GhcPs -> HsExpr GhcPs
    go (HsUntypedSplice a1 (HsUntypedSpliceExpr a2 expr)) = HsTypedSplice (a1, a2) expr
    go (HsTypedSplice (a1, a2) expr) = HsUntypedSplice a1 (HsUntypedSpliceExpr a2 expr)
    go (HsUntypedBracket a1 (ExpBr _a2 expr)) = HsTypedBracket a1 expr
    go (HsTypedBracket a expr) = HsUntypedBracket a (ExpBr noExtField expr)
    go x = x
