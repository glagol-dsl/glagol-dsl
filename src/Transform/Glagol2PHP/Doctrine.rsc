module Transform::Glagol2PHP::Doctrine

import Transform::Glagol2PHP::Common;
import Syntax::Abstract::Glagol;
import Syntax::Abstract::PHP;
import Config::Reader;

private str NS_DL = "\\";

public PhpScript toPHPScript(<_, doctrine()>, \module(Declaration namespace, imports, artifact))
    = phpScript([toPhpStmt(namespace, imports, artifact)]);

private PhpStmt toPhpStmt(Declaration namespace, set[Declaration] imports, Declaration artifact)
    = phpNamespace(
        phpSomeName(phpName(namespaceToString(namespace, NS_DL))),
        [phpUse({toPhpUse(i) | i <- imports})] + [toPhpStmt(artifact)]
    );

// imports
private PhpUse toPhpUse(\import(str artifactName, Declaration namespace, str as))
    = phpUse(phpName(namespaceToString(namespace, NS_DL) + NS_DL + artifactName), phpSomeName(phpName(as))) when as != artifactName;

private PhpUse toPhpUse(\import(str artifactName, Declaration namespace, str as))
    = phpUse(phpName(namespaceToString(namespace, NS_DL) + NS_DL + artifactName), phpNoName()) when as == artifactName;

// entities
private PhpStmt toPhpStmt(entity(str name, set[Declaration] declarations))
    = phpClassDef(phpClass(name, {}, phpNoName(), [], [toPhpClassItem(m) | m <- declarations]));

private PhpClassItem toPhpClassItem(property(Type \valueType, str name, _)) 
    = phpProperty({phpPrivate()}, [phpProperty(name, phpNoExpr())]);

private PhpClassItem toPhpClassItem(property(Type \valueType, str name, _, Expression defaultValue)) 
    = phpProperty({phpPrivate()}, [phpProperty(name, phpSomeExpr(toPhpExpr(defaultValue)))]);
