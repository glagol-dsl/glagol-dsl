package org.glagoldsl.compiler.ast.nodes.type;

public interface TypeVisitor<T, C> {
    T visitBoolType(BoolType node, C context);
    T visitClassType(ClassType node, C context);
    T visitFloatType(FloatType node, C context);
    T visitGListType(GListType node, C context);
    T visitGMapType(GMapType node, C context);
    T visitIntegerType(IntegerType node, C context);
    T visitRepositoryType(RepositoryType node, C context);
    T visitStringType(StringType node, C context);
    T visitVoidType(VoidType node, C context);
}
