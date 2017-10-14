module Transform::OriginAnnotator

import Syntax::Abstract::Glagol;
import Syntax::Abstract::PHP;
import Node;

public &T origin(&T subjectNode, Declaration originNode) = subjectNode[@origin = originNode@src] when (originNode@src?);
public &T origin(&T subjectNode, ControllerType originNode) = subjectNode[@origin = originNode@src] when (originNode@src?);
public &T origin(&T subjectNode, Route originNode) = subjectNode[@origin = originNode@src] when (originNode@src?);
public &T origin(&T subjectNode, AssignOperator originNode) = subjectNode[@origin = originNode@src] when (originNode@src?);
public &T origin(&T subjectNode, Statement originNode) = subjectNode[@origin = originNode@src] when (originNode@src?);
public &T origin(&T subjectNode, Modifier originNode) = subjectNode[@origin = originNode@src] when (originNode@src?);
public &T origin(&T subjectNode, Type originNode) = subjectNode[@origin = originNode@src] when (originNode@src?);
public &T origin(&T subjectNode, Name originNode) = subjectNode[@origin = originNode@src] when (originNode@src?);
public &T origin(&T subjectNode, Symbol originNode) = subjectNode[@origin = originNode@src] when (originNode@src?);
public &T origin(&T subjectNode, Expression originNode) = subjectNode[@origin = originNode@src] when (originNode@src?);
public &T origin(&T subjectNode, Annotation originNode) = subjectNode[@origin = originNode@src] when (originNode@src?);
public &T origin(&T subjectNode, Declaration originNode) = subjectNode[@origin = originNode@src] when (originNode@src?);

public &T origin(&T subjectNode, Declaration originNode, true) = applyDown(subjectNode, originNode@src) when (originNode@src?);
public &T origin(&T subjectNode, ControllerType originNode, true) = applyDown(subjectNode, originNode@src) when (originNode@src?);
public &T origin(&T subjectNode, Route originNode, true) = applyDown(subjectNode, originNode@src) when (originNode@src?);
public &T origin(&T subjectNode, AssignOperator originNode, true) = applyDown(subjectNode, originNode@src) when (originNode@src?);
public &T origin(&T subjectNode, Statement originNode, true) = applyDown(subjectNode, originNode@src) when (originNode@src?);
public &T origin(&T subjectNode, Modifier originNode, true) = applyDown(subjectNode, originNode@src) when (originNode@src?);
public &T origin(&T subjectNode, Type originNode, true) = applyDown(subjectNode, originNode@src) when (originNode@src?);
public &T origin(&T subjectNode, Name originNode, true) = applyDown(subjectNode, originNode@src) when (originNode@src?);
public &T origin(&T subjectNode, Symbol originNode, true) = applyDown(subjectNode, originNode@src) when (originNode@src?);
public &T origin(&T subjectNode, Expression originNode, true) = applyDown(subjectNode, originNode@src) when (originNode@src?);
public &T origin(&T subjectNode, Annotation originNode, true) = applyDown(subjectNode, originNode@src) when (originNode@src?);
public &T origin(&T subjectNode, Declaration originNode, true) = applyDown(subjectNode, originNode@src) when (originNode@src?);

public list[&T] origin(list[&T] subjectNodes, Declaration originNode, true) = applyDown(subjectNodes, originNode@src) when (originNode@src?);
public list[&T] origin(list[&T] subjectNodes, ControllerType originNode, true) = applyDown(subjectNodes, originNode@src) when (originNode@src?);
public list[&T] origin(list[&T] subjectNodes, Route originNode, true) = applyDown(subjectNodes, originNode@src) when (originNode@src?);
public list[&T] origin(list[&T] subjectNodes, AssignOperator originNode, true) = applyDown(subjectNodes, originNode@src) when (originNode@src?);
public list[&T] origin(list[&T] subjectNodes, Statement originNode, true) = applyDown(subjectNodes, originNode@src) when (originNode@src?);
public list[&T] origin(list[&T] subjectNodes, Modifier originNode, true) = applyDown(subjectNodes, originNode@src) when (originNode@src?);
public list[&T] origin(list[&T] subjectNodes, Type originNode, true) = applyDown(subjectNodes, originNode@src) when (originNode@src?);
public list[&T] origin(list[&T] subjectNodes, Name originNode, true) = applyDown(subjectNodes, originNode@src) when (originNode@src?);
public list[&T] origin(list[&T] subjectNodes, Symbol originNode, true) = applyDown(subjectNodes, originNode@src) when (originNode@src?);
public list[&T] origin(list[&T] subjectNodes, Expression originNode, true) = applyDown(subjectNodes, originNode@src) when (originNode@src?);
public list[&T] origin(list[&T] subjectNodes, Annotation originNode, true) = applyDown(subjectNodes, originNode@src) when (originNode@src?);
public list[&T] origin(list[&T] subjectNodes, Declaration originNode, true) = applyDown(subjectNodes, originNode@src) when (originNode@src?);

public default &T origin(&T subjectNode, node originNode) = subjectNode;
public default &T origin(&T subjectNode, node originNode, true) = subjectNode;

private &T applyDown(&T subjectNode, loc src) = top-down visit (subjectNode) {
	case node n => n@origin? ? n : n[@origin=src]
};

private list[&T] applyDown(list[&T] subjectNodes, loc src) = top-down visit (subjectNodes) {
	case node n => n@origin? ? n : n[@origin=src]
};
