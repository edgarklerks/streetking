{-# LANGUAGE FlexibleInstances, MultiParamTypeClasses, TemplateHaskell #-}
module Model.MenuModel where 

import           Data.SqlTransaction
import           Database.HDBC
import           Data.Convertible
import           Model.General
import           Data.MenuTree 
import           Data.Database 
import           Control.Monad
import           Data.Tree

import           Control.Applicative
import qualified Data.Map as M
import           Model.TH
import           Prelude hiding (id)

$(genAll "MenuModel" "menu" [
        ("id", ''Id),
        ("parent", ''Int),
        ("number", ''Int),
        ("type", ''String),
        ("label", ''String),
        ("module", ''String),
        ("class", ''String)
    ])


instance Convertible [MenuModel] FlatTree  where 
        safeConvert = Right . fmap step 
            where step (MenuModel pid pt nm tp lb md cl) = ((nm ,pt), m)
                            where m = case tp of 
                                        "MenuItem" -> MenuItem lb md cl
                                        "SubMenu" -> SubMenu lb md cl 
                                        "Tab" -> Tab lb md cl 

instance Convertible FlatTree [MenuModel] where 
        safeConvert = Right . fmap step 
            where 
                    step ((pt, nm), MenuItem lb md cl) = MenuModel Nothing pt nm "MenuItem" lb md cl 
                    step ((pt, nm), Tab lb md cl) = MenuModel Nothing pt nm "Tab" lb md cl 
                    step ((pt, nm), SubMenu lb md cl) = MenuModel Nothing pt nm "SubMenu" lb md cl 

instance Convertible (Tree Menu) [MenuModel] where 
        safeConvert x = Right (convert $ toFlat x)

instance Convertible [MenuModel] (Tree Menu) where 
        safeConvert x = Right (fromFlat $ convert x)
