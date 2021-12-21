package org.glagoldsl.compiler.ast.declaration;

import org.glagoldsl.compiler.ast.declaration.member.Member;
import org.glagoldsl.compiler.ast.identifier.Identifier;

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
}
