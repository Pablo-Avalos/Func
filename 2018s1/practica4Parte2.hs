--                                                      TP 4 - NICOLÁS MATÍAS GARCÍA (2da Parte)


-- 2.2)
-- Definir para listas:
-- 1) 
foldr1' :: (a -> a -> a) -> [a] -> a
foldr1' f [] = error "la lista esta vacia"
foldr1' f [x] = x
foldr1' f (x:xs) = f x (foldr1' f xs)
--2) 
recr' :: (a -> [a] -> b -> b) -> b -> [a] -> b
recr' f z [] = z
recr' f z (x:xs) = 
            f x xs (recr' f z xs)


-- 2.3)
-- Definir todas las funciones ya definidas sobre listas utilizando foldr, foldr1 o recr (depen-
-- diendo del caso), y sobre árboles binarios con foldT. Tener en cuenta que en algunos casos pueden
-- ser difíciles, o que no se puedan realizar con recursión estructural. Se recomienda consultar si es
-- que se detuvo mucho tiempo en encontrar una solución.


-- foldr :: (a -> b -> b) -> b -> [a] -> b

head' :: [a] -> a
head' = foldr const (error "la lista esta vacia")

tail' :: [a] -> [a]
tail' = recr' (\ x xs r -> xs) (error "La lista esta vacia")

sum', product' :: Num a => [a] -> a

sum' = foldr (+) 0

product' = foldr (*) 1

elem', notElem' :: Eq a => a -> [a] -> Bool

elem' y = foldr (\ x r -> x == y || r) False

notElem' y = foldr (\ x r -> x /= y && r) True

and', or' :: [Bool] -> Bool

and' = foldr (&&) True

or' = foldr (||) False

last' :: [a] -> a
last' = foldr1 (\ x r -> r) 

init' :: [a] -> [a]
init' = recr' (\ x xs r -> if null xs then [] else x:r) (error "La lista esta vacia")


subset :: Eq a => [a] -> [a] -> Bool
subset xs ys = foldr (\ y r -> y `elem` ys && r) True xs

(++¿) :: [a] -> [a] -> [a]
(++¿) xs ys = foldr (:) ys xs 

concat' :: [[a]] -> [a]
concat' = foldr (++) []

--(!!¿) :: Num a => [a] -> Int -> a
--(!!¿) [] n = error "La lista no tiene dimensión n" 
--(!!¿) (x:_) 0 = x 
--(!!¿) (x:xs) n = xs !!¿ (n-1)

-- ERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERROR

-- DROP, ZIP, SPLIT AT, TAKE, 

maximum', minimum' :: Ord a => [a] -> a

maximum' = foldr1 max 

minimum' = foldr1 min 


-- UNZIP.....

lookup' :: Eq a => a -> [(a,b)] -> Maybe b
lookup' x = foldr f Nothing
        where f (x',y) r = if x == x' then Just y else r 


tails :: [a] -> [[a]]
tails = recr' (\ x xs r -> if null xs then r else xs:r) []

countBy :: (a -> Bool) -> [a] -> Int
countBy p = foldr (\ x r -> if p x then 1 + r else r) 0 

map' :: (a -> b) -> [a] -> [b]
map' p = foldr (\ x r -> p x : r) []

filter' :: (a -> Bool) -> [a] -> [a]
filter' p = foldr (\ x r -> if p x then x:r else r) []

any',all' :: (a -> Bool) -> [a] -> Bool

any' p = foldr (\ x r -> p x || r) False

all' p = foldr (\ x r -> p x && r) True

find' :: (a -> Bool) -> [a] -> Maybe a
find' p = foldr (\ x r -> if p x then Just x else r) Nothing

partition :: (a -> Bool) -> [a] -> ([a], [a])
partition p = foldr (\ x r -> let (left,right) = r in if p x then ((x:left),right) else (left,(x:right))) ([],[])

length' :: [a] -> Int
length' = foldr (\ x r -> 1 + r) 0

reverse' :: [a] -> [a]
reverse' = foldr (\ x r -> r ++ [x]) []


--takeWhile', dropWhile' :: (a -> Bool) -> [a] -> [a]

takeWhile' p = foldr (\ x r -> if p x then x:r else []) []

--dropWhile' p = recr' (\ x xs r -> if p x then r else xs) []


--SPAN, BREAK, ZIPWITH, ZIPAPPLY, INDEX, APPLYN, ITERATE, NATS, CYCLE, NUBBY, DROPWHILE

fromJust :: Maybe a -> a
fromJust Nothing = error "No tiene elemento"
fromJust (Just x) = x

isJust :: Maybe a -> Bool
isJust Nothing = False
isJust (Just x) = True

findIndex :: (a -> Bool) -> [a] -> Maybe Int
findIndex p = foldr (\ x r -> let m = r
                     in if p x then Just 0
                        else if isJust m then Just (fromJust m + 1) else r) Nothing


--agrupar :: Eq a => [a] -> [[a]]
--agrupar [] = []
--agrupar [x] = [[x]]
--agrupar (x:xs) = let (ys:yss) = agrupar xs
--                               in if elem' x ys then (x:ys):yss else [x] : agrupar xs

--agrupar = recr' (\ x xs r -> let (ys:yss) = r in if elem x ys then ((x:ys):yss) else ([x] : (ys:yss)) ) []




--                                                          ÁRBOLES

data Tree a = EmptyT | NodeT a (Tree a) (Tree a) deriving (Show)

foldrT :: (a -> b -> b -> b) -> b -> Tree a -> b
foldrT f y EmptyT = y
foldrT f y (NodeT x t1 t2) = f x (foldrT f y t1) (foldrT f y t2)

sumT :: Tree Int -> Int 
sumT = foldrT (\ x r1 r2 -> x + r1 + r2) 0

sizeT :: Tree a -> Int
sizeT = foldrT (\ x r1 r2 -> 1 + r1 + r2) 0

mapT :: (a -> b) -> Tree a -> Tree b
mapT f = foldrT (\ x t1 t2 -> NodeT (f x) t1 t2) EmptyT

mapDoubleT :: Tree Int -> Tree Int
mapDoubleT = mapT (*2)

mapLengthT :: Tree String -> Tree Int
mapLengthT = mapT length

elemT :: Eq a => a -> Tree a -> Bool
elemT x = foldrT (\ x' r1 r2 -> x' == x || r1 || r2) False

occurrsT :: Eq a => a -> Tree a -> Int
occurrsT x = foldrT (\ x' r1 r2 -> if x == x' then 1 + r1 + r2 else r1 + r2) 0

-- Necesario para countLeaves
isEmptyT :: Tree a -> Bool
isEmptyT EmptyT = True
isEmptyT _ = False

recrT :: (a -> Tree a -> Tree a -> b -> b -> b) -> b -> Tree a -> b
recrT f y EmptyT = y
recrT f y (NodeT x t1 t2) = f x t1 t2 (recrT f y t1) (recrT f y t2)

countLeaves :: Tree a -> Int
countLeaves = recrT (\ x t1 t2 r1 r2 -> if isEmptyT t1 && isEmptyT t2 then 1 + r1 + r2 else r1 + r2) 0

leaves :: Tree a -> [a]
leaves = recrT (\ x t1 t2 r1 r2 -> if isEmptyT t1 && isEmptyT t2 then [x] ++ r1 ++ r2 else r1 ++ r2) []

heightT :: Tree a -> Int
heightT = foldrT (\ x r1 r2 -> 1 + max r1 r2) 0

mirrorT :: Tree a -> Tree a
mirrorT = foldrT (\ x r1 r2 -> NodeT x r2 r1) EmptyT

listInOrder :: Tree a -> [a]
listInOrder = foldrT (\ x r1 r2 -> r1 ++ [x] ++ r2) []

listPreOrder :: Tree a -> [a]
listPreOrder = foldrT (\ x r1 r2 -> x : r1 ++ r2) []

listPosOrder :: Tree a -> [a]
listPosOrder = foldrT (\ x r1 r2 -> r1 ++ r2 ++ [x]) []

concatT :: Num a => Tree [a] -> [a]
concatT = foldrT (\ x r1 r2 -> r1 ++ x ++ r2) []

--LEVELN, LISTPERLEVEL, COUNTNOLEAVES ?

leftBranches :: Tree a -> [a]
leftBranches = recrT (\ x t1 t2 r1 r2 -> if isEmptyT t1 then [] else root t1 : r1) [] where root (NodeT x t1 t2) = x


longestBranch :: Tree a -> [a]
longestBranch = foldrT (\ x r1 r2 -> let (xs,ys) = (r1,r2) in if length xs >= length ys then x:xs else x:ys) [] 

allPaths :: Tree a -> [[a]]
allPaths = recrT (\ x t1 t2 r1 r2 -> if isEmptyT t1 && isEmptyT t2 then [[x]] else map (x:) r1 ++ map (x:) r2) []




































