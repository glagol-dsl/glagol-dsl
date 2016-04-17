module Parser::ParseAST

import Syntax::Abstract::AST;
import Parser::ParseCode;
import ParseTree;

public Declaration parseModule(str code) = implode(#Declaration, parseCode(code));
public Declaration parseModule(loc file) = implode(#Declaration, parseFile(file));
