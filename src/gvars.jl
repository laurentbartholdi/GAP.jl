NameGVar(gvar::UInt) = bytestring(@libgapcall(:libGAP_NameGVar,Cstring,(UInt,),gvar))
NameGVarObj(gvar::UInt) = @libgapcall(:libGAP_NameGVarObj,Obj,(UInt,),gvar)
GVarName(name::AbstractString) = @libgapcall(:libGAP_GVarName,UInt,(Cstring,),name)
AssGVar(gvar::UInt,val::Obj) = @libgapcall(:libGAP_AssGVar,Void,(UInt,Obj),gvar,val)
function ValAutoGVar(gvar::UInt)
    val = @libgapcall(:libGAP_ValAutoGVar,Obj,(UInt,),gvar)
    val == C_NULL && error("Variable $gvar is not bound")
    val
end
CountGVars = @libgapglobal(:libGAP_CountGVars,Int)
