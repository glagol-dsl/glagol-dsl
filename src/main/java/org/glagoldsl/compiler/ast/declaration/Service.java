package org.glagoldsl.compiler.ast.declaration;

import org.glagoldsl.compiler.ast.declaration.member.Member;
import org.glagoldsl.compiler.ast.identifier.Identifier;

import java.util.List;

public class Service extends NamedDeclaration {
    final private List<Member> members;

    public Service(
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
