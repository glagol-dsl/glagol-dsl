module Parser::Converter::AssignOperator

import Syntax::Abstract::AST;
import Syntax::Concrete::Grammar;

public AssignOperator convertAssignOperator((AssignOperator) `/=`) = divisionAssign();
public AssignOperator convertAssignOperator((AssignOperator) `*=`) = productAssign();
public AssignOperator convertAssignOperator((AssignOperator) `-=`) = subtractionAssign();
public AssignOperator convertAssignOperator((AssignOperator) `=`) = defaultAssign();
public AssignOperator convertAssignOperator((AssignOperator) `+=`) = additionAssign();
