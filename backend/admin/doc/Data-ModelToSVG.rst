===============
Data.ModelToSVG
===============

-  `Contents <index.html>`__
-  `Index <doc-index.html>`__

 

Safe Haskell

None

Data.ModelToSVG

Synopsis

-  type `X <#t:X>`__ = Double
-  type `Y <#t:Y>`__ = Double
-  type `Radius <#t:Radius>`__ = Double
-  type `Label <#t:Label>`__ = String
-  type `Name <#t:Name>`__ = String
-  data `Connect <#t:Connect>`__ a where

   -  `Many <#v:Many>`__ :: [a] ->
      `Connect <Data-ModelToSVG.html#t:Connect>`__ a
   -  `None <#v:None>`__ :: `Connect <Data-ModelToSVG.html#t:Connect>`__
      a

-  type `Action <#t:Action>`__ = String
-  data `SVGTree <#t:SVGTree>`__ where

   -  `Box <#v:Box>`__ :: `Label <Data-ModelToSVG.html#t:Label>`__ ->
      (`X <Data-ModelToSVG.html#t:X>`__,
      `Y <Data-ModelToSVG.html#t:Y>`__) ->
      (`X <Data-ModelToSVG.html#t:X>`__,
      `Y <Data-ModelToSVG.html#t:Y>`__) ->
      `Name <Data-ModelToSVG.html#t:Name>`__ ->
      `Connect <Data-ModelToSVG.html#t:Connect>`__
      `SVGTree <Data-ModelToSVG.html#t:SVGTree>`__ ->
      `SVGTree <Data-ModelToSVG.html#t:SVGTree>`__
   -  `Circle <#v:Circle>`__ :: `Label <Data-ModelToSVG.html#t:Label>`__
      -> (`X <Data-ModelToSVG.html#t:X>`__,
      `Y <Data-ModelToSVG.html#t:Y>`__) ->
      `Radius <Data-ModelToSVG.html#t:Radius>`__ ->
      `Name <Data-ModelToSVG.html#t:Name>`__ ->
      `Connect <Data-ModelToSVG.html#t:Connect>`__
      `SVGTree <Data-ModelToSVG.html#t:SVGTree>`__ ->
      `SVGTree <Data-ModelToSVG.html#t:SVGTree>`__
   -  `Button <#v:Button>`__ :: Integer ->
      `Label <Data-ModelToSVG.html#t:Label>`__ ->
      (`X <Data-ModelToSVG.html#t:X>`__,
      `Y <Data-ModelToSVG.html#t:Y>`__) ->
      `Name <Data-ModelToSVG.html#t:Name>`__ ->
      `Action <Data-ModelToSVG.html#t:Action>`__ ->
      `Connect <Data-ModelToSVG.html#t:Connect>`__
      `SVGTree <Data-ModelToSVG.html#t:SVGTree>`__ ->
      `SVGTree <Data-ModelToSVG.html#t:SVGTree>`__
   -  `Line <#v:Line>`__ :: `Label <Data-ModelToSVG.html#t:Label>`__ ->
      (`X <Data-ModelToSVG.html#t:X>`__,
      `Y <Data-ModelToSVG.html#t:Y>`__) ->
      (`X <Data-ModelToSVG.html#t:X>`__,
      `Y <Data-ModelToSVG.html#t:Y>`__) ->
      `Name <Data-ModelToSVG.html#t:Name>`__ ->
      `Connect <Data-ModelToSVG.html#t:Connect>`__
      `SVGTree <Data-ModelToSVG.html#t:SVGTree>`__ ->
      `SVGTree <Data-ModelToSVG.html#t:SVGTree>`__
   -  `Modifier <#v:Modifier>`__ ::
      `SVGTree <Data-ModelToSVG.html#t:SVGTree>`__ ->
      `Options <Data-ModelToSVG.html#t:Options>`__ ->
      `SVGTree <Data-ModelToSVG.html#t:SVGTree>`__

-  data `Option <#t:Option>`__

   -  = `FGColor <#v:FGColor>`__ (Int, Int, Int)
   -  \| `BGColor <#v:BGColor>`__ (Int, Int, Int)
   -  \| `CSS <#v:CSS>`__ (String, String)
   -  \| `Attribute <#v:Attribute>`__ (String, String)

-  type `Options <#t:Options>`__ =
   [`Option <Data-ModelToSVG.html#t:Option>`__\ ]
-  newtype `SVGDef <#t:SVGDef>`__ = `SVGDef <#v:SVGDef>`__ {

   -  `unSVGDef <#v:unSVGDef>`__ :: Seq
      `SVGTree <Data-ModelToSVG.html#t:SVGTree>`__

   }
-  type `SVGPair <#t:SVGPair>`__ =
   (`SVGTree <Data-ModelToSVG.html#t:SVGTree>`__,
   `Options <Data-ModelToSVG.html#t:Options>`__)
-  data `RenderData <#t:RenderData>`__ = `RD <#v:RD>`__ {

   -  `\_cons <#v:_cons>`__ :: [((`X <Data-ModelToSVG.html#t:X>`__,
      `Y <Data-ModelToSVG.html#t:Y>`__),
      (`X <Data-ModelToSVG.html#t:X>`__,
      `Y <Data-ModelToSVG.html#t:Y>`__))]
   -  `\_boxes <#v:_boxes>`__ ::
      [`SVGPair <Data-ModelToSVG.html#t:SVGPair>`__\ ]
   -  `\_circles <#v:_circles>`__ ::
      [`SVGPair <Data-ModelToSVG.html#t:SVGPair>`__\ ]
   -  `\_buttons <#v:_buttons>`__ ::
      [`SVGPair <Data-ModelToSVG.html#t:SVGPair>`__\ ]
   -  `\_lines <#v:_lines>`__ ::
      [`SVGPair <Data-ModelToSVG.html#t:SVGPair>`__\ ]
   -  `\_opts <#v:_opts>`__ ::
      `Options <Data-ModelToSVG.html#t:Options>`__
   -  `\_cpoint <#v:_cpoint>`__ :: Maybe
      (`X <Data-ModelToSVG.html#t:X>`__,
      `Y <Data-ModelToSVG.html#t:Y>`__)

   }
-  `defaultRenderData <#v:defaultRenderData>`__ ::
   `RenderData <Data-ModelToSVG.html#t:RenderData>`__
-  `cpoint <#v:cpoint>`__ :: Lens
   `RenderData <Data-ModelToSVG.html#t:RenderData>`__ (Maybe
   (`X <Data-ModelToSVG.html#t:X>`__, `Y <Data-ModelToSVG.html#t:Y>`__))
-  `opts <#v:opts>`__ :: Lens
   `RenderData <Data-ModelToSVG.html#t:RenderData>`__
   `Options <Data-ModelToSVG.html#t:Options>`__
-  `lines <#v:lines>`__ :: Lens
   `RenderData <Data-ModelToSVG.html#t:RenderData>`__
   [`SVGPair <Data-ModelToSVG.html#t:SVGPair>`__\ ]
-  `buttons <#v:buttons>`__ :: Lens
   `RenderData <Data-ModelToSVG.html#t:RenderData>`__
   [`SVGPair <Data-ModelToSVG.html#t:SVGPair>`__\ ]
-  `circles <#v:circles>`__ :: Lens
   `RenderData <Data-ModelToSVG.html#t:RenderData>`__
   [`SVGPair <Data-ModelToSVG.html#t:SVGPair>`__\ ]
-  `boxes <#v:boxes>`__ :: Lens
   `RenderData <Data-ModelToSVG.html#t:RenderData>`__
   [`SVGPair <Data-ModelToSVG.html#t:SVGPair>`__\ ]
-  `cons <#v:cons>`__ :: Lens
   `RenderData <Data-ModelToSVG.html#t:RenderData>`__
   [((`X <Data-ModelToSVG.html#t:X>`__,
   `Y <Data-ModelToSVG.html#t:Y>`__), (`X <Data-ModelToSVG.html#t:X>`__,
   `Y <Data-ModelToSVG.html#t:Y>`__))]
-  `def <#v:def>`__ :: `SVGTree <Data-ModelToSVG.html#t:SVGTree>`__ ->
   `SVGDef <Data-ModelToSVG.html#t:SVGDef>`__
-  `box <#v:box>`__ :: `Label <Data-ModelToSVG.html#t:Label>`__ ->
   ((`X <Data-ModelToSVG.html#t:X>`__,
   `Y <Data-ModelToSVG.html#t:Y>`__), (`X <Data-ModelToSVG.html#t:X>`__,
   `Y <Data-ModelToSVG.html#t:Y>`__)) ->
   `Name <Data-ModelToSVG.html#t:Name>`__ ->
   `SVGDef <Data-ModelToSVG.html#t:SVGDef>`__
-  `circle <#v:circle>`__ :: `Label <Data-ModelToSVG.html#t:Label>`__ ->
   ((`X <Data-ModelToSVG.html#t:X>`__,
   `Y <Data-ModelToSVG.html#t:Y>`__),
   `Radius <Data-ModelToSVG.html#t:Radius>`__) ->
   `Name <Data-ModelToSVG.html#t:Name>`__ ->
   `SVGDef <Data-ModelToSVG.html#t:SVGDef>`__
-  `line <#v:line>`__ :: `Label <Data-ModelToSVG.html#t:Label>`__ ->
   ((`X <Data-ModelToSVG.html#t:X>`__,
   `Y <Data-ModelToSVG.html#t:Y>`__), (`X <Data-ModelToSVG.html#t:X>`__,
   `Y <Data-ModelToSVG.html#t:Y>`__)) ->
   `Name <Data-ModelToSVG.html#t:Name>`__ ->
   `SVGDef <Data-ModelToSVG.html#t:SVGDef>`__
-  `button <#v:button>`__ :: Integer ->
   `Label <Data-ModelToSVG.html#t:Label>`__ ->
   (`X <Data-ModelToSVG.html#t:X>`__, `Y <Data-ModelToSVG.html#t:Y>`__)
   -> `Name <Data-ModelToSVG.html#t:Name>`__ ->
   `Action <Data-ModelToSVG.html#t:Action>`__ ->
   `SVGDef <Data-ModelToSVG.html#t:SVGDef>`__
-  `(<->) <#v:-60--45--62->`__ ::
   `SVGDef <Data-ModelToSVG.html#t:SVGDef>`__ ->
   `SVGDef <Data-ModelToSVG.html#t:SVGDef>`__ ->
   `SVGDef <Data-ModelToSVG.html#t:SVGDef>`__
-  `(\|->) <#v:-124--45--62->`__ ::
   `SVGDef <Data-ModelToSVG.html#t:SVGDef>`__ ->
   `SVGDef <Data-ModelToSVG.html#t:SVGDef>`__ ->
   `SVGDef <Data-ModelToSVG.html#t:SVGDef>`__
-  `(<-\|) <#v:-60--45--124->`__ ::
   `SVGDef <Data-ModelToSVG.html#t:SVGDef>`__ ->
   `SVGDef <Data-ModelToSVG.html#t:SVGDef>`__ ->
   `SVGDef <Data-ModelToSVG.html#t:SVGDef>`__
-  `multi <#v:multi>`__ :: `SVGDef <Data-ModelToSVG.html#t:SVGDef>`__ ->
   [`SVGDef <Data-ModelToSVG.html#t:SVGDef>`__\ ] ->
   `SVGDef <Data-ModelToSVG.html#t:SVGDef>`__
-  `insert <#v:insert>`__ ::
   `SVGTree <Data-ModelToSVG.html#t:SVGTree>`__ ->
   `SVGDef <Data-ModelToSVG.html#t:SVGDef>`__ ->
   `SVGTree <Data-ModelToSVG.html#t:SVGTree>`__
-  `test <#v:test>`__ :: `SVGDef <Data-ModelToSVG.html#t:SVGDef>`__
-  `(<!>) <#v:-60--33--62->`__ ::
   `SVGDef <Data-ModelToSVG.html#t:SVGDef>`__ ->
   `Options <Data-ModelToSVG.html#t:Options>`__ ->
   `SVGDef <Data-ModelToSVG.html#t:SVGDef>`__
-  type `Renderer <#t:Renderer>`__ = State
   `RenderData <Data-ModelToSVG.html#t:RenderData>`__
-  `renderData <#v:renderData>`__ ::
   `SVGTree <Data-ModelToSVG.html#t:SVGTree>`__ ->
   `Renderer <Data-ModelToSVG.html#t:Renderer>`__ ()
-  `interpRenderData <#v:interpRenderData>`__ ::
   `SVGDef <Data-ModelToSVG.html#t:SVGDef>`__ ->
   `RenderData <Data-ModelToSVG.html#t:RenderData>`__
-  `makeConnected <#v:makeConnected>`__ ::
   (`X <Data-ModelToSVG.html#t:X>`__, `Y <Data-ModelToSVG.html#t:Y>`__)
   -> `Renderer <Data-ModelToSVG.html#t:Renderer>`__ ()
-  `renderLocal <#v:renderLocal>`__ ::
   (`X <Data-ModelToSVG.html#t:X>`__, `Y <Data-ModelToSVG.html#t:Y>`__)
   -> [`SVGTree <Data-ModelToSVG.html#t:SVGTree>`__\ ] ->
   `Renderer <Data-ModelToSVG.html#t:Renderer>`__ ()
-  `localConnect <#v:localConnect>`__ ::
   (`X <Data-ModelToSVG.html#t:X>`__, `Y <Data-ModelToSVG.html#t:Y>`__)
   -> `Renderer <Data-ModelToSVG.html#t:Renderer>`__ a ->
   `Renderer <Data-ModelToSVG.html#t:Renderer>`__ a
-  `svgData <#v:svgData>`__ ::
   `RenderData <Data-ModelToSVG.html#t:RenderData>`__ -> Svg
-  `renderBox <#v:renderBox>`__ ::
   `SVGPair <Data-ModelToSVG.html#t:SVGPair>`__ -> Svg
-  `modelAttribute <#v:modelAttribute>`__ :: (Functor f, ToValue (f
   Char)) => f Char -> Attribute
-  `testBox <#v:testBox>`__ ::
   `SVGPair <Data-ModelToSVG.html#t:SVGPair>`__
-  `addOpts <#v:addOpts>`__ :: (Foldable t, Attributable b) => t
   `Option <Data-ModelToSVG.html#t:Option>`__ -> b -> b
-  `renderCircle <#v:renderCircle>`__ :: Foldable t =>
   (`SVGTree <Data-ModelToSVG.html#t:SVGTree>`__, t
   `Option <Data-ModelToSVG.html#t:Option>`__) -> Svg
-  `renderLine <#v:renderLine>`__ ::
   (`SVGTree <Data-ModelToSVG.html#t:SVGTree>`__, t) -> a
-  `renderCon <#v:renderCon>`__ :: (ToValue a3, ToValue a2, ToValue a1,
   ToValue a) => ((a, a2), (a1, a3)) -> Svg
-  `renderButton <#v:renderButton>`__ :: Foldable t =>
   (`SVGTree <Data-ModelToSVG.html#t:SVGTree>`__, t
   `Option <Data-ModelToSVG.html#t:Option>`__) -> Svg
-  `(++=) <#v:-43--43--61->`__ :: (Monad m, Monoid b) => Lens a b -> b
   -> StateT a m b
-  `render <#v:render>`__ :: `SVGDef <Data-ModelToSVG.html#t:SVGDef>`__
   -> String
-  `connect <#v:connect>`__ ::
   `SVGDef <Data-ModelToSVG.html#t:SVGDef>`__ ->
   `Connect <Data-ModelToSVG.html#t:Connect>`__
   `SVGTree <Data-ModelToSVG.html#t:SVGTree>`__ ->
   `Connect <Data-ModelToSVG.html#t:Connect>`__
   `SVGTree <Data-ModelToSVG.html#t:SVGTree>`__
-  `headr <#v:headr>`__ :: Seq a -> a
-  `headl <#v:headl>`__ :: Seq a -> a
-  `tailr <#v:tailr>`__ :: Seq a -> Seq a
-  `taill <#v:taill>`__ :: Seq a -> Seq a
-  `records <#v:records>`__ ::
   `SVGDef <Data-ModelToSVG.html#t:SVGDef>`__
-  `record <#v:record>`__ :: String ->
   (`X <Data-ModelToSVG.html#t:X>`__, `Y <Data-ModelToSVG.html#t:Y>`__)
   -> Integer -> String -> [String] ->
   `SVGDef <Data-ModelToSVG.html#t:SVGDef>`__
-  `addButtons <#v:addButtons>`__ :: (`X <Data-ModelToSVG.html#t:X>`__,
   `Y <Data-ModelToSVG.html#t:Y>`__) -> `X <Data-ModelToSVG.html#t:X>`__
   -> `Y <Data-ModelToSVG.html#t:Y>`__ -> Integer -> String -> [String]
   -> `SVGDef <Data-ModelToSVG.html#t:SVGDef>`__
-  `testdb <#v:testdb>`__ :: IO
   `Connection <Data-SqlTransaction.html#t:Connection>`__
-  `loadContinent' <#v:loadContinent-39->`__ :: Integer ->
   `SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
   `Connection <Data-SqlTransaction.html#t:Connection>`__
   `SVGDef <Data-ModelToSVG.html#t:SVGDef>`__
-  `loadContinent <#v:loadContinent>`__ :: Integer ->
   `SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
   `Connection <Data-SqlTransaction.html#t:Connection>`__
   `SVGDef <Data-ModelToSVG.html#t:SVGDef>`__
-  `trackRecord <#v:trackRecord>`__ :: `X <Data-ModelToSVG.html#t:X>`__
   -> `Y <Data-ModelToSVG.html#t:Y>`__ ->
   `Track <Model-Track.html#t:Track>`__ ->
   `SVGDef <Data-ModelToSVG.html#t:SVGDef>`__
-  `continentRecord <#v:continentRecord>`__ ::
   `X <Data-ModelToSVG.html#t:X>`__ -> `Y <Data-ModelToSVG.html#t:Y>`__
   -> `Continent <Model-Continent.html#t:Continent>`__ ->
   `SVGDef <Data-ModelToSVG.html#t:SVGDef>`__
-  `cityRecord <#v:cityRecord>`__ :: `X <Data-ModelToSVG.html#t:X>`__ ->
   `Y <Data-ModelToSVG.html#t:Y>`__ -> `City <Model-City.html#t:City>`__
   -> `SVGDef <Data-ModelToSVG.html#t:SVGDef>`__
-  `loadCarInstance <#v:loadCarInstance>`__ :: Integer ->
   `SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
   `Connection <Data-SqlTransaction.html#t:Connection>`__
   `SVGDef <Data-ModelToSVG.html#t:SVGDef>`__
-  `carInstanceRecord <#v:carInstanceRecord>`__ ::
   `X <Data-ModelToSVG.html#t:X>`__ -> `Y <Data-ModelToSVG.html#t:Y>`__
   -> `CarInstance <Model-CarInstance.html#t:CarInstance>`__ ->
   `SVGDef <Data-ModelToSVG.html#t:SVGDef>`__
-  `carModelRecord <#v:carModelRecord>`__ ::
   `X <Data-ModelToSVG.html#t:X>`__ -> `Y <Data-ModelToSVG.html#t:Y>`__
   -> `Car <Model-Car.html#t:Car>`__ ->
   `SVGDef <Data-ModelToSVG.html#t:SVGDef>`__
-  `accountRecord <#v:accountRecord>`__ ::
   `X <Data-ModelToSVG.html#t:X>`__ -> `Y <Data-ModelToSVG.html#t:Y>`__
   -> `Account <Model-Account.html#t:Account>`__ ->
   `SVGDef <Data-ModelToSVG.html#t:SVGDef>`__
-  `loadPartModel <#v:loadPartModel>`__ :: Integer ->
   `SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
   `Connection <Data-SqlTransaction.html#t:Connection>`__
   `SVGDef <Data-ModelToSVG.html#t:SVGDef>`__
-  `partTypeRecord <#v:partTypeRecord>`__ ::
   `X <Data-ModelToSVG.html#t:X>`__ -> `Y <Data-ModelToSVG.html#t:Y>`__
   -> `PartType <Model-PartType.html#t:PartType>`__ ->
   `SVGDef <Data-ModelToSVG.html#t:SVGDef>`__
-  `partInstanceRecord <#v:partInstanceRecord>`__ ::
   `X <Data-ModelToSVG.html#t:X>`__ -> `Y <Data-ModelToSVG.html#t:Y>`__
   -> `PartInstance <Model-PartInstance.html#t:PartInstance>`__ ->
   `SVGDef <Data-ModelToSVG.html#t:SVGDef>`__
-  `partModelRecord <#v:partModelRecord>`__ ::
   `X <Data-ModelToSVG.html#t:X>`__ -> `Y <Data-ModelToSVG.html#t:Y>`__
   -> `Part <Model-Part.html#t:Part>`__ ->
   `SVGDef <Data-ModelToSVG.html#t:SVGDef>`__
-  `loadPartInstance <#v:loadPartInstance>`__ :: Integer ->
   `SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
   `Connection <Data-SqlTransaction.html#t:Connection>`__
   `SVGDef <Data-ModelToSVG.html#t:SVGDef>`__
-  `loadPartType <#v:loadPartType>`__ :: Convertible a
   `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__ => a ->
   `SqlTransactionUser <Data-SqlTransaction.html#t:SqlTransactionUser>`__
   `Lock <LockSnaplet.html#t:Lock>`__
   `Connection <Data-SqlTransaction.html#t:Connection>`__
   `SVGDef <Data-ModelToSVG.html#t:SVGDef>`__
-  `recId <#v:recId>`__ :: Monad m => (`X <Data-ModelToSVG.html#t:X>`__
   -> `Y <Data-ModelToSVG.html#t:Y>`__ -> a -> m
   `SVGDef <Data-ModelToSVG.html#t:SVGDef>`__) ->
   `X <Data-ModelToSVG.html#t:X>`__ -> `Y <Data-ModelToSVG.html#t:Y>`__
   -> a -> m ((`X <Data-ModelToSVG.html#t:X>`__,
   `Y <Data-ModelToSVG.html#t:Y>`__),
   `SVGDef <Data-ModelToSVG.html#t:SVGDef>`__)
-  `addRecordsPaged <#v:addRecordsPaged>`__ :: (Monad f, Applicative f)
   => Int -> `X <Data-ModelToSVG.html#t:X>`__ ->
   `Y <Data-ModelToSVG.html#t:Y>`__ -> `Y <Data-ModelToSVG.html#t:Y>`__
   -> `Y <Data-ModelToSVG.html#t:Y>`__ ->
   `SVGDef <Data-ModelToSVG.html#t:SVGDef>`__ -> [a] ->
   (`X <Data-ModelToSVG.html#t:X>`__ -> `Y <Data-ModelToSVG.html#t:Y>`__
   -> a -> f ((`X <Data-ModelToSVG.html#t:X>`__,
   `Y <Data-ModelToSVG.html#t:Y>`__),
   `SVGDef <Data-ModelToSVG.html#t:SVGDef>`__)) -> f
   ((`X <Data-ModelToSVG.html#t:X>`__,
   `Y <Data-ModelToSVG.html#t:Y>`__),
   `SVGDef <Data-ModelToSVG.html#t:SVGDef>`__)
-  `addRecords' <#v:addRecords-39->`__ :: Monad m =>
   `X <Data-ModelToSVG.html#t:X>`__ -> `Y <Data-ModelToSVG.html#t:Y>`__
   -> `SVGDef <Data-ModelToSVG.html#t:SVGDef>`__ -> [a] ->
   (`X <Data-ModelToSVG.html#t:X>`__ -> `Y <Data-ModelToSVG.html#t:Y>`__
   -> a -> m ((`X <Data-ModelToSVG.html#t:X>`__,
   `Y <Data-ModelToSVG.html#t:Y>`__),
   `SVGDef <Data-ModelToSVG.html#t:SVGDef>`__)) -> m
   ((`X <Data-ModelToSVG.html#t:X>`__,
   `Y <Data-ModelToSVG.html#t:Y>`__),
   `SVGDef <Data-ModelToSVG.html#t:SVGDef>`__)
-  `addRecordsDivided <#v:addRecordsDivided>`__ :: Monad m => Int ->
   `X <Data-ModelToSVG.html#t:X>`__ -> `Y <Data-ModelToSVG.html#t:Y>`__
   -> `SVGDef <Data-ModelToSVG.html#t:SVGDef>`__ -> [a] ->
   (`X <Data-ModelToSVG.html#t:X>`__ -> `Y <Data-ModelToSVG.html#t:Y>`__
   -> a -> m `SVGDef <Data-ModelToSVG.html#t:SVGDef>`__) -> m
   `SVGDef <Data-ModelToSVG.html#t:SVGDef>`__
-  `divide <#v:divide>`__ :: Int -> [t] -> [[a] -> [a]]
-  `test2 <#v:test2>`__ :: `SVGDef <Data-ModelToSVG.html#t:SVGDef>`__
-  `test3 <#v:test3>`__ :: `SVGDef <Data-ModelToSVG.html#t:SVGDef>`__
-  `addRecords <#v:addRecords>`__ :: Monad m =>
   `X <Data-ModelToSVG.html#t:X>`__ -> `Y <Data-ModelToSVG.html#t:Y>`__
   -> `SVGDef <Data-ModelToSVG.html#t:SVGDef>`__ -> [a] ->
   (`X <Data-ModelToSVG.html#t:X>`__ -> `Y <Data-ModelToSVG.html#t:Y>`__
   -> a -> m `SVGDef <Data-ModelToSVG.html#t:SVGDef>`__) -> m
   `SVGDef <Data-ModelToSVG.html#t:SVGDef>`__
-  `runl <#v:runl>`__ ::
   `SqlTransactionUser <Data-SqlTransaction.html#t:SqlTransactionUser>`__
   l `Connection <Data-SqlTransaction.html#t:Connection>`__ b -> IO b

Documentation
=============

type X = Double

type Y = Double

type Radius = Double

type Label = String

type Name = String

data Connect a where

Constructors

+-----------------------------------------------------------------+-----+
| Many :: [a] -> `Connect <Data-ModelToSVG.html#t:Connect>`__ a   |     |
+-----------------------------------------------------------------+-----+
| None :: `Connect <Data-ModelToSVG.html#t:Connect>`__ a          |     |
+-----------------------------------------------------------------+-----+

Instances

+-------------------------------------------------------------------+-----+
| Eq a => Eq (`Connect <Data-ModelToSVG.html#t:Connect>`__ a)       |     |
+-------------------------------------------------------------------+-----+
| Show a => Show (`Connect <Data-ModelToSVG.html#t:Connect>`__ a)   |     |
+-------------------------------------------------------------------+-----+
| Monoid (`Connect <Data-ModelToSVG.html#t:Connect>`__ a)           |     |
+-------------------------------------------------------------------+-----+

type Action = String

data SVGTree where

Constructors

+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Box :: `Label <Data-ModelToSVG.html#t:Label>`__ -> (`X <Data-ModelToSVG.html#t:X>`__, `Y <Data-ModelToSVG.html#t:Y>`__) -> (`X <Data-ModelToSVG.html#t:X>`__, `Y <Data-ModelToSVG.html#t:Y>`__) -> `Name <Data-ModelToSVG.html#t:Name>`__ -> `Connect <Data-ModelToSVG.html#t:Connect>`__ `SVGTree <Data-ModelToSVG.html#t:SVGTree>`__ -> `SVGTree <Data-ModelToSVG.html#t:SVGTree>`__    |     |
+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Circle :: `Label <Data-ModelToSVG.html#t:Label>`__ -> (`X <Data-ModelToSVG.html#t:X>`__, `Y <Data-ModelToSVG.html#t:Y>`__) -> `Radius <Data-ModelToSVG.html#t:Radius>`__ -> `Name <Data-ModelToSVG.html#t:Name>`__ -> `Connect <Data-ModelToSVG.html#t:Connect>`__ `SVGTree <Data-ModelToSVG.html#t:SVGTree>`__ -> `SVGTree <Data-ModelToSVG.html#t:SVGTree>`__                           |     |
+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Button :: Integer -> `Label <Data-ModelToSVG.html#t:Label>`__ -> (`X <Data-ModelToSVG.html#t:X>`__, `Y <Data-ModelToSVG.html#t:Y>`__) -> `Name <Data-ModelToSVG.html#t:Name>`__ -> `Action <Data-ModelToSVG.html#t:Action>`__ -> `Connect <Data-ModelToSVG.html#t:Connect>`__ `SVGTree <Data-ModelToSVG.html#t:SVGTree>`__ -> `SVGTree <Data-ModelToSVG.html#t:SVGTree>`__                |     |
+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Line :: `Label <Data-ModelToSVG.html#t:Label>`__ -> (`X <Data-ModelToSVG.html#t:X>`__, `Y <Data-ModelToSVG.html#t:Y>`__) -> (`X <Data-ModelToSVG.html#t:X>`__, `Y <Data-ModelToSVG.html#t:Y>`__) -> `Name <Data-ModelToSVG.html#t:Name>`__ -> `Connect <Data-ModelToSVG.html#t:Connect>`__ `SVGTree <Data-ModelToSVG.html#t:SVGTree>`__ -> `SVGTree <Data-ModelToSVG.html#t:SVGTree>`__   |     |
+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Modifier :: `SVGTree <Data-ModelToSVG.html#t:SVGTree>`__ -> `Options <Data-ModelToSVG.html#t:Options>`__ -> `SVGTree <Data-ModelToSVG.html#t:SVGTree>`__                                                                                                                                                                                                                                  |     |
+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+

Instances

+-----------------------------------------------------+-----+
| Eq `SVGTree <Data-ModelToSVG.html#t:SVGTree>`__     |     |
+-----------------------------------------------------+-----+
| Show `SVGTree <Data-ModelToSVG.html#t:SVGTree>`__   |     |
+-----------------------------------------------------+-----+

data Option

Constructors

+------------------------------+-----+
| FGColor (Int, Int, Int)      |     |
+------------------------------+-----+
| BGColor (Int, Int, Int)      |     |
+------------------------------+-----+
| CSS (String, String)         |     |
+------------------------------+-----+
| Attribute (String, String)   |     |
+------------------------------+-----+

Instances

+---------------------------------------------------+-----+
| Eq `Option <Data-ModelToSVG.html#t:Option>`__     |     |
+---------------------------------------------------+-----+
| Show `Option <Data-ModelToSVG.html#t:Option>`__   |     |
+---------------------------------------------------+-----+

type Options = [`Option <Data-ModelToSVG.html#t:Option>`__\ ]

newtype SVGDef

Constructors

SVGDef

 

Fields

unSVGDef :: Seq `SVGTree <Data-ModelToSVG.html#t:SVGTree>`__
     

Instances

+-----------------------------------------------------+-----+
| Eq `SVGDef <Data-ModelToSVG.html#t:SVGDef>`__       |     |
+-----------------------------------------------------+-----+
| Show `SVGDef <Data-ModelToSVG.html#t:SVGDef>`__     |     |
+-----------------------------------------------------+-----+
| Monoid `SVGDef <Data-ModelToSVG.html#t:SVGDef>`__   |     |
+-----------------------------------------------------+-----+

type SVGPair = (`SVGTree <Data-ModelToSVG.html#t:SVGTree>`__,
`Options <Data-ModelToSVG.html#t:Options>`__)

data RenderData

Constructors

RD

 

Fields

\_cons :: [((`X <Data-ModelToSVG.html#t:X>`__,
`Y <Data-ModelToSVG.html#t:Y>`__), (`X <Data-ModelToSVG.html#t:X>`__,
`Y <Data-ModelToSVG.html#t:Y>`__))]
     
\_boxes :: [`SVGPair <Data-ModelToSVG.html#t:SVGPair>`__\ ]
     
\_circles :: [`SVGPair <Data-ModelToSVG.html#t:SVGPair>`__\ ]
     
\_buttons :: [`SVGPair <Data-ModelToSVG.html#t:SVGPair>`__\ ]
     
\_lines :: [`SVGPair <Data-ModelToSVG.html#t:SVGPair>`__\ ]
     
\_opts :: `Options <Data-ModelToSVG.html#t:Options>`__
     
\_cpoint :: Maybe (`X <Data-ModelToSVG.html#t:X>`__,
`Y <Data-ModelToSVG.html#t:Y>`__)
     

Instances

+-----------------------------------------------------------+-----+
| Show `RenderData <Data-ModelToSVG.html#t:RenderData>`__   |     |
+-----------------------------------------------------------+-----+

defaultRenderData :: `RenderData <Data-ModelToSVG.html#t:RenderData>`__

cpoint :: Lens `RenderData <Data-ModelToSVG.html#t:RenderData>`__ (Maybe
(`X <Data-ModelToSVG.html#t:X>`__, `Y <Data-ModelToSVG.html#t:Y>`__))

opts :: Lens `RenderData <Data-ModelToSVG.html#t:RenderData>`__
`Options <Data-ModelToSVG.html#t:Options>`__

lines :: Lens `RenderData <Data-ModelToSVG.html#t:RenderData>`__
[`SVGPair <Data-ModelToSVG.html#t:SVGPair>`__\ ]

buttons :: Lens `RenderData <Data-ModelToSVG.html#t:RenderData>`__
[`SVGPair <Data-ModelToSVG.html#t:SVGPair>`__\ ]

circles :: Lens `RenderData <Data-ModelToSVG.html#t:RenderData>`__
[`SVGPair <Data-ModelToSVG.html#t:SVGPair>`__\ ]

boxes :: Lens `RenderData <Data-ModelToSVG.html#t:RenderData>`__
[`SVGPair <Data-ModelToSVG.html#t:SVGPair>`__\ ]

cons :: Lens `RenderData <Data-ModelToSVG.html#t:RenderData>`__
[((`X <Data-ModelToSVG.html#t:X>`__, `Y <Data-ModelToSVG.html#t:Y>`__),
(`X <Data-ModelToSVG.html#t:X>`__, `Y <Data-ModelToSVG.html#t:Y>`__))]

def :: `SVGTree <Data-ModelToSVG.html#t:SVGTree>`__ ->
`SVGDef <Data-ModelToSVG.html#t:SVGDef>`__

Lift a SVGTree in SVGDef

box :: `Label <Data-ModelToSVG.html#t:Label>`__ ->
((`X <Data-ModelToSVG.html#t:X>`__, `Y <Data-ModelToSVG.html#t:Y>`__),
(`X <Data-ModelToSVG.html#t:X>`__, `Y <Data-ModelToSVG.html#t:Y>`__)) ->
`Name <Data-ModelToSVG.html#t:Name>`__ ->
`SVGDef <Data-ModelToSVG.html#t:SVGDef>`__

Box create a box with a label. (Shown in box) The coordinates are
topright, bottomleft. The name can be use for actions

circle :: `Label <Data-ModelToSVG.html#t:Label>`__ ->
((`X <Data-ModelToSVG.html#t:X>`__, `Y <Data-ModelToSVG.html#t:Y>`__),
`Radius <Data-ModelToSVG.html#t:Radius>`__) ->
`Name <Data-ModelToSVG.html#t:Name>`__ ->
`SVGDef <Data-ModelToSVG.html#t:SVGDef>`__

Circle creates a circle with center (x,y) and radius Radius. Name can \|
be used for actions

line :: `Label <Data-ModelToSVG.html#t:Label>`__ ->
((`X <Data-ModelToSVG.html#t:X>`__, `Y <Data-ModelToSVG.html#t:Y>`__),
(`X <Data-ModelToSVG.html#t:X>`__, `Y <Data-ModelToSVG.html#t:Y>`__)) ->
`Name <Data-ModelToSVG.html#t:Name>`__ ->
`SVGDef <Data-ModelToSVG.html#t:SVGDef>`__

Line creates a line from (x,y) to (x',y'). Name can be used for \|
actions. Label is shown above

button :: Integer -> `Label <Data-ModelToSVG.html#t:Label>`__ ->
(`X <Data-ModelToSVG.html#t:X>`__, `Y <Data-ModelToSVG.html#t:Y>`__) ->
`Name <Data-ModelToSVG.html#t:Name>`__ ->
`Action <Data-ModelToSVG.html#t:Action>`__ ->
`SVGDef <Data-ModelToSVG.html#t:SVGDef>`__

Creates a button with center (X,Y). Name can be used for the action. \|
Label is placed in the box

(<->) :: `SVGDef <Data-ModelToSVG.html#t:SVGDef>`__ ->
`SVGDef <Data-ModelToSVG.html#t:SVGDef>`__ ->
`SVGDef <Data-ModelToSVG.html#t:SVGDef>`__

Connect combinator. Connects the new whole (left) element to the right
last element. \| The element is not a part of the visual SVGDef

(\|->) :: `SVGDef <Data-ModelToSVG.html#t:SVGDef>`__ ->
`SVGDef <Data-ModelToSVG.html#t:SVGDef>`__ ->
`SVGDef <Data-ModelToSVG.html#t:SVGDef>`__

(<-\|) :: `SVGDef <Data-ModelToSVG.html#t:SVGDef>`__ ->
`SVGDef <Data-ModelToSVG.html#t:SVGDef>`__ ->
`SVGDef <Data-ModelToSVG.html#t:SVGDef>`__

multi :: `SVGDef <Data-ModelToSVG.html#t:SVGDef>`__ ->
[`SVGDef <Data-ModelToSVG.html#t:SVGDef>`__\ ] ->
`SVGDef <Data-ModelToSVG.html#t:SVGDef>`__

insert :: `SVGTree <Data-ModelToSVG.html#t:SVGTree>`__ ->
`SVGDef <Data-ModelToSVG.html#t:SVGDef>`__ ->
`SVGTree <Data-ModelToSVG.html#t:SVGTree>`__

test :: `SVGDef <Data-ModelToSVG.html#t:SVGDef>`__

(<!>) :: `SVGDef <Data-ModelToSVG.html#t:SVGDef>`__ ->
`Options <Data-ModelToSVG.html#t:Options>`__ ->
`SVGDef <Data-ModelToSVG.html#t:SVGDef>`__

Apply a modifier to the right last element

type Renderer = State `RenderData <Data-ModelToSVG.html#t:RenderData>`__

renderData :: `SVGTree <Data-ModelToSVG.html#t:SVGTree>`__ ->
`Renderer <Data-ModelToSVG.html#t:Renderer>`__ ()

interpRenderData :: `SVGDef <Data-ModelToSVG.html#t:SVGDef>`__ ->
`RenderData <Data-ModelToSVG.html#t:RenderData>`__

makeConnected :: (`X <Data-ModelToSVG.html#t:X>`__,
`Y <Data-ModelToSVG.html#t:Y>`__) ->
`Renderer <Data-ModelToSVG.html#t:Renderer>`__ ()

renderLocal :: (`X <Data-ModelToSVG.html#t:X>`__,
`Y <Data-ModelToSVG.html#t:Y>`__) ->
[`SVGTree <Data-ModelToSVG.html#t:SVGTree>`__\ ] ->
`Renderer <Data-ModelToSVG.html#t:Renderer>`__ ()

localConnect :: (`X <Data-ModelToSVG.html#t:X>`__,
`Y <Data-ModelToSVG.html#t:Y>`__) ->
`Renderer <Data-ModelToSVG.html#t:Renderer>`__ a ->
`Renderer <Data-ModelToSVG.html#t:Renderer>`__ a

svgData :: `RenderData <Data-ModelToSVG.html#t:RenderData>`__ -> Svg

renderBox :: `SVGPair <Data-ModelToSVG.html#t:SVGPair>`__ -> Svg

modelAttribute :: (Functor f, ToValue (f Char)) => f Char -> Attribute

testBox :: `SVGPair <Data-ModelToSVG.html#t:SVGPair>`__

addOpts :: (Foldable t, Attributable b) => t
`Option <Data-ModelToSVG.html#t:Option>`__ -> b -> b

renderCircle :: Foldable t =>
(`SVGTree <Data-ModelToSVG.html#t:SVGTree>`__, t
`Option <Data-ModelToSVG.html#t:Option>`__) -> Svg

renderLine :: (`SVGTree <Data-ModelToSVG.html#t:SVGTree>`__, t) -> a

renderCon :: (ToValue a3, ToValue a2, ToValue a1, ToValue a) => ((a,
a2), (a1, a3)) -> Svg

renderButton :: Foldable t =>
(`SVGTree <Data-ModelToSVG.html#t:SVGTree>`__, t
`Option <Data-ModelToSVG.html#t:Option>`__) -> Svg

(++=) :: (Monad m, Monoid b) => Lens a b -> b -> StateT a m b

render :: `SVGDef <Data-ModelToSVG.html#t:SVGDef>`__ -> String

connect :: `SVGDef <Data-ModelToSVG.html#t:SVGDef>`__ ->
`Connect <Data-ModelToSVG.html#t:Connect>`__
`SVGTree <Data-ModelToSVG.html#t:SVGTree>`__ ->
`Connect <Data-ModelToSVG.html#t:Connect>`__
`SVGTree <Data-ModelToSVG.html#t:SVGTree>`__

headr :: Seq a -> a

headl :: Seq a -> a

tailr :: Seq a -> Seq a

taill :: Seq a -> Seq a

records :: `SVGDef <Data-ModelToSVG.html#t:SVGDef>`__

record :: String -> (`X <Data-ModelToSVG.html#t:X>`__,
`Y <Data-ModelToSVG.html#t:Y>`__) -> Integer -> String -> [String] ->
`SVGDef <Data-ModelToSVG.html#t:SVGDef>`__

addButtons :: (`X <Data-ModelToSVG.html#t:X>`__,
`Y <Data-ModelToSVG.html#t:Y>`__) -> `X <Data-ModelToSVG.html#t:X>`__ ->
`Y <Data-ModelToSVG.html#t:Y>`__ -> Integer -> String -> [String] ->
`SVGDef <Data-ModelToSVG.html#t:SVGDef>`__

testdb :: IO `Connection <Data-SqlTransaction.html#t:Connection>`__

loadContinent' :: Integer ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__
`SVGDef <Data-ModelToSVG.html#t:SVGDef>`__

loadContinent :: Integer ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__
`SVGDef <Data-ModelToSVG.html#t:SVGDef>`__

trackRecord :: `X <Data-ModelToSVG.html#t:X>`__ ->
`Y <Data-ModelToSVG.html#t:Y>`__ -> `Track <Model-Track.html#t:Track>`__
-> `SVGDef <Data-ModelToSVG.html#t:SVGDef>`__

continentRecord :: `X <Data-ModelToSVG.html#t:X>`__ ->
`Y <Data-ModelToSVG.html#t:Y>`__ ->
`Continent <Model-Continent.html#t:Continent>`__ ->
`SVGDef <Data-ModelToSVG.html#t:SVGDef>`__

cityRecord :: `X <Data-ModelToSVG.html#t:X>`__ ->
`Y <Data-ModelToSVG.html#t:Y>`__ -> `City <Model-City.html#t:City>`__ ->
`SVGDef <Data-ModelToSVG.html#t:SVGDef>`__

loadCarInstance :: Integer ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__
`SVGDef <Data-ModelToSVG.html#t:SVGDef>`__

carInstanceRecord :: `X <Data-ModelToSVG.html#t:X>`__ ->
`Y <Data-ModelToSVG.html#t:Y>`__ ->
`CarInstance <Model-CarInstance.html#t:CarInstance>`__ ->
`SVGDef <Data-ModelToSVG.html#t:SVGDef>`__

carModelRecord :: `X <Data-ModelToSVG.html#t:X>`__ ->
`Y <Data-ModelToSVG.html#t:Y>`__ -> `Car <Model-Car.html#t:Car>`__ ->
`SVGDef <Data-ModelToSVG.html#t:SVGDef>`__

accountRecord :: `X <Data-ModelToSVG.html#t:X>`__ ->
`Y <Data-ModelToSVG.html#t:Y>`__ ->
`Account <Model-Account.html#t:Account>`__ ->
`SVGDef <Data-ModelToSVG.html#t:SVGDef>`__

loadPartModel :: Integer ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__
`SVGDef <Data-ModelToSVG.html#t:SVGDef>`__

partTypeRecord :: `X <Data-ModelToSVG.html#t:X>`__ ->
`Y <Data-ModelToSVG.html#t:Y>`__ ->
`PartType <Model-PartType.html#t:PartType>`__ ->
`SVGDef <Data-ModelToSVG.html#t:SVGDef>`__

partInstanceRecord :: `X <Data-ModelToSVG.html#t:X>`__ ->
`Y <Data-ModelToSVG.html#t:Y>`__ ->
`PartInstance <Model-PartInstance.html#t:PartInstance>`__ ->
`SVGDef <Data-ModelToSVG.html#t:SVGDef>`__

partModelRecord :: `X <Data-ModelToSVG.html#t:X>`__ ->
`Y <Data-ModelToSVG.html#t:Y>`__ -> `Part <Model-Part.html#t:Part>`__ ->
`SVGDef <Data-ModelToSVG.html#t:SVGDef>`__

loadPartInstance :: Integer ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__
`SVGDef <Data-ModelToSVG.html#t:SVGDef>`__

loadPartType :: Convertible a
`SqlValue <Data-SqlTransaction.html#t:SqlValue>`__ => a ->
`SqlTransactionUser <Data-SqlTransaction.html#t:SqlTransactionUser>`__
`Lock <LockSnaplet.html#t:Lock>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__
`SVGDef <Data-ModelToSVG.html#t:SVGDef>`__

recId :: Monad m => (`X <Data-ModelToSVG.html#t:X>`__ ->
`Y <Data-ModelToSVG.html#t:Y>`__ -> a -> m
`SVGDef <Data-ModelToSVG.html#t:SVGDef>`__) ->
`X <Data-ModelToSVG.html#t:X>`__ -> `Y <Data-ModelToSVG.html#t:Y>`__ ->
a -> m ((`X <Data-ModelToSVG.html#t:X>`__,
`Y <Data-ModelToSVG.html#t:Y>`__),
`SVGDef <Data-ModelToSVG.html#t:SVGDef>`__)

addRecordsPaged :: (Monad f, Applicative f) => Int ->
`X <Data-ModelToSVG.html#t:X>`__ -> `Y <Data-ModelToSVG.html#t:Y>`__ ->
`Y <Data-ModelToSVG.html#t:Y>`__ -> `Y <Data-ModelToSVG.html#t:Y>`__ ->
`SVGDef <Data-ModelToSVG.html#t:SVGDef>`__ -> [a] ->
(`X <Data-ModelToSVG.html#t:X>`__ -> `Y <Data-ModelToSVG.html#t:Y>`__ ->
a -> f ((`X <Data-ModelToSVG.html#t:X>`__,
`Y <Data-ModelToSVG.html#t:Y>`__),
`SVGDef <Data-ModelToSVG.html#t:SVGDef>`__)) -> f
((`X <Data-ModelToSVG.html#t:X>`__, `Y <Data-ModelToSVG.html#t:Y>`__),
`SVGDef <Data-ModelToSVG.html#t:SVGDef>`__)

addRecords' :: Monad m => `X <Data-ModelToSVG.html#t:X>`__ ->
`Y <Data-ModelToSVG.html#t:Y>`__ ->
`SVGDef <Data-ModelToSVG.html#t:SVGDef>`__ -> [a] ->
(`X <Data-ModelToSVG.html#t:X>`__ -> `Y <Data-ModelToSVG.html#t:Y>`__ ->
a -> m ((`X <Data-ModelToSVG.html#t:X>`__,
`Y <Data-ModelToSVG.html#t:Y>`__),
`SVGDef <Data-ModelToSVG.html#t:SVGDef>`__)) -> m
((`X <Data-ModelToSVG.html#t:X>`__, `Y <Data-ModelToSVG.html#t:Y>`__),
`SVGDef <Data-ModelToSVG.html#t:SVGDef>`__)

addRecordsDivided :: Monad m => Int -> `X <Data-ModelToSVG.html#t:X>`__
-> `Y <Data-ModelToSVG.html#t:Y>`__ ->
`SVGDef <Data-ModelToSVG.html#t:SVGDef>`__ -> [a] ->
(`X <Data-ModelToSVG.html#t:X>`__ -> `Y <Data-ModelToSVG.html#t:Y>`__ ->
a -> m `SVGDef <Data-ModelToSVG.html#t:SVGDef>`__) -> m
`SVGDef <Data-ModelToSVG.html#t:SVGDef>`__

divide :: Int -> [t] -> [[a] -> [a]]

test2 :: `SVGDef <Data-ModelToSVG.html#t:SVGDef>`__

test3 :: `SVGDef <Data-ModelToSVG.html#t:SVGDef>`__

addRecords :: Monad m => `X <Data-ModelToSVG.html#t:X>`__ ->
`Y <Data-ModelToSVG.html#t:Y>`__ ->
`SVGDef <Data-ModelToSVG.html#t:SVGDef>`__ -> [a] ->
(`X <Data-ModelToSVG.html#t:X>`__ -> `Y <Data-ModelToSVG.html#t:Y>`__ ->
a -> m `SVGDef <Data-ModelToSVG.html#t:SVGDef>`__) -> m
`SVGDef <Data-ModelToSVG.html#t:SVGDef>`__

runl ::
`SqlTransactionUser <Data-SqlTransaction.html#t:SqlTransactionUser>`__ l
`Connection <Data-SqlTransaction.html#t:Connection>`__ b -> IO b

Produced by `Haddock <http://www.haskell.org/haddock/>`__ version 2.11.0
