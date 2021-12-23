package org.glagoldsl.compiler.ast.nodes.statement.assignable;

public interface AssignableVisitor<T, C> {
    T visitListValueAssign(ListValueAssign node, C context);
    T visitPropertyAssign(PropertyAssign node, C context);
    T visitVariableAssign(VariableAssign node, C context);
}
