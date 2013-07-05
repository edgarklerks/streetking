
module Data.Section (
        Section (..),
        angle,
        perturb,
        trackDetailsSection
    ) where 

--import Data.Matrix 
import Data.Maybe
import qualified Model.TrackDetails as TD

trackWidth :: Double
trackWidth = 12

data Section = Section {
        section_id :: Integer,
        radius :: Maybe Double,     -- section curve radius
        arclength :: Double         -- section length
    } deriving (Eq, Show)

section :: Integer -> Double -> Double -> Section
section i r = case (r < 0.01) of
    True -> Section i Nothing
    False -> Section i (Just r)

trackDetailsSection :: TD.TrackDetails -> Section
trackDetailsSection t = section (fromJust $ TD.id t) (TD.radius t) (TD.length t)

radius' :: Section -> Double
radius' = fromJust . radius

-- section curve angle (length = angle * radius)
angle :: Section -> Maybe Double
angle s = case (radius s) of
    Nothing -> Nothing
    Just r -> Just $ (arclength s) / r

angle' :: Section -> Double
angle' = fromJust . angle

-- section curve curvature is 1 / (curve radius)
curvature :: Section -> Maybe Double
curvature s = case (radius s) of
    Nothing -> Nothing
    Just r -> Just $ 1 / r

-- calculate section intersecting at the start and end points and deviating in the center by a distance calculated from the center of curvature outward.
-- perturbarion amount is 0-1 and represents the lateral position on the track as a percentage, calculated from the inner limit outward.
perturb :: Double -> Section -> Section
perturb q s = case maybe False (1.5*pi <) (angle s)  of 
        -- TODO: calculations for radius > 2*pi. for now there is no perturbation at all in this case.
        -- NOTE: close to 2*pi we see extreme behavior. limit is set to 3/2 pi.
        -- NOTE: for very long curves, there is little difference between the paths.
        True -> s 
        False -> Section (section_id s) pradius plength
                where
                        -- for very small corner radii, we must use a smaller track width to avoid the track overlapping itself and performances resulting in negative track lengths
                        -- when the radius equals half the width, the road curves around its own outer limit. any smaller and overlap occurs. 
                        tw = case sradius of
                                Nothing -> trackWidth
                                Just sr -> min trackWidth $ sr

                        -- calculate deviation from main path in center of section
                        d = tw * (0.5 - q) 
        
                        sradius = radius s
                        slength = arclength s
                        sangle = angle s
        
                        pradius :: Maybe Double
                        pradius = case sradius of
                                Nothing -> Nothing
                                Just r0 -> case ((d <) $ (0.001 +) $ r0 * (ca - 1)) of
                                        -- True: path cuts through the section in a straight line; effective path radius goes to infinity
                                        True -> Nothing
                                        False -> Just $ (2*(r0+d)*x - 2*r0^2 - 2*d*r0 - d^2) / (2*(x-r0-d))
                                    where
                                        x = r0 * ca
                                        a = fromJust sangle
                                        ca = cos a
        
                        plength :: Double
                        plength = case sradius of
                                Nothing -> arclength s
                                Just r -> case pradius of
                                        -- Nothing: path cuts through the section in a straight line; length is the difference between the y-coordinates of the intersection points
                                        Nothing -> 2 * r * (sin $ (/2) $ fromJust sangle) 
                                        Just rp -> rp * 2 * ap 
                                            where
                                                r0 = fromJust $ sradius
                                                ap = atan2 y x
                                                y = r0 * sin a0
                                                x = (r0 * cos a0) - (d + r0 - rp)
                                                a0 = (/2) $ fromJust sangle


