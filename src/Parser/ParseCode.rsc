module Parser::ParseCode

import Syntax::Concrete::Grammar;
import ParseTree;
import String;
import IO;

public Tree parseFile(loc file) = parse(#Module, trim(readFile(file)), file);
public Tree parseCode(str code) = parse(#Module, trim(code));
