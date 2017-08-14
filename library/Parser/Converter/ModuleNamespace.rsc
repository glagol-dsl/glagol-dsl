module Parser::Converter::ModuleNamespace

import Syntax::Abstract::Glagol;
import Syntax::Concrete::Grammar;

public Declaration convertModuleNamespace(a: (Namespace) `<Name name>`) = namespace("<name>")[@src=a@\loc];
public Declaration convertModuleNamespace(a: (Namespace) `<Name name>::<Namespace n>`) 
    = namespace("<name>", convertModuleNamespace(n))[@src=a@\loc];
