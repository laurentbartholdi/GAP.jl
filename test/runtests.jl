using GAP
using Base.Test

# write your own tests here
@test 1 == 1

function test()
    eval("0;\n")

    eval("CyclicGroup(2);\n")

    try
        eval("1 + CyclicGroup(2);\n")
    catch y
        println("Got error ",y)
    end

    try
        eval("1/0;\n")
    catch y
        println("Got error ",y)
    end

    eval("a:=NormalSubgroups;\n")
    eval("b:=SymmetricGroup(4);\n")
    eval("a(b);\n")

    eval("SmallGroup(12,3);\n")
    eval("0;\n")

    eval("0;\n")
    eval("1+3;\n")
    eval("[1, 3, 5];\n")

    eval("if 4>3 then\nPrint(\"hi\n\");\n fi;\n")
    eval("0;\n")

    check("rec( a:=0, b:=1, c:=3 );\n",
          "rec( a := 0, b := 1, c := 3 )")

    check("0;\n", 
          "0")

    eval("rec( a=0, b:1, c;3 );\n")
    eval("0;\n")

    eval("rec( a=0, b:1, c;3 );\n")
    check("\"back to normal\";\n", 
          "\"back to normal\"")

    eval("Print(\"Printed Message\");\n")

    rm("tmp_file.txt", force=true)
    eval("Print(\"Printed Message\");\n")
    eval("PrintTo(\"tmp_file.txt\", \"Printed Message\");\n")
    check("StringFile(\"tmp_file.txt\");\n", 
          "Printed Message");  

    try
        eval("1/0;\n")
    catch y
        println("Expected error ",y)
    end
end
