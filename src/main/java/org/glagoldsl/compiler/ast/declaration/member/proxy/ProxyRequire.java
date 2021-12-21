package org.glagoldsl.compiler.ast.declaration.member.proxy;

import org.glagoldsl.compiler.ast.declaration.member.Member;

public class ProxyRequire extends Member {
    final private String pkg;
    final private String version;

    public ProxyRequire(
            String pkg,
            String version
    ) {
        this.pkg = pkg;
        this.version = version;
    }

    public String getPackage() {
        return pkg;
    }

    public String getVersion() {
        return version;
    }
}
