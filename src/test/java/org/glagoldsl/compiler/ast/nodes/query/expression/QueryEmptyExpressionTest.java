package org.glagoldsl.compiler.ast.nodes.query.expression;

import org.glagoldsl.compiler.ast.nodes.query.QueryVisitor;
import org.glagoldsl.compiler.ast.nodes.type.IntegerType;
import org.glagoldsl.compiler.ast.nodes.type.TypeVisitor;
import org.junit.jupiter.api.Test;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.junit.jupiter.api.extension.ExtendWith;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class QueryEmptyExpressionTest {
    @Test
    void accept(@Mock QueryExpressionVisitor<Void, Void> visitor) {
        var node = new QueryEmptyExpression();
        node.accept(visitor, null);
        verify(visitor, times(1)).visitQueryEmptyExpression(any(), any());
    }
}