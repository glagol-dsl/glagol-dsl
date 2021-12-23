package org.glagoldsl.compiler.ast.nodes.expression;

import org.glagoldsl.compiler.ast.nodes.expression.binary.Concatenation;
import org.glagoldsl.compiler.ast.nodes.expression.binary.arithmetic.Addition;
import org.glagoldsl.compiler.ast.nodes.expression.binary.arithmetic.Division;
import org.glagoldsl.compiler.ast.nodes.expression.binary.arithmetic.Product;
import org.glagoldsl.compiler.ast.nodes.expression.binary.arithmetic.Subtraction;
import org.glagoldsl.compiler.ast.nodes.expression.binary.relational.*;
import org.glagoldsl.compiler.ast.nodes.expression.literal.*;
import org.glagoldsl.compiler.ast.nodes.expression.unary.Bracket;
import org.glagoldsl.compiler.ast.nodes.expression.unary.arithmetic.Negative;
import org.glagoldsl.compiler.ast.nodes.expression.unary.arithmetic.Positive;
import org.glagoldsl.compiler.ast.nodes.expression.unary.relational.Negation;

public interface ExpressionVisitor<T, C> {
    // binary
    T visitConcatenation(Concatenation node, C context);
    // binary: arithmetic
    T visitAddition(Addition node, C context);
    T visitDivision(Division node, C context);
    T visitProduct(Product node, C context);
    T visitSubtraction(Subtraction node, C context);
    // binary: relational
    T visitConjunction(Conjunction node, C context);
    T visitDisjunction(Disjunction node, C context);
    T visitEqual(Equal node, C context);
    T visitGreaterThan(GreaterThan node, C context);
    T visitGreaterThanOrEqual(GreaterThanOrEqual node, C context);
    T visitLowerThan(LowerThan node, C context);
    T visitLowerThanOrEqual(LowerThanOrEqual node, C context);
    T visitNonEqual(NonEqual node, C context);

    // unary
    T visitBracket(Bracket node, C context);
    // unary: arithmetic
    T visitNegative(Negative node, C context);
    T visitPositive(Positive node, C context);
    // unary: relational
    T visitNegation(Negation node, C context);

    // literals
    T visitBooleanLiteral(BooleanLiteral node, C context);
    T visitDecimalLiteral(DecimalLiteral node, C context);
    T visitIntegerLiteral(IntegerLiteral node, C context);
    T visitStringLiteral(StringLiteral node, C context);

    // Misc
    T visitEmptyExpression(EmptyExpression node, C context);
    T visitExpressionQuery(ExpressionQuery node, C context);
    T visitGList(GList node, C context);
    T visitGMap(GMap node, C context);
    T visitInvoke(Invoke node, C context);
    T visitNew(New node, C context);
    T visitPropertyAccess(PropertyAccess node, C context);
    T visitTernary(Ternary node, C context);
    T visitThis(This node, C context);
    T visitTypeCast(TypeCast node, C context);
    T visitVariable(Variable node, C context);
}
