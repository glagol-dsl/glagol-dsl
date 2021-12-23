package org.glagoldsl.compiler.ast.nodes.declaration;

import org.glagoldsl.compiler.ast.nodes.declaration.member.Member;
import org.glagoldsl.compiler.ast.nodes.identifier.Identifier;

import java.util.List;

public class Entity extends NamedDeclaration {
    final private List<Member> members;

    public Entity(
            Identifier identifier,
            List<Member> members
    ) {
        super(identifier);
        this.members = members;
    }

    public List<Member> getMembers() {
        return members;
    }

    public <T, C> T accept(DeclarationVisitor<T, C> visitor, C context) {
        return visitor.visitEntity(this, context);
    }
}
