package org.glagoldsl.compiler.ast.type;

import org.glagoldsl.compiler.ast.identifier.Identifier;

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
}
