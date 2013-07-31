====================
Data.RaceParticipant
====================

-  `Contents <index.html>`__
-  `Index <doc-index.html>`__

 

Safe Haskell

None

Data.RaceParticipant

Documentation
=============

data RaceParticipant

Constructors

RaceParticipant

 

Fields

rp\_account :: `Account <Model-Account.html#t:Account>`__
     
rp\_account\_min ::
`AccountProfileMin <Model-AccountProfileMin.html#t:AccountProfileMin>`__
     
rp\_car :: `CarInGarage <Model-CarInGarage.html#t:CarInGarage>`__
     
rp\_car\_min :: `CarMinimal <Model-CarMinimal.html#t:CarMinimal>`__
     
rp\_escrow\_id :: MInteger
     

Instances

+---------------------------------------------------------------------------------------------------------------------+-----+
| Eq `RaceParticipant <Data-RaceParticipant.html#t:RaceParticipant>`__                                                |     |
+---------------------------------------------------------------------------------------------------------------------+-----+
| Show `RaceParticipant <Data-RaceParticipant.html#t:RaceParticipant>`__                                              |     |
+---------------------------------------------------------------------------------------------------------------------+-----+
| ToJSON `RaceParticipant <Data-RaceParticipant.html#t:RaceParticipant>`__                                            |     |
+---------------------------------------------------------------------------------------------------------------------+-----+
| FromJSON `RaceParticipant <Data-RaceParticipant.html#t:RaceParticipant>`__                                          |     |
+---------------------------------------------------------------------------------------------------------------------+-----+
| Default `RaceParticipant <Data-RaceParticipant.html#t:RaceParticipant>`__                                           |     |
+---------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-InRules.html#t:FromInRule>`__ `RaceParticipant <Data-RaceParticipant.html#t:RaceParticipant>`__   |     |
+---------------------------------------------------------------------------------------------------------------------+-----+
| `ToInRule <Data-InRules.html#t:ToInRule>`__ `RaceParticipant <Data-RaceParticipant.html#t:RaceParticipant>`__       |     |
+---------------------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ `RaceParticipant <Data-RaceParticipant.html#t:RaceParticipant>`__        |     |
+---------------------------------------------------------------------------------------------------------------------+-----+

mkRaceParticipant :: Integer -> Integer -> Maybe Integer ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__
`RaceParticipant <Data-RaceParticipant.html#t:RaceParticipant>`__

rp\_account\_id ::
`RaceParticipant <Data-RaceParticipant.html#t:RaceParticipant>`__ ->
Integer

rp\_car\_id ::
`RaceParticipant <Data-RaceParticipant.html#t:RaceParticipant>`__ ->
Integer

Produced by `Haddock <http://www.haskell.org/haddock/>`__ version 2.11.0
