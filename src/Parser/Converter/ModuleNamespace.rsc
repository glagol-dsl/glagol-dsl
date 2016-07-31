module Parser::Converter::ModuleNamespace

import Syntax::Abstract::AST;
import Syntax::Concrete::Grammar;

public Declaration convertModuleNamespace((Namespace) `<Name name>`) = namespace("<name>");
public Declaration convertModuleNamespace((Namespace) `<Name name>::<Namespace n>`) 
    = namespace("<name>", convertModuleNamespace(n));
