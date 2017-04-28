module Parser::Converter::Boolean

import Syntax::Abstract::Glagol;
import Syntax::Concrete::Grammar;

public bool convertBoolean((Boolean) `true`) = true;
public bool convertBoolean((Boolean) `false`) = false;
