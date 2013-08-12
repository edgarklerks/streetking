============
Data.Section
============

-  `Contents <index.html>`__
-  `Index <doc-index.html>`__

 

Safe Haskell

None

Data.Section

Documentation
=============

data Section

Constructors

Section

 

Fields

section\_id :: Integer
     
radius :: Maybe Double
     
arclength :: Double
     

Instances

+--------------------------------------------------+-----+
| Eq `Section <Data-Section.html#t:Section>`__     |     |
+--------------------------------------------------+-----+
| Show `Section <Data-Section.html#t:Section>`__   |     |
+--------------------------------------------------+-----+

angle :: `Section <Data-Section.html#t:Section>`__ -> Maybe Double

perturb :: Double -> `Section <Data-Section.html#t:Section>`__ ->
`Section <Data-Section.html#t:Section>`__

trackDetailsSection ::
`TrackDetails <Model-TrackDetails.html#t:TrackDetails>`__ ->
`Section <Data-Section.html#t:Section>`__

Produced by `Haddock <http://www.haskell.org/haddock/>`__ version 2.11.0
