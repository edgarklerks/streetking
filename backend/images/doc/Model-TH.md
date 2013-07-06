% Model.TH
% 
% 

-   [Contents](index.html)
-   [Index](doc-index.html)

 

Safe Haskell

None

Model.TH

Synopsis

-   [getAnyColumn](#v:getAnyColumn) :: String -\> Q String
-   [checkTables](#v:checkTables) :: String -\> [(String, Name)] -\> Q
    ()
-   [isMaybe](#v:isMaybe) :: Name -\> Q Bool
-   [genAll](#v:genAll) :: String -\> String -\> [(String, Name)] -\> Q
    [Dec]
-   [genAllId](#v:genAllId) :: String -\> String -\> String -\>
    [(String, Name)] -\> Q [Dec]
-   [genMapableRecord](#v:genMapableRecord) :: String -\> [(String,
    Name)] -\> Q [Dec]
-   [genRecord](#v:genRecord) :: String -\> [(String, Name)] -\> Q [Dec]
-   [genDependenciesUpdate](#v:genDependenciesUpdate) :: [(String,
    String)] -\> String
-   [genDatabase](#v:genDatabase) :: String -\> String -\> String -\>
    [(String, Name)] -\> Q [Dec]
-   [genInstance](#v:genInstance) :: String -\> [(String, Name)] -\> Q
    [Dec]
-   [genDefaultInstance](#v:genDefaultInstance) :: String -\> [(String,
    Name)] -\> Q [Dec]
-   [tmMap](#v:tmMap) :: t -\> [String] -\> [DecQ]
-   [frmMap](#v:frmMap) :: String -\> [String] -\> [DecQ]
-   [loadDb](#v:loadDb) :: String -\> String -\> [DecQ]
-   [fieldsDb](#v:fieldsDb) :: [(String, Name)] -\> [DecQ]
-   [tableDb](#v:tableDb) :: String -\> [DecQ]
-   [searchDB](#v:searchDB) :: String -\> [DecQ]
-   [deleteDb](#v:deleteDb) :: String -\> [DecQ]
-   [idq](#v:idq) :: Q ()
-   [upsertWithTables](#v:upsertWithTables) :: [(String, [String])] -\>
    [Sql](Data-Database.html#t:Sql) -\> HashMap
    [Sql](Data-Database.html#t:Sql) [Value](Data-Database.html#t:Value)
    -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction)
    [Connection](Data-SqlTransaction.html#t:Connection)
    [Value](Data-Database.html#t:Value)
-   [saveDb](#v:saveDb) :: String -\> [DecQ]
-   [saveDb'](#v:saveDb-39-) :: String -\> [DecQ]
-   [tmHashMap](#v:tmHashMap) :: t -\> [String] -\> [DecQ]
-   [frmHashMap](#v:frmHashMap) :: String -\> [String] -\> [DecQ]
-   [genInstanceToJSON](#v:genInstanceToJSON) :: String -\> [(String,
    b)] -\> Q [Dec]
-   [genInstanceFromJSON](#v:genInstanceFromJSON) :: String -\>
    [(String, b)] -\> Q [Dec]
-   [mkParser](#v:mkParser) :: String -\> [String] -\> Q Dec
-   [mkToJson](#v:mkToJson) :: [String] -\> Q Dec
-   [hempty](#v:hempty) :: HashMap String Value
-   [hiempty](#v:hiempty) :: HashMap String
    [InRule](Data-InRules.html#t:InRule)
-   [hfromlist](#v:hfromlist) :: [(String, Value)] -\> HashMap String
    Value
-   [hmlookup](#v:hmlookup) :: String -\> HashMap String b -\> b
-   [genInstanceToInRule](#v:genInstanceToInRule) :: String -\>
    [(String, b)] -\> Q [Dec]
-   [genInstanceFromInRule](#v:genInstanceFromInRule) :: String -\>
    [(String, b)] -\> Q [Dec]
-   [mkFromInRule](#v:mkFromInRule) :: String -\> [String] -\> Q Dec
-   [mkToInRule](#v:mkToInRule) :: [String] -\> Q Dec
-   [genRelationSchema](#v:genRelationSchema) :: [(String, Name)] -\> Q
    [Dec]
-   [genRelation](#v:genRelation) :: String -\> [(String, Name)] -\> Q
    [Dec]

Documentation
=============

getAnyColumn :: String -\> Q String

checkTables :: String -\> [(String, Name)] -\> Q ()

isMaybe :: Name -\> Q Bool

genAll :: String -\> String -\> [(String, Name)] -\> Q [Dec]

genAllId :: String -\> String -\> String -\> [(String, Name)] -\> Q
[Dec]

genMapableRecord :: String -\> [(String, Name)] -\> Q [Dec]

genRecord :: String -\> [(String, Name)] -\> Q [Dec]

genDependenciesUpdate :: [(String, String)] -\> String

genDatabase :: String -\> String -\> String -\> [(String, Name)] -\> Q
[Dec]

genInstance :: String -\> [(String, Name)] -\> Q [Dec]

genDefaultInstance :: String -\> [(String, Name)] -\> Q [Dec]

tmMap :: t -\> [String] -\> [DecQ]

frmMap :: String -\> [String] -\> [DecQ]

loadDb :: String -\> String -\> [DecQ]

fieldsDb :: [(String, Name)] -\> [DecQ]

tableDb :: String -\> [DecQ]

searchDB :: String -\> [DecQ]

deleteDb :: String -\> [DecQ]

idq :: Q ()

upsertWithTables :: [(String, [String])] -\>
[Sql](Data-Database.html#t:Sql) -\> HashMap
[Sql](Data-Database.html#t:Sql) [Value](Data-Database.html#t:Value) -\>
[SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction)
[Connection](Data-SqlTransaction.html#t:Connection)
[Value](Data-Database.html#t:Value)

Like upset with extra update statements

saveDb :: String -\> [DecQ]

save i = mco \$ upsertWithTables undefined tablename (toHashMap i)

saveDb' :: String -\> [DecQ]

tmHashMap :: t -\> [String] -\> [DecQ]

frmHashMap :: String -\> [String] -\> [DecQ]

genInstanceToJSON :: String -\> [(String, b)] -\> Q [Dec]

genInstanceFromJSON :: String -\> [(String, b)] -\> Q [Dec]

mkParser :: String -\> [String] -\> Q Dec

mkToJson :: [String] -\> Q Dec

hempty :: HashMap String Value

hiempty :: HashMap String [InRule](Data-InRules.html#t:InRule)

hfromlist :: [(String, Value)] -\> HashMap String Value

hmlookup :: String -\> HashMap String b -\> b

genInstanceToInRule :: String -\> [(String, b)] -\> Q [Dec]

genInstanceFromInRule :: String -\> [(String, b)] -\> Q [Dec]

mkFromInRule :: String -\> [String] -\> Q Dec

mkToInRule :: [String] -\> Q Dec

genRelationSchema :: [(String, Name)] -\> Q [Dec]

genRelation :: String -\> [(String, Name)] -\> Q [Dec]

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
