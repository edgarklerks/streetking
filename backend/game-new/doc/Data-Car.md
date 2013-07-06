% Data.Car
% 
% 

-   [Contents](index.html)
-   [Index](doc-index.html)

 

Safe Haskell

None

Data.Car

Description

Car specific functions

Synopsis

-   data [Car](#t:Car) = [Car](#v:Car) {
    -   [mass](#v:mass) :: Double
    -   [power](#v:power) :: Double
    -   [traction](#v:traction) :: Double
    -   [handling](#v:handling) :: Double
    -   [braking](#v:braking) :: Double
    -   [aero](#v:aero) :: Double
    -   [nos](#v:nos) :: Double

    }
-   [pwr](#v:pwr) :: [Car](Data-Car.html#t:Car) -\> Double
-   [hlm](#v:hlm) :: [Car](Data-Car.html#t:Car) -\> Double
-   [tco](#v:tco) :: [Car](Data-Car.html#t:Car) -\> Double
-   [cda](#v:cda) :: [Car](Data-Car.html#t:Car) -\> Double
-   [dnf](#v:dnf) :: [Car](Data-Car.html#t:Car) -\> Double
-   [brp](#v:brp) :: [Car](Data-Car.html#t:Car) -\> Double
-   [carInGarageCar](#v:carInGarageCar) ::
    [CarInGarage](Model-CarInGarage.html#t:CarInGarage) -\>
    [Car](Data-Car.html#t:Car)
-   [carMinimalCar](#v:carMinimalCar) ::
    [CarMinimal](Model-CarMinimal.html#t:CarMinimal) -\>
    [Car](Data-Car.html#t:Car)
-   [testCar](#v:testCar) :: [Car](Data-Car.html#t:Car)
-   [zeroCar](#v:zeroCar) :: [Car](Data-Car.html#t:Car)
-   [noobCar](#v:noobCar) :: [Car](Data-Car.html#t:Car)
-   [leetCar](#v:leetCar) :: [Car](Data-Car.html#t:Car)
-   [oneCar](#v:oneCar) :: [Car](Data-Car.html#t:Car)

Documentation
=============

data Car

Car parameters, units as described, % from 0 to 1

Constructors

Car

 

Fields

mass :: Double
:   kg

power :: Double
:   %

traction :: Double
:   %

handling :: Double
:   %

braking :: Double
:   %

aero :: Double
:   %

nos :: Double
:   %

Instances

  --------------------------------- ---
  Show [Car](Data-Car.html#t:Car)    
  --------------------------------- ---

pwr :: [Car](Data-Car.html#t:Car) -\> Double

effectively usable power in Watt

hlm :: [Car](Data-Car.html#t:Car) -\> Double

handling multiplier to maximum lateral acceleration

tco :: [Car](Data-Car.html#t:Car) -\> Double

traction coefficient

cda :: [Car](Data-Car.html#t:Car) -\> Double

drag coefficient

dnf :: [Car](Data-Car.html#t:Car) -\> Double

downforce per square m/s

brp :: [Car](Data-Car.html#t:Car) -\> Double

braking force as a factor of the traction limit

carInGarageCar :: [CarInGarage](Model-CarInGarage.html#t:CarInGarage)
-\> [Car](Data-Car.html#t:Car)

Transform a CarInCarage to a Car

carMinimalCar :: [CarMinimal](Model-CarMinimal.html#t:CarMinimal) -\>
[Car](Data-Car.html#t:Car)

Transform a CarMinimal to a Car

testCar :: [Car](Data-Car.html#t:Car)

Test car, is the same as default car

zeroCar :: [Car](Data-Car.html#t:Car)

The zero car, doesn't drive

noobCar :: [Car](Data-Car.html#t:Car)

A minimal running car

leetCar :: [Car](Data-Car.html#t:Car)

Very good car

oneCar :: [Car](Data-Car.html#t:Car)

Best car

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
