package org.glagol.shell;

import io.usethesource.vallang.IInteger;
import io.usethesource.vallang.ISourceLocation;
import io.usethesource.vallang.IValue;
import io.usethesource.vallang.IValueFactory;
import io.usethesource.vallang.io.StandardTextWriter;
import org.rascalmpl.interpreter.Evaluator;
import org.rascalmpl.interpreter.load.IRascalSearchPathContributor;
import org.rascalmpl.shell.ShellEvaluatorFactory;
import org.rascalmpl.shell.ShellRunner;
import org.rascalmpl.values.ValueFactoryFactory;

import java.io.IOException;
import java.io.PrintWriter;
import java.net.URISyntaxException;
import java.util.List;

public class ModuleRunner implements ShellRunner {
    private final Evaluator eval;

    public ModuleRunner(PrintWriter stdout, PrintWriter stderr) {
        eval = ShellEvaluatorFactory.getDefaultEvaluator(stdout, stderr);
        eval.addRascalSearchPathContributor(new IRascalSearchPathContributor() {
            @Override
            public void contributePaths(List<ISourceLocation> list) {
                IValueFactory vf = ValueFactoryFactory.getValueFactory();
                try {
                    list.add(vf.sourceLocation("glagol","",""));
                } catch (URISyntaxException e) {
                    e.printStackTrace();
                }
            }

            @Override
            public String getName() {
                return "glagol";
            }
        });
    }

    @Override
    public void run(String args[]) throws IOException {
        String module = args[0];
        if (module.endsWith(".rsc")) {
            module = module.substring(0, module.length() - 4);
        }
        module = module.replaceAll("/", "::");

        eval.doImport(null, module);
        String[] realArgs = new String[args.length - 1];
        System.arraycopy(args, 1, realArgs, 0, args.length - 1);

        IValue v = eval.main(null, module, "main", realArgs);

        if (v != null && !(v instanceof IInteger)) {
            new StandardTextWriter(true).write(v, eval.getStdOut());
            eval.getStdOut().flush();
        }

        System.exit(v instanceof IInteger ? ((IInteger) v).intValue() : 0);
    }
}
