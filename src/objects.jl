IS_INTOBJ(obj::Obj) = reinterpret(UInt64,obj) & 0x1 != 0
IS_FFE(obj::Obj) = reinterpret(UInt64,obj) & 0x2 != 0

const OBJ_NULL = reinterpret(Obj,C_NULL)

const FIRST_CONSTANT_TNUM     = UInt(0)
const T_INT                   = (FIRST_CONSTANT_TNUM+ 0)    # immediate
const T_INTPOS                = (FIRST_CONSTANT_TNUM+ 1)
const T_INTNEG                = (FIRST_CONSTANT_TNUM+ 2)
const T_RAT                   = (FIRST_CONSTANT_TNUM+ 3)
const T_CYC                   = (FIRST_CONSTANT_TNUM+ 4)
const T_FFE                   = (FIRST_CONSTANT_TNUM+ 5)    # immediate
const T_PERM2                 = (FIRST_CONSTANT_TNUM+ 6)
const T_PERM4                 = (FIRST_CONSTANT_TNUM+ 7)
const T_BOOL                  = (FIRST_CONSTANT_TNUM+ 8)
const T_CHAR                  = (FIRST_CONSTANT_TNUM+ 9)
const T_FUNCTION              = (FIRST_CONSTANT_TNUM+10)
const T_FLAGS                 = (FIRST_CONSTANT_TNUM+11)
const T_MACFLOAT              = (FIRST_CONSTANT_TNUM+12)
const T_LVARS                 = (FIRST_CONSTANT_TNUM+13)
const T_SINGULAR              = (FIRST_CONSTANT_TNUM+14)
const T_POLYMAKE              = (FIRST_CONSTANT_TNUM+15)
const T_TRANS2                = (FIRST_CONSTANT_TNUM+16)
const T_TRANS4                = (FIRST_CONSTANT_TNUM+17)
const T_PPERM2                = (FIRST_CONSTANT_TNUM+18)
const T_PPERM4                = (FIRST_CONSTANT_TNUM+19)
const T_SPARE1                = (FIRST_CONSTANT_TNUM+20)
const T_SPARE2                = (FIRST_CONSTANT_TNUM+21)
const T_SPARE3                = (FIRST_CONSTANT_TNUM+22)
const T_SPARE4                = (FIRST_CONSTANT_TNUM+23)
const LAST_CONSTANT_TNUM      = (T_SPARE4)

const IMMUTABLE               = 1
const FIRST_IMM_MUT_TNUM      = (LAST_CONSTANT_TNUM+1)    # Should be even
const FIRST_RECORD_TNUM       = FIRST_IMM_MUT_TNUM
const T_PREC                  = (FIRST_RECORD_TNUM+ 0)
const LAST_RECORD_TNUM        = (T_PREC+IMMUTABLE)

const FIRST_LIST_TNUM         = (LAST_RECORD_TNUM+1)
const FIRST_PLIST_TNUM        = FIRST_LIST_TNUM
const T_PLIST                 = (FIRST_LIST_TNUM+ 0)
const T_PLIST_NDENSE          = (FIRST_LIST_TNUM+ 2)
const T_PLIST_DENSE           = (FIRST_LIST_TNUM+ 4)
const T_PLIST_DENSE_NHOM      = (FIRST_LIST_TNUM+ 6)
const T_PLIST_DENSE_NHOM_SSORT = (FIRST_LIST_TNUM+8 )
const T_PLIST_DENSE_NHOM_NSORT = (FIRST_LIST_TNUM+10)
const T_PLIST_EMPTY           = (FIRST_LIST_TNUM+12)
const T_PLIST_HOM             = (FIRST_LIST_TNUM+14)
const T_PLIST_HOM_NSORT       = (FIRST_LIST_TNUM+16)
const T_PLIST_HOM_SSORT       = (FIRST_LIST_TNUM+18)
const T_PLIST_TAB             = (FIRST_LIST_TNUM+20)
const T_PLIST_TAB_NSORT       = (FIRST_LIST_TNUM+22)
const T_PLIST_TAB_SSORT       = (FIRST_LIST_TNUM+24)
const T_PLIST_TAB_RECT             = (FIRST_LIST_TNUM+26)
const T_PLIST_TAB_RECT_NSORT       = (FIRST_LIST_TNUM+28)
const T_PLIST_TAB_RECT_SSORT       = (FIRST_LIST_TNUM+30)
const T_PLIST_CYC             = (FIRST_LIST_TNUM+32)
const T_PLIST_CYC_NSORT       = (FIRST_LIST_TNUM+34)
const T_PLIST_CYC_SSORT       = (FIRST_LIST_TNUM+36)
const T_PLIST_FFE             = (FIRST_LIST_TNUM+38)
const LAST_PLIST_TNUM         = (T_PLIST_FFE+IMMUTABLE)
const T_RANGE_NSORT           = (FIRST_LIST_TNUM+40)
const T_RANGE_SSORT           = (FIRST_LIST_TNUM+42)
const T_BLIST                 = (FIRST_LIST_TNUM+44)
const T_BLIST_NSORT           = (FIRST_LIST_TNUM+46)
const T_BLIST_SSORT           = (FIRST_LIST_TNUM+48)
const T_STRING                = (FIRST_LIST_TNUM+50)
const T_STRING_NSORT          = (FIRST_LIST_TNUM+52)
const T_STRING_SSORT          = (FIRST_LIST_TNUM+54)
const LAST_LIST_TNUM          = (T_STRING_SSORT+IMMUTABLE)
const LAST_IMM_MUT_TNUM       = LAST_LIST_TNUM
# ...
const T_BODY                  = 254

TNUM_OBJ(obj::Obj) = IS_INTOBJ(obj) ? T_INT : IS_FFE(obj) ? T_FFE : TNUM_BAG(obj)
