package org.glagoldsl.compiler.ast.nodes.declaration.member;

import org.glagoldsl.compiler.ast.nodes.declaration.DeclarationVisitor;
import org.glagoldsl.compiler.ast.nodes.expression.Expression;
import org.glagoldsl.compiler.ast.nodes.identifier.Identifier;
import org.glagoldsl.compiler.ast.nodes.type.Type;

public class Property extends AccessibleMember {
    final private Type type;
    final private Identifier name;
    final private Expression defaultValue;

    public Property(
            Accessor accessor,
            Type type,
            Identifier name,
            Expression defaultValue
    ) {
        super(accessor);
        this.type = type;
        this.name = name;
        this.defaultValue = defaultValue;
    }

    public Expression getDefaultValue() {
        return defaultValue;
    }

    public boolean hasDefaultValue() {
        return !defaultValue.isEmpty();
    }

    public Type getType() {
        return type;
    }

    public Identifier getName() {
        return name;
    }

    @Override
    public boolean isProperty() {
        return true;
    }

    public <T, C> T accept(DeclarationVisitor<T, C> visitor, C context) {
        return visitor.visitProperty(this, context);
    }
}
