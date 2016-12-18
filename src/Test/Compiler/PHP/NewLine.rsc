module Test::Compiler::PHP::NewLine

import Compiler::PHP::NewLine;

test bool shouldProcudeNewLine() = nl() == "\n";
test bool shouldProcudeTwoNewLines() = nl(2) == "\n\n";
test bool shouldProcudeThewwNewLines() = nl(3) == "\n\n\n";
