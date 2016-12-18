module Transform::Glagol2PHP::Repositories

import Transform::Glagol2PHP::Annotations;
import Transform::Glagol2PHP::Common;
import Transform::Glagol2PHP::Constructors;
import Transform::Glagol2PHP::Methods;
import Transform::Glagol2PHP::Statements;
import Transform::Glagol2PHP::Properties;
import Transform::Glagol2PHP::ClassItems;
import Syntax::Abstract::Glagol;
import Syntax::Abstract::PHP;
import Config::Reader;

public PhpStmt toPhpClassDef(r: repository(str name, list[Declaration] declarations), env: <Framework f, doctrine()>)
    = phpClassDef(phpClass("<name>Repository", {}, phpSomeName(phpName("EntityRepository")), [], 
    		toPhpClassItems(declarations, env, r))[
        @phpAnnotations=toPhpAnnotations(r, env)
    ]);
