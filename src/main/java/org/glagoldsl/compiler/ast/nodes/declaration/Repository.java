package org.glagoldsl.compiler.ast.nodes.declaration;

import org.glagoldsl.compiler.ast.nodes.declaration.member.Member;
import org.glagoldsl.compiler.ast.nodes.identifier.Identifier;

import java.util.List;

public class Repository extends Declaration {
    final private Identifier entityIdentifier;
    final private List<Member> members;

    public Repository(
            Identifier entityIdentifier,
            List<Member> members
    ) {
        this.entityIdentifier = entityIdentifier;
        this.members = members;
    }

    public Identifier getEntityIdentifier() {
        return entityIdentifier;
    }

    public List<Member> getMembers() {
        return members;
    }

    public <T, C> T accept(DeclarationVisitor<T, C> visitor, C context) {
        return visitor.visitRepository(this, context);
    }
}
