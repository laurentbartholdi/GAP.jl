type StringObj
    length::Int
    bytes::Array{UInt8,1}
end

IsStringFuncs = @libgapglobal(:libGAP_IsStringFuncs,Ptr{Void})
IS_STRING(obj::Obj) = ccall(unsafe_load(IsStringFuncs,1+TNUM_OBJ(obj)),Bool,(GAP.Obj,),obj)
GET_LEN_STRING(obj::Obj) = Int(unsafe_load(PTR_BAG(obj)))
CSTR_STRING(obj::Obj) = reinterpret(Cstring,PTR_BAG(obj)+sizeof(Int))

NEW_STRING(len::Int) = @libgapcall(:libGAP_NEW_STRING,Obj,(UInt,),len)
function C_NEW_STRING(str::ASCIIString)
    len = length(str)
    obj = NEW_STRING(len)
    unsafe_copy!(reinterpret(Ptr{UInt8},CSTR_STRING(obj)),pointer(str.data),len)
    obj
end

convert(::Type{AbstractString},obj::Obj) = IS_STRING(obj) ? bytestring(CSTR_STRING(obj)) : ArgumentError("not a string")

convert(::Type{Obj},str::AbstractString) = C_NEW_STRING(str)
