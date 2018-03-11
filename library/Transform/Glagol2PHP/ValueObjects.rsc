module Transform::Glagol2PHP::ValueObjects

import Transform::Env;
import Transform::OriginAnnotator;
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

public PhpStmt toPhpClassDef(v: valueObject(str name, list[Declaration] declarations, notProxy()), TransformEnv env)
    = origin(phpClassDef(origin(phpClass(name, {}, phpNoName(), [origin(phpName("\\JsonSerializable"), v)], [
    	origin(phpTraitUse([phpName("\\Glagol\\Bridge\\Lumen\\Entity\\JsonSerializeTrait")], []), v, true)
    ] + toPhpClassItems(declarations, env))[
        @phpAnnotations=toPhpAnnotations(v, env)
    ], v)), v);
