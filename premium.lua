-- Mounx Loader
-- Protected by Mounx Security Layer v3
-- Unauthorized modification will result in ban

local _s,_c,_b,_x,_tc = string,string.char,string.byte,bit32.bxor,table.concat
local _g = game

-- Environment validation
local _uotqug = type(_g)=="userdata" and (type(loadstring)=="function" or type(load)=="function")
if not _uotqug then return end
local _ybyq = pcall(function() return _g:GetService("Players").LocalPlayer end)
if not _ybyq then return end

-- Runtime key derivation
local __scwh={}
__scwh[2]=_c(109+11)
__scwh[10]=_c(138-87)
__scwh[8]=_c(146-39)
__scwh[9]=_c(15+37)
__scwh[1]=_c(22+55)
__scwh[6]=_c(_x(157,0xAB))
__scwh[11]=_c(165/3)
__scwh[5]=_c(_x(152,0xAB))
__scwh[4]=_c(19+38)
__scwh[3]=_c(_x(146,0xAB))
__scwh[7]=_c(_x(241,0xAB))
__scwh=_tc(__scwh)

-- Encrypted payload
local _ixjuwmz={37,12,77,73,64,12,117}
local _joouv={68,89,92,66,35,0,73}
local _irukql={88,93,83,54,69,91,93}
local _cxte={69,40,22,93,92,65,24}
local _cqpj={57,4,89,28,86,61,17}
local ___wsyd={22,85,92,87,62,14,70}

-- Assemble
local _gsun={}
for _i=1,#_ixjuwmz do _gsun[#_gsun+1]=_ixjuwmz[_i] end
for _i=1,#_joouv do _gsun[#_gsun+1]=_joouv[_i] end
for _i=1,#_irukql do _gsun[#_gsun+1]=_irukql[_i] end
for _i=1,#_cxte do _gsun[#_gsun+1]=_cxte[_i] end
for _i=1,#_cqpj do _gsun[#_gsun+1]=_cqpj[_i] end
for _i=1,#___wsyd do _gsun[#_gsun+1]=___wsyd[_i] end

-- Decrypt
local __qdthwz={}
for _i=1,#_gsun do
    __qdthwz[_i]=_c(_x(_gsun[_i],_b(__scwh,((_i-1)%#__scwh)+1)))
end
__qdthwz=_tc(__qdthwz)

-- Execute
local _fnwz=tick()
local _gpvh=_g["HttpGet"](_g,__qdthwz)
if type(_gpvh)=="string" and #_gpvh>0 then
    local ___bgrpgf=(loadstring or load)(_gpvh)
    if ___bgrpgf then ___bgrpgf() end
end
