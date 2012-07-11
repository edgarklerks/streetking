{-# LANGUAGE DeriveDataTypeable, TemplateHaskell, NoMonomorphismRestriction, TypeFamilies #-}
module Data.AcidStore where 

import qualified Data.HashMap.Strict as H
import qualified Data.ByteString as B
import           Data.Typeable
import           Data.Lens.Strict
import           Data.Lens.Template 
import           Data.SafeCopy
import           Control.Applicative
import           Control.Monad
import           Control.Monad.Reader
import           Control.Monad.State
import           Data.Acid

data AcidState a = PS {
        _store :: H.HashMap B.ByteString a  
    } deriving (Show, Typeable)

$(makeLenses [''AcidState])

instance (SafeCopy a) => SafeCopy (AcidState a) where 
        version = 0
        kind = base 
        putCopy (PS a) = contain $ safePut $ H.toList a
        getCopy = contain $ liftM (PS . H.fromList) safeGet

search :: B.ByteString -> Query (AcidState a) (Maybe a)
search s = asks _store >>= \c -> return (H.lookup s c)


add  :: B.ByteString -> a -> Update (AcidState a) ()
add k v = gets _store >>= \c -> put (PS $ H.insert k v c)

delete :: B.ByteString -> Update (AcidState a) ()
delete k = gets _store >>= \c -> put (PS $ H.delete k c)

$(makeAcidic ''AcidStore ['search, 'add, 'delete])
