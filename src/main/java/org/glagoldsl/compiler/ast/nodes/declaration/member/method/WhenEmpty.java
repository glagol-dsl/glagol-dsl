package org.glagoldsl.compiler.ast.nodes.declaration.member.method;

import org.glagoldsl.compiler.ast.nodes.declaration.DeclarationVisitor;
import org.glagoldsl.compiler.ast.nodes.expression.EmptyExpression;

public class WhenEmpty extends When {
    public WhenEmpty() {
        super(new EmptyExpression());
    }

    @Override
    public boolean isEmpty() {
        return true;
    }

    public <T, C> T accept(DeclarationVisitor<T, C> visitor, C context) {
        return visitor.visitWhenEmpty(this, context);
    }
}
