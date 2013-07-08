Streetking
=========

Streetking is a race simulation game with realistic physical computations. 


Overal Structure 
===================

Backend is where the various servers reside. Proxy-new is the load balancer and securing proxy, which communicates with the backend servers.
Game-new is the game server and images is the image server. 

Every map has a src, where the source files reside. There is also a doc map, where the documentation is.

src/Data contains all (concurrent) datastructures, dsl's, statemachines, parsers etc.

in src/Lua resides the Lua intepreter, which is interconnected with the game server.

The snaplets (which are composable servers) reside in the src map.

The configuration is found in the resource map. 

The models are in src/Models and following a strict recipe how to build them up.

In src/Models/DbFunctions.hs you can add your database functions. See the examples how to do  that.

In Site.hs are all the interface functions defined. These are the functions the frontend uses.
In proxy-new/resource/roleSet.cfg the permission should be set correctly and the function should be added to the routing in Site.hs

For simple query resources, use the DatabaseTemplateDSL (DTD), it generates a search interface, fetches variables from the provided json and get a limit and order and transform it into SqlValue's:

    marketCarPrototype :: Application ()
    marketCarPrototype = do 
          uid <- getUserId
          puser <- fromJust <$> runDb (load uid) :: Application (A.Account )
          let ctr = ("level" |<= (toSql $ A.level puser)) 
          ((l,o),xs) <- getPagesWithDTD (
                -- This is the DatabaseTemplateDSL
                      "manufacturer_id" +== "manufacturer_id"
                  +&& "id" +== "id"
                  +&& "car_id" +== "car_id"
                  +&& "prototype" +==| toSql True
                  +&& "prototype_available" +==| toSql True
                  +&& "prototype_claimable" +== "prototype_claimable"
              )
          ns <- runDb (searchCarInGarage (ctr:xs) [] l o)
          writeMapables ns

Documentation of these are done elsewhere. At the moment in a serie mails. This can be better.

The main datatype are InRule, this is a data type, which emulates a dynamic typesystem and can even encode Abstract Datatypes as 
binary. A subset is isomorphic to JSON, SqlValue and YAML and can be made isomorphic to XML. This means it doesn't lose information between
conversion between different types.

This means for example:

    JSONa -> InRule -> SqlValue -> InRule -> JSONb
    JSONa === JSONb


Style
=====

We prefer to write datatypes on front and add for pure code some laws we can check with quickcheck.

In Bot.hs it is described how to do it. For impure computations, please use HUnit. And for api level testing
add your test cases to proxy-new/src/Test/Flupper.hs 

It is best to add the tests to Bot.hs, but if that is not possible add it to the source file itself and prefix
then name with prop_

In game/src/Bot.hs there are some tests, which use unit testing.

When possible use applicative code and try to avoid do notation.

If you have the time CPS transform your monads and roll them your own. This gives a speedup of 30% in the average case.
See game/src/Data/SqlTransaction.hs as example how to do this. 

Try to eta reduce as much as possible and write for every datatype the appropiate instances.
For example monad, functor, applicative, comonad, arrow, category, monad or whatever. This makes code more compositional.

If you work with records, derive some lenses for it. This is much easier than the cluncky record syntax.


Documentation
=============

Document your code with haddock. This is easy to do:

    -- | Adds one 
    plus1 :: Int -- ^ input integer
            -> Int -- ^ output integer 
    plus1 = (+1)

You can regenerate the documentation by running perl gen-doc.pl

The generated restructed text sucks balls, but stupid bitbucket cannot show html. The html is fine.

Profiling
=========


Profiling is not hard, just remember to build your buildchain with profiling enabled. 


Snaplets
========

Snaplets are little server components, which are easily plugged in. If you have some general functionality 
wrap it in a snaplet. 
