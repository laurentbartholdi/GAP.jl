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

macro CALL_nARGS(args...)
    nargs = length(args)
    quote
        f = FuncObj($(esc(args[1])))
        @mark_stack_bottom()
        ccall(f.handler[$nargs],Obj,$(Expr(:tuple,[Obj for i in 1:nargs]...)),$args...)
    end
end

macro CALL_0ARGS(obj)
    quote
        f = FuncObj($(esc(obj)))
        @mark_stack_bottom()
        ccall(f.handler[1],Obj,(Obj,),$(esc(obj)))
    end
end

macro CALL_1ARGS(obj,a1)
    quote
        f = FuncObj($(esc(obj)))
        @mark_stack_bottom()
        ccall(f.handler[2],Obj,(Obj,Obj),$(esc(obj)),$(esc(a1)))
    end
end

macro CALL_2ARGS(obj,a1,a2)
    quote
        f = FuncObj($(esc(obj)))
        @mark_stack_bottom()
        ccall(f.handler[3],Obj,(Obj,Obj,Obj),$(esc(obj)),$(esc(a1)),$(esc(a2)))
    end
end

(obj::Obj)() = @CALL_0ARGS(obj)
(obj::Obj)(a1::Obj) = @CALL_1ARGS(obj,a1)
(obj::Obj)(a1::Obj,a2::Obj) = @CALL_2ARGS(obj,a1,a2)
