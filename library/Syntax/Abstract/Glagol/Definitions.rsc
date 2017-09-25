module Syntax::Abstract::Glagol::Definitions

import Syntax::Abstract::Glagol;

data Definition
    = field(Declaration d)
    | param(Declaration d)
    | localVar(Statement stmt)
    | method(Declaration d)
    ;
    
public bool isField(field(_)) = true;
public default bool isField(value v) = false;
