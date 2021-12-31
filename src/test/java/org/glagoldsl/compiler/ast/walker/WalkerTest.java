package org.glagoldsl.compiler.ast.walker;

import org.glagoldsl.compiler.ast.Builder;
import org.glagoldsl.compiler.ast.nodes.Node;
import org.glagoldsl.compiler.ast.nodes.declaration.member.Accessor;
import org.glagoldsl.compiler.ast.nodes.module.Module;
import org.glagoldsl.compiler.ast.nodes.module.Namespace;
import org.glagoldsl.compiler.ast.nodes.statement.AssignOperator;
import org.junit.jupiter.api.Test;
import org.mockito.junit.jupiter.MockitoExtension;
import org.junit.jupiter.api.extension.ExtendWith;

import java.io.ByteArrayInputStream;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class WalkerTest {
    @Test
    void should_walk_through_every_node() {
        var tree = build("""
                                            // 1
        namespace abc::cde::xyz;            // +4
        import qwe::poi::tyu;               // +6
        import qwe::poi::tyu as xu;         // +6
                                            // =17
        @abc("test")                        // +5
        entity Test {                       // +1
            @anno(123)                      // +5
            public int bla = 123;           // +3
                                            // =31
            @public(true)                   // +5
            Test() {}                       // +2
                                            // =38
            @private(true)                  // +5
            private Test(@ttt Arg a) {}     // +8
                                            // =51
            @method("arg")                  // +5
            public bool expression(         // +3
                @argument(true) string a    // +7
            ) = true;                       // +3
                                            // =69
            @method("arg1", 2)              // +7
            public void expressions(        // +4
                @argument1(true) string a,  // +7
                @argument2(false) string b  // +7
            ) {                             // =94
                SELECT a FROM aa a;         // +(expr_stmt=1, expr_query=1, query=1, query_select=5+1+2)
                                            // =105
                SELECT a FROM aa a          // +(expr_stmt=1, expr_query=1, query=1, query_select=5+1+2+2+1)
                    LIMIT 10;               // =119
                    
                SELECT a FROM aa a          // +(expr_stmt=1, expr_query=1, query=1, query_select=5+1+2)         
                    ORDER BY                // +3
                        a.id ASC,           // +3
                        a.b DESC,           // +3
                        a.c;                // +3
                                            // =142
                
                SELECT a FROM aa a          // +(expr_stmt=1, expr_query=1, query=1, query_select=5+1+2+2+2)
                    LIMIT 10,10;            // =157
                    
                SELECT a[] FROM aa a        // +(expr_stmt=1, expr_query=1, query=1, query_select=5+1+2)
                    WHERE                   // =168
                        true AND false;     // +4
                                            // =172
                    
                SELECT a[] FROM aa a        // +(expr_stmt=1, expr_query=1, query=1, query_select=5+1+2)
                    WHERE                   // =183
                        true OR false;      // +4
                                            // =187
                    
                SELECT a[] FROM aa a        // +(expr_stmt=1, expr_query=1, query=1, query_select=5+1+2)
                    WHERE                   // =198
                        1 > 2;              // +4
                                            // =202
                    
                SELECT a[] FROM aa a        // +(expr_stmt=1, expr_query=1, query=1, query_select=5+1+2)
                    WHERE                   // =213
                        a.a >= 2;           // +5
                                            // =218
                    
                SELECT a[] FROM aa a        // +(expr_stmt=1, expr_query=1, query=1, query_select=5+1+2)
                    WHERE                   // =229
                        a.a = a.b;          // +6
                                            // =235
                    
                SELECT a[] FROM aa a        // +(expr_stmt=1, expr_query=1, query=1, query_select=5+1+2)
                    WHERE                   // =246
                        a.a != a.b;         // +6
                                            // =252
                    
                SELECT a[] FROM aa a        // +(expr_stmt=1, expr_query=1, query=1, query_select=5+1+2)
                    WHERE                   // =263
                        a.a < <<2>>;        // +5
                                            // =268
                    
                SELECT a[] FROM aa a        // +(expr_stmt=1, expr_query=1, query=1, query_select=5+1+2)
                    WHERE                   // =279
                        (a.a <= <<2>>);     // +6
                                            // =285
                    
                SELECT a[] FROM aa a        // +(expr_stmt=1, expr_query=1, query=1, query_select=5+1+2)
                    WHERE                   // =296
                        a.id IS NULL;       // +3
                                            // =299
                    
                SELECT a[] FROM aa a        // +(expr_stmt=1, expr_query=1, query=1, query_select=5+1+2)
                    WHERE                   // =310
                        a.id IS NOT NULL;   // +3
                                            // =313
                [1, 2, 3];                  // +(expr_stmt=1, expr_list=1, nodes=3)
                                            // =318
                {"a": "b"};                 // +(expr_stmt=1, expr_map=1, nodes=2)
                                            // =322
                (true);                     // +3
                "test";                     // +2
                10;                         // +2
                10.50;                      // +2
                false;                      // +2
                var;                        // +3
                new Class(123, "test");     // +(expr_stmt=1, expr_new=1, new=3)
                                            // =341
                test();                     // +(expr_stmt=1, expr_invoke=1, nodes=2)
                test(123);                  // +(expr_stmt=1, expr_invoke=1, nodes=3)
                                            // =350
                this;                       // +2
                this.a;                     // +4
                true ? true : true;         // +5
                +1;                         // +3
                -1;                         // +3
                !true;                      // +3
                                            // =370
                (int) a;                    // +5
                (bool) a;                   // +5
                (string) a;                 // +5
                (float) a;                  // +5
                (void) a;                   // +5
                (Test) a;                   // +6
                (int[]) a;                  // +6
                ({string,bool}) a;          // +7
                (repository<Test>) a;       // +6
                                            // =420
                "abc" ++ "def";             // +4
                12 + 34;                    // +4
                12 - 34;                    // +4
                12 * 34;                    // +4
                12 / 34;                    // +4
                12 > 34;                    // +4
                12 < 34;                    // +4
                12 == 34;                   // +4
                12 != 34;                   // +4
                12 >= 34;                   // +4
                12 <= 34;                   // +4
                12 && 34;                   // +4
                12 || 34;                   // +4
                                            // =472
                {}                          // +1
                if (true) false;            // +5
                if (true) false; else true; // +6
                                            // =484
                var = 123;                  // +5
                this.var = 123;             // +6
                var["123"] = 123;           // +7
                                            // =502
                for (var as v, true)        // +5 
                    return;                 // +2
                                            // =509
                for (var as k:v, true)      // +6
                    return;                 // +2
                                            // =517
                return 123;                 // +2
                return;                     // +2
                flush 123;                  // +2
                flush;                      // +2
                remove 123;                 // +2
                persist 123;                // +2
                break 1;                    // +2
                break;                      // +2
                continue 1;                 // +2
                continue;                   // +2
                                            // =537
                int a = b;                  // +6
                int a;                      // +4
                                            // =547
            }
        }
        
        @ab("test2")                        // +5
        repository<Test> {                  // +1
                                            // =554
            @anno1(21.3)                    // +5
            public string bla2 = "123";     // +3
                                            // =562
        }
        
        @ab("test2")                        // +5
        value Test {                        // +1
                                            // =567
            @anno1(21.3)                    // +5
            public string bla2 = "123";     // +3
                                            // =576
        }
        
        @ab("test2")                        // +5
        service Test {                      // +1
                                            // =581
            @anno1(21.3)                    // +5
            public string bla2 = "123";     // +3
                                            // =589
        }
        
        @ab("test2")                        // +5
        rest controller /path/:var {        // +3
                                            // =597
            index = "test";                 // +6
                                            // =604
            index (string a) = a;           // +10
                                            // =614
            index (string a) when (1) = a;  // +11
                                            // =625
        }
        
        @ab("test2")                        // +5
        proxy \\Php\\Class as               // +1
        service Test {                      // +2
                                            // =632
            @anno2(true)                    // +5
            string bla2;                    // +3
                                            // =640
            @anno2(false)                   // +5
            string bla2(int b);             // +7
                                            // =653
            @anno2(1)                       // +5
            Test(int b);                    // +5
                                            // =662
            @anno2(2)                       // +5
            require "test" "1.0";           // +0
                                            // =667
        }
        """);

        var listener = mock(Listener.class);
        var walker = new Walker(listener) {};
        tree.accept(walker, null);

        verify(listener, times(667)).enter(any(Node.class));
        verify(listener, times(667)).leave(any(Node.class));
        verify(listener, times(11)).enter(any(Accessor.class));
        verify(listener, times(3)).enter(any(AssignOperator.class));
    }

    private Module build(String code) {
        return new Builder().build(new ByteArrayInputStream(code.getBytes()));
    }
}
