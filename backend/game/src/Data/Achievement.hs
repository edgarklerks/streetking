module Data.Achievement where 


import Text.Parsec.Combinator
import Text.Parsec.Prim 
import Text.Parsec.Char
import Text.Parsec.String 

type Identifier = String  
type Program = [Stm]

data Stm = VarD Identifier 
         | If Expr Expr (Maybe Expr)
         | For Expr Expr Expr Expr 
         | While Expr Expr 
         | Func Identifier [(Expr, Identifier)] Expr Expr 
         | Assign Identifier Expr 
         | Send Identifier Expr 
    deriving Show 

data Expr = BinOp Op Expr Expr 
          | UnOp Op Expr Expr 
          | Body [Expr]
          | Apply Identifier [Expr]
          | VarE Identifier 
          | IntT
          | FloatT
          | DoubleT
          | StringT 
          | CharT 
    deriving Show 

data Op = Plus 
        | Div 
        | Mul
        | Sub  
        | Mod
    deriving Show


program :: Parser Program 
program = stm `endBy` le

{-- Statements parsers --}

stm :: Parser Stm
stm = vard <|> ifd <|> ford <|> whiled <|> funcd <|> assignd <|> sendd 

vard,ifd,ford,whiled,funcd,assignd,sendd :: Parser Stm 
vard = undefined 
ifd = undefined 
ford = undefined 
whiled = undefined
funcd = undefined 
assignd = undefined 
sendd = undefined 

{-- Expression parsers --}



{-- Parser helpers --}

le :: Parser String 
le = undefined 
