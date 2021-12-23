package org.glagoldsl.compiler.ast.nodes.statement;

public interface StatementVisitor<T, C> {
    T visitAssign(Assign node, C context);
    T visitAssignOperator(AssignOperator node, C context);
    T visitBlock(Block node, C context);
    T visitBreak(Break node, C context);
    T visitContinue(Continue node, C context);
    T visitDeclare(Declare node, C context);
    T visitEmptyStatement(EmptyStatement node, C context);
    T visitExpressionStatement(ExpressionStatement node, C context);
    T visitFlush(Flush node, C context);
    T visitForEach(ForEach node, C context);
    T visitForEachWithKey(ForEachWithKey node, C context);
    T visitIf(If node, C context);
    T visitPersist(Persist node, C context);
    T visitRemove(Remove node, C context);
    T visitReturn(Return node, C context);
}
