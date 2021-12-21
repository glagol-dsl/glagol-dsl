package org.glagoldsl.compiler.ast.declaration;

import org.glagoldsl.compiler.ast.declaration.member.Member;
import org.glagoldsl.compiler.ast.identifier.Identifier;

import java.util.List;

public class Repository extends Declaration {
    final private Identifier entityIdentifier;
    final private List<Member> members;

    public Repository(
            Identifier identifier,
            List<Member> members
    ) {
        this.entityIdentifier = identifier;
        this.members = members;
    }

    public Identifier getEntityIdentifier() {
        return entityIdentifier;
    }

    public List<Member> getMembers() {
        return members;
    }
}
