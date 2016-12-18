module Test::Compiler::PHP::Indentation

import Compiler::PHP::Indentation;

test bool zeroIndentation() = s(0) == "";
test bool firstLevelIndentation() = s(1) == "    ";
test bool secondLevelIndentation() = s(2) == "        ";
test bool thirdLevelIndentation() = s(3) == "            ";
