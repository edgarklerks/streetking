{-# LANGUAGE GADTs, ViewPatterns, TemplateHaskell, OverloadedStrings #-}
module Data.ModelToSVG where 


import qualified Text.Blaze.Svg11 as S
import qualified Text.Blaze.Svg11.Attributes as A
import Text.Blaze
import Text.Blaze.Svg.Renderer.Pretty
import Text.Blaze.Internal 
import Data.Monoid 
import qualified Data.Sequence as S 
import Control.Applicative
import Control.Monad.State hiding (forM_) 
import Data.Foldable 
import Prelude hiding (foldr, foldl, foldl1, lines)
import Data.Lens.Template 
import Data.Lens.Lazy
import Data.Text (pack)
import qualified Model.Continent as C 
import qualified Model.City as CI 
import qualified Model.CarInstance as CRI 
import qualified Model.Car as Car 
import qualified Model.PartInstance as P 
import qualified Model.Part as Part 
import qualified Model.PartType as PT 
import Model.General hiding (def) 
import Database.HDBC.PostgreSQL 
import Data.Database hiding (insert) 
import Data.SqlTransaction
import Database.HDBC.SqlValue 
import Data.Maybe 

type X = Double 
type Y = Double  
type Radius = Double 
type Label = String
type Name = String 


data Connect a where 
        Many :: [a] -> Connect a 
        None :: Connect a 
    deriving (Show, Eq) 
                  
instance Monoid (Connect a) where 
        mempty = None 
        mappend (Many xs) (Many ys) = Many (xs ++ ys)
        mappend None x = x
        mappend x None = x

data SVGTree where 
    Box :: Label -> (X,Y) -> (X,Y) -> Name -> Connect SVGTree -> SVGTree 
    Circle :: Label -> (X,Y) -> Radius -> Name -> Connect SVGTree -> SVGTree  
    Button :: Integer -> Label -> (X,Y) -> Name -> Connect SVGTree -> SVGTree 
    Line :: Label -> (X,Y) -> (X,Y) -> Name -> Connect SVGTree ->  SVGTree 
    Modifier :: SVGTree -> Options -> SVGTree 
 deriving (Show, Eq)

data Option = FGColor (Int, Int, Int)
            | BGColor (Int, Int, Int)
            | CSS (String, String)
            | Attribute (String, String)
        deriving (Show, Eq)

type Options = [Option] 
newtype SVGDef = SVGDef {
            unSVGDef :: S.Seq SVGTree
        } deriving (Show, Eq)

instance Monoid SVGDef where 
    mempty = SVGDef mempty 
    mappend (SVGDef xs) (SVGDef ys) = SVGDef (xs <> ys)

type SVGPair = (SVGTree, Options)
data RenderData = RD {
                _cons :: [((X,Y), (X,Y))],
                _boxes :: [SVGPair],
                _circles :: [SVGPair],
                _buttons :: [SVGPair],
                _lines :: [SVGPair],
                _opts :: Options,
                _cpoint :: Maybe (X,Y)
        } deriving Show

defaultRenderData = RD {
        _cons = [],
        _boxes = [],
        _circles = [],
        _buttons = [],
        _lines = [],
        _opts = [],
        _cpoint = Nothing  
    }
$(makeLens ''RenderData)



-- | Lift a SVGTree in SVGDef 
def :: SVGTree -> SVGDef 
def = SVGDef . S.singleton 

-- | Box create a box with a label. (Shown in box) The coordinates are topright, bottomleft. The name can be use for actions 
box :: Label -> ((X,Y),(X,Y)) -> Name -> SVGDef 
box s (rt,lb) n = def $ Box s rt lb n None 

-- | Circle creates a circle with center (x,y) and radius Radius. Name can
-- | be used for actions 
circle :: Label -> ((X,Y), Radius) -> Name -> SVGDef 
circle s (ct, r) n = def $ Circle s ct r n None

-- | Line creates a line from (x,y) to (x',y'). Name can be used  for
-- | actions. Label is shown above 
line :: Label -> ((X,Y),(X,Y)) -> Name -> SVGDef 
line l (xy,x'y') n = def $ Line l xy x'y' n None 

-- | Creates a button with center (X,Y). Name can be used for the action.
-- | Label is placed in the box 
button :: Integer -> Label -> (X,Y) -> Name -> SVGDef 
button id l xy n = def $ Button id l xy n None 

{-- Combinators --}

-- | Connect combinator. Connects the new whole (left) element to the right last element.
-- | The element is not a part of the visual SVGDef 
(<->) :: SVGDef -> SVGDef -> SVGDef  
(<->) (unSVGDef -> xs) l | S.null xs = l 
                         | otherwise = SVGDef (tailr xs S.|> insert (headr xs) l)


multi :: SVGDef -> [SVGDef] -> SVGDef 
multi (unSVGDef -> xs) l | S.null xs = mconcat l
                         | otherwise = SVGDef (tailr xs S.|> insert (headr xs) (mconcat l))
insert :: SVGTree -> SVGDef -> SVGTree 
insert (Modifier svg opts) xs = Modifier (insert svg xs) opts 
insert (Box lbl rt bl n ys) ns = Box lbl rt bl n (ns `connect` ys)
insert (Circle lbl rt r nm xs) ns = Circle lbl rt r nm (ns `connect` xs)
insert (Button id lbl xy nm xs) ns = Button id lbl xy nm (ns `connect` xs)

infixl 7 <-> 

test = box "testbox" ((10,10),(20,20)) "actiontest" <-> 
       box "bla box" ((30,30), (40,40)) "bla action" <!> [FGColor (0,0,0)]
       <> box "loosebox" ((50,50), (60,60)) "shitfuck" <-> 
       (box "newbox" ((200,10),(300,50)) "test" <!> [BGColor (231,230,0)])
       <-> circle "circlebox" ((50,90),20) "circlesda" <!> [BGColor (233,230,10)] 
       <-> button 10 "value" (310,50) "edit" 


infixr 8 <!>
-- | Apply a modifier to the right last element
(<!>) :: SVGDef -> Options -> SVGDef 
(<!>) t@(unSVGDef -> xs) opts | S.null xs = t
                              | otherwise = case headr xs of 
                                                Modifier svg ts -> SVGDef $ tailr xs S.|> (Modifier svg (ts ++ opts))
                                                x -> SVGDef $ tailr xs S.|> (Modifier x opts) 

type Renderer = State RenderData 

renderData :: SVGTree -> Renderer () 
renderData (Modifier t xs) = do 
                    opts ~= xs 
                    renderData t
                    opts ~= []
                    return ()
renderData (Box lbl (x,y) (x',y') nm xs) = do 
                    -- previous 
                    os <- access opts
                    let rside = (x', (y + y') / 2)
                    let lside = (x, (y + y') / 2)
                    boxes ++= pure ((Box lbl (x,y) (x',y') nm None),os)
                    opts ~= []
                    makeConnected lside 
                    case xs of 
                        None -> return ()
                        Many xs -> renderLocal rside xs 
                    return ()
renderData (Circle lbl (x,y) r nm xs) = do 
                    os <- access opts
                    let rside = (x + r,y)
                    let lside = (x - r,y)
                    circles ++= pure ((Circle lbl (x,y) r nm None), os)
                    opts ~= []
                    makeConnected lside 
                    case xs of 
                        None -> return ()
                        Many xs -> renderLocal rside xs 
                    return ()
renderData (Button id lbl (x,y) n xs) = do 
                    os <- access opts
                    let rside = (x,y)
                    buttons ++= pure ((Button id lbl (x,y) n None), os)
                    opts ~= []
                    case xs of 
                        None -> return ()
                        Many xs -> renderLocal rside xs 
renderData (Line lbl (x,y) (x',y') nm xs) = do 
                    os <- access opts
                    let rside = (x',y')
                    lines ++= pure ((Line lbl (x,y) (x',y') nm xs),os)
                    opts ~= []
                    case xs of 
                        None -> return ()
                        Many xs -> renderLocal rside xs 

interpRenderData :: SVGDef -> RenderData 
interpRenderData (SVGDef xs) = flip execState defaultRenderData $
                        forM_ xs $ \i -> do 
                                cpoint ~= Nothing 
                                renderData i




makeConnected :: (X,Y) -> Renderer ()
makeConnected r = do 
            rside <- access cpoint 
            case rside of 
                Nothing ->  return ()
                Just r' -> void $ cons ++= pure (r, r') 

renderLocal :: (X,Y) -> [SVGTree] -> Renderer ()
renderLocal xy xs = localConnect xy $ forM_ xs $ \i -> renderData i 

localConnect :: (X,Y) -> Renderer a -> Renderer a
localConnect r m = do 
            rside <- access cpoint 
            cpoint ~= Just r 
            a <- m
            cpoint ~= rside 
            return a

svgData :: RenderData -> S.Svg 
svgData rd = mconcat $ 
             (renderBox <$> _boxes rd) <> 
             (renderButton <$> _buttons rd) <>
             (renderLine <$> _lines rd) <>
             (renderCircle <$> _circles rd) <>
             (renderCon <$> _cons rd) 


renderBox :: SVGPair -> S.Svg 
renderBox ((Box lbl (x,y) (x',y') nm None),opts) = let obj = S.rect ! A.height (toValue height) ! A.width (toValue width) ! A.x (toValue x) ! A.y (toValue y) ! A.name (toValue nm) in addOpts opts obj <> (S.text_ (text $ pack lbl )) ! A.x (toValue $ fst lm) ! A.y (toValue $ snd lm) ! A.fontSize "12px"
        where width = abs $ x' - x
              height = abs $ y' - y
              lm = (x + width / 10, y' - height / 2)

modelAttribute s = customAttribute (stringTag $ "module") (toValue s) 

testBox :: SVGPair 
testBox = (Box "testbox" (10,20) (30,40) "hello" None, [FGColor (20,30,255)])

addOpts xs m = foldr step m xs 
    where step (FGColor fg) z = z ! A.color (toValue ("rgb" ++ show fg )) 
          step (BGColor fg) z = z ! A.fill (toValue ("rgb" ++ show fg ))
          step (CSS c) z = z ! A.style (toValue $ (fst c) ++ ":" ++ (snd c))
          step (Attribute c) z = z ! customAttribute (stringTag $ fst c) (toValue (snd c))
renderCircle ((Circle lbl (x,y) r nm None),opts) = let obj = S.circle ! A.cx (toValue x) ! A.cy (toValue y) ! A.r (toValue r) ! A.name (toValue nm) in addOpts opts obj 

renderLine ((Line lbl (x,y) (x',y') nm None),opts) = undefined 

renderCon ((x,y), (x',y')) = S.line ! A.x1 (toValue x) ! A.x2 (toValue x') ! A.y1 (toValue y) ! A.y2 (toValue y') ! A.color ("red") ! A.style ("stroke:rgb(255,0,0);stroke-width=2")

renderButton ((Button id lbl (x,y) nm None),opts) = let obj = S.image ! A.x (toValue x) ! A.y (toValue y) ! A.xlinkHref (toValue (nm ++ ".png")) ! A.height "15" ! A.width "15" in addOpts opts obj ! modelAttribute nm  ! A.id_ (toValue id)

(++=) x z = x %= (`mappend`z)

render :: SVGDef -> String 
render = renderSvg . S.docTypeSvg . svgData . interpRenderData  



connect :: SVGDef -> Connect SVGTree -> Connect SVGTree 
connect (SVGDef x) (None) = Many $ foldr (:) [] x
connect (SVGDef x) (Many xs) = Many $ foldr (:) xs x 

headr (S.viewr -> (_ S.:> x )) = x
headl (S.viewl -> (x S.:< _)) = x
tailr (S.viewr -> (xs S.:> _)) = xs
taill (S.viewl -> (_ S.:< xs)) = xs


{-- Widgets --}
records = record "test" (10,10) 1 "test" ["edit", "delete","view"] `multi` [ 
                record "test1" (230, 10) 2 "test2" ["edit", "delete", "view"],
                record "test2" (230, 140) 3 "test2" ["edit", "delete", "view"],
                record "test3" (230, 260) 4 "test2" ["edit", "delete", "view"]
            ]

record :: String -> (X,Y)  -> Integer -> String -> [String] -> SVGDef 
record lbl (x,y) id nm xs = addButtons (x,y) 200 100 id nm xs  <> (bt <!> [BGColor (255,255,0), FGColor (0,0,255)])
                where bt = box lbl ((x,y),rt) nm 
                      rt = (x + 210, y + 110)

addButtons :: (X,Y) -> X -> Y -> Integer -> String -> [String] -> SVGDef 
addButtons (x,y) w h id nm xs = fst $ foldr step (mempty,y) xs 
        where step lbl (z,h) = (z <> button id nm (x+10+ w,h) lbl, h + 20)


testdb = connectPostgreSQL "host=db.graffity.me user=deosx password=#*rl& dbname=streetking_dev"

loadContinent :: Integer -> SqlTransaction Connection SVGDef
loadContinent cid = do
                x <- fromJust <$> load cid :: SqlTransaction Connection (C.Continent)
                xs <- search ["continent_id" |== (toSql $ C.id x)] [] 1000 0 :: SqlTransaction Connection [CI.City]
                return $ 
                    record (C.name x) (10,10) (fromJust $ C.id x) ("continent") ["edit", "delete"] `multi` (bm (230 + 50,10) xs) 

    where bm (x,y) (r:xs) = record (CI.name r) (x,y) (fromJust $ CI.id r) "city" ["edit", "delete"] : bm (x, y + 220) xs
          bm (x,y) _ = [] 


-- 10 10 
-- 280 10 
-- 550 10 
-- 820 10 

loadCarInstance :: Integer -> SqlTransaction Connection SVGDef 
loadCarInstance cid = do 
                    ci <- fromJust <$> load cid :: SqlTransaction Connection CRI.CarInstance
                    c <- fromJust <$> load (CRI.car_id ci) :: SqlTransaction Connection Car.Car 
                    ps <- search [("car_instance_id" |== (toSql $ CRI.id ci))] [] 1000 0 :: SqlTransaction Connection [P.PartInstance]
                    let bm (x,y) (i:xs) = do 
                            pi <- fromJust <$> load (P.part_id i) :: SqlTransaction Connection Part.Part
                            pt <- fromJust <$> load (Part.part_type_id pi) :: SqlTransaction Connection PT.PartType  
                            rest <- bm (x, y + 220) xs 
                            return $ ((record ("part_" ++ show (fromJust $ P.id i)) (x, y) (fromJust $ P.id i) "part" ["edit", "delete"])
                                        <-> (record (PT.name pt) (270 + x, y) (fromJust $ PT.id pt) "part_model" ["edit", "delete"])) : rest
                        bm (x,y) [] = return []

                    cs <- bm (550, 10) ps
                    return $ record (Car.name c) (10,10)  (fromJust $ Car.id c) "car" ["edit", "delete"] <-> 
                                (record ("car_instance_id_" ++ (show $ fromJust $ CRI.id ci)) (280, 10) (fromJust $ CRI.id ci) "car" ["edit", "delete"] `multi` cs)
                        

runl m = testdb >>= \x -> runSqlTransaction m error x <* disconnect x
