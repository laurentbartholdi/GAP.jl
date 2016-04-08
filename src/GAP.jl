module GAP

if isfile(joinpath(Pkg.dir(string(current_module())),"deps","deps.jl"))
    include("../deps/deps.jl")
else
    error("GAP not properly installed. Please run Pkg.build(\"GAP\")")
end

import Base: convert, promote_rule, +, -, *, /

export @g_str, Obj

const GAP_VERSION = "4.8.3"
const GAP_DIR = joinpath(Pkg.dir(string(current_module())),"deps","usr","share","gap-"*GAP_VERSION)

type GapError <: Exception
    msg::AbstractString
end

Base.showerror(io::IO, e::GapError) = print(io, "\rGAP ", e.msg);

include("libgap.jl")

include("gasman.jl")
include("objects.jl")
include("integer.jl")
include("bool.jl")
include("calls.jl")
include("gvars.jl")
include("finfield.jl")
include("string.jl")
include("commands.jl")

global in_interaction = false

no_error_handler(msg::Cstring) = nothing
function error_handler(msg::Cstring)
    global in_interaction
    if in_interaction
        in_interaction = false
        libgap_finish_interaction()
    end
    throw(GapError(bytestring(msg)))
end

function do_gap_init(memory_pool::Int,memory_start::Int)
    pool_string = string(memory_pool>>20)*"M"
    start_string = string(memory_start>>20)*"M"

    print_with_color(:blue,"LibGAP: using gap library at $GAP_DIR\n",
            "Pool memory=$pool_string, start memory=$start_string\n")
    libgap_set_error_handler(no_error_handler);

    libgap_initialize(["juliagap","-l",GAP_DIR,"-o",pool_string,"-s",pool_string,"-m",start_string,"-q","-T",C_NULL])
    libgap_start_interaction("")
    output_msg = libgap_get_output()
    length(output_msg)>0 && error("libGAP initialization failed: ", output_msg)
    error_msg = libgap_get_error()
    length(error_msg)>0 && error("libGAP initialization failed: ", error_msg)
    libgap_finish_interaction()

    libgap_set_error_handler(error_handler)

    # somehow this bit of black magic seems to prevent a segfault
    libgap_start_interaction("0;;")
    status = ReadEvalCommand(unsafe_load(BottomLVars))    
    libgap_finish_interaction()
end

function __init__()
    try
        ENV["__LIBGAP_INITIALIZED"]
        print_with_color(:blue,"LibGAP already initialized\n")
    catch
        do_gap_init(1<<30,1<<26)
        ENV["__LIBGAP_INITIALIZED"] = true
    end
end

promote_rule(::Type{Obj},::Type{Any}) = Obj
promote_rule(::Type{Any},::Type{Obj}) = Obj

+(a::Obj,b::Obj) = _SUM(a,b)
+(a::Obj,b::Any) = _SUM(a,b)
+(a::Any,b::Obj) = _SUM(a,b)

-(a::Obj,b::Obj) = _DIFF(a,b)
-(a::Obj,b::Any) = _DIFF(a,b)
-(a::Any,b::Obj) = _DIFF(a,b)

*(a::Obj,b::Obj) = _PROD(a,b)
*(a::Obj,b::Any) = _PROD(a,b)
*(a::Any,b::Obj) = _PROD(a,b)

/(a::Obj,b::Obj) = _QUO(a,b)
/(a::Obj,b::Any) = _QUO(a,b)
/(a::Any,b::Obj) = _QUO(a,b)

################################################################

function evaluate(input::AbstractString)
    global in_interaction
    const Symbol = @libgapglobal(:libGAP_Symbol,UInt)

    if length(input)==0 || input[end] != ';'
        input *= ";"
    end
    libgap_start_interaction(input)
    in_interaction = true
    status = ReadEvalCommand(unsafe_load(BottomLVars))

    status == STATUS_END || println("Weird, interpreter not in end state")

    unsafe_load(Symbol) == S_SEMICOLON || println("Weird, no semicolon read")

    GetSymbol()
    unsafe_load(Symbol) == S_EOF || println("Weird, multiple statements executed")

    result = unsafe_load(ReadEvalResult)
    in_interaction = false
    libgap_finish_interaction()

    result == C_NULL ? nothing : result
end

function Base.show(io::IO, x::Obj)
    global in_interaction
    if isinteger(x)
        print(io, "<gap short ",reinterpret(Int,x)>>2,">")
#    elseif isffe(x)
    else
        libgap_start_interaction("")
        in_interaction = true
        ViewObjHandler(x)
        out = libgap_get_output()
        in_interaction = false
        libgap_finish_interaction()
        print(io, "<gap ",strip(out),">")
    end
end

macro g_str(s)
    evaluate(s)
end

end
