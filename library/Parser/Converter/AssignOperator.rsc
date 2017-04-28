module Parser::Converter::AssignOperator

import Syntax::Abstract::Glagol;
import Syntax::Concrete::Grammar;

public AssignOperator convertAssignOperator(a: (AssignOperator) `/=`) = divisionAssign()[@src=a@\loc];
public AssignOperator convertAssignOperator(a: (AssignOperator) `*=`) = productAssign()[@src=a@\loc];
public AssignOperator convertAssignOperator(a: (AssignOperator) `-=`) = subtractionAssign()[@src=a@\loc];
public AssignOperator convertAssignOperator(a: (AssignOperator) `=`) = defaultAssign()[@src=a@\loc];
public AssignOperator convertAssignOperator(a: (AssignOperator) `+=`) = additionAssign()[@src=a@\loc];
