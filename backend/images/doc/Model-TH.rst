========
Model.TH
========

-  `Contents <index.html>`__
-  `Index <doc-index.html>`__

 

Safe Haskell

None

Model.TH

Synopsis

-  `getAnyColumn <#v:getAnyColumn>`__ :: String -> Q String
-  `checkTables <#v:checkTables>`__ :: String -> [(String, Name)] -> Q
   ()
-  `isMaybe <#v:isMaybe>`__ :: Name -> Q Bool
-  `genAll <#v:genAll>`__ :: String -> String -> [(String, Name)] -> Q
   [Dec]
-  `genAllId <#v:genAllId>`__ :: String -> String -> String -> [(String,
   Name)] -> Q [Dec]
-  `genMapableRecord <#v:genMapableRecord>`__ :: String -> [(String,
   Name)] -> Q [Dec]
-  `genRecord <#v:genRecord>`__ :: String -> [(String, Name)] -> Q [Dec]
-  `genDependenciesUpdate <#v:genDependenciesUpdate>`__ :: [(String,
   String)] -> String
-  `genDatabase <#v:genDatabase>`__ :: String -> String -> String ->
   [(String, Name)] -> Q [Dec]
-  `genInstance <#v:genInstance>`__ :: String -> [(String, Name)] -> Q
   [Dec]
-  `genDefaultInstance <#v:genDefaultInstance>`__ :: String -> [(String,
   Name)] -> Q [Dec]
-  `tmMap <#v:tmMap>`__ :: t -> [String] -> [DecQ]
-  `frmMap <#v:frmMap>`__ :: String -> [String] -> [DecQ]
-  `loadDb <#v:loadDb>`__ :: String -> String -> [DecQ]
-  `fieldsDb <#v:fieldsDb>`__ :: [(String, Name)] -> [DecQ]
-  `tableDb <#v:tableDb>`__ :: String -> [DecQ]
-  `searchDB <#v:searchDB>`__ :: String -> [DecQ]
-  `deleteDb <#v:deleteDb>`__ :: String -> [DecQ]
-  `idq <#v:idq>`__ :: Q ()
-  `upsertWithTables <#v:upsertWithTables>`__ :: [(String, [String])] ->
   `Sql <Data-Database.html#t:Sql>`__ -> HashMap
   `Sql <Data-Database.html#t:Sql>`__
   `Value <Data-Database.html#t:Value>`__ ->
   `SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
   `Connection <Data-SqlTransaction.html#t:Connection>`__
   `Value <Data-Database.html#t:Value>`__
-  `saveDb <#v:saveDb>`__ :: String -> [DecQ]
-  `saveDb' <#v:saveDb-39->`__ :: String -> [DecQ]
-  `tmHashMap <#v:tmHashMap>`__ :: t -> [String] -> [DecQ]
-  `frmHashMap <#v:frmHashMap>`__ :: String -> [String] -> [DecQ]
-  `genInstanceToJSON <#v:genInstanceToJSON>`__ :: String -> [(String,
   b)] -> Q [Dec]
-  `genInstanceFromJSON <#v:genInstanceFromJSON>`__ :: String ->
   [(String, b)] -> Q [Dec]
-  `mkParser <#v:mkParser>`__ :: String -> [String] -> Q Dec
-  `mkToJson <#v:mkToJson>`__ :: [String] -> Q Dec
-  `hempty <#v:hempty>`__ :: HashMap String Value
-  `hiempty <#v:hiempty>`__ :: HashMap String
   `InRule <Data-InRules.html#t:InRule>`__
-  `hfromlist <#v:hfromlist>`__ :: [(String, Value)] -> HashMap String
   Value
-  `hmlookup <#v:hmlookup>`__ :: String -> HashMap String b -> b
-  `genInstanceToInRule <#v:genInstanceToInRule>`__ :: String ->
   [(String, b)] -> Q [Dec]
-  `genInstanceFromInRule <#v:genInstanceFromInRule>`__ :: String ->
   [(String, b)] -> Q [Dec]
-  `mkFromInRule <#v:mkFromInRule>`__ :: String -> [String] -> Q Dec
-  `mkToInRule <#v:mkToInRule>`__ :: [String] -> Q Dec
-  `genRelationSchema <#v:genRelationSchema>`__ :: [(String, Name)] -> Q
   [Dec]
-  `genRelation <#v:genRelation>`__ :: String -> [(String, Name)] -> Q
   [Dec]

Documentation
=============

getAnyColumn :: String -> Q String

checkTables :: String -> [(String, Name)] -> Q ()

isMaybe :: Name -> Q Bool

genAll :: String -> String -> [(String, Name)] -> Q [Dec]

genAllId :: String -> String -> String -> [(String, Name)] -> Q [Dec]

genMapableRecord :: String -> [(String, Name)] -> Q [Dec]

genRecord :: String -> [(String, Name)] -> Q [Dec]

genDependenciesUpdate :: [(String, String)] -> String

genDatabase :: String -> String -> String -> [(String, Name)] -> Q [Dec]

genInstance :: String -> [(String, Name)] -> Q [Dec]

genDefaultInstance :: String -> [(String, Name)] -> Q [Dec]

tmMap :: t -> [String] -> [DecQ]

frmMap :: String -> [String] -> [DecQ]

loadDb :: String -> String -> [DecQ]

fieldsDb :: [(String, Name)] -> [DecQ]

tableDb :: String -> [DecQ]

searchDB :: String -> [DecQ]

deleteDb :: String -> [DecQ]

idq :: Q ()

upsertWithTables :: [(String, [String])] ->
`Sql <Data-Database.html#t:Sql>`__ -> HashMap
`Sql <Data-Database.html#t:Sql>`__
`Value <Data-Database.html#t:Value>`__ ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__
`Value <Data-Database.html#t:Value>`__

Like upset with extra update statements

saveDb :: String -> [DecQ]

save i = mco $ upsertWithTables undefined tablename (toHashMap i)

saveDb' :: String -> [DecQ]

tmHashMap :: t -> [String] -> [DecQ]

frmHashMap :: String -> [String] -> [DecQ]

genInstanceToJSON :: String -> [(String, b)] -> Q [Dec]

genInstanceFromJSON :: String -> [(String, b)] -> Q [Dec]

mkParser :: String -> [String] -> Q Dec

mkToJson :: [String] -> Q Dec

hempty :: HashMap String Value

hiempty :: HashMap String `InRule <Data-InRules.html#t:InRule>`__

hfromlist :: [(String, Value)] -> HashMap String Value

hmlookup :: String -> HashMap String b -> b

genInstanceToInRule :: String -> [(String, b)] -> Q [Dec]

genInstanceFromInRule :: String -> [(String, b)] -> Q [Dec]

mkFromInRule :: String -> [String] -> Q Dec

mkToInRule :: [String] -> Q Dec

genRelationSchema :: [(String, Name)] -> Q [Dec]

genRelation :: String -> [(String, Name)] -> Q [Dec]

Produced by `Haddock <http://www.haskell.org/haddock/>`__ version 2.11.0
