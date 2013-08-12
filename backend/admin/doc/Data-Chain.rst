==========
Data.Chain
==========

-  `Contents <index.html>`__
-  `Index <doc-index.html>`__

 

Safe Haskell

None

Data.Chain

Documentation
=============

registerTask :: (`Task <Model-Task.html#t:Task>`__ -> Bool) ->
(`Task <Model-Task.html#t:Task>`__ ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__ Bool) -> IO ()

runTask :: `Task <Model-Task.html#t:Task>`__ ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__ Bool

Produced by `Haddock <http://www.haskell.org/haddock/>`__ version 2.11.0
