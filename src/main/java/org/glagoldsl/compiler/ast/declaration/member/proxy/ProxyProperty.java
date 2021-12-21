package org.glagoldsl.compiler.ast.declaration.member.proxy;

import org.glagoldsl.compiler.ast.declaration.member.Accessor;
import org.glagoldsl.compiler.ast.declaration.member.Property;
import org.glagoldsl.compiler.ast.expression.EmptyExpression;
import org.glagoldsl.compiler.ast.identifier.Identifier;
import org.glagoldsl.compiler.ast.type.Type;

public class ProxyProperty extends Property {
    public ProxyProperty(
            Type type,
            Identifier name
    ) {
        super(
                Accessor.PUBLIC,
                type,
                name,
                new EmptyExpression()
        );
    }

    @Override
    public boolean hasDefaultValue() {
        return false;
    }
}
