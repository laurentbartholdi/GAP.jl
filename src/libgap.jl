# the interface between C and gap

bitstype WORD_SIZE Obj

const STATUS_END = 0
const S_SEMICOLON = UInt(1)<<30
const S_EOF = UInt(1)<<31

macro libgapglobal(name,vartype=Obj)
    :(cglobal(($name,libgap),$vartype))
end

CharFF = @libgapglobal(:libGAP_CharFF)
DegrFF = @libgapglobal(:libGAP_DegrFF)
BottomLVars = @libgapglobal(:libGAP_BottomLVars)
ReadEvalResult = @libgapglobal(:libGAP_ReadEvalResult)
StackBottomBags = @libgapglobal(:libGAP_StackBottomBags,Ptr{Void})

macro mark_stack_bottom()
    :(unsafe_store!(StackBottomBags, Base.llvmcall(("""
        declare i8 *@llvm.frameaddress(i32)
    """, """
        %1 = call i8 *@llvm.frameaddress(i32 0)
        ret i8 *%1
    """), Ptr{Void}, Tuple{})))
end

macro libgapcall(name,returntype,argtype,args...)
    :(@mark_stack_bottom();
      ccall(($name,libgap),$returntype,$argtype,$(args...)))
end

libgap_initialize(argv) = @libgapcall(:libgap_initialize,Void,(Int32,Ptr{Ptr{UInt8}}),length(argv)-1,argv)
libgap_set_error_handler(callback) = @libgapcall(:libgap_set_error_handler,Void,(Ptr{Void},),cfunction(callback,Void,(Cstring,)))
libgap_set_gasman_callback(callback) = @libgapcall(:libgap_set_gasman_callback,Void,(Ptr{Void},),cfunction(callback))
libgap_call_error_handler() = @libgapcall(:libgap_call_error_handler,Void,())
libgap_call_gasman_callback() = @libgapcall(:libgap_call_gasman_callback,Void,())
libgap_start_interaction(inputline) = @libgapcall(:libgap_start_interaction,Void,(Cstring,),inputline)
libgap_set_input(line) = @libgapcall(:libgap_set_input,Void,(Cstring,),line)
libgap_get_output() = bytestring(@libgapcall(:libgap_get_output,Cstring,()))
libgap_finish_interaction() = @libgapcall(:libgap_finish_interaction,Void,())

# libgap_internals.h
libgap_get_input(line) = bytestring(@libgapcall(:libgap_get_input,Cstring,(Cstring,UInt32),line,length(line)))
libgap_get_error() = bytestring(@libgapcall(:libgap_get_error,Cstring,()))
libgap_append_stdout(ch) = @libgapcall(:libgap_append_stdout,Void,(UInt8,),ch)
libgap_append_stderr(ch) = @libgapcall(:libgap_append_stderr,Void,(UInt8,),ch)
libgap_set_error(msg) = @libgapcall(:libgap_set_error,Void,(Cstring,),msg)
