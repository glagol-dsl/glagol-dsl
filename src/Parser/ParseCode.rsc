module Parser::ParseCode

import Syntax::Concrete::Grammar;
import ParseTree;

public Tree parseCode(str code) = parse(#Module, code);