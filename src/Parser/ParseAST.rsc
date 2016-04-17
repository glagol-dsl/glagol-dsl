module Parser::ParseAST

import Syntax::Abstract::AST;
import Parser::ParseCode;
import ParseTree;

public Module parseModule(str code) = implode(#Module, parseCode(code));