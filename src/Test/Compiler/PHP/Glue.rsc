module Test::Compiler::PHP::Glue

import Compiler::PHP::Glue;

test bool shouldGlueOnePiece() = glue(["a"], ",") == "a";
test bool shouldGlueNoPiece() = glue([], ",") == "";
test bool shouldGlueTwoPieces() = glue(["a", "b"], ",") == "a,b";
test bool shouldGlueThreePiecesDiffDelimiter() = glue(["a", "b", "c"], "|") == "a|b|c";
test bool shouldGlueThreePiecesWithoutDelimiter() = glue(["a", "b", "c"]) == "abc";
