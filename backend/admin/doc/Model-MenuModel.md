% Model.MenuModel
% 
% 

-   [Contents](index.html)
-   [Index](doc-index.html)

 

Safe Haskell

None

Model.MenuModel

Documentation
=============

type MString = Maybe String

data MenuModel

Constructors

MenuModel

 

Fields

id :: [Id](Model-General.html#t:Id)
:    
number :: Int
:    
parent :: Int
:    
type :: String
:    
label :: String
:    
module :: String
:    
class :: String
:    
menu\_type :: [MString](Model-MenuModel.html#t:MString)
:    

Instances

  --------------------------------------------------------------------------------------------------------------------------------------------- ---
  Eq [MenuModel](Model-MenuModel.html#t:MenuModel)                                                                                               
  Show [MenuModel](Model-MenuModel.html#t:MenuModel)                                                                                             
  ToJSON [MenuModel](Model-MenuModel.html#t:MenuModel)                                                                                           
  FromJSON [MenuModel](Model-MenuModel.html#t:MenuModel)                                                                                         
  Default [MenuModel](Model-MenuModel.html#t:MenuModel)                                                                                          
  [FromInRule](Data-InRules.html#t:FromInRule) [MenuModel](Model-MenuModel.html#t:MenuModel)                                                     
  [ToInRule](Data-InRules.html#t:ToInRule) [MenuModel](Model-MenuModel.html#t:MenuModel)                                                         
  [Mapable](Model-General.html#t:Mapable) [MenuModel](Model-MenuModel.html#t:MenuModel)                                                          
  [Database](Model-General.html#t:Database) [Connection](Data-SqlTransaction.html#t:Connection) [MenuModel](Model-MenuModel.html#t:MenuModel)    
  Convertible [FlatTree](Data-MenuTree.html#t:FlatTree) [[MenuModel](Model-MenuModel.html#t:MenuModel)]                                          
  Convertible [[MenuModel](Model-MenuModel.html#t:MenuModel)] [FlatTree](Data-MenuTree.html#t:FlatTree)                                          
  Convertible [[MenuModel](Model-MenuModel.html#t:MenuModel)] (Tree [Menu](Data-MenuTree.html#t:Menu))                                           
  Convertible (Tree [Menu](Data-MenuTree.html#t:Menu)) [[MenuModel](Model-MenuModel.html#t:MenuModel)]                                           
  --------------------------------------------------------------------------------------------------------------------------------------------- ---

relation :: [RelationM](Data-Relation.html#t:RelationM)

schema :: [[Char]]

tagMenuModel :: String -\>
[[MenuModel](Model-MenuModel.html#t:MenuModel)] -\>
[[MenuModel](Model-MenuModel.html#t:MenuModel)]

logintree :: Tree [Menu](Data-MenuTree.html#t:Menu)

gametree :: Tree [Menu](Data-MenuTree.html#t:Menu)

market\_tabstree :: Tree [Menu](Data-MenuTree.html#t:Menu)

garage\_tabstree :: Tree [Menu](Data-MenuTree.html#t:Menu)

saveTree :: Convertible a
[[MenuModel](Model-MenuModel.html#t:MenuModel)] =\> String -\> a -\> IO
[Integer]

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
