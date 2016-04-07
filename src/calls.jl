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
        f = FuncObj($(esc(obj)))
        @mark_stack_bottom()
        ccall(f.handler[$nargs],Obj,$(Expr(:tuple,[Obj for arg in 1:nargs]...)),$(esc(obj)),$([esc(arg) for arg in args]...))
    end
end

function (obj::Obj)(args...)
    newargs = map(Obj,args)
    @CALL_nARGS(obj,newargs...)
end
