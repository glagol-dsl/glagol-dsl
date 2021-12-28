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
            Test() {}                       // +1
                                            // =37
            @private(true)                  // +5
            private Test(@ttt Arg a) {}     // +7
                                            // =49
            @method("arg")                  // +5
            public bool expression(         // +2
                @argument(true) string a    // +7
            ) = true;                       // +3
                                            // =66
            @method("arg1", 2)              // +7
            public void expressions(        // +3
                @argument1(true) string a,  // +7
                @argument2(false) string b  // +7
            ) {                             // =90
                SELECT a FROM aa a;         // +(expr_stmt=1, expr_query=1, query=1, query_select=5+1+2)
                                            // =101
                SELECT a FROM aa a          // +(expr_stmt=1, expr_query=1, query=1, query_select=5+1+2+2+1)
                    LIMIT 10;               // =115
                    
                SELECT a FROM aa a          // +(expr_stmt=1, expr_query=1, query=1, query_select=5+1+2)         
                    ORDER BY                // +3
                        a.id ASC,           // +3
                        a.b DESC,           // +3
                        a.c;                // +3
                                            // =138
                
                SELECT a FROM aa a          // +(expr_stmt=1, expr_query=1, query=1, query_select=5+1+2+2+2)
                    LIMIT 10,10;            // =153
                    
                SELECT a[] FROM aa a        // +(expr_stmt=1, expr_query=1, query=1, query_select=5+1+2)
                    WHERE                   // =164
                        true AND false;     // +4
                                            // =168
                    
                SELECT a[] FROM aa a        // +(expr_stmt=1, expr_query=1, query=1, query_select=5+1+2)
                    WHERE                   // =179
                        true OR false;      // +4
                                            // =183
                    
                SELECT a[] FROM aa a        // +(expr_stmt=1, expr_query=1, query=1, query_select=5+1+2)
                    WHERE                   // =194
                        1 > 2;              // +4
                                            // =198
                    
                SELECT a[] FROM aa a        // +(expr_stmt=1, expr_query=1, query=1, query_select=5+1+2)
                    WHERE                   // =209
                        a.a >= 2;           // +5
                                            // =214
                    
                SELECT a[] FROM aa a        // +(expr_stmt=1, expr_query=1, query=1, query_select=5+1+2)
                    WHERE                   // =225
                        a.a = a.b;          // +6
                                            // =231
                    
                SELECT a[] FROM aa a        // +(expr_stmt=1, expr_query=1, query=1, query_select=5+1+2)
                    WHERE                   // =242
                        a.a != a.b;         // +6
                                            // =248
                    
                SELECT a[] FROM aa a        // +(expr_stmt=1, expr_query=1, query=1, query_select=5+1+2)
                    WHERE                   // =259
                        a.a < <<2>>;        // +5
                                            // =264
                    
                SELECT a[] FROM aa a        // +(expr_stmt=1, expr_query=1, query=1, query_select=5+1+2)
                    WHERE                   // =275
                        (a.a <= <<2>>);     // +6
                                            // =281
                    
                SELECT a[] FROM aa a        // +(expr_stmt=1, expr_query=1, query=1, query_select=5+1+2)
                    WHERE                   // =292
                        a.id IS NULL;       // +3
                                            // =295
                    
                SELECT a[] FROM aa a        // +(expr_stmt=1, expr_query=1, query=1, query_select=5+1+2)
                    WHERE                   // =306
                        a.id IS NOT NULL;   // +3
                                            // =309
                [1, 2, 3];                  // +(expr_stmt=1, expr_list=1, nodes=3)
                                            // =314
                {"a": "b"};                 // +(expr_stmt=1, expr_map=1, nodes=2)
                                            // =318
                (true);                     // +3
                "test";                     // +2
                10;                         // +2
                10.50;                      // +2
                false;                      // +2
                var;                        // +3
                new Class(123, "test");     // +(expr_stmt=1, expr_new=1, new=3)
                                            // =337
                test();                     // +(expr_stmt=1, expr_invoke=1, nodes=2)
                test(123);                  // +(expr_stmt=1, expr_invoke=1, nodes=3)
                                            // =346
                this;                       // +2
                this.a;                     // +4
                true ? true : true;         // +5
                +1;                         // +3
                -1;                         // +3
                !true;                      // +3
                                            // =366
                (int) a;                    // +5
                (bool) a;                   // +5
                (string) a;                 // +5
                (float) a;                  // +5
                (void) a;                   // +5
                (Test) a;                   // +6
                (int[]) a;                  // +6
                ({string,bool}) a;          // +7
                (repository<Test>) a;       // +6
                                            // =416
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
                                            // =468
                {}                          // +1
                if (true) false;            // +5
                if (true) false; else true; // +6
                                            // =480
                var = 123;                  // +5
                this.var = 123;             // +6
                var["123"] = 123;           // +7
                                            // =498
                for (var as v, true)        // +5 
                    return;                 // +2
                                            // =505
                for (var as k:v, true)      // +6
                    return;                 // +2
                                            // =513
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
                                            // =533
                int a = b;                  // +6
                int a;                      // +4
                                            // =543
            }
        }
        
        @ab("test2")                        // +5
        repository<Test> {                  // +1
                                            // =550
            @anno1(21.3)                    // +5
            public string bla2 = "123";     // +3
                                            // =558
        }
        
        @ab("test2")                        // +5
        value Test {                        // +1
                                            // =563
            @anno1(21.3)                    // +5
            public string bla2 = "123";     // +3
                                            // =572
        }
        
        @ab("test2")                        // +5
        service Test {                      // +1
                                            // =577
            @anno1(21.3)                    // +5
            public string bla2 = "123";     // +3
                                            // =585
        }
        
        @ab("test2")                        // +5
        rest controller /path/:var {        // +3
                                            // =593
            index = "test";                 // +5
                                            // =599
            index (string a) = a;           // +9
                                            // =608
        }
        
        @ab("test2")                        // +5
        proxy \\Php\\Class as               // +1
        service Test {                      // +2
                                            // =615
            @anno2(true)                    // +5
            string bla2;                    // +3
                                            // =623
            @anno2(false)                   // +5
            string bla2(int b);             // +6
                                            // =635
            @anno2(1)                       // +5
            Test(int b);                    // +4
                                            // =643
            @anno2(2)                       // +5
            require "test" "1.0";           // +0
                                            // =648
        }
        """);

        var listener = mock(Listener.class);
        var walker = new Walker(listener) {};
        tree.accept(walker, null);

        verify(listener, times(648)).enter(any(Node.class));
        verify(listener, times(648)).leave(any(Node.class));
        verify(listener, times(11)).enter(any(Accessor.class));
        verify(listener, times(3)).enter(any(AssignOperator.class));
    }

    private Module build(String code) {
        return new Builder().build(new ByteArrayInputStream(code.getBytes()));
    }
}