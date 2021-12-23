package org.glagoldsl.compiler.ast.nodes.type;

import org.glagoldsl.compiler.ast.nodes.identifier.Identifier;

public class RepositoryType extends Type {
    final private Identifier entity;

    public RepositoryType(Identifier entity) {
        this.entity = entity;
    }

    public Identifier getEntity() {
        return entity;
    }

    @Override
    public String toString() {
        return "repository<" + entity + '>';
    }

    @Override
    public <T, C> T accept(TypeVisitor<T, C> visitor, C context) {
        return visitor.visitRepositoryType(this, context);
    }
}
