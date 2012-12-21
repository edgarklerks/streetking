module Paths_secureproxy (
    version,
    getBinDir, getLibDir, getDataDir, getLibexecDir,
    getDataFileName
  ) where

import qualified Control.Exception as Exception
import Data.Version (Version(..))
import System.Environment (getEnv)
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
catchIO = Exception.catch


version :: Version
version = Version {versionBranch = [0,1], versionTags = []}
bindir, libdir, datadir, libexecdir :: FilePath

bindir     = "/home/edgar/.cabal/bin"
libdir     = "/home/edgar/.cabal/lib/secureproxy-0.1/ghc-7.4.1"
datadir    = "/home/edgar/.cabal/share/secureproxy-0.1"
libexecdir = "/home/edgar/.cabal/libexec"

getBinDir, getLibDir, getDataDir, getLibexecDir :: IO FilePath
getBinDir = catchIO (getEnv "secureproxy_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "secureproxy_libdir") (\_ -> return libdir)
getDataDir = catchIO (getEnv "secureproxy_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "secureproxy_libexecdir") (\_ -> return libexecdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "/" ++ name)
