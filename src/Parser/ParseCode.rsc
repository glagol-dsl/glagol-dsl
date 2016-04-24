module Parser::ParseCode

import Syntax::Concrete::Grammar;
import ParseTree;
import String;
import IO;

public Tree parseCode(str code) = parse(#Module, trim(code));
public Tree parseFile(loc file) = parseCode(readFile(file));
