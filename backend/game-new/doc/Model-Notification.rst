==================
Model.Notification
==================

-  `Contents <index.html>`__
-  `Index <doc-index.html>`__

 

Safe Haskell

None

Model.Notification

Documentation
=============

type MInteger = Maybe Integer

type MString = Maybe String

data Notification

Constructors

Notification

 

Fields

id :: `Id <Model-General.html#t:Id>`__
     
name :: String
     
type :: `MString <Model-Notification.html#t:MString>`__
     
language :: Integer
     
body :: String
     
title :: String
     

Instances

+-----------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Eq `Notification <Model-Notification.html#t:Notification>`__                                                                                                    |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Show `Notification <Model-Notification.html#t:Notification>`__                                                                                                  |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| ToJSON `Notification <Model-Notification.html#t:Notification>`__                                                                                                |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| FromJSON `Notification <Model-Notification.html#t:Notification>`__                                                                                              |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Default `Notification <Model-Notification.html#t:Notification>`__                                                                                               |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-InRules.html#t:FromInRule>`__ `Notification <Model-Notification.html#t:Notification>`__                                                       |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `ToInRule <Data-InRules.html#t:ToInRule>`__ `Notification <Model-Notification.html#t:Notification>`__                                                           |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ `Notification <Model-Notification.html#t:Notification>`__                                                            |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `Notification <Model-Notification.html#t:Notification>`__   |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+

relation :: `RelationM <Data-Relation.html#t:RelationM>`__

schema :: [[Char]]

Produced by `Haddock <http://www.haskell.org/haddock/>`__ version 2.11.0
