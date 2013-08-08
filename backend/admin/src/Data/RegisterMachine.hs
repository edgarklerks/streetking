module Data.RegisterMachine where 

import Control.Monad 
import Control.Applicative

{--
 - Infinite integer registers which are stacks 
 -  i1 ... in 
 - 
 - Infinite double register which are stacks 
 -  d1 ... dn 
 - 
 - Infinite general purpose register which are stacks, which can hold any type
 -  r1 ... rn
 - 
 - [any]
 -
 -  Prim types [prim]:
 -  Integer
 -  Double 
 -
 -  Addr types [addr]: 
 -  IAddr (Instruction address), DAddr (Data address)
 -
 -  Register labels [reg] = [r|d|i]:
 -
 -  r1, d1, i1 .. rn, dn, in
 -
 -
 - Instruction set
 -  
 - load [addr], [reg] : [addr] -> [reg]
 - store [any], [addr] : [reg] -> [addr]
 - 
 - Conditional jump:
 -
 - jmn [reg], [iaddr] 
 - jmz [req], [iaddr]
 --}
