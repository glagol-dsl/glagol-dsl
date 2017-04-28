module Parser::Converter::DefaultValue

import Syntax::Abstract::Glagol;
import Syntax::Concrete::Grammar;
import Parser::Converter::Expression;

public Expression convertParameterDefaultVal(a: (AssignDefaultValue) `=<DefaultValue defaultValue>`, Type onType) {

    Expression defaultValue = convertExpression(defaultValue);
    
    if (defaultValue == get(selfie())) {
        defaultValue = get(onType);
    }

    return defaultValue[@src=a@\loc];
}
    
