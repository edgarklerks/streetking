% Data.ModelToSVG
% 
% 

-   [Contents](index.html)
-   [Index](doc-index.html)

 

Safe Haskell

None

Data.ModelToSVG

Synopsis

-   type [X](#t:X) = Double
-   type [Y](#t:Y) = Double
-   type [Radius](#t:Radius) = Double
-   type [Label](#t:Label) = String
-   type [Name](#t:Name) = String
-   data [Connect](#t:Connect) a where
    -   [Many](#v:Many) :: [a] -\>
        [Connect](Data-ModelToSVG.html#t:Connect) a
    -   [None](#v:None) :: [Connect](Data-ModelToSVG.html#t:Connect) a

-   type [Action](#t:Action) = String
-   data [SVGTree](#t:SVGTree) where
    -   [Box](#v:Box) :: [Label](Data-ModelToSVG.html#t:Label) -\>
        ([X](Data-ModelToSVG.html#t:X), [Y](Data-ModelToSVG.html#t:Y))
        -\> ([X](Data-ModelToSVG.html#t:X),
        [Y](Data-ModelToSVG.html#t:Y)) -\>
        [Name](Data-ModelToSVG.html#t:Name) -\>
        [Connect](Data-ModelToSVG.html#t:Connect)
        [SVGTree](Data-ModelToSVG.html#t:SVGTree) -\>
        [SVGTree](Data-ModelToSVG.html#t:SVGTree)
    -   [Circle](#v:Circle) :: [Label](Data-ModelToSVG.html#t:Label) -\>
        ([X](Data-ModelToSVG.html#t:X), [Y](Data-ModelToSVG.html#t:Y))
        -\> [Radius](Data-ModelToSVG.html#t:Radius) -\>
        [Name](Data-ModelToSVG.html#t:Name) -\>
        [Connect](Data-ModelToSVG.html#t:Connect)
        [SVGTree](Data-ModelToSVG.html#t:SVGTree) -\>
        [SVGTree](Data-ModelToSVG.html#t:SVGTree)
    -   [Button](#v:Button) :: Integer -\>
        [Label](Data-ModelToSVG.html#t:Label) -\>
        ([X](Data-ModelToSVG.html#t:X), [Y](Data-ModelToSVG.html#t:Y))
        -\> [Name](Data-ModelToSVG.html#t:Name) -\>
        [Action](Data-ModelToSVG.html#t:Action) -\>
        [Connect](Data-ModelToSVG.html#t:Connect)
        [SVGTree](Data-ModelToSVG.html#t:SVGTree) -\>
        [SVGTree](Data-ModelToSVG.html#t:SVGTree)
    -   [Line](#v:Line) :: [Label](Data-ModelToSVG.html#t:Label) -\>
        ([X](Data-ModelToSVG.html#t:X), [Y](Data-ModelToSVG.html#t:Y))
        -\> ([X](Data-ModelToSVG.html#t:X),
        [Y](Data-ModelToSVG.html#t:Y)) -\>
        [Name](Data-ModelToSVG.html#t:Name) -\>
        [Connect](Data-ModelToSVG.html#t:Connect)
        [SVGTree](Data-ModelToSVG.html#t:SVGTree) -\>
        [SVGTree](Data-ModelToSVG.html#t:SVGTree)
    -   [Modifier](#v:Modifier) ::
        [SVGTree](Data-ModelToSVG.html#t:SVGTree) -\>
        [Options](Data-ModelToSVG.html#t:Options) -\>
        [SVGTree](Data-ModelToSVG.html#t:SVGTree)

-   data [Option](#t:Option)
    -   = [FGColor](#v:FGColor) (Int, Int, Int)
    -   | [BGColor](#v:BGColor) (Int, Int, Int)
    -   | [CSS](#v:CSS) (String, String)
    -   | [Attribute](#v:Attribute) (String, String)

-   type [Options](#t:Options) =
    [[Option](Data-ModelToSVG.html#t:Option)]
-   newtype [SVGDef](#t:SVGDef) = [SVGDef](#v:SVGDef) {
    -   [unSVGDef](#v:unSVGDef) :: Seq
        [SVGTree](Data-ModelToSVG.html#t:SVGTree)

    }
-   type [SVGPair](#t:SVGPair) =
    ([SVGTree](Data-ModelToSVG.html#t:SVGTree),
    [Options](Data-ModelToSVG.html#t:Options))
-   data [RenderData](#t:RenderData) = [RD](#v:RD) {
    -   [\_cons](#v:_cons) :: [(([X](Data-ModelToSVG.html#t:X),
        [Y](Data-ModelToSVG.html#t:Y)), ([X](Data-ModelToSVG.html#t:X),
        [Y](Data-ModelToSVG.html#t:Y)))]
    -   [\_boxes](#v:_boxes) ::
        [[SVGPair](Data-ModelToSVG.html#t:SVGPair)]
    -   [\_circles](#v:_circles) ::
        [[SVGPair](Data-ModelToSVG.html#t:SVGPair)]
    -   [\_buttons](#v:_buttons) ::
        [[SVGPair](Data-ModelToSVG.html#t:SVGPair)]
    -   [\_lines](#v:_lines) ::
        [[SVGPair](Data-ModelToSVG.html#t:SVGPair)]
    -   [\_opts](#v:_opts) :: [Options](Data-ModelToSVG.html#t:Options)
    -   [\_cpoint](#v:_cpoint) :: Maybe ([X](Data-ModelToSVG.html#t:X),
        [Y](Data-ModelToSVG.html#t:Y))

    }
-   [defaultRenderData](#v:defaultRenderData) ::
    [RenderData](Data-ModelToSVG.html#t:RenderData)
-   [cpoint](#v:cpoint) :: Lens
    [RenderData](Data-ModelToSVG.html#t:RenderData) (Maybe
    ([X](Data-ModelToSVG.html#t:X), [Y](Data-ModelToSVG.html#t:Y)))
-   [opts](#v:opts) :: Lens
    [RenderData](Data-ModelToSVG.html#t:RenderData)
    [Options](Data-ModelToSVG.html#t:Options)
-   [lines](#v:lines) :: Lens
    [RenderData](Data-ModelToSVG.html#t:RenderData)
    [[SVGPair](Data-ModelToSVG.html#t:SVGPair)]
-   [buttons](#v:buttons) :: Lens
    [RenderData](Data-ModelToSVG.html#t:RenderData)
    [[SVGPair](Data-ModelToSVG.html#t:SVGPair)]
-   [circles](#v:circles) :: Lens
    [RenderData](Data-ModelToSVG.html#t:RenderData)
    [[SVGPair](Data-ModelToSVG.html#t:SVGPair)]
-   [boxes](#v:boxes) :: Lens
    [RenderData](Data-ModelToSVG.html#t:RenderData)
    [[SVGPair](Data-ModelToSVG.html#t:SVGPair)]
-   [cons](#v:cons) :: Lens
    [RenderData](Data-ModelToSVG.html#t:RenderData)
    [(([X](Data-ModelToSVG.html#t:X), [Y](Data-ModelToSVG.html#t:Y)),
    ([X](Data-ModelToSVG.html#t:X), [Y](Data-ModelToSVG.html#t:Y)))]
-   [def](#v:def) :: [SVGTree](Data-ModelToSVG.html#t:SVGTree) -\>
    [SVGDef](Data-ModelToSVG.html#t:SVGDef)
-   [box](#v:box) :: [Label](Data-ModelToSVG.html#t:Label) -\>
    (([X](Data-ModelToSVG.html#t:X), [Y](Data-ModelToSVG.html#t:Y)),
    ([X](Data-ModelToSVG.html#t:X), [Y](Data-ModelToSVG.html#t:Y))) -\>
    [Name](Data-ModelToSVG.html#t:Name) -\>
    [SVGDef](Data-ModelToSVG.html#t:SVGDef)
-   [circle](#v:circle) :: [Label](Data-ModelToSVG.html#t:Label) -\>
    (([X](Data-ModelToSVG.html#t:X), [Y](Data-ModelToSVG.html#t:Y)),
    [Radius](Data-ModelToSVG.html#t:Radius)) -\>
    [Name](Data-ModelToSVG.html#t:Name) -\>
    [SVGDef](Data-ModelToSVG.html#t:SVGDef)
-   [line](#v:line) :: [Label](Data-ModelToSVG.html#t:Label) -\>
    (([X](Data-ModelToSVG.html#t:X), [Y](Data-ModelToSVG.html#t:Y)),
    ([X](Data-ModelToSVG.html#t:X), [Y](Data-ModelToSVG.html#t:Y))) -\>
    [Name](Data-ModelToSVG.html#t:Name) -\>
    [SVGDef](Data-ModelToSVG.html#t:SVGDef)
-   [button](#v:button) :: Integer -\>
    [Label](Data-ModelToSVG.html#t:Label) -\>
    ([X](Data-ModelToSVG.html#t:X), [Y](Data-ModelToSVG.html#t:Y)) -\>
    [Name](Data-ModelToSVG.html#t:Name) -\>
    [Action](Data-ModelToSVG.html#t:Action) -\>
    [SVGDef](Data-ModelToSVG.html#t:SVGDef)
-   [(\<-\>)](#v:-60--45--62-) ::
    [SVGDef](Data-ModelToSVG.html#t:SVGDef) -\>
    [SVGDef](Data-ModelToSVG.html#t:SVGDef) -\>
    [SVGDef](Data-ModelToSVG.html#t:SVGDef)
-   [(|-\>)](#v:-124--45--62-) ::
    [SVGDef](Data-ModelToSVG.html#t:SVGDef) -\>
    [SVGDef](Data-ModelToSVG.html#t:SVGDef) -\>
    [SVGDef](Data-ModelToSVG.html#t:SVGDef)
-   [(\<-|)](#v:-60--45--124-) ::
    [SVGDef](Data-ModelToSVG.html#t:SVGDef) -\>
    [SVGDef](Data-ModelToSVG.html#t:SVGDef) -\>
    [SVGDef](Data-ModelToSVG.html#t:SVGDef)
-   [multi](#v:multi) :: [SVGDef](Data-ModelToSVG.html#t:SVGDef) -\>
    [[SVGDef](Data-ModelToSVG.html#t:SVGDef)] -\>
    [SVGDef](Data-ModelToSVG.html#t:SVGDef)
-   [insert](#v:insert) :: [SVGTree](Data-ModelToSVG.html#t:SVGTree) -\>
    [SVGDef](Data-ModelToSVG.html#t:SVGDef) -\>
    [SVGTree](Data-ModelToSVG.html#t:SVGTree)
-   [test](#v:test) :: [SVGDef](Data-ModelToSVG.html#t:SVGDef)
-   [(\<!\>)](#v:-60--33--62-) ::
    [SVGDef](Data-ModelToSVG.html#t:SVGDef) -\>
    [Options](Data-ModelToSVG.html#t:Options) -\>
    [SVGDef](Data-ModelToSVG.html#t:SVGDef)
-   type [Renderer](#t:Renderer) = State
    [RenderData](Data-ModelToSVG.html#t:RenderData)
-   [renderData](#v:renderData) ::
    [SVGTree](Data-ModelToSVG.html#t:SVGTree) -\>
    [Renderer](Data-ModelToSVG.html#t:Renderer) ()
-   [interpRenderData](#v:interpRenderData) ::
    [SVGDef](Data-ModelToSVG.html#t:SVGDef) -\>
    [RenderData](Data-ModelToSVG.html#t:RenderData)
-   [makeConnected](#v:makeConnected) :: ([X](Data-ModelToSVG.html#t:X),
    [Y](Data-ModelToSVG.html#t:Y)) -\>
    [Renderer](Data-ModelToSVG.html#t:Renderer) ()
-   [renderLocal](#v:renderLocal) :: ([X](Data-ModelToSVG.html#t:X),
    [Y](Data-ModelToSVG.html#t:Y)) -\>
    [[SVGTree](Data-ModelToSVG.html#t:SVGTree)] -\>
    [Renderer](Data-ModelToSVG.html#t:Renderer) ()
-   [localConnect](#v:localConnect) :: ([X](Data-ModelToSVG.html#t:X),
    [Y](Data-ModelToSVG.html#t:Y)) -\>
    [Renderer](Data-ModelToSVG.html#t:Renderer) a -\>
    [Renderer](Data-ModelToSVG.html#t:Renderer) a
-   [svgData](#v:svgData) ::
    [RenderData](Data-ModelToSVG.html#t:RenderData) -\> Svg
-   [renderBox](#v:renderBox) ::
    [SVGPair](Data-ModelToSVG.html#t:SVGPair) -\> Svg
-   [modelAttribute](#v:modelAttribute) :: (Functor f, ToValue (f Char))
    =\> f Char -\> Attribute
-   [testBox](#v:testBox) :: [SVGPair](Data-ModelToSVG.html#t:SVGPair)
-   [addOpts](#v:addOpts) :: (Foldable t, Attributable b) =\> t
    [Option](Data-ModelToSVG.html#t:Option) -\> b -\> b
-   [renderCircle](#v:renderCircle) :: Foldable t =\>
    ([SVGTree](Data-ModelToSVG.html#t:SVGTree), t
    [Option](Data-ModelToSVG.html#t:Option)) -\> Svg
-   [renderLine](#v:renderLine) ::
    ([SVGTree](Data-ModelToSVG.html#t:SVGTree), t) -\> a
-   [renderCon](#v:renderCon) :: (ToValue a3, ToValue a2, ToValue a1,
    ToValue a) =\> ((a, a2), (a1, a3)) -\> Svg
-   [renderButton](#v:renderButton) :: Foldable t =\>
    ([SVGTree](Data-ModelToSVG.html#t:SVGTree), t
    [Option](Data-ModelToSVG.html#t:Option)) -\> Svg
-   [(++=)](#v:-43--43--61-) :: (Monad m, Monoid b) =\> Lens a b -\> b
    -\> StateT a m b
-   [render](#v:render) :: [SVGDef](Data-ModelToSVG.html#t:SVGDef) -\>
    String
-   [connect](#v:connect) :: [SVGDef](Data-ModelToSVG.html#t:SVGDef) -\>
    [Connect](Data-ModelToSVG.html#t:Connect)
    [SVGTree](Data-ModelToSVG.html#t:SVGTree) -\>
    [Connect](Data-ModelToSVG.html#t:Connect)
    [SVGTree](Data-ModelToSVG.html#t:SVGTree)
-   [headr](#v:headr) :: Seq a -\> a
-   [headl](#v:headl) :: Seq a -\> a
-   [tailr](#v:tailr) :: Seq a -\> Seq a
-   [taill](#v:taill) :: Seq a -\> Seq a
-   [records](#v:records) :: [SVGDef](Data-ModelToSVG.html#t:SVGDef)
-   [record](#v:record) :: String -\> ([X](Data-ModelToSVG.html#t:X),
    [Y](Data-ModelToSVG.html#t:Y)) -\> Integer -\> String -\> [String]
    -\> [SVGDef](Data-ModelToSVG.html#t:SVGDef)
-   [addButtons](#v:addButtons) :: ([X](Data-ModelToSVG.html#t:X),
    [Y](Data-ModelToSVG.html#t:Y)) -\> [X](Data-ModelToSVG.html#t:X) -\>
    [Y](Data-ModelToSVG.html#t:Y) -\> Integer -\> String -\> [String]
    -\> [SVGDef](Data-ModelToSVG.html#t:SVGDef)
-   [testdb](#v:testdb) :: IO
    [Connection](Data-SqlTransaction.html#t:Connection)
-   [loadContinent'](#v:loadContinent-39-) :: Integer -\>
    [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction)
    [Connection](Data-SqlTransaction.html#t:Connection)
    [SVGDef](Data-ModelToSVG.html#t:SVGDef)
-   [loadContinent](#v:loadContinent) :: Integer -\>
    [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction)
    [Connection](Data-SqlTransaction.html#t:Connection)
    [SVGDef](Data-ModelToSVG.html#t:SVGDef)
-   [trackRecord](#v:trackRecord) :: [X](Data-ModelToSVG.html#t:X) -\>
    [Y](Data-ModelToSVG.html#t:Y) -\> [Track](Model-Track.html#t:Track)
    -\> [SVGDef](Data-ModelToSVG.html#t:SVGDef)
-   [continentRecord](#v:continentRecord) ::
    [X](Data-ModelToSVG.html#t:X) -\> [Y](Data-ModelToSVG.html#t:Y) -\>
    [Continent](Model-Continent.html#t:Continent) -\>
    [SVGDef](Data-ModelToSVG.html#t:SVGDef)
-   [cityRecord](#v:cityRecord) :: [X](Data-ModelToSVG.html#t:X) -\>
    [Y](Data-ModelToSVG.html#t:Y) -\> [City](Model-City.html#t:City) -\>
    [SVGDef](Data-ModelToSVG.html#t:SVGDef)
-   [loadCarInstance](#v:loadCarInstance) :: Integer -\>
    [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction)
    [Connection](Data-SqlTransaction.html#t:Connection)
    [SVGDef](Data-ModelToSVG.html#t:SVGDef)
-   [carInstanceRecord](#v:carInstanceRecord) ::
    [X](Data-ModelToSVG.html#t:X) -\> [Y](Data-ModelToSVG.html#t:Y) -\>
    [CarInstance](Model-CarInstance.html#t:CarInstance) -\>
    [SVGDef](Data-ModelToSVG.html#t:SVGDef)
-   [carModelRecord](#v:carModelRecord) :: [X](Data-ModelToSVG.html#t:X)
    -\> [Y](Data-ModelToSVG.html#t:Y) -\> [Car](Model-Car.html#t:Car)
    -\> [SVGDef](Data-ModelToSVG.html#t:SVGDef)
-   [accountRecord](#v:accountRecord) :: [X](Data-ModelToSVG.html#t:X)
    -\> [Y](Data-ModelToSVG.html#t:Y) -\>
    [Account](Model-Account.html#t:Account) -\>
    [SVGDef](Data-ModelToSVG.html#t:SVGDef)
-   [loadPartModel](#v:loadPartModel) :: Integer -\>
    [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction)
    [Connection](Data-SqlTransaction.html#t:Connection)
    [SVGDef](Data-ModelToSVG.html#t:SVGDef)
-   [partTypeRecord](#v:partTypeRecord) :: [X](Data-ModelToSVG.html#t:X)
    -\> [Y](Data-ModelToSVG.html#t:Y) -\>
    [PartType](Model-PartType.html#t:PartType) -\>
    [SVGDef](Data-ModelToSVG.html#t:SVGDef)
-   [partInstanceRecord](#v:partInstanceRecord) ::
    [X](Data-ModelToSVG.html#t:X) -\> [Y](Data-ModelToSVG.html#t:Y) -\>
    [PartInstance](Model-PartInstance.html#t:PartInstance) -\>
    [SVGDef](Data-ModelToSVG.html#t:SVGDef)
-   [partModelRecord](#v:partModelRecord) ::
    [X](Data-ModelToSVG.html#t:X) -\> [Y](Data-ModelToSVG.html#t:Y) -\>
    [Part](Model-Part.html#t:Part) -\>
    [SVGDef](Data-ModelToSVG.html#t:SVGDef)
-   [loadPartInstance](#v:loadPartInstance) :: Integer -\>
    [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction)
    [Connection](Data-SqlTransaction.html#t:Connection)
    [SVGDef](Data-ModelToSVG.html#t:SVGDef)
-   [loadPartType](#v:loadPartType) :: Convertible a
    [SqlValue](Data-SqlTransaction.html#t:SqlValue) =\> a -\>
    [SqlTransactionUser](Data-SqlTransaction.html#t:SqlTransactionUser)
    [Lock](LockSnaplet.html#t:Lock)
    [Connection](Data-SqlTransaction.html#t:Connection)
    [SVGDef](Data-ModelToSVG.html#t:SVGDef)
-   [recId](#v:recId) :: Monad m =\> ([X](Data-ModelToSVG.html#t:X) -\>
    [Y](Data-ModelToSVG.html#t:Y) -\> a -\> m
    [SVGDef](Data-ModelToSVG.html#t:SVGDef)) -\>
    [X](Data-ModelToSVG.html#t:X) -\> [Y](Data-ModelToSVG.html#t:Y) -\>
    a -\> m (([X](Data-ModelToSVG.html#t:X),
    [Y](Data-ModelToSVG.html#t:Y)),
    [SVGDef](Data-ModelToSVG.html#t:SVGDef))
-   [addRecordsPaged](#v:addRecordsPaged) :: (Monad f, Applicative f)
    =\> Int -\> [X](Data-ModelToSVG.html#t:X) -\>
    [Y](Data-ModelToSVG.html#t:Y) -\> [Y](Data-ModelToSVG.html#t:Y) -\>
    [Y](Data-ModelToSVG.html#t:Y) -\>
    [SVGDef](Data-ModelToSVG.html#t:SVGDef) -\> [a] -\>
    ([X](Data-ModelToSVG.html#t:X) -\> [Y](Data-ModelToSVG.html#t:Y) -\>
    a -\> f (([X](Data-ModelToSVG.html#t:X),
    [Y](Data-ModelToSVG.html#t:Y)),
    [SVGDef](Data-ModelToSVG.html#t:SVGDef))) -\> f
    (([X](Data-ModelToSVG.html#t:X), [Y](Data-ModelToSVG.html#t:Y)),
    [SVGDef](Data-ModelToSVG.html#t:SVGDef))
-   [addRecords'](#v:addRecords-39-) :: Monad m =\>
    [X](Data-ModelToSVG.html#t:X) -\> [Y](Data-ModelToSVG.html#t:Y) -\>
    [SVGDef](Data-ModelToSVG.html#t:SVGDef) -\> [a] -\>
    ([X](Data-ModelToSVG.html#t:X) -\> [Y](Data-ModelToSVG.html#t:Y) -\>
    a -\> m (([X](Data-ModelToSVG.html#t:X),
    [Y](Data-ModelToSVG.html#t:Y)),
    [SVGDef](Data-ModelToSVG.html#t:SVGDef))) -\> m
    (([X](Data-ModelToSVG.html#t:X), [Y](Data-ModelToSVG.html#t:Y)),
    [SVGDef](Data-ModelToSVG.html#t:SVGDef))
-   [addRecordsDivided](#v:addRecordsDivided) :: Monad m =\> Int -\>
    [X](Data-ModelToSVG.html#t:X) -\> [Y](Data-ModelToSVG.html#t:Y) -\>
    [SVGDef](Data-ModelToSVG.html#t:SVGDef) -\> [a] -\>
    ([X](Data-ModelToSVG.html#t:X) -\> [Y](Data-ModelToSVG.html#t:Y) -\>
    a -\> m [SVGDef](Data-ModelToSVG.html#t:SVGDef)) -\> m
    [SVGDef](Data-ModelToSVG.html#t:SVGDef)
-   [divide](#v:divide) :: Int -\> [t] -\> [[a] -\> [a]]
-   [test2](#v:test2) :: [SVGDef](Data-ModelToSVG.html#t:SVGDef)
-   [test3](#v:test3) :: [SVGDef](Data-ModelToSVG.html#t:SVGDef)
-   [addRecords](#v:addRecords) :: Monad m =\>
    [X](Data-ModelToSVG.html#t:X) -\> [Y](Data-ModelToSVG.html#t:Y) -\>
    [SVGDef](Data-ModelToSVG.html#t:SVGDef) -\> [a] -\>
    ([X](Data-ModelToSVG.html#t:X) -\> [Y](Data-ModelToSVG.html#t:Y) -\>
    a -\> m [SVGDef](Data-ModelToSVG.html#t:SVGDef)) -\> m
    [SVGDef](Data-ModelToSVG.html#t:SVGDef)
-   [runl](#v:runl) ::
    [SqlTransactionUser](Data-SqlTransaction.html#t:SqlTransactionUser)
    l [Connection](Data-SqlTransaction.html#t:Connection) b -\> IO b

Documentation
=============

type X = Double

type Y = Double

type Radius = Double

type Label = String

type Name = String

data Connect a where

Constructors

  ------------------------------------------------------------- ---
  Many :: [a] -\> [Connect](Data-ModelToSVG.html#t:Connect) a    
  None :: [Connect](Data-ModelToSVG.html#t:Connect) a            
  ------------------------------------------------------------- ---

Instances

  --------------------------------------------------------------- ---
  Eq a =\> Eq ([Connect](Data-ModelToSVG.html#t:Connect) a)        
  Show a =\> Show ([Connect](Data-ModelToSVG.html#t:Connect) a)    
  Monoid ([Connect](Data-ModelToSVG.html#t:Connect) a)             
  --------------------------------------------------------------- ---

type Action = String

data SVGTree where

Constructors

  ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- ---
  Box :: [Label](Data-ModelToSVG.html#t:Label) -\> ([X](Data-ModelToSVG.html#t:X), [Y](Data-ModelToSVG.html#t:Y)) -\> ([X](Data-ModelToSVG.html#t:X), [Y](Data-ModelToSVG.html#t:Y)) -\> [Name](Data-ModelToSVG.html#t:Name) -\> [Connect](Data-ModelToSVG.html#t:Connect) [SVGTree](Data-ModelToSVG.html#t:SVGTree) -\> [SVGTree](Data-ModelToSVG.html#t:SVGTree)     
  Circle :: [Label](Data-ModelToSVG.html#t:Label) -\> ([X](Data-ModelToSVG.html#t:X), [Y](Data-ModelToSVG.html#t:Y)) -\> [Radius](Data-ModelToSVG.html#t:Radius) -\> [Name](Data-ModelToSVG.html#t:Name) -\> [Connect](Data-ModelToSVG.html#t:Connect) [SVGTree](Data-ModelToSVG.html#t:SVGTree) -\> [SVGTree](Data-ModelToSVG.html#t:SVGTree)                         
  Button :: Integer -\> [Label](Data-ModelToSVG.html#t:Label) -\> ([X](Data-ModelToSVG.html#t:X), [Y](Data-ModelToSVG.html#t:Y)) -\> [Name](Data-ModelToSVG.html#t:Name) -\> [Action](Data-ModelToSVG.html#t:Action) -\> [Connect](Data-ModelToSVG.html#t:Connect) [SVGTree](Data-ModelToSVG.html#t:SVGTree) -\> [SVGTree](Data-ModelToSVG.html#t:SVGTree)             
  Line :: [Label](Data-ModelToSVG.html#t:Label) -\> ([X](Data-ModelToSVG.html#t:X), [Y](Data-ModelToSVG.html#t:Y)) -\> ([X](Data-ModelToSVG.html#t:X), [Y](Data-ModelToSVG.html#t:Y)) -\> [Name](Data-ModelToSVG.html#t:Name) -\> [Connect](Data-ModelToSVG.html#t:Connect) [SVGTree](Data-ModelToSVG.html#t:SVGTree) -\> [SVGTree](Data-ModelToSVG.html#t:SVGTree)    
  Modifier :: [SVGTree](Data-ModelToSVG.html#t:SVGTree) -\> [Options](Data-ModelToSVG.html#t:Options) -\> [SVGTree](Data-ModelToSVG.html#t:SVGTree)                                                                                                                                                                                                                    
  ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- ---

Instances

  ------------------------------------------------ ---
  Eq [SVGTree](Data-ModelToSVG.html#t:SVGTree)      
  Show [SVGTree](Data-ModelToSVG.html#t:SVGTree)    
  ------------------------------------------------ ---

data Option

Constructors

  ---------------------------- ---
  FGColor (Int, Int, Int)       
  BGColor (Int, Int, Int)       
  CSS (String, String)          
  Attribute (String, String)    
  ---------------------------- ---

Instances

  ---------------------------------------------- ---
  Eq [Option](Data-ModelToSVG.html#t:Option)      
  Show [Option](Data-ModelToSVG.html#t:Option)    
  ---------------------------------------------- ---

type Options = [[Option](Data-ModelToSVG.html#t:Option)]

newtype SVGDef

Constructors

SVGDef

 

Fields

unSVGDef :: Seq [SVGTree](Data-ModelToSVG.html#t:SVGTree)
:    

Instances

  ------------------------------------------------ ---
  Eq [SVGDef](Data-ModelToSVG.html#t:SVGDef)        
  Show [SVGDef](Data-ModelToSVG.html#t:SVGDef)      
  Monoid [SVGDef](Data-ModelToSVG.html#t:SVGDef)    
  ------------------------------------------------ ---

type SVGPair = ([SVGTree](Data-ModelToSVG.html#t:SVGTree),
[Options](Data-ModelToSVG.html#t:Options))

data RenderData

Constructors

RD

 

Fields

\_cons :: [(([X](Data-ModelToSVG.html#t:X), [Y](Data-ModelToSVG.html#t:Y)), ([X](Data-ModelToSVG.html#t:X), [Y](Data-ModelToSVG.html#t:Y)))]
:    
\_boxes :: [[SVGPair](Data-ModelToSVG.html#t:SVGPair)]
:    
\_circles :: [[SVGPair](Data-ModelToSVG.html#t:SVGPair)]
:    
\_buttons :: [[SVGPair](Data-ModelToSVG.html#t:SVGPair)]
:    
\_lines :: [[SVGPair](Data-ModelToSVG.html#t:SVGPair)]
:    
\_opts :: [Options](Data-ModelToSVG.html#t:Options)
:    
\_cpoint :: Maybe ([X](Data-ModelToSVG.html#t:X), [Y](Data-ModelToSVG.html#t:Y))
:    

Instances

  ------------------------------------------------------ ---
  Show [RenderData](Data-ModelToSVG.html#t:RenderData)    
  ------------------------------------------------------ ---

defaultRenderData :: [RenderData](Data-ModelToSVG.html#t:RenderData)

cpoint :: Lens [RenderData](Data-ModelToSVG.html#t:RenderData) (Maybe
([X](Data-ModelToSVG.html#t:X), [Y](Data-ModelToSVG.html#t:Y)))

opts :: Lens [RenderData](Data-ModelToSVG.html#t:RenderData)
[Options](Data-ModelToSVG.html#t:Options)

lines :: Lens [RenderData](Data-ModelToSVG.html#t:RenderData)
[[SVGPair](Data-ModelToSVG.html#t:SVGPair)]

buttons :: Lens [RenderData](Data-ModelToSVG.html#t:RenderData)
[[SVGPair](Data-ModelToSVG.html#t:SVGPair)]

circles :: Lens [RenderData](Data-ModelToSVG.html#t:RenderData)
[[SVGPair](Data-ModelToSVG.html#t:SVGPair)]

boxes :: Lens [RenderData](Data-ModelToSVG.html#t:RenderData)
[[SVGPair](Data-ModelToSVG.html#t:SVGPair)]

cons :: Lens [RenderData](Data-ModelToSVG.html#t:RenderData)
[(([X](Data-ModelToSVG.html#t:X), [Y](Data-ModelToSVG.html#t:Y)),
([X](Data-ModelToSVG.html#t:X), [Y](Data-ModelToSVG.html#t:Y)))]

def :: [SVGTree](Data-ModelToSVG.html#t:SVGTree) -\>
[SVGDef](Data-ModelToSVG.html#t:SVGDef)

Lift a SVGTree in SVGDef

box :: [Label](Data-ModelToSVG.html#t:Label) -\>
(([X](Data-ModelToSVG.html#t:X), [Y](Data-ModelToSVG.html#t:Y)),
([X](Data-ModelToSVG.html#t:X), [Y](Data-ModelToSVG.html#t:Y))) -\>
[Name](Data-ModelToSVG.html#t:Name) -\>
[SVGDef](Data-ModelToSVG.html#t:SVGDef)

Box create a box with a label. (Shown in box) The coordinates are
topright, bottomleft. The name can be use for actions

circle :: [Label](Data-ModelToSVG.html#t:Label) -\>
(([X](Data-ModelToSVG.html#t:X), [Y](Data-ModelToSVG.html#t:Y)),
[Radius](Data-ModelToSVG.html#t:Radius)) -\>
[Name](Data-ModelToSVG.html#t:Name) -\>
[SVGDef](Data-ModelToSVG.html#t:SVGDef)

Circle creates a circle with center (x,y) and radius Radius. Name can |
be used for actions

line :: [Label](Data-ModelToSVG.html#t:Label) -\>
(([X](Data-ModelToSVG.html#t:X), [Y](Data-ModelToSVG.html#t:Y)),
([X](Data-ModelToSVG.html#t:X), [Y](Data-ModelToSVG.html#t:Y))) -\>
[Name](Data-ModelToSVG.html#t:Name) -\>
[SVGDef](Data-ModelToSVG.html#t:SVGDef)

Line creates a line from (x,y) to (x',y'). Name can be used for |
actions. Label is shown above

button :: Integer -\> [Label](Data-ModelToSVG.html#t:Label) -\>
([X](Data-ModelToSVG.html#t:X), [Y](Data-ModelToSVG.html#t:Y)) -\>
[Name](Data-ModelToSVG.html#t:Name) -\>
[Action](Data-ModelToSVG.html#t:Action) -\>
[SVGDef](Data-ModelToSVG.html#t:SVGDef)

Creates a button with center (X,Y). Name can be used for the action. |
Label is placed in the box

(\<-\>) :: [SVGDef](Data-ModelToSVG.html#t:SVGDef) -\>
[SVGDef](Data-ModelToSVG.html#t:SVGDef) -\>
[SVGDef](Data-ModelToSVG.html#t:SVGDef)

Connect combinator. Connects the new whole (left) element to the right
last element. | The element is not a part of the visual SVGDef

(|-\>) :: [SVGDef](Data-ModelToSVG.html#t:SVGDef) -\>
[SVGDef](Data-ModelToSVG.html#t:SVGDef) -\>
[SVGDef](Data-ModelToSVG.html#t:SVGDef)

(\<-|) :: [SVGDef](Data-ModelToSVG.html#t:SVGDef) -\>
[SVGDef](Data-ModelToSVG.html#t:SVGDef) -\>
[SVGDef](Data-ModelToSVG.html#t:SVGDef)

multi :: [SVGDef](Data-ModelToSVG.html#t:SVGDef) -\>
[[SVGDef](Data-ModelToSVG.html#t:SVGDef)] -\>
[SVGDef](Data-ModelToSVG.html#t:SVGDef)

insert :: [SVGTree](Data-ModelToSVG.html#t:SVGTree) -\>
[SVGDef](Data-ModelToSVG.html#t:SVGDef) -\>
[SVGTree](Data-ModelToSVG.html#t:SVGTree)

test :: [SVGDef](Data-ModelToSVG.html#t:SVGDef)

(\<!\>) :: [SVGDef](Data-ModelToSVG.html#t:SVGDef) -\>
[Options](Data-ModelToSVG.html#t:Options) -\>
[SVGDef](Data-ModelToSVG.html#t:SVGDef)

Apply a modifier to the right last element

type Renderer = State [RenderData](Data-ModelToSVG.html#t:RenderData)

renderData :: [SVGTree](Data-ModelToSVG.html#t:SVGTree) -\>
[Renderer](Data-ModelToSVG.html#t:Renderer) ()

interpRenderData :: [SVGDef](Data-ModelToSVG.html#t:SVGDef) -\>
[RenderData](Data-ModelToSVG.html#t:RenderData)

makeConnected :: ([X](Data-ModelToSVG.html#t:X),
[Y](Data-ModelToSVG.html#t:Y)) -\>
[Renderer](Data-ModelToSVG.html#t:Renderer) ()

renderLocal :: ([X](Data-ModelToSVG.html#t:X),
[Y](Data-ModelToSVG.html#t:Y)) -\>
[[SVGTree](Data-ModelToSVG.html#t:SVGTree)] -\>
[Renderer](Data-ModelToSVG.html#t:Renderer) ()

localConnect :: ([X](Data-ModelToSVG.html#t:X),
[Y](Data-ModelToSVG.html#t:Y)) -\>
[Renderer](Data-ModelToSVG.html#t:Renderer) a -\>
[Renderer](Data-ModelToSVG.html#t:Renderer) a

svgData :: [RenderData](Data-ModelToSVG.html#t:RenderData) -\> Svg

renderBox :: [SVGPair](Data-ModelToSVG.html#t:SVGPair) -\> Svg

modelAttribute :: (Functor f, ToValue (f Char)) =\> f Char -\> Attribute

testBox :: [SVGPair](Data-ModelToSVG.html#t:SVGPair)

addOpts :: (Foldable t, Attributable b) =\> t
[Option](Data-ModelToSVG.html#t:Option) -\> b -\> b

renderCircle :: Foldable t =\>
([SVGTree](Data-ModelToSVG.html#t:SVGTree), t
[Option](Data-ModelToSVG.html#t:Option)) -\> Svg

renderLine :: ([SVGTree](Data-ModelToSVG.html#t:SVGTree), t) -\> a

renderCon :: (ToValue a3, ToValue a2, ToValue a1, ToValue a) =\> ((a,
a2), (a1, a3)) -\> Svg

renderButton :: Foldable t =\>
([SVGTree](Data-ModelToSVG.html#t:SVGTree), t
[Option](Data-ModelToSVG.html#t:Option)) -\> Svg

(++=) :: (Monad m, Monoid b) =\> Lens a b -\> b -\> StateT a m b

render :: [SVGDef](Data-ModelToSVG.html#t:SVGDef) -\> String

connect :: [SVGDef](Data-ModelToSVG.html#t:SVGDef) -\>
[Connect](Data-ModelToSVG.html#t:Connect)
[SVGTree](Data-ModelToSVG.html#t:SVGTree) -\>
[Connect](Data-ModelToSVG.html#t:Connect)
[SVGTree](Data-ModelToSVG.html#t:SVGTree)

headr :: Seq a -\> a

headl :: Seq a -\> a

tailr :: Seq a -\> Seq a

taill :: Seq a -\> Seq a

records :: [SVGDef](Data-ModelToSVG.html#t:SVGDef)

record :: String -\> ([X](Data-ModelToSVG.html#t:X),
[Y](Data-ModelToSVG.html#t:Y)) -\> Integer -\> String -\> [String] -\>
[SVGDef](Data-ModelToSVG.html#t:SVGDef)

addButtons :: ([X](Data-ModelToSVG.html#t:X),
[Y](Data-ModelToSVG.html#t:Y)) -\> [X](Data-ModelToSVG.html#t:X) -\>
[Y](Data-ModelToSVG.html#t:Y) -\> Integer -\> String -\> [String] -\>
[SVGDef](Data-ModelToSVG.html#t:SVGDef)

testdb :: IO [Connection](Data-SqlTransaction.html#t:Connection)

loadContinent' :: Integer -\>
[SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction)
[Connection](Data-SqlTransaction.html#t:Connection)
[SVGDef](Data-ModelToSVG.html#t:SVGDef)

loadContinent :: Integer -\>
[SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction)
[Connection](Data-SqlTransaction.html#t:Connection)
[SVGDef](Data-ModelToSVG.html#t:SVGDef)

trackRecord :: [X](Data-ModelToSVG.html#t:X) -\>
[Y](Data-ModelToSVG.html#t:Y) -\> [Track](Model-Track.html#t:Track) -\>
[SVGDef](Data-ModelToSVG.html#t:SVGDef)

continentRecord :: [X](Data-ModelToSVG.html#t:X) -\>
[Y](Data-ModelToSVG.html#t:Y) -\>
[Continent](Model-Continent.html#t:Continent) -\>
[SVGDef](Data-ModelToSVG.html#t:SVGDef)

cityRecord :: [X](Data-ModelToSVG.html#t:X) -\>
[Y](Data-ModelToSVG.html#t:Y) -\> [City](Model-City.html#t:City) -\>
[SVGDef](Data-ModelToSVG.html#t:SVGDef)

loadCarInstance :: Integer -\>
[SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction)
[Connection](Data-SqlTransaction.html#t:Connection)
[SVGDef](Data-ModelToSVG.html#t:SVGDef)

carInstanceRecord :: [X](Data-ModelToSVG.html#t:X) -\>
[Y](Data-ModelToSVG.html#t:Y) -\>
[CarInstance](Model-CarInstance.html#t:CarInstance) -\>
[SVGDef](Data-ModelToSVG.html#t:SVGDef)

carModelRecord :: [X](Data-ModelToSVG.html#t:X) -\>
[Y](Data-ModelToSVG.html#t:Y) -\> [Car](Model-Car.html#t:Car) -\>
[SVGDef](Data-ModelToSVG.html#t:SVGDef)

accountRecord :: [X](Data-ModelToSVG.html#t:X) -\>
[Y](Data-ModelToSVG.html#t:Y) -\>
[Account](Model-Account.html#t:Account) -\>
[SVGDef](Data-ModelToSVG.html#t:SVGDef)

loadPartModel :: Integer -\>
[SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction)
[Connection](Data-SqlTransaction.html#t:Connection)
[SVGDef](Data-ModelToSVG.html#t:SVGDef)

partTypeRecord :: [X](Data-ModelToSVG.html#t:X) -\>
[Y](Data-ModelToSVG.html#t:Y) -\>
[PartType](Model-PartType.html#t:PartType) -\>
[SVGDef](Data-ModelToSVG.html#t:SVGDef)

partInstanceRecord :: [X](Data-ModelToSVG.html#t:X) -\>
[Y](Data-ModelToSVG.html#t:Y) -\>
[PartInstance](Model-PartInstance.html#t:PartInstance) -\>
[SVGDef](Data-ModelToSVG.html#t:SVGDef)

partModelRecord :: [X](Data-ModelToSVG.html#t:X) -\>
[Y](Data-ModelToSVG.html#t:Y) -\> [Part](Model-Part.html#t:Part) -\>
[SVGDef](Data-ModelToSVG.html#t:SVGDef)

loadPartInstance :: Integer -\>
[SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction)
[Connection](Data-SqlTransaction.html#t:Connection)
[SVGDef](Data-ModelToSVG.html#t:SVGDef)

loadPartType :: Convertible a
[SqlValue](Data-SqlTransaction.html#t:SqlValue) =\> a -\>
[SqlTransactionUser](Data-SqlTransaction.html#t:SqlTransactionUser)
[Lock](LockSnaplet.html#t:Lock)
[Connection](Data-SqlTransaction.html#t:Connection)
[SVGDef](Data-ModelToSVG.html#t:SVGDef)

recId :: Monad m =\> ([X](Data-ModelToSVG.html#t:X) -\>
[Y](Data-ModelToSVG.html#t:Y) -\> a -\> m
[SVGDef](Data-ModelToSVG.html#t:SVGDef)) -\>
[X](Data-ModelToSVG.html#t:X) -\> [Y](Data-ModelToSVG.html#t:Y) -\> a
-\> m (([X](Data-ModelToSVG.html#t:X), [Y](Data-ModelToSVG.html#t:Y)),
[SVGDef](Data-ModelToSVG.html#t:SVGDef))

addRecordsPaged :: (Monad f, Applicative f) =\> Int -\>
[X](Data-ModelToSVG.html#t:X) -\> [Y](Data-ModelToSVG.html#t:Y) -\>
[Y](Data-ModelToSVG.html#t:Y) -\> [Y](Data-ModelToSVG.html#t:Y) -\>
[SVGDef](Data-ModelToSVG.html#t:SVGDef) -\> [a] -\>
([X](Data-ModelToSVG.html#t:X) -\> [Y](Data-ModelToSVG.html#t:Y) -\> a
-\> f (([X](Data-ModelToSVG.html#t:X), [Y](Data-ModelToSVG.html#t:Y)),
[SVGDef](Data-ModelToSVG.html#t:SVGDef))) -\> f
(([X](Data-ModelToSVG.html#t:X), [Y](Data-ModelToSVG.html#t:Y)),
[SVGDef](Data-ModelToSVG.html#t:SVGDef))

addRecords' :: Monad m =\> [X](Data-ModelToSVG.html#t:X) -\>
[Y](Data-ModelToSVG.html#t:Y) -\>
[SVGDef](Data-ModelToSVG.html#t:SVGDef) -\> [a] -\>
([X](Data-ModelToSVG.html#t:X) -\> [Y](Data-ModelToSVG.html#t:Y) -\> a
-\> m (([X](Data-ModelToSVG.html#t:X), [Y](Data-ModelToSVG.html#t:Y)),
[SVGDef](Data-ModelToSVG.html#t:SVGDef))) -\> m
(([X](Data-ModelToSVG.html#t:X), [Y](Data-ModelToSVG.html#t:Y)),
[SVGDef](Data-ModelToSVG.html#t:SVGDef))

addRecordsDivided :: Monad m =\> Int -\> [X](Data-ModelToSVG.html#t:X)
-\> [Y](Data-ModelToSVG.html#t:Y) -\>
[SVGDef](Data-ModelToSVG.html#t:SVGDef) -\> [a] -\>
([X](Data-ModelToSVG.html#t:X) -\> [Y](Data-ModelToSVG.html#t:Y) -\> a
-\> m [SVGDef](Data-ModelToSVG.html#t:SVGDef)) -\> m
[SVGDef](Data-ModelToSVG.html#t:SVGDef)

divide :: Int -\> [t] -\> [[a] -\> [a]]

test2 :: [SVGDef](Data-ModelToSVG.html#t:SVGDef)

test3 :: [SVGDef](Data-ModelToSVG.html#t:SVGDef)

addRecords :: Monad m =\> [X](Data-ModelToSVG.html#t:X) -\>
[Y](Data-ModelToSVG.html#t:Y) -\>
[SVGDef](Data-ModelToSVG.html#t:SVGDef) -\> [a] -\>
([X](Data-ModelToSVG.html#t:X) -\> [Y](Data-ModelToSVG.html#t:Y) -\> a
-\> m [SVGDef](Data-ModelToSVG.html#t:SVGDef)) -\> m
[SVGDef](Data-ModelToSVG.html#t:SVGDef)

runl ::
[SqlTransactionUser](Data-SqlTransaction.html#t:SqlTransactionUser) l
[Connection](Data-SqlTransaction.html#t:Connection) b -\> IO b

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
