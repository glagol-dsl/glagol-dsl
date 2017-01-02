module Test::Utils::NewLine

import Utils::NewLine;

test bool shouldProcudeNewLine() = nl() == "\n";
test bool shouldProcudeTwoNewLines() = nl(2) == "\n\n";
test bool shouldProcudeThewwNewLines() = nl(3) == "\n\n\n";
