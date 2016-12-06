module Transform::Glagol2PHP::Utils

import Transform::Glagol2PHP::Common;
import Transform::Glagol2PHP::Constructors;
import Transform::Glagol2PHP::Methods;
import Transform::Glagol2PHP::Statements;
import Transform::Glagol2PHP::Properties;
import Syntax::Abstract::Glagol;
import Syntax::Abstract::PHP;

public PhpStmt toPhpClassDef(util(str name, list[Declaration] declarations))
    = phpClassDef(phpClass(name, {}, phpNoName(), [], []));
