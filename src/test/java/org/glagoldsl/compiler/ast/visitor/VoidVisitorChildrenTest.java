package org.glagoldsl.compiler.ast.visitor;

import org.glagoldsl.compiler.ast.nodes.annotation.Annotation;
import org.glagoldsl.compiler.ast.nodes.annotation.AnnotationArgument;
import org.glagoldsl.compiler.ast.nodes.declaration.Declaration;
import org.glagoldsl.compiler.ast.nodes.declaration.Entity;
import org.glagoldsl.compiler.ast.nodes.declaration.Repository;
import org.glagoldsl.compiler.ast.nodes.declaration.Service;
import org.glagoldsl.compiler.ast.nodes.declaration.controller.RestController;
import org.glagoldsl.compiler.ast.nodes.declaration.controller.route.Route;
import org.glagoldsl.compiler.ast.nodes.declaration.controller.route.RouteElement;
import org.glagoldsl.compiler.ast.nodes.declaration.member.*;
import org.glagoldsl.compiler.ast.nodes.declaration.member.method.Body;
import org.glagoldsl.compiler.ast.nodes.declaration.member.method.Parameter;
import org.glagoldsl.compiler.ast.nodes.declaration.member.proxy.ProxyConstructor;
import org.glagoldsl.compiler.ast.nodes.declaration.member.proxy.ProxyMethod;
import org.glagoldsl.compiler.ast.nodes.declaration.member.proxy.ProxyProperty;
import org.glagoldsl.compiler.ast.nodes.declaration.proxy.PhpLabel;
import org.glagoldsl.compiler.ast.nodes.declaration.proxy.Proxy;
import org.glagoldsl.compiler.ast.nodes.expression.*;
import org.glagoldsl.compiler.ast.nodes.expression.binary.Concatenation;
import org.glagoldsl.compiler.ast.nodes.expression.binary.arithmetic.Addition;
import org.glagoldsl.compiler.ast.nodes.expression.binary.arithmetic.Division;
import org.glagoldsl.compiler.ast.nodes.expression.binary.arithmetic.Product;
import org.glagoldsl.compiler.ast.nodes.expression.binary.arithmetic.Subtraction;
import org.glagoldsl.compiler.ast.nodes.expression.binary.relational.*;
import org.glagoldsl.compiler.ast.nodes.expression.literal.BooleanLiteral;
import org.glagoldsl.compiler.ast.nodes.expression.literal.IntegerLiteral;
import org.glagoldsl.compiler.ast.nodes.expression.unary.Bracket;
import org.glagoldsl.compiler.ast.nodes.expression.unary.arithmetic.Negative;
import org.glagoldsl.compiler.ast.nodes.expression.unary.arithmetic.Positive;
import org.glagoldsl.compiler.ast.nodes.expression.unary.relational.Negation;
import org.glagoldsl.compiler.ast.nodes.identifier.Identifier;
import org.glagoldsl.compiler.ast.nodes.module.Import;
import org.glagoldsl.compiler.ast.nodes.module.Module;
import org.glagoldsl.compiler.ast.nodes.module.Namespace;
import org.glagoldsl.compiler.ast.nodes.query.*;
import org.glagoldsl.compiler.ast.nodes.query.expression.QueryExpression;
import org.glagoldsl.compiler.ast.nodes.query.expression.QueryField;
import org.glagoldsl.compiler.ast.nodes.query.expression.QueryInterpolation;
import org.glagoldsl.compiler.ast.nodes.query.expression.binary.relational.*;
import org.glagoldsl.compiler.ast.nodes.query.expression.unary.QueryBracket;
import org.glagoldsl.compiler.ast.nodes.query.expression.unary.QueryIsNotNull;
import org.glagoldsl.compiler.ast.nodes.query.expression.unary.QueryIsNull;
import org.glagoldsl.compiler.ast.nodes.query.expression.unary.QueryUnary;
import org.glagoldsl.compiler.ast.nodes.statement.*;
import org.glagoldsl.compiler.ast.nodes.statement.assignable.Assignable;
import org.glagoldsl.compiler.ast.nodes.type.*;
import org.jetbrains.annotations.NotNull;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.mockito.verification.VerificationMode;

import java.util.ArrayList;
import java.util.HashMap;

import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class VoidVisitorChildrenTest {

    final private VoidVisitor<Void> visitor = new VoidVisitor<>() {
    };

    @Test
    public void it_expects_annotation_children_to_be_visited() {
        var identifier = mock(Identifier.class);
        var arg1 = mock(AnnotationArgument.class);
        var arg2 = mock(AnnotationArgument.class);

        var tree = new Annotation(identifier, new ArrayList<>() {{
            add(arg1);
            add(arg2);
        }});

        tree.accept(visitor, null);

        verify(identifier, once()).accept(visitor, null);
        verify(arg1, once()).accept(visitor, null);
        verify(arg2, once()).accept(visitor, null);
    }

    @Test
    public void it_expects_annotation_argument_children_to_be_visited() {
        var expression = mock(Expression.class);

        var tree = new AnnotationArgument(expression);

        tree.accept(visitor, null);

        verify(expression, once()).accept(visitor, null);
    }

    @Test
    public void it_expects_entity_children_to_be_visited() {
        var identifier = mock(Identifier.class);
        var member = mock(Member.class);
        var annotation = mock(Annotation.class);

        var tree = new Entity(identifier, new ArrayList<>() {{
            add(member);
        }});
        tree.addAnnotation(annotation);

        tree.accept(visitor, null);

        verify(identifier, once()).accept(visitor, null);
        verify(member, once()).accept(visitor, null);
        verify(annotation, once()).accept(visitor, null);
    }

    @Test
    public void it_expects_repository_children_to_be_visited() {
        var identifier = mock(Identifier.class);
        var member = mock(Member.class);
        var annotation = mock(Annotation.class);

        var tree = new Repository(identifier, new ArrayList<>() {{
            add(member);
        }});
        tree.addAnnotation(annotation);

        tree.accept(visitor, null);

        verify(identifier, once()).accept(visitor, null);
        verify(member, once()).accept(visitor, null);
        verify(annotation, once()).accept(visitor, null);
    }

    @Test
    public void it_expects_service_children_to_be_visited() {
        var identifier = mock(Identifier.class);
        var member = mock(Member.class);
        var annotation = mock(Annotation.class);

        var tree = new Service(identifier, new ArrayList<>() {{
            add(member);
        }});
        tree.addAnnotation(annotation);

        tree.accept(visitor, null);

        verify(identifier, once()).accept(visitor, null);
        verify(member, once()).accept(visitor, null);
        verify(annotation, once()).accept(visitor, null);
    }

    @Test
    public void it_expects_value_children_to_be_visited() {
        var identifier = mock(Identifier.class);
        var member = mock(Member.class);
        var annotation = mock(Annotation.class);

        var tree = new Service(identifier, new ArrayList<>() {{
            add(member);
        }});
        tree.addAnnotation(annotation);

        tree.accept(visitor, null);

        verify(identifier, once()).accept(visitor, null);
        verify(member, once()).accept(visitor, null);
        verify(annotation, once()).accept(visitor, null);
    }

    @Test
    public void it_expects_rest_controller_children_to_be_visited() {
        var route = mock(Route.class);
        var member = mock(Member.class);
        var annotation = mock(Annotation.class);

        var tree = new RestController(route, new ArrayList<>() {{
            add(member);
        }});
        tree.addAnnotation(annotation);

        tree.accept(visitor, null);

        verify(route, once()).accept(visitor, null);
        verify(member, once()).accept(visitor, null);
        verify(annotation, once()).accept(visitor, null);
    }

    @Test
    public void it_expects_route_children_to_be_visited() {
        var element1 = mock(RouteElement.class);
        var element2 = mock(RouteElement.class);

        var tree = new Route(new ArrayList<>() {{
            add(element1);
            add(element2);
        }});

        tree.accept(visitor, null);

        verify(element1, once()).accept(visitor, null);
        verify(element2, once()).accept(visitor, null);
    }

    @Test
    public void it_expects_action_children_to_be_visited() {
        var identifier = mock(Identifier.class);
        var parameter = mock(Parameter.class);
        var body = mock(Body.class);
        var annotation = mock(Annotation.class);

        var tree = new Action(identifier, new ArrayList<>() {{
            add(parameter);
        }}, body);
        tree.addAnnotation(annotation);

        tree.accept(visitor, null);

        verify(identifier, once()).accept(visitor, null);
        verify(parameter, once()).accept(visitor, null);
        verify(body, once()).accept(visitor, null);
        verify(annotation, once()).accept(visitor, null);
    }

    @Test
    public void it_expects_constructor_children_to_be_visited() {
        var accessor = Accessor.PUBLIC;
        var parameter = mock(Parameter.class);
        var body = mock(Body.class);
        var annotation = mock(Annotation.class);

        var tree = new Constructor(accessor, new ArrayList<>() {{
            add(parameter);
        }}, body);
        tree.addAnnotation(annotation);

        tree.accept(visitor, null);

        verify(parameter, once()).accept(visitor, null);
        verify(body, once()).accept(visitor, null);
        verify(annotation, once()).accept(visitor, null);
    }

    @Test
    public void it_expects_proxy_constructor_children_to_be_visited() {
        var parameter = mock(Parameter.class);
        var annotation = mock(Annotation.class);

        var tree = new ProxyConstructor(new ArrayList<>() {{
            add(parameter);
        }});
        tree.addAnnotation(annotation);

        tree.accept(visitor, null);

        verify(parameter, once()).accept(visitor, null);
        verify(annotation, once()).accept(visitor, null);
    }

    @Test
    public void it_expects_method_children_to_be_visited() {
        var accessor = Accessor.PUBLIC;
        var type = mock(Type.class);
        var identifier = mock(Identifier.class);
        var parameter = mock(Parameter.class);
        var body = mock(Body.class);
        var annotation = mock(Annotation.class);

        var tree = new Method(accessor, type, identifier, new ArrayList<>() {{
            add(parameter);
        }}, body);
        tree.addAnnotation(annotation);

        tree.accept(visitor, null);

        verify(type, once()).accept(visitor, null);
        verify(identifier, once()).accept(visitor, null);
        verify(parameter, once()).accept(visitor, null);
        verify(body, once()).accept(visitor, null);
        verify(annotation, once()).accept(visitor, null);
    }

    @Test
    public void it_expects_proxy_method_children_to_be_visited() {
        var type = mock(Type.class);
        var identifier = mock(Identifier.class);
        var parameter = mock(Parameter.class);
        var annotation = mock(Annotation.class);

        var tree = new ProxyMethod(type, identifier, new ArrayList<>() {{
            add(parameter);
        }});
        tree.addAnnotation(annotation);

        tree.accept(visitor, null);

        verify(type, once()).accept(visitor, null);
        verify(identifier, once()).accept(visitor, null);
        verify(parameter, once()).accept(visitor, null);
        verify(annotation, once()).accept(visitor, null);
    }

    @Test
    public void it_expects_property_children_to_be_visited() {
        var accessor = Accessor.PUBLIC;
        var type = mock(Type.class);
        var identifier = mock(Identifier.class);
        var defaultValue = mock(Expression.class);
        var annotation = mock(Annotation.class);

        var tree = new Property(accessor, type, identifier, defaultValue);
        tree.addAnnotation(annotation);

        tree.accept(visitor, null);

        verify(type, once()).accept(visitor, null);
        verify(identifier, once()).accept(visitor, null);
        verify(defaultValue, once()).accept(visitor, null);
        verify(annotation, once()).accept(visitor, null);
    }

    @Test
    public void it_expects_proxy_property_children_to_be_visited() {
        var type = mock(Type.class);
        var identifier = mock(Identifier.class);
        var annotation = mock(Annotation.class);

        var tree = new ProxyProperty(type, identifier);
        tree.addAnnotation(annotation);

        tree.accept(visitor, null);

        verify(type, once()).accept(visitor, null);
        verify(identifier, once()).accept(visitor, null);
        verify(annotation, once()).accept(visitor, null);
    }

    @Test
    public void it_expects_body_children_to_be_visited() {
        var statement = mock(Statement.class);

        var tree = new Body(new ArrayList<>() {{
            add(statement);
        }});

        tree.accept(visitor, null);
    }

    @Test
    public void it_expects_parameter_children_to_be_visited() {
        var type = mock(Type.class);
        var identifier = mock(Identifier.class);
        var annotation = mock(Annotation.class);

        var tree = new Parameter(type, identifier);
        tree.addAnnotation(annotation);

        tree.accept(visitor, null);

        verify(type, once()).accept(visitor, null);
        verify(identifier, once()).accept(visitor, null);
        verify(annotation, once()).accept(visitor, null);
    }

    @Test
    public void it_expects_proxy_children_to_be_visited() {
        var phpLabel = mock(PhpLabel.class);
        var service = mock(Service.class);
        var annotation = mock(Annotation.class);

        var tree = new Proxy(phpLabel, service);
        tree.addAnnotation(annotation);

        tree.accept(visitor, null);

        verify(phpLabel, once()).accept(visitor, null);
        verify(service, once()).accept(visitor, null);
        verify(annotation, once()).accept(visitor, null);
    }

    @Test
    public void it_expects_expression_query_children_to_be_visited() {
        var query = mock(Query.class);

        var tree = new ExpressionQuery(query);

        tree.accept(visitor, null);

        verify(query, once()).accept(visitor, null);
    }

    @Test
    public void it_expects_glist_children_to_be_visited() {
        var expression = mock(Expression.class);

        var tree = new GList(new ArrayList<>() {{
            add(expression);
        }});

        tree.accept(visitor, null);

        verify(expression, once()).accept(visitor, null);
    }

    @Test
    public void it_expects_gmap_children_to_be_visited() {
        var key = mock(Expression.class);
        var value = mock(Expression.class);

        var tree = new GMap(new HashMap<>() {{
            put(key, value);
        }});

        tree.accept(visitor, null);

        verify(key, once()).accept(visitor, null);
        verify(value, once()).accept(visitor, null);
    }

    @Test
    public void it_expects_invoke_children_to_be_visited() {
        var prev = mock(Expression.class);
        var identifier = mock(Identifier.class);
        var argument = mock(Expression.class);

        var tree = new Invoke(prev, identifier, new ArrayList<>() {{
            add(argument);
        }});

        tree.accept(visitor, null);

        verify(prev, once()).accept(visitor, null);
        verify(identifier, once()).accept(visitor, null);
        verify(argument, once()).accept(visitor, null);
    }

    @Test
    public void it_expects_new_children_to_be_visited() {
        var identifier = mock(Identifier.class);
        var argument = mock(Expression.class);

        var tree = new New(identifier, new ArrayList<>() {{
            add(argument);
        }});

        tree.accept(visitor, null);

        verify(identifier, once()).accept(visitor, null);
        verify(argument, once()).accept(visitor, null);
    }

    @Test
    public void it_expects_property_access_children_to_be_visited() {
        var prev = mock(Expression.class);
        var identifier = mock(Identifier.class);

        var tree = new PropertyAccess(prev, identifier);

        tree.accept(visitor, null);

        verify(prev, once()).accept(visitor, null);
        verify(identifier, once()).accept(visitor, null);
    }

    @Test
    public void it_expects_ternary_children_to_be_visited() {
        var condition = mock(Expression.class);
        var then = mock(Expression.class);
        var els = mock(Expression.class);

        var tree = new Ternary(condition, then, els);

        tree.accept(visitor, null);

        verify(condition, once()).accept(visitor, null);
        verify(then, once()).accept(visitor, null);
        verify(els, once()).accept(visitor, null);
    }

    @Test
    public void it_expects_type_cast_children_to_be_visited() {
        var type = mock(Type.class);
        var expression = mock(Expression.class);

        var tree = new TypeCast(type, expression);

        tree.accept(visitor, null);

        verify(type, once()).accept(visitor, null);
        verify(expression, once()).accept(visitor, null);
    }

    @Test
    public void it_expects_variable_children_to_be_visited() {
        var identifier = mock(Identifier.class);

        new Variable(identifier).accept(visitor, null);

        verify(identifier, once()).accept(visitor, null);
    }

    @Test
    public void it_expects_binary_expression_children_to_be_visited() {
        var left = mock(Expression.class);
        var right = mock(Expression.class);

        new Concatenation(left, right).accept(visitor, null);

        new Addition(left, right).accept(visitor, null);
        new Division(left, right).accept(visitor, null);
        new Product(left, right).accept(visitor, null);
        new Subtraction(left, right).accept(visitor, null);

        new Conjunction(left, right).accept(visitor, null);
        new Disjunction(left, right).accept(visitor, null);
        new Equal(left, right).accept(visitor, null);
        new GreaterThan(left, right).accept(visitor, null);
        new GreaterThanOrEqual(left, right).accept(visitor, null);
        new LowerThan(left, right).accept(visitor, null);
        new LowerThanOrEqual(left, right).accept(visitor, null);
        new NonEqual(left, right).accept(visitor, null);

        verify(left, times(13)).accept(visitor, null);
        verify(right, times(13)).accept(visitor, null);
    }

    @Test
    public void it_expects_unary_expression_children_to_be_visited() {
        var expression = mock(Expression.class);

        new Bracket(expression).accept(visitor, null);
        new Negative(expression).accept(visitor, null);
        new Positive(expression).accept(visitor, null);
        new Negation(expression).accept(visitor, null);

        verify(expression, times(4)).accept(visitor, null);
    }

    @Test
    public void it_expects_module_children_to_be_visited() {
        var namespace = mock(Namespace.class);
        var imprt = mock(Import.class);
        var declaration = mock(Declaration.class);

        new Module(namespace, new ArrayList<>() {{
            add(imprt);
        }}, new ArrayList<>() {{
            add(declaration);
        }}).accept(visitor, null);

        verify(namespace, once()).accept(visitor, null);
        verify(imprt, once()).accept(visitor, null);
        verify(declaration, once()).accept(visitor, null);
    }

    @Test
    public void it_expects_import_children_to_be_visited() {
        var namespace = mock(Namespace.class);
        var declaration = mock(Identifier.class);
        var alias = mock(Identifier.class);

        new Import(namespace, declaration, alias).accept(visitor, null);

        verify(namespace, once()).accept(visitor, null);
        verify(declaration, once()).accept(visitor, null);
        verify(alias, once()).accept(visitor, null);
    }

    @Test
    public void it_expects_namespace_children_to_be_visited() {
        var name = mock(Identifier.class);

        new Namespace(new ArrayList<>() {{
            add(name);
            add(name);
        }}).accept(visitor, null);

        verify(name, times(2)).accept(visitor, null);
    }

    @Test
    public void it_expects_defined_query_limit_children_to_be_visited() {
        var offset = mock(QueryExpression.class);
        var size = mock(QueryExpression.class);

        new DefinedQueryLimit(offset, size).accept(visitor, null);

        verify(offset, once()).accept(visitor, null);
        verify(size, once()).accept(visitor, null);
    }

    @Test
    public void it_expects_query_order_by_children_to_be_visited() {
        var field1 = mock(QueryOrderByField.class);
        var field2 = mock(QueryOrderByField.class);

        new QueryOrderBy(new ArrayList<>() {{
            add(field1);
            add(field2);
        }}).accept(visitor, null);

        verify(field1, once()).accept(visitor, null);
        verify(field2, once()).accept(visitor, null);
    }

    @Test
    public void it_expects_query_order_by_field_children_to_be_visited() {
        var field = mock(QueryField.class);

        new QueryOrderByField(field, false).accept(visitor, null);

        verify(field, once()).accept(visitor, null);
    }

    @Test
    public void it_expects_query_select_children_to_be_visited() {
        var spec = mock(QuerySpec.class);
        var source = mock(QuerySource.class);
        var expr = mock(QueryExpression.class);
        var orderBy = mock(QueryOrderBy.class);
        var limit = mock(QueryLimit.class);

        new QuerySelect(spec, source, expr, orderBy, limit).accept(visitor, null);

        verify(spec, once()).accept(visitor, null);
        verify(source, once()).accept(visitor, null);
        verify(expr, once()).accept(visitor, null);
        verify(orderBy, once()).accept(visitor, null);
        verify(limit, once()).accept(visitor, null);
    }

    @Test
    public void it_expects_query_source_children_to_be_visited() {
        var identifier = mock(Identifier.class);
        var alias = mock(Identifier.class);

        new QuerySource(identifier, alias).accept(visitor, null);

        verify(identifier, once()).accept(visitor, null);
        verify(alias, once()).accept(visitor, null);
    }

    @Test
    public void it_expects_query_spec_children_to_be_visited() {
        var identifier = mock(Identifier.class);

        new QuerySpec(identifier, false).accept(visitor, null);
        new QuerySpec(identifier, true).accept(visitor, null);

        verify(identifier, twice()).accept(visitor, null);
    }

    @Test
    public void it_expects_query_field_children_to_be_visited() {
        var entity = mock(Identifier.class);
        var property = mock(Identifier.class);

        new QueryField(entity, property).accept(visitor, null);

        verify(entity, once()).accept(visitor, null);
        verify(property, once()).accept(visitor, null);
    }

    @Test
    public void it_expects_query_interpolation_children_to_be_visited() {
        var expression = mock(Expression.class);

        new QueryInterpolation(expression).accept(visitor, null);

        verify(expression, once()).accept(visitor, null);
    }

    @Test
    public void it_expects_binary_query_expression_children_to_be_visited() {
        var left = mock(QueryExpression.class);
        var right = mock(QueryExpression.class);

        new QueryConjunction(left, right).accept(visitor, null);
        new QueryDisjunction(left, right).accept(visitor, null);
        new QueryEqual(left, right).accept(visitor, null);
        new QueryGreaterThan(left, right).accept(visitor, null);
        new QueryGreaterThanOrEqual(left, right).accept(visitor, null);
        new QueryLowerThan(left, right).accept(visitor, null);
        new QueryLowerThanOrEqual(left, right).accept(visitor, null);
        new QueryNonEqual(left, right).accept(visitor, null);

        verify(left, times(8)).accept(visitor, null);
        verify(right, times(8)).accept(visitor, null);
    }

    @Test
    public void it_expects_unary_query_expression_children_to_be_visited() {
        var expression = mock(QueryExpression.class);

        new QueryBracket(expression).accept(visitor, null);
        new QueryIsNotNull(expression).accept(visitor, null);
        new QueryIsNull(expression).accept(visitor, null);

        verify(expression, times(3)).accept(visitor, null);
    }

    @Test
    public void it_expects_assign_children_to_be_visited(@Mock @NotNull VoidVisitor<Void> visitor) {
        var assignable = mock(Assignable.class);
        var operator = AssignOperator.DEFAULT;
        var statement = mock(Statement.class);

        when(visitor.visitAssign(any(), any())).thenCallRealMethod();

        new Assign(assignable, operator, statement).accept(visitor, null);

        verify(assignable, once()).accept(visitor, null);
        verify(statement, once()).accept(visitor, null);
        verify(visitor, once()).visitAssignOperator(any(), any());
    }

    @Test
    public void it_expects_block_children_to_be_visited() {
        var statement = mock(Statement.class);

        new Block(new ArrayList<>() {{
            add(statement);
        }}).accept(visitor, null);

        verify(statement, once()).accept(visitor, null);
    }

    @Test
    public void it_expects_break_children_to_be_visited() {
        var level = mock(IntegerLiteral.class);

        new Break(level).accept(visitor, null);

        verify(level, once()).accept(visitor, null);
    }

    @Test
    public void it_expects_continue_children_to_be_visited() {
        var level = mock(IntegerLiteral.class);

        new Continue(level).accept(visitor, null);

        verify(level, once()).accept(visitor, null);
    }

    @Test
    public void it_expects_declare_children_to_be_visited() {
        var type = mock(Type.class);
        var identifier = mock(Identifier.class);
        var statement = mock(Statement.class);

        new Declare(type, identifier, statement).accept(visitor, null);

        verify(type, once()).accept(visitor, null);
        verify(identifier, once()).accept(visitor, null);
        verify(statement, once()).accept(visitor, null);
    }

    @Test
    public void it_expects_expression_statement_children_to_be_visited() {
        var expression = mock(Expression.class);

        new ExpressionStatement(expression).accept(visitor, null);

        verify(expression, once()).accept(visitor, null);
    }

    @Test
    public void it_expects_flush_children_to_be_visited() {
        var expression = mock(Expression.class);

        new Flush(expression).accept(visitor, null);

        verify(expression, once()).accept(visitor, null);
    }

    @Test
    public void it_expects_persist_children_to_be_visited() {
        var expression = mock(Expression.class);

        new Persist(expression).accept(visitor, null);

        verify(expression, once()).accept(visitor, null);
    }

    @Test
    public void it_expects_remove_children_to_be_visited() {
        var expression = mock(Expression.class);

        new Remove(expression).accept(visitor, null);

        verify(expression, once()).accept(visitor, null);
    }

    @Test
    public void it_expects_return_children_to_be_visited() {
        var expression = mock(Expression.class);

        new Return(expression).accept(visitor, null);

        verify(expression, once()).accept(visitor, null);
    }

    @Test
    public void it_expects_for_each_children_to_be_visited() {
        var array = mock(Expression.class);
        var variable = mock(Identifier.class);
        var condition = mock(Expression.class);
        var body = mock(Statement.class);

        new ForEach(array, variable, new ArrayList<>() {{
            add(condition);
        }}, body).accept(visitor, null);

        verify(array, once()).accept(visitor, null);
        verify(variable, once()).accept(visitor, null);
        verify(condition, once()).accept(visitor, null);
        verify(body, once()).accept(visitor, null);
    }

    @Test
    public void it_expects_for_each_with_key_children_to_be_visited() {
        var array = mock(Expression.class);
        var key = mock(Identifier.class);
        var variable = mock(Identifier.class);
        var condition = mock(Expression.class);
        var body = mock(Statement.class);

        new ForEachWithKey(array, key, variable, new ArrayList<>() {{
            add(condition);
        }}, body).accept(visitor, null);

        verify(array, once()).accept(visitor, null);
        verify(key, once()).accept(visitor, null);
        verify(variable, once()).accept(visitor, null);
        verify(condition, once()).accept(visitor, null);
        verify(body, once()).accept(visitor, null);
    }

    @Test
    public void it_expects_if_statement_children_to_be_visited() {
        var condition = mock(Expression.class);
        var then = mock(Statement.class);
        var els = mock(Statement.class);

        new If(condition, then, els).accept(visitor, null);

        verify(condition, once()).accept(visitor, null);
        verify(then, once()).accept(visitor, null);
        verify(els, once()).accept(visitor, null);
    }

    @Test
    public void it_expects_class_type_children_to_be_visited() {
        var identifier = mock(Identifier.class);

        new ClassType(identifier).accept(visitor, null);

        verify(identifier, once()).accept(visitor, null);
    }

    @Test
    public void it_expects_glist_type_children_to_be_visited() {
        var type = mock(Type.class);

        new GListType(type).accept(visitor, null);

        verify(type, once()).accept(visitor, null);
    }

    @Test
    public void it_expects_gmap_type_children_to_be_visited() {
        var key = mock(Type.class);
        var value = mock(Type.class);

        new GMapType(key, value).accept(visitor, null);

        verify(key, once()).accept(visitor, null);
        verify(value, once()).accept(visitor, null);
    }

    @Test
    public void it_expects_repository_type_children_to_be_visited() {
        var identifier = mock(Identifier.class);

        new RepositoryType(identifier).accept(visitor, null);

        verify(identifier, once()).accept(visitor, null);
    }

    @NotNull
    private VerificationMode once() {
        return times(1);
    }

    @NotNull
    private VerificationMode twice() {
        return times(2);
    }
}