module Parser::Converter::Declaration::Action

import Syntax::Abstract::Glagol;
import Syntax::Concrete::Grammar;
import Parser::Converter::Parameter;
import Parser::Converter::Expression;
import Parser::Converter::Statement;

public Declaration convertDeclaration(d: (Declaration) `<Action action>`, _, a: /^(?!controller).*$/) {
	throw ActionNotAllowed("Action declarations not allowed in artifact type \'<a>\'", d@\loc);
}

public Declaration convertDeclaration((Declaration) `<Action action>`, _, _) = convertAction(action);

public Declaration convertAction(a: (Action) `<MemberName name>{<Statement* body>}`) = 
	action("<name>", [], [convertStmt(stmt) | stmt <- body]);

public Declaration convertAction(a: (Action) `<MemberName name>=<Expression expr>;`) = 
	action("<name>", [], [\return(convertExpression(expr))]);

public Declaration convertAction(a: (Action) `<MemberName name><AbstractParameters params>{<Statement* body>}`) = 
	action("<name>", convertParameters(params), [convertStmt(stmt) | stmt <- body]);

public Declaration convertAction(a: (Action) `<MemberName name><AbstractParameters params>=<Expression expr>;`) = 
	action("<name>", convertParameters(params), [\return(convertExpression(expr))]);
