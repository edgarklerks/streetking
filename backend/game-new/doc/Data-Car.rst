========
Data.Car
========

-  `Contents <index.html>`__
-  `Index <doc-index.html>`__

 

Safe Haskell

None

Data.Car

Description

Car specific functions

Synopsis

-  data `Car <#t:Car>`__ = `Car <#v:Car>`__ {

   -  `mass <#v:mass>`__ :: Double
   -  `power <#v:power>`__ :: Double
   -  `traction <#v:traction>`__ :: Double
   -  `handling <#v:handling>`__ :: Double
   -  `braking <#v:braking>`__ :: Double
   -  `aero <#v:aero>`__ :: Double
   -  `nos <#v:nos>`__ :: Double

   }
-  `pwr <#v:pwr>`__ :: `Car <Data-Car.html#t:Car>`__ -> Double
-  `hlm <#v:hlm>`__ :: `Car <Data-Car.html#t:Car>`__ -> Double
-  `tco <#v:tco>`__ :: `Car <Data-Car.html#t:Car>`__ -> Double
-  `cda <#v:cda>`__ :: `Car <Data-Car.html#t:Car>`__ -> Double
-  `dnf <#v:dnf>`__ :: `Car <Data-Car.html#t:Car>`__ -> Double
-  `brp <#v:brp>`__ :: `Car <Data-Car.html#t:Car>`__ -> Double
-  `carInGarageCar <#v:carInGarageCar>`__ ::
   `CarInGarage <Model-CarInGarage.html#t:CarInGarage>`__ ->
   `Car <Data-Car.html#t:Car>`__
-  `carMinimalCar <#v:carMinimalCar>`__ ::
   `CarMinimal <Model-CarMinimal.html#t:CarMinimal>`__ ->
   `Car <Data-Car.html#t:Car>`__
-  `testCar <#v:testCar>`__ :: `Car <Data-Car.html#t:Car>`__
-  `zeroCar <#v:zeroCar>`__ :: `Car <Data-Car.html#t:Car>`__
-  `noobCar <#v:noobCar>`__ :: `Car <Data-Car.html#t:Car>`__
-  `leetCar <#v:leetCar>`__ :: `Car <Data-Car.html#t:Car>`__
-  `oneCar <#v:oneCar>`__ :: `Car <Data-Car.html#t:Car>`__

Documentation
=============

data Car

Car parameters, units as described, % from 0 to 1

Constructors

Car

 

Fields

mass :: Double
    kg

power :: Double
    %

traction :: Double
    %

handling :: Double
    %

braking :: Double
    %

aero :: Double
    %

nos :: Double
    %

Instances

+--------------------------------------+-----+
| Show `Car <Data-Car.html#t:Car>`__   |     |
+--------------------------------------+-----+

pwr :: `Car <Data-Car.html#t:Car>`__ -> Double

effectively usable power in Watt

hlm :: `Car <Data-Car.html#t:Car>`__ -> Double

handling multiplier to maximum lateral acceleration

tco :: `Car <Data-Car.html#t:Car>`__ -> Double

traction coefficient

cda :: `Car <Data-Car.html#t:Car>`__ -> Double

drag coefficient

dnf :: `Car <Data-Car.html#t:Car>`__ -> Double

downforce per square m/s

brp :: `Car <Data-Car.html#t:Car>`__ -> Double

braking force as a factor of the traction limit

carInGarageCar :: `CarInGarage <Model-CarInGarage.html#t:CarInGarage>`__
-> `Car <Data-Car.html#t:Car>`__

Transform a CarInCarage to a Car

carMinimalCar :: `CarMinimal <Model-CarMinimal.html#t:CarMinimal>`__ ->
`Car <Data-Car.html#t:Car>`__

Transform a CarMinimal to a Car

testCar :: `Car <Data-Car.html#t:Car>`__

Test car, is the same as default car

zeroCar :: `Car <Data-Car.html#t:Car>`__

The zero car, doesn't drive

noobCar :: `Car <Data-Car.html#t:Car>`__

A minimal running car

leetCar :: `Car <Data-Car.html#t:Car>`__

Very good car

oneCar :: `Car <Data-Car.html#t:Car>`__

Best car

Produced by `Haddock <http://www.haskell.org/haddock/>`__ version 2.11.0
