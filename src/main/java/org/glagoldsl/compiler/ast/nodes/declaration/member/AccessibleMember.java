package org.glagoldsl.compiler.ast.nodes.declaration.member;

abstract public class AccessibleMember extends Member {
    final private Accessor accessor;

    protected AccessibleMember(Accessor accessor) {
        this.accessor = accessor;
    }

    public Accessor getAccessor() {
        return accessor;
    }
}
