INT_INTOBJ(obj::Obj) = reinterpret(Int,obj)>>2
INTOBJ_INT(obj::Int) = reinterpret(Obj,(obj<<2)|0x1)

isinteger(obj::Obj) = IS_INTOBJ(obj)

convert(::Type{Obj},n::Int) = INTOBJ_INT(n)
convert(::Type{Int},obj::Obj) = IS_INTOBJ(obj) ? INT_INTOBJ(obj) : ArgumentError("Not a short integer object")

HexStringInt(obj::Obj) = @libgapcall(:libGAP_FuncHexStringInt,Obj,(Obj,Obj),OBJ_NULL,obj)
IntHexString(obj::Obj) = @libgapcall(:libGAP_FuncIntHexString,Obj,(Obj,Obj),OBJ_NULL,obj)

convert(::Type{BigInt},obj::Obj) = TNUM_OBJ(obj)≤T_INTNEG ? parse(BigInt,bytestring(CSTR_STRING(HexStringInt(obj))),16) : ArgumentError("Not an integer object")
convert(::Type{Obj},n::BigInt) = IntHexString(C_NEW_STRING(base(16,n)))
