True = @libgapglobal(:libGAP_True,Obj)
False = @libgapglobal(:libGAP_False,Obj)

IS_BOOL(obj::Obj) = TNUM_OBJ(obj) == T_BOOL

convert(::Type{Obj},b::Bool) = unsafe_load(b ? True : False)
convert(::Type{Bool},obj::Obj) = IS_BOOL(obj) ? (obj == unsafe_load(True) ? true : false) : ArgumentError("Not a boolean")
