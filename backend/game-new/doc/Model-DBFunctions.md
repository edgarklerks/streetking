-   [Contents](index.html)
-   [Index](doc-index.html)

 

Safe Haskell

None

Model.DBFunctions

Documentation
=============

type Arg = Name

type Args = [[Arg](Model-DBFunctions.html#t:Arg)]

type Ret = Name

type FName = String

type Definition = String

type Arity = Int

data FType

Constructors

||
|Row| |
|Scalar| |

Instances

||
|Show [FType](Model-DBFunctions.html#t:FType)| |

data Function

Constructors

||
|F [FType](Model-DBFunctions.html#t:FType) [FName](Model-DBFunctions.html#t:FName) [Args](Model-DBFunctions.html#t:Args) [Ret](Model-DBFunctions.html#t:Ret)| |

Instances

||
|Show [Function](Model-DBFunctions.html#t:Function)| |

data SqlFunction

Constructors

||
|SF [FName](Model-DBFunctions.html#t:FName) [FType](Model-DBFunctions.html#t:FType) [Arity](Model-DBFunctions.html#t:Arity) [Args](Model-DBFunctions.html#t:Args) [Definition](Model-DBFunctions.html#t:Definition) [Ret](Model-DBFunctions.html#t:Ret)| |

Instances

||
|Show [SqlFunction](Model-DBFunctions.html#t:SqlFunction)| |

mkFunctions :: [(String, [Name], Name, [FType](Model-DBFunctions.html#t:FType))] -\> Q [Dec]

ftosql :: [Function](Model-DBFunctions.html#t:Function) -\> [SqlFunction](Model-DBFunctions.html#t:SqlFunction)

sqlFunctionToSql :: [SqlFunction](Model-DBFunctions.html#t:SqlFunction) -\> DecQ

ft :: String -\> [[SqlValue](Data-SqlTransaction.html#t:SqlValue)] -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) [Connection](Data-SqlTransaction.html#t:Connection) [SqlValue](Data-SqlTransaction.html#t:SqlValue)

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
