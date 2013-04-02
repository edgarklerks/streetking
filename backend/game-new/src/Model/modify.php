<?php

die("remove this line");

die("TODO: in some models, not only id is hidden from prelude. update the replacement line to reflect this.");

$a = "import qualified Data.Relation as Rel";

$h = opendir('.');
while(false !== ($n = readdir($h))) {
        echo "\nprocessing \"" . $n . "\" `... ";
        // is Haskell?
        if(array_pop(explode(".", $n)) == "hs") {
                $c = file_get_contents($n);
                // is record definition?
                if(strstr($c, "\$(genAll")) {
                        echo "!";
                        // append after prelude line
                        $d = preg_replace("/(import\s+Prelude\s+hiding\s+\(id\))/", "$1\n" . $a, $c);
                        file_put_contents($n, $d);
                }
        }
}
closedir($h);

echo "\n\ndone.\n";
