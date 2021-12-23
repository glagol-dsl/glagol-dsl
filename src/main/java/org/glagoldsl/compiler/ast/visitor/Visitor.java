package org.glagoldsl.compiler.ast.visitor;

import org.glagoldsl.compiler.ast.nodes.annotation.AnnotationVisitor;
import org.glagoldsl.compiler.ast.nodes.declaration.DeclarationVisitor;
import org.glagoldsl.compiler.ast.nodes.expression.ExpressionVisitor;
import org.glagoldsl.compiler.ast.nodes.identifier.IdentifierVisitor;
import org.glagoldsl.compiler.ast.nodes.module.ModuleVisitor;
import org.glagoldsl.compiler.ast.nodes.query.QueryVisitor;
import org.glagoldsl.compiler.ast.nodes.query.expression.QueryExpressionVisitor;
import org.glagoldsl.compiler.ast.nodes.statement.StatementVisitor;
import org.glagoldsl.compiler.ast.nodes.statement.assignable.AssignableVisitor;
import org.glagoldsl.compiler.ast.nodes.type.TypeVisitor;

public interface Visitor<T, C> extends AnnotationVisitor<T, C>,
        DeclarationVisitor<T, C>,
        ModuleVisitor<T, C>,
        ExpressionVisitor<T, C>,
        QueryVisitor<T, C>,
        QueryExpressionVisitor<T, C>,
        StatementVisitor<T, C>,
        AssignableVisitor<T, C>,
        TypeVisitor<T, C>,
        IdentifierVisitor<T, C> {
}
