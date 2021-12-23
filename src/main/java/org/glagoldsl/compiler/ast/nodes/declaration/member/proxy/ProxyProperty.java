package org.glagoldsl.compiler.ast.nodes.declaration.member.proxy;

import org.glagoldsl.compiler.ast.nodes.declaration.DeclarationVisitor;
import org.glagoldsl.compiler.ast.nodes.declaration.member.Accessor;
import org.glagoldsl.compiler.ast.nodes.declaration.member.Property;
import org.glagoldsl.compiler.ast.nodes.expression.EmptyExpression;
import org.glagoldsl.compiler.ast.nodes.identifier.Identifier;
import org.glagoldsl.compiler.ast.nodes.type.Type;

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

    public <T, C> T accept(DeclarationVisitor<T, C> visitor, C context) {
        return visitor.visitProxyProperty(this, context);
    }
}
