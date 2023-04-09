package org.glagoldsl.compiler.ast.nodes.declaration.controller;

import org.glagoldsl.compiler.ast.nodes.declaration.DeclarationVisitor;
import org.glagoldsl.compiler.ast.nodes.declaration.controller.route.Route;
import org.glagoldsl.compiler.ast.nodes.declaration.member.Member;
import org.glagoldsl.compiler.ast.nodes.declaration.member.MemberCollection;

import java.util.List;

public class RestController extends Controller {
    final private MemberCollection members;

    public RestController(
            Route route,
            MemberCollection members
    ) {
        super(route);
        this.members = members;
    }

    public MemberCollection getMembers() {
        return members;
    }

    public <T, C> T accept(DeclarationVisitor<T, C> visitor, C context) {
        return visitor.visitRestController(this, context);
    }

    @Override
    public String toString() {
        return "rest controller";
    }
}
