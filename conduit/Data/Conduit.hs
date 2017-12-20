{-# LANGUAGE RankNTypes #-}
{-# LANGUAGE DeriveFunctor #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE Safe #-}
-- | If this is your first time with conduit, you should probably start with
-- the tutorial:
-- <https://github.com/snoyberg/conduit#readme>.
module Data.Conduit
    ( -- * Core interface
      -- ** Types
      ConduitT
      -- *** Deprecated
    , Source
    , Conduit
    , Sink
    , ConduitM
      -- ** Connect/fuse operators
    , (.|)
    , connect
    , fuse
      -- *** Deprecated
    , ($$)
    , ($=)
    , (=$)
    , (=$=)

      -- *** Fuse with upstream results
    , fuseBoth
    , fuseBothMaybe
    , fuseUpstream

      -- ** Primitives
    , await
    , yield
    , yieldM
    , leftover
    , runConduit
    , runConduitPure
    , runConduitRes

      -- ** Finalization
    , bracketP
    , addCleanup
    , yieldOr

      -- ** Exception handling
    , catchC
    , handleC
    , tryC

      -- * Generalized conduit types
    , Producer
    , Consumer
    , toProducer
    , toConsumer

      -- * Utility functions
    , awaitForever
    , transPipe
    , mapOutput
    , mapOutputMaybe
    , mapInput
    , mergeSource
    , passthroughSink
    , sourceToList

      -- * Connect-and-resume
    , ResumableSource
    , newResumableSource
    , ($$+)
    , ($$++)
    , ($$+-)
    , ($=+)
    , unwrapResumable
    , closeResumableSource

      -- ** For @Conduit@s
    , ResumableConduit
    , newResumableConduit
    , (=$$+)
    , (=$$++)
    , (=$$+-)
    , unwrapResumableConduit

      -- * Fusion with leftovers
    , fuseLeftovers
    , fuseReturnLeftovers

      -- * Flushing
    , Flush (..)

      -- * Newtype wrappers
      -- ** ZipSource
    , ZipSource (..)
    , sequenceSources

      -- ** ZipSink
    , ZipSink (..)
    , sequenceSinks

      -- ** ZipConduit
    , ZipConduit (..)
    , sequenceConduits

      -- * Convenience reexports
    , Void -- FIXME consider instead relaxing type of runConduit
    ) where

import Data.Conduit.Internal.Conduit
import Data.Void (Void)
import Data.Functor.Identity (Identity, runIdentity)
import Control.Monad.Trans.Resource (ResourceT, runResourceT)
import Control.Monad.IO.Unlift (MonadUnliftIO)

-- | Run a pure pipeline until processing completes, i.e. a pipeline
-- with @Identity@ as the base monad. This is equivalient to
-- @runIdentity . runConduit@.
--
-- @since 1.2.8
runConduitPure :: ConduitM () Void Identity r -> r
runConduitPure = runIdentity . runConduit
{-# INLINE runConduitPure #-}

-- | Run a pipeline which acquires resources with @ResourceT@, and
-- then run the @ResourceT@ transformer. This is equivalent to
-- @runResourceT . runConduit@.
--
-- @since 1.2.8
runConduitRes :: MonadUnliftIO m
              => ConduitM () Void (ResourceT m) r
              -> m r
runConduitRes = runResourceT . runConduit
{-# INLINE runConduitRes #-}
