{-# LANGUAGE ExistentialQuantification #-}
{-# LANGUAGE StandaloneDeriving #-}
{-# LANGUAGE GADTs #-}

import Control.Monad.Writer
import Data.IORef
import Control.Monad.ST
import Control.Monad.State

-- name with de'bruijn index
data Var = Var (Maybe Int) String deriving (Eq)

instance Show Var where
  show (Var (Just index) name) = "(var: " ++ show name ++ " (" ++ show index ++ "))"
  show (Var Nothing name) = "(nacked var: " ++ show name ++ ")"

data Op = Add deriving (Show,Eq)

data Expr a where
  Num :: Int -> Expr Int
  Intrinsic :: Op -> Expr a -> Expr a -> Expr a
  Lambda :: Var -> Expr a -> Expr a
  App :: Expr a -> Expr a -> Expr a
  If :: Expr a -> Expr a -> Expr a -> Expr a
  VarE :: Var -> Expr a 
  Combinator :: SKI a -> Expr a 

deriving instance Show (Expr a)

data SKI a where
  S :: Expr a -> Expr a -> SKI a
  K :: Expr a -> SKI a
  I :: SKI a

deriving instance Show (SKI a)

-- compile innermost lambda.
compile :: Expr a -> Expr a
compile (Num x) = Num x
compile (Intrinsic op x y) = (Intrinsic op (compile x) (compile y))
compile (Lambda var body) = if hasLambda body 
                             then Lambda var (compile body)
                             else compileLambda var body
compile (App x y) = App (compile x) (compile y)
compile (If b t e) = If (compile b) (compile t) (compile e)
compile (VarE v) = VarE v
compile (Combinator ski) = Combinator $ compile' ski

compile' :: SKI a -> SKI a
compile' (S x y) = S (compile x) (compile y)
compile' (K x) = K (compile x)
compile' I = I

-- no further lambda in body is assumed
compileLambda :: Var -> Expr a -> Expr a
compileLambda var (App x y) = Combinator $ S (Lambda var x) (Lambda var y)
compileLambda var (VarE x) | isId var x = Combinator I
                           | otherwise = Combinator $ K (VarE x)
compileLambda var (Num x) = Combinator $ K (Num x)
compileLambda var x@(Combinator _) = x
compileLambda _ e = error $ "whut in inner lam: " ++ show e

-- is identity function? should generate I?
isId :: Var -> Var -> Bool
isId (Var _ x) (Var _ y) = x == y

-- compile all until no lambda left
compileAll :: Expr a -> Writer String (Expr a)
compileAll expr | hasLambda expr = do let expr' = compile expr
                                      tell $ "\n\n==> " ++ show expr'
                                      compileAll expr'
                | otherwise = return expr

compileSKI :: Expr a -> IO ()
compileSKI expr = let (value,output) = runWriter (compileAll expr)
                  in do putStrLn $ "steps: " ++ output ++ "\n\nand finally ==>"
                        print value

hasLambda :: Expr a -> Bool
hasLambda (Lambda _ _) = True
hasLambda (Intrinsic _ x y) = hasLambda x || hasLambda y
hasLambda (App x y) = hasLambda x || hasLambda y
hasLambda (If x y z) = hasLambda x || hasLambda y || hasLambda z
hasLambda (Combinator ski) = hasLambda' ski
hasLambda (Num _) = False
hasLambda (VarE _) = False

hasLambda' :: SKI a -> Bool
hasLambda' I = False
hasLambda' (K x) = hasLambda x
hasLambda' (S x y) = hasLambda x || hasLambda y

add :: Expr a -> Expr a -> Expr a
add = Intrinsic Add

var :: String -> Expr a
var = VarE . Var Nothing

bind :: String -> Var 
bind = Var Nothing

plus = Lambda (bind "x") (Lambda (bind "y") (add (var "x") (var "y")))

plusE x y = let lambda = Lambda (bind "x") (Lambda (bind "y") (var "+"))
            in App (App lambda x) y

test1 = let expr =  Lambda (bind "x") (plusE (var "x") (var "x"))
        in App expr (Num 5)

suc = Lambda (bind "x") (plusE (var "1") (var "x"))

sLet :: Var -> Expr a -> Expr a -> Expr a
sLet var expr body = let abs = Lambda var body
                     in App abs expr

define :: Expr a -> Expr a 
define = Lambda (bind "useless") 

letTest = define $ sLet (bind "x") (var "1") (plusE (var "x") (var "x")) 

data SKI' = S' SKI' SKI'
            | K' SKI'
            | I' 
            | BuiltIn String deriving Show


-- expr in SKI to SKI'
toPureSKI :: Expr a -> SKI'
toPureSKI (Combinator ski) = skiToPureSKI ski
toPureSKI (VarE (Var _ s)) = BuiltIn s
toPureSKI (Num s) = BuiltIn (show s)
toPureSKI s = error $ "no top level SKI (use def?): "  ++ show s

skiToPureSKI :: SKI a -> SKI'
skiToPureSKI (S x y) = S' (toPureSKI x) (toPureSKI y)
skiToPureSKI (K x) = K' $ toPureSKI x
skiToPureSKI I = I'

data SKIDef = SKIDef { def :: SKI', arg :: Maybe SKI' } deriving Show

fullCompileW :: Expr a -> Writer String SKIDef
fullCompileW expr = do exprSKI <- compileAll expr
                       case exprSKI of 
                        App f arg -> do tell "expr is full reduction. Create arg\n"
                                        return SKIDef { def = toPureSKI f,arg = Just $ toPureSKI arg }
                        _ -> do tell "pure definition or irreducible\n"
                                return SKIDef {def = toPureSKI exprSKI, arg = Nothing }

fullCompile :: Expr a -> IO ()
fullCompile expr = let (v,output) = runWriter (fullCompileW expr)
                   in do putStrLn $ "translation: " ++ output
                         putStrLn $ "\n\nfinal result in pure SKI: " ++ show v
                         return ()

data Graph = Node (IORef Graph) (IORef Graph)
             | Thunk SKI' | GS | GK | GI | GBuiltin String

mkGraph :: SKI' -> IO Graph
mkGraph (S' f g) = do
  f' <- newIORef (Thunk f)
  g' <- newIORef (Thunk g)
  s' <- newIORef GS
  sf <- newIORef (Node s' f')
  return $ Node sf  g'
mkGraph (K' f) = do
  k' <- newIORef GK
  f' <- newIORef (Thunk f)
  return $ Node k' f'
mkGraph I' = return GI
mkGraph (BuiltIn v) = return $ GBuiltin v 
 
type Stack = [String]

reduce :: Graph -> StateT Stack IO Graph
reduce (Node l r) = do
  l' <- getRef l
  r' <- getRef r
  l'' <- reduce l'
  r'' <- reduce r'
  undefined

getRef :: IORef Graph -> StateT Stack IO Graph
getRef = liftIO . readIORef

