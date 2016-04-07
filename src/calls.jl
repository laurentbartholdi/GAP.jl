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
        ccall(f.handler[$nargs],Obj,$(Expr(:tuple,[Obj for i in 1:nargs]...)),$(esc(obj)),$(args...))
    end
end

(obj::Obj)(args...) = @CALL_nARGS(obj,map(Obj,args)...)
