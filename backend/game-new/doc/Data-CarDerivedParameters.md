-   [Contents](index.html)
-   [Index](doc-index.html)

 

Safe Haskell

None

Data.CarDerivedParameters

Description

This module has some calculations for the derived parameters (these are the parameters used in the calculations)

Synopsis

-   [searchCarInGarage](#v:searchCarInGarage) :: [Constraints](Data-Database.html#t:Constraints) -\> [Orders](Data-Database.html#t:Orders) -\> Integer -\> Integer -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) [Connection](Data-SqlTransaction.html#t:Connection) [[CarInGarage](Model-CarInGarage.html#t:CarInGarage)]
-   [getCarInGarage](#v:getCarInGarage) :: [[Constraint](Data-Database.html#t:Constraint)] -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) [Connection](Data-SqlTransaction.html#t:Connection) [CarInGarage](Model-CarInGarage.html#t:CarInGarage) -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) [Connection](Data-SqlTransaction.html#t:Connection) [CarInGarage](Model-CarInGarage.html#t:CarInGarage)
-   [loadCarInGarage](#v:loadCarInGarage) :: Integer -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) [Connection](Data-SqlTransaction.html#t:Connection) [CarInGarage](Model-CarInGarage.html#t:CarInGarage) -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) [Connection](Data-SqlTransaction.html#t:Connection) [CarInGarage](Model-CarInGarage.html#t:CarInGarage)
-   [previewWithPartList](#v:previewWithPartList) :: [CarInGarage](Model-CarInGarage.html#t:CarInGarage) -\> [[GaragePart](Model-GarageParts.html#t:GaragePart)] -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) [Connection](Data-SqlTransaction.html#t:Connection) [PreviewPart]
-   [previewWithPart](#v:previewWithPart) :: [CarInGarage](Model-CarInGarage.html#t:CarInGarage) -\> [GaragePart](Model-GarageParts.html#t:GaragePart) -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) [Connection](Data-SqlTransaction.html#t:Connection) PreviewPart
-   [searchCarMinified](#v:searchCarMinified) :: [Constraints](Data-Database.html#t:Constraints) -\> [Orders](Data-Database.html#t:Orders) -\> Integer -\> Integer -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) [Connection](Data-SqlTransaction.html#t:Connection) [[CarMinimal](Model-CarMinimal.html#t:CarMinimal)]
-   [loadCarMinified](#v:loadCarMinified) :: Integer -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) [Connection](Data-SqlTransaction.html#t:Connection) [CarInGarage](Model-CarInGarage.html#t:CarInGarage) -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) [Connection](Data-SqlTransaction.html#t:Connection) [CarMinimal](Model-CarMinimal.html#t:CarMinimal)
-   [getCarMinified](#v:getCarMinified) :: [Constraints](Data-Database.html#t:Constraints) -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) [Connection](Data-SqlTransaction.html#t:Connection) [CarInGarage](Model-CarInGarage.html#t:CarInGarage) -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) [Connection](Data-SqlTransaction.html#t:Connection) [CarMinimal](Model-CarMinimal.html#t:CarMinimal)

Documentation
=============

searchCarInGarage

Arguments

:: [Constraints](Data-Database.html#t:Constraints)

Database search constraints

-\> [Orders](Data-Database.html#t:Orders)

Ordering

-\> Integer

limit

-\> Integer

offset

-\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) [Connection](Data-SqlTransaction.html#t:Connection) [[CarInGarage](Model-CarInGarage.html#t:CarInGarage)]

 

Find a car in garage with derived parameters

getCarInGarage

Arguments

:: [[Constraint](Data-Database.html#t:Constraint)]

Database search constraints

-\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) [Connection](Data-SqlTransaction.html#t:Connection) [CarInGarage](Model-CarInGarage.html#t:CarInGarage)

Default car

-\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) [Connection](Data-SqlTransaction.html#t:Connection) [CarInGarage](Model-CarInGarage.html#t:CarInGarage)

 

get car in garage with default

loadCarInGarage :: Integer -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) [Connection](Data-SqlTransaction.html#t:Connection) [CarInGarage](Model-CarInGarage.html#t:CarInGarage) -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) [Connection](Data-SqlTransaction.html#t:Connection) [CarInGarage](Model-CarInGarage.html#t:CarInGarage)

Load a specific car

previewWithPartList :: [CarInGarage](Model-CarInGarage.html#t:CarInGarage) -\> [[GaragePart](Model-GarageParts.html#t:GaragePart)] -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) [Connection](Data-SqlTransaction.html#t:Connection) [PreviewPart]

previewWithPart :: [CarInGarage](Model-CarInGarage.html#t:CarInGarage) -\> [GaragePart](Model-GarageParts.html#t:GaragePart) -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) [Connection](Data-SqlTransaction.html#t:Connection) PreviewPart

searchCarMinified

Arguments

:: [Constraints](Data-Database.html#t:Constraints)

Database search constraints

-\> [Orders](Data-Database.html#t:Orders)

Order

-\> Integer

limit

-\> Integer

offset

-\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) [Connection](Data-SqlTransaction.html#t:Connection) [[CarMinimal](Model-CarMinimal.html#t:CarMinimal)]

 

Get a minified car

loadCarMinified :: Integer -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) [Connection](Data-SqlTransaction.html#t:Connection) [CarInGarage](Model-CarInGarage.html#t:CarInGarage) -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) [Connection](Data-SqlTransaction.html#t:Connection) [CarMinimal](Model-CarMinimal.html#t:CarMinimal)

getCarMinified :: [Constraints](Data-Database.html#t:Constraints) -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) [Connection](Data-SqlTransaction.html#t:Connection) [CarInGarage](Model-CarInGarage.html#t:CarInGarage) -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) [Connection](Data-SqlTransaction.html#t:Connection) [CarMinimal](Model-CarMinimal.html#t:CarMinimal)

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
