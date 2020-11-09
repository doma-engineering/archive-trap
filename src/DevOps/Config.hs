-- | A fistful of functions for putting server configurations on Git
module DevOps.Config ( snapConfigs
                     , applyConfigs
                     , snapSys
                     , applySys
                     , mkPackage
                     , Package()
                     ) where

import Data.Text (Text(..))
import Turtle
import Prelude hiding (FilePath)
import Turtle.Convert
import Turtle.Directory.Filter

import qualified Control.Foldl as Foldl
import qualified Data.Text as T

import DevOps.OS

import Debug.Trace (trace)

-- | Snapshot of system state, helps reinstall necessary system-wide packages
data Snapshot = Snapshot { dcs_packages :: [Package]
                         , dcs_uname :: Text
                         , dcs_pin :: Maybe Text
                         , dcs_os :: OS
                         }

-- | Wrapper for packages
newtype Package = Package { getPackage :: Text }
-- | Smart constructor for packages (eventually it'll make sure that its argument is packaged under given OS)
mkPackage :: OS -> Text -> Package
mkPackage _ x = Package x

-- | Best-effort attempt to collect all the configs that fits green/red-lists
-- in the destination directory
snapConfigs :: Shell FilePath -> Maybe Greenlist -> Maybe Redlist -> FilePath -> IO ()
snapConfigs relevant gr rd dest = foldIO (simpleFilter relevant gr rd) $ Foldl.FoldM step begin done
  where
    step _acc x = do
      putStrLn $ show x
      sx <- stat x
      if isRegularFile sx
        then do
          let target = joinPaths [ dest, x ]
          let targetDir = directory target
          mktree targetDir
          cp x target
        else
          snapConfigs (ls x) gr rd dest
    begin = return ()
    done = return

-- | Gets to the correct branch within FilePath using DevOps.Config.Git
-- functions, then copies it with sudo.
applyConfigs :: FilePath -> IO (Maybe ())
applyConfigs fp = undefined

-- | Takes a snapshot of packages installed on the system
snapSys :: OS -> IO Snapshot
snapSys Ubuntu = undefined
snapSys _ = error "Unsupported OS"

-- | Best-effort attempt to install listed packages on the system
applySys :: Snapshot -> IO (Maybe ())
applySys = undefined
