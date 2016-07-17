module Parser::Converter::Boolean

import Syntax::Abstract::AST;
import Syntax::Concrete::Grammar;

public bool convertBoolean((Boolean) `true`) = true;
public bool convertBoolean((Boolean) `false`) = false;
