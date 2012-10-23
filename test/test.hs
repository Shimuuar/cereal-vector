{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE TemplateHaskell #-}

import Control.Monad

import Data.Int       (Int64)
import Data.Serialize (decode, encode, Serialize(..))
import qualified Data.Vector           as V
import qualified Data.Vector.Primitive as VP
import qualified Data.Vector.Generic   as VG
import qualified Data.Vector.Storable  as VS
import qualified Data.Vector.Unboxed   as VU

import Test.QuickCheck.All

import Data.Vector.Serialize
import Data.Vector.Storable.Serialize ()


prop_vec :: [Int] -> Bool
prop_vec xs = (Right xsv) == decode (encode xsv)
  where xsv = V.fromList xs

prop_vec_tuple :: [[Int]] -> [Either [Bool] Double] -> Bool
prop_vec_tuple xs ys = (Right (xsv, ysv)) == decode (encode (xsv, ysv))
  where (xsv, ysv) = (V.fromList xs, V.fromList ys)

prop_prim :: [Int] -> Bool
prop_prim xs = (Right xsv) == decode (encode xsv)
  where xsv = VP.fromList xs

instance Serialize (VU.Vector Int) where
  get = genericGetVector ; put = genericPutVector

prop_unbox :: [Int] -> Bool
prop_unbox xs = (Right xsv) == decode (encode xsv)
  where xsv = VU.fromList xs

prop_storable :: [Int] -> Bool
prop_storable xs = (Right xsv) == decode (encode xsv)
  where xsv = VS.fromList xs

prop_storable_tuple :: [Int64] -> [Double] -> Bool
prop_storable_tuple xs ys = (Right (xsv, ysv)) == decode (encode (xsv, ysv))
  where (xsv, ysv) = (VS.fromList xs, VS.fromList ys)

main :: IO ()
main = void $ $quickCheckAll
