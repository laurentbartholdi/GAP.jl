typealias Bag Obj # should be the other way round

PTR_BAG(b::Bag) = unsafe_load(reinterpret(Ptr{Ptr{UInt}},b))
SIZE_BAG(b::Bag) = unsafe_load(PTR_BAG(b),-1) >> 16
TNUM_BAG(b::Bag) = unsafe_load(PTR_BAG(b),-1) & 0xffff
LINK_BAG(b::Bag) = unsafe_load(PTR_BAG(b),0)

# garbage collection
CHANGED_BAG(b::Bag) = error("todo")
