{-# LANGUAGE FlexibleInstances, MultiParamTypeClasses, TemplateHaskell #-}
module Model.MenuModel where 

import           Data.SqlTransaction
import           Database.HDBC (toSql)
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
type MString = Maybe String 
$(genAll "MenuModel" "menu" [
        ("id", ''Id),
        ("number", ''Int),
        ("parent", ''Int),
        ("type", ''String),
        ("label", ''String),
        ("module", ''String),
        ("class", ''String),
        ("menu_type", ''MString)
    ])


tagMenuModel t xs = map step xs 
        where step (MenuModel pid pt nm tp lb md cl _) = MenuModel pid pt nm tp lb md cl (Just t)

instance Convertible [MenuModel] FlatTree  where 
        safeConvert = Right . fmap step 
            where step (MenuModel pid pt nm tp lb md cl p) = ((nm ,pt), m)
                            where m = case tp of 
                                        "MenuItem" -> MenuItem lb md cl
                                        "SubMenu" -> SubMenu lb md cl 
                                        "Tab" -> Tab lb md cl 
                                        "Root" -> Root 

instance Convertible FlatTree [MenuModel] where 
        safeConvert = Right . fmap step 
            where 
                    step ((nm, pt), MenuItem lb md cl) = MenuModel Nothing pt nm "MenuItem" lb md cl Nothing 
                    step ((nm, pt), Tab lb md cl) = MenuModel Nothing pt nm "Tab" lb md cl Nothing 
                    step ((nm, pt), SubMenu lb md cl) = MenuModel Nothing pt nm "SubMenu" lb md cl Nothing 
                    step ((nm, pt), Root) = MenuModel Nothing pt nm "Root" "" "" "" Nothing  

instance Convertible (Tree Menu) [MenuModel] where 
        safeConvert x = Right (convert $ toFlat x)

instance Convertible [MenuModel] (Tree Menu) where 
        safeConvert x = Right (fromFlat $ convert x)

logintree = Node Root [Node (SubMenu "ACCOUNT" "" "") 
                            [ Node (MenuItem "LOGIN" "ACCOUNT_LOGIN" "dialog") [],
                               Node (MenuItem "REGISTER" "ACCOUNT_REGISTER" "dialog") []

                               
                            ],
                          Node (MenuItem "MAIN" "MAIN" "") []
                        ]

gametree = Node Root [
            Node (MenuItem "LOGOUT" "LOGOUT" "") [],
            Node (MenuItem "REPORTS" "REPORTS" "") [],
            Node (SubMenu "SHOP" "" "") [
                                Node (MenuItem "NEW_CARS" "MARKETPLACE_NEWCARS" "") [],
                                Node (MenuItem "NEW_PARTS" "MARKETPLACE_NEWPARTS" "") [],
                                Node (MenuItem "USED_PARTS" "MARKETPLACE_USEDPARTS" "") []
                            ],
            Node (MenuItem "PROFILE" "PROFILE" "") [],
            Node (MenuItem "RACES" "RACES" "") [],
            Node (SubMenu "GARAGE" "" "") [
                Node (MenuItem "CARS" "GARAGE_CARS" "") [],
                Node (MenuItem "PARTS" "GARAGE_PARTS" "") [],
                Node (MenuItem "PERSONNEL" "GARAGE_PERSONNEL" "") []

            ],
            Node (MenuItem "HOME" "HOME" "") []

        ]

market_tabstree = Node Root [
            Node (Tab "engine" "PARTS" "") [],
            Node (Tab "suspension" "PARTS" "") [],
            Node (Tab "brake" "PARTS" "") [],
            Node (Tab "wheel" "PARTS" "") [],
            Node (Tab "turbo" "PARTS" "") [],
            Node (Tab "spoiler" "PARTS" "") [],
            Node (Tab "nos" "PARTS" "") []
    ]
garage_tabstree = Node Root [
            Node (Tab "aerodynamic" "PARTS" "") [],
            Node (Tab "engine" "PARTS" "") [],
            Node (Tab "suspension" "PARTS" "") [],
            Node (Tab "brake" "PARTS" "") [],
            Node (Tab "wheel" "PARTS" "") [],
            Node (Tab "turbo" "PARTS" "") [],
            Node (Tab "spoiler" "PARTS" "") [],
            Node (Tab "nos" "PARTS" "") []
    ]


saveTree name tree = do 
        c <- dbconn 
        let bs = tagMenuModel name (convert tree :: [MenuModel]) 
        let step = do 
            quickQuery "delete from menu where menu_type = ?" [toSql name]
            mapM save bs 
        runSqlTransaction step error c 
        

