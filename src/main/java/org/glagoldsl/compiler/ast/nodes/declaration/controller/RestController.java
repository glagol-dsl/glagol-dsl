package org.glagoldsl.compiler.ast.nodes.declaration.controller;

import org.glagoldsl.compiler.ast.nodes.declaration.DeclarationVisitor;
import org.glagoldsl.compiler.ast.nodes.declaration.controller.route.Route;
import org.glagoldsl.compiler.ast.nodes.declaration.member.Member;

import java.util.List;

public class RestController extends Controller {
    final private List<Member> members;

    public RestController(
            Route route,
            List<Member> members
    ) {
        super(route);
        this.members = members;
    }

    public List<Member> getMembers() {
        return members;
    }

    public <T, C> T accept(DeclarationVisitor<T, C> visitor, C context) {
        return visitor.visitRestController(this, context);
    }
}
