module DevOps.Config.Git where

import Data.Text (Text(..))
import Network.HostName (getHostName)
import qualified Data.Text as T

newtype Branch = Branch { getBranch :: Text }
h2b :: String -> Branch
h2b = (Branch . T.pack)

-- | Returns hostname
branch :: IO Branch
branch = getHostName >>= (return . h2b)

