module Parser::ParseCode

import Syntax::Concrete::Grammar;
import ParseTree;
import String;
import IO;

public Tree parseFile(loc file) = parse(#Module, readFile(file), file);
public Tree parseCode(str code) = parse(#Module, code);
public Tree parseCode(loc file, bool ambiguity) = parse(#Module, readFile(file), file, allowAmbiguity=ambiguity);
