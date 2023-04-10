package org.glagoldsl.compiler.ast.nodes.declaration;

import org.glagoldsl.compiler.ast.nodes.declaration.member.MemberCollection;
import org.glagoldsl.compiler.ast.nodes.identifier.Identifier;
import org.glagoldsl.compiler.ast.nodes.module.Module;
import org.glagoldsl.compiler.ast.nodes.module.ModuleSet;

public class Repository extends Declaration {
    final private Identifier entityIdentifier;
    final private MemberCollection members;

    public Repository(
            Identifier entityIdentifier,
            MemberCollection members
    ) {
        this.entityIdentifier = entityIdentifier;
        this.members = members;
    }

    public Identifier getEntityIdentifier() {
        return entityIdentifier;
    }

    public MemberCollection getMembers() {
        return members;
    }

    public <T, C> T accept(DeclarationVisitor<T, C> visitor, C context) {
        return visitor.visitRepository(this, context);
    }

    @Override
    public DeclarationPointer pointer(Module module) {
        return new DeclarationPointer(module, this);
    }

    @Override
    public String toString() {
        return "repository<" + entityIdentifier + ">";
    }
}
