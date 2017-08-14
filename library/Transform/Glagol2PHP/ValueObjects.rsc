module Transform::Glagol2PHP::ValueObjects

import Transform::Glagol2PHP::Annotations;
import Transform::Glagol2PHP::Common;
import Transform::Glagol2PHP::Constructors;
import Transform::Glagol2PHP::Methods;
import Transform::Glagol2PHP::Statements;
import Transform::Glagol2PHP::Properties;
import Transform::Glagol2PHP::ClassItems;
import Syntax::Abstract::Glagol;
import Syntax::Abstract::PHP;
import Config::Config;

public PhpStmt toPhpClassDef(v: valueObject(str name, list[Declaration] declarations), env: <Framework f, ORM orm>)
    = phpClassDef(phpClass(name, {}, phpNoName(), [], toPhpClassItems(declarations, env, v))[
        @phpAnnotations=toPhpAnnotations(v, env)
    ]);
