-- | Git types.
--
-- Some day, we will make proper smart constructors! I promise.
module DevOps.Git ( Branch ()
                  , mkBranch
                  , getBranch
                  , Repo ()
                  , mkRepo
                  , getRepo
                  , hostnameBranch
                  ) where

import Turtle
import Prelude hiding (FilePath)
import Data.Text (Text(..))
import Network.HostName (getHostName)
import qualified Data.Text as T

newtype Branch = Branch { getBranch :: Text }
mkBranch :: Text -> Branch
mkBranch x = Branch x

h2b :: String -> Branch
h2b = (Branch . T.pack)

newtype Repo = Repo { getRepo :: Text }
mkRepo :: Text -> Repo
mkRepo x = Repo x

-- | Returns branch named the same way as hostname
hostnameBranch :: IO Branch
hostnameBranch = getHostName >>= (return . h2b)

-- | Adds everything and makes a commit
commit :: FilePath -> IO ExitCode
commit fp = undefined
