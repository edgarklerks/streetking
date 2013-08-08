=========================
Data.CarDerivedParameters
=========================

-  `Contents <index.html>`__
-  `Index <doc-index.html>`__

 

Safe Haskell

None

Data.CarDerivedParameters

Description

This module has some calculations for the derived parameters (these are
the parameters used in the calculations)

Synopsis

-  `searchCarInGarage <#v:searchCarInGarage>`__ ::
   `Constraints <Data-Database.html#t:Constraints>`__ ->
   `Orders <Data-Database.html#t:Orders>`__ -> Integer -> Integer ->
   `SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
   `Connection <Data-SqlTransaction.html#t:Connection>`__
   [`CarInGarage <Model-CarInGarage.html#t:CarInGarage>`__\ ]
-  `getCarInGarage <#v:getCarInGarage>`__ ::
   [`Constraint <Data-Database.html#t:Constraint>`__\ ] ->
   `SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
   `Connection <Data-SqlTransaction.html#t:Connection>`__
   `CarInGarage <Model-CarInGarage.html#t:CarInGarage>`__ ->
   `SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
   `Connection <Data-SqlTransaction.html#t:Connection>`__
   `CarInGarage <Model-CarInGarage.html#t:CarInGarage>`__
-  `loadCarInGarage <#v:loadCarInGarage>`__ :: Integer ->
   `SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
   `Connection <Data-SqlTransaction.html#t:Connection>`__
   `CarInGarage <Model-CarInGarage.html#t:CarInGarage>`__ ->
   `SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
   `Connection <Data-SqlTransaction.html#t:Connection>`__
   `CarInGarage <Model-CarInGarage.html#t:CarInGarage>`__
-  `previewWithPartList <#v:previewWithPartList>`__ ::
   `CarInGarage <Model-CarInGarage.html#t:CarInGarage>`__ ->
   [`GaragePart <Model-GarageParts.html#t:GaragePart>`__\ ] ->
   `SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
   `Connection <Data-SqlTransaction.html#t:Connection>`__ [PreviewPart]
-  `previewWithPart <#v:previewWithPart>`__ ::
   `CarInGarage <Model-CarInGarage.html#t:CarInGarage>`__ ->
   `GaragePart <Model-GarageParts.html#t:GaragePart>`__ ->
   `SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
   `Connection <Data-SqlTransaction.html#t:Connection>`__ PreviewPart
-  `searchCarMinified <#v:searchCarMinified>`__ ::
   `Constraints <Data-Database.html#t:Constraints>`__ ->
   `Orders <Data-Database.html#t:Orders>`__ -> Integer -> Integer ->
   `SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
   `Connection <Data-SqlTransaction.html#t:Connection>`__
   [`CarMinimal <Model-CarMinimal.html#t:CarMinimal>`__\ ]
-  `loadCarMinified <#v:loadCarMinified>`__ :: Integer ->
   `SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
   `Connection <Data-SqlTransaction.html#t:Connection>`__
   `CarInGarage <Model-CarInGarage.html#t:CarInGarage>`__ ->
   `SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
   `Connection <Data-SqlTransaction.html#t:Connection>`__
   `CarMinimal <Model-CarMinimal.html#t:CarMinimal>`__
-  `getCarMinified <#v:getCarMinified>`__ ::
   `Constraints <Data-Database.html#t:Constraints>`__ ->
   `SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
   `Connection <Data-SqlTransaction.html#t:Connection>`__
   `CarInGarage <Model-CarInGarage.html#t:CarInGarage>`__ ->
   `SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
   `Connection <Data-SqlTransaction.html#t:Connection>`__
   `CarMinimal <Model-CarMinimal.html#t:CarMinimal>`__

Documentation
=============

searchCarInGarage

Arguments

:: `Constraints <Data-Database.html#t:Constraints>`__

Database search constraints

-> `Orders <Data-Database.html#t:Orders>`__

Ordering

-> Integer

limit

-> Integer

offset

-> `SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__
[`CarInGarage <Model-CarInGarage.html#t:CarInGarage>`__\ ]

 

Find a car in garage with derived parameters

getCarInGarage

Arguments

:: [`Constraint <Data-Database.html#t:Constraint>`__\ ]

Database search constraints

-> `SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__
`CarInGarage <Model-CarInGarage.html#t:CarInGarage>`__

Default car

-> `SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__
`CarInGarage <Model-CarInGarage.html#t:CarInGarage>`__

 

get car in garage with default

loadCarInGarage :: Integer ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__
`CarInGarage <Model-CarInGarage.html#t:CarInGarage>`__ ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__
`CarInGarage <Model-CarInGarage.html#t:CarInGarage>`__

Load a specific car

previewWithPartList ::
`CarInGarage <Model-CarInGarage.html#t:CarInGarage>`__ ->
[`GaragePart <Model-GarageParts.html#t:GaragePart>`__\ ] ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__ [PreviewPart]

previewWithPart ::
`CarInGarage <Model-CarInGarage.html#t:CarInGarage>`__ ->
`GaragePart <Model-GarageParts.html#t:GaragePart>`__ ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__ PreviewPart

searchCarMinified

Arguments

:: `Constraints <Data-Database.html#t:Constraints>`__

Database search constraints

-> `Orders <Data-Database.html#t:Orders>`__

Order

-> Integer

limit

-> Integer

offset

-> `SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__
[`CarMinimal <Model-CarMinimal.html#t:CarMinimal>`__\ ]

 

Get a minified car

loadCarMinified :: Integer ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__
`CarInGarage <Model-CarInGarage.html#t:CarInGarage>`__ ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__
`CarMinimal <Model-CarMinimal.html#t:CarMinimal>`__

getCarMinified :: `Constraints <Data-Database.html#t:Constraints>`__ ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__
`CarInGarage <Model-CarInGarage.html#t:CarInGarage>`__ ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__
`CarMinimal <Model-CarMinimal.html#t:CarMinimal>`__

Produced by `Haddock <http://www.haskell.org/haddock/>`__ version 2.11.0
