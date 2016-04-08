type FuncObj
    handler::NTuple{8,Ptr{Void}}
    name::Ptr{Void}
    nargs::Int
    nami::Ptr{Cstring}
    prof::Ptr{Void}
    nloc::Ptr{UInt}
    body::Ptr{Void}
    envi::Ptr{Void}
    fexs::Ptr{Void}
end

FuncObj(obj::Obj) = unsafe_load(reinterpret(Ptr{FuncObj},PTR_BAG(obj)))

macro CALL_nARGS(obj,args...)
    nargs = 1+length(args)
    quote
        f = FuncObj($(esc(obj))).handler[$nargs]
        @mark_stack_bottom()
        ccall(f,Obj,$(Expr(:tuple,[Obj for arg in 1:nargs]...)),$(esc(obj)),$([esc(arg) for arg in args]...))
    end
end

# force non-vararg call to macro @CALL_nARGS
CALL_nARGS(obj,a1) = @CALL_nARGS(obj,a1)
CALL_nARGS(obj,a1,a2) = @CALL_nARGS(obj,a1,a2)
CALL_nARGS(obj,a1,a2,a3) = @CALL_nARGS(obj,a1,a2,a3)
CALL_nARGS(obj,a1,a2,a3,a4) = @CALL_nARGS(obj,a1,a2,a3,a4)
CALL_nARGS(obj,a1,a2,a3,a4,a5) = @CALL_nARGS(obj,a1,a2,a3,a4,a5)
CALL_nARGS(obj,a1,a2,a3,a4,a5,a6) = @CALL_nARGS(obj,a1,a2,a3,a4,a5,a6)

function (obj::Obj)(args...)
    newargs = map(Obj,args)
    CALL_nARGS(obj,newargs...)
end
