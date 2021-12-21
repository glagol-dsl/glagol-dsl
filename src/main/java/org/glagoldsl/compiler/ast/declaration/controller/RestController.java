package org.glagoldsl.compiler.ast.declaration.controller;

import org.glagoldsl.compiler.ast.declaration.controller.route.Route;
import org.glagoldsl.compiler.ast.declaration.member.Member;

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
}
