module Parser::Converter::Declaration::Action

import Syntax::Abstract::Glagol;
import Syntax::Concrete::Grammar;
import Parser::Converter::Parameter;
import Parser::Converter::Expression;
import Parser::Converter::Statement;

public Declaration convertDeclaration((Declaration) `<Annotation* annotations><Action action>`, str _, str _, ParseEnv env) = 
	convertAction(action, env)[
    	@annotations = convertAnnotations(annotations, env)
    ];

public Declaration convertDeclaration((Declaration) `<Action action>`, _, _, ParseEnv env) = convertAction(action, env)[@src=action@\loc];

public Declaration convertAction(a: (Action) `<MemberName name>{<Statement* body>}`, ParseEnv env) = 
	action("<name>", [], [convertStmt(stmt, env) | stmt <- body]);

public Declaration convertAction(a: (Action) `<MemberName name>=<Expression expr>;`, ParseEnv env) = 
	action("<name>", [], [\return(convertExpression(expr, env))]);

public Declaration convertAction(a: (Action) `<MemberName name><AbstractParameters params>{<Statement* body>}`, ParseEnv env) = 
	action("<name>", convertParameters(params, env), [convertStmt(stmt, env) | stmt <- body]);

public Declaration convertAction(a: (Action) `<MemberName name><AbstractParameters params>=<Expression expr>;`, ParseEnv env) = 
	action("<name>", convertParameters(params, env), [\return(convertExpression(expr, env))]);
