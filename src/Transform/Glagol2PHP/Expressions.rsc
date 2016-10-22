module Transform::Glagol2PHP::Expressions

import Syntax::Abstract::Glagol;
import Syntax::Abstract::PHP;
import String;

private str toLowerCaseFirstChar(str text) = toLowerCase(text[0]) + substring(text, 1);

public PhpExpr toPhpExpr(intLiteral(int i)) = phpScalar(phpInteger(i));
public PhpExpr toPhpExpr(floatLiteral(real r)) = phpScalar(phpFloat(r));
public PhpExpr toPhpExpr(strLiteral(str s)) = phpScalar(phpString(s));
public PhpExpr toPhpExpr(boolLiteral(bool b)) = phpScalar(phpBoolean(b));
public PhpExpr toPhpExpr(\list(list[Expression] items)) 
    = phpArray([phpArrayElement(phpNoExpr(), toPhpExpr(i), false) | i <- items]);
public PhpExpr toPhpExpr(get(artifactType(str name))) 
    = phpPropertyFetch(phpVar(phpName(phpName("this"))), phpName(phpName(toLowerCaseFirstChar(name))));
