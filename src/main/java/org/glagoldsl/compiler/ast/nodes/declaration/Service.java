package org.glagoldsl.compiler.ast.nodes.declaration;

import org.glagoldsl.compiler.ast.nodes.declaration.member.MemberCollection;
import org.glagoldsl.compiler.ast.nodes.identifier.Identifier;

public class Service extends NamedDeclaration {
    final private MemberCollection members;

    public Service(
            Identifier identifier,
            MemberCollection members
    ) {
        super(identifier);
        this.members = members;
    }

    public MemberCollection getMembers() {
        return members;
    }

    public <T, C> T accept(DeclarationVisitor<T, C> visitor, C context) {
        return visitor.visitService(this, context);
    }

    @Override
    public String toString() {
        return "service";
    }
}
