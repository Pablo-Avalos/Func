--                                                      TP 4 - NICOLÁS MATÍAS GARCÍA (1ra Parte)

--                                1 MAP

-- 1.1) Definir la función map para los siguientes tipos algebraicos:

-- 1) 
--data [a] = [] | a : [a]

mapL :: (a -> b) -> [a] -> [b]
mapL f [] = []
mapL f (x:xs) = f x : mapL f xs


-- 2) 
data Tree a = EmptyT | NodeT a (Tree a) (Tree a) deriving (Show)

mapTree :: (a -> b) -> Tree a -> Tree b
mapTree f EmptyT = EmptyT
mapTree f (NodeT x tr1 tr2) = NodeT (f x) (mapTree f tr1) (mapTree f tr2)


-- 3) 
data NonEmptyList a = Unit a | NECons a (NonEmptyList a) deriving (Show)

mapNEL :: (a -> b) -> NonEmptyList a -> NonEmptyList b
mapNEL f (Unit x) = Unit (f x)
mapNEL f (NECons x nel) = NECons (f x) (mapNEL f nel) 


-- 4) 
data AppendList a = Nil | Unity a | Append (AppendList a) (AppendList a) deriving (Show)

mapAppendL :: (a -> b) -> AppendList a -> AppendList b
mapAppendL f Nil = Nil
mapAppendL f (Unity x) = Unity (f x)
mapAppendL f (Append ap1 ap2) = Append (mapAppendL f ap1) (mapAppendL f ap2)


-- 5) 
-- data Maybe a = Nothing | Just a deriving (Show)

mapMaybe :: (a -> b) -> Maybe a -> Maybe b
mapMaybe f Nothing = Nothing
mapMaybe f (Just x) = Just (f x) 

-- 6) 
data T a = A a | B (T a) | C (T a) (T a) deriving (Show)

mapT :: (a -> b) -> T a -> T b
mapT f (A x) = A (f x)
mapT f (B t) = B (mapT f t)
mapT f (C t1 t2) = C (mapT f t1) (mapT f t2)


-- 7)
data LTree a = L [a] | BL a (LTree a) (LTree a) deriving (Show)

mapLTree :: (a -> b) -> LTree a -> LTree b
mapLTree f (L xs) = L (mapL f xs)
mapLTree f (BL x lt1 lt2) = BL (f x) (mapLTree f lt1) (mapLTree f lt2)


-- 8)
--data Either b a = Left b | Right a deriving (Show)

--mapEither :: (a -> b) -> Either b a -> Either a b
--mapEither f (Left x) = Right x
--mapEither f (Right y) = Left (f y)


-- 9) 
data MTree a = Lm (Maybe a) | Bm a (MTree a) (MTree a) deriving (Show)

mapMTree :: (a -> b) -> (MTree a) -> (MTree b)
mapMTree f (Lm maybe) = Lm (mapMaybe f maybe)
mapMTree f (Bm x mt1 mt2) = Bm (f x) (mapMTree f mt1) (mapMTree f mt2)


--10) (Desafío) --> (pendiente por ahora)

data GenTree a = GNode a [GenTree a] deriving (Show)

--mapGenTree :: (a -> b) -> GenTree a -> GenTree b
--mapGenTree f (GNode x xs) = GNode (f x) (mapL f xs) 


-- 1.2)
-- Con la definición de map dada para el tipo T del ejercicio anterior (llamémosla mapX), demostrar:

--1)

 {- Todo dentro de este comentario largo son las demostraciones inductivas :s
 
mapX id = id
                    = ppio extensionalidad
mapX id t = id t

Demuestro por inducción estructural en t

Caso base, t = (A x)

mapX id (A x)
                  = def mapX
A (id x)
                  = def id
A x

id (A x)
                  = def id
A x

-- 2 Casos inductivos:

Caso 1, t = (B r)    -> (r = recursive)

HI) mapX id r = id r
TI) mapX id (B r) = id (B r)

mapX id (B r)
                          = def mapX
B (mapX id r)
                          = HI
B (id r)
                          = def id
B r
                          = def id
id (B r)

Demostrado caso 1 .

Caso 2, t = (C r1 r2) 

HI) 
1) mapX id r1 = id r1
2) mapX id r2 = id r2
TI) mapX id (C r1 r2) = id (C r1 r2)

mapX id (C r1 r2)
                              = def mapX
C (mapX id r1) (mapX id r2)
                              = HI 1) y 2)
C (id r1) (id r2)
                              = def id (2 veces)
C r1 r2
                              = def id
id (C r1 r2)

Demostrado caso 2 .

                     QED

-----------------------------------------------------------------------------------------

2. mapX f . mapX g = mapX (f.g) (Llamada propiedad de fusión)

mapX f . mapX g = mapX (f.g)
                                      = ppio extensionalidad
(mapX f . mapX g) t = mapX (f.g) t
                                      = def (.)
mapX f (mapX g t) = mapX (f.g) t

Demuestro por inducción estructural en t

Caso base, t = (A x)

mapX f (mapX g (A x))
                             = def mapX
mapX f (A (g x))
                             = def mapX
A (f (g x))

mapX (f.g) (A x)
                     = def mapX
A ((f.g) x)
                     = def (.)
A (f (g x))

-- 2 Casos inductivos:

Caso 1, t = (B r)    -> (r = recursive)


HI) mapX f (mapX g r) = mapX (f.g) r
TI) mapX f (mapX g (B r)) = mapX (f.g) (B r)


mapX f (mapX g (B r))
                         = def mapX
mapX f (B (mapX g r))
                         = def mapX
B (mapX f (mapX g r))
                         = HI
B (mapX (f.g) r)
                         = def mapX (al revés)
mapX (f.g) (B r)

Demostrado caso 1 .

Caso 2, t = (C r1 r2) 

HI) 
1) mapX f (mapX g r1) = mapX (f.g) r1
2) mapX f (mapX g r2) = mapX (f.g) r2
TI) mapX f (mapX g (C r1 r2)) = mapX (f.g) (C r1 r2)


mapX f (mapX g (C r1 r2))
                                            = def mapX
mapX f (C (mapX g r1) (mapX g r2))
                                            = def mapX
C (mapX f (mapX g r1)) (mapX f (mapX g r2))
                                            = HI 1) y 2)
C (mapX (f.g) r1) (mapX (f.g) r2)
                                            = def mapX (al revés)
mapX (f.g) (C r1 r2)

                       QED

-------------------------------------------------------------------------------------------

-}

-- 1.3)
--Definir las siguientes funciones sobre los tipos algebraicos del punto 1, donde f es reemplazado por cada uno de dichos tipos:


-- 1) 
--data [a] = [] | a : [a]

find :: (a -> Bool) -> [a] -> Maybe a
find f xs = foldr (\ x y -> if f x then Just x else y) Nothing xs


isJust :: Maybe a -> Bool
isJust Nothing = False
isJust (Just x) = True


fromJust :: Maybe a -> a
fromJust Nothing = error "no se puede tomar un elemento de Nothing"
fromJust (Just x) = x

--data Tree a = EmptyT | NodeT a (Tree a) (Tree a) 

dameJustSiPodes :: Maybe a -> Maybe a -> Maybe a
dameJustSiPodes (Just x) _ = Just x
dameJustSiPodes _ (Just y) = Just y
dameJustSiPodes _ _ = Nothing

findT :: (a -> Bool) -> Tree a -> Maybe a
findT f t = foldrT (\ x t1 t2 -> if f x then Just x else dameJustSiPodes t1 t2) Nothing t

foldrT :: (a -> b -> b -> b) -> b -> Tree a -> b
foldrT f y EmptyT = y
foldrT f y (NodeT x t1 t2) = f x (foldrT f y t1) (foldrT f y t2)


-- data NonEmptyList a = Unit a | NECons a (NonEmptyList a)

findNEL f nel = foldrNEL (\ x y -> if f x then Just x else y) (\ z -> if f z then Just z else Nothing) nel


foldrNEL f g (Unit x) = g x
foldrNEL f g (NECons x nel) = x `f` (foldrNEL f g nel)


-- data AppendList a = Nil | Unity a | Append (AppendList a) (AppendList a)

--findAppendL f appL = foldrAPPL (\ x y -> if f x then Just x else if f y then Just y else Nothing) 
--                               (\ z -> if f z then Just z else Nothing) Nothing appL


--foldrAPPL f g y Nil = y
--foldrAPPL f g y (Unity x) = g x
--foldrAPPL f g y (Append ap1 ap2) = (foldrAPPL f g y ap1) `f` (foldrAPPL f g y ap2) 



-- data Maybe a = Nothing | Just a 

findMaybe :: (a -> Bool) -> Maybe a -> Maybe a
findMaybe f m = foldrMaybe (\ x -> if f x then Just x else Nothing) Nothing m

foldrMaybe f y Nothing = y
foldrMaybe f y (Just x) = f x 





-------------------------------------------------------------------------------------------------------------

-- 2. any, all :: (a -> Bool) -> f a -> Bool

any' f = foldr (\ x y -> f x || y) False

all' f = foldr (\ x y -> f x && y) True

anyT, allT :: (a -> Bool) -> Tree a -> Bool

anyT f = foldrT (\ x t1 t2 -> f x || t1 || t2) False

allT f = foldrT (\ x t1 t2 -> f x && t1 && t2) True 

-- data NonEmptyList a = Unit a | NECons a (NonEmptyList a) 

anyNEL, allNEL :: (a -> Bool) -> NonEmptyList a -> Bool 

anyNEL f = foldrNEL (\ x y -> f x || y) (\ z -> f z)

allNEL f = foldrNEL (\ x y -> f x && y) (\ z -> f z)






















