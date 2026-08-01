-- Mounx Loader
-- Protected by Mounx Security Layer v3.2
-- Unauthorized modification will result in ban

local _s,_c,_b,_x,_tc = string,string.char,string.byte,bit32.bxor,table.concat
local _g = game

-- Runtime key derivation
local k={}
k[1]=_c(77)
k[2]=_c(120)
k[3]=_c(56)
k[4]=_c(57)
k[5]=_c(55)
k[6]=_c(55)
k[7]=_c(90)
k[8]=_c(107)
k[9]=_c(55)
k[10]=_c(56)
k[11]=_c(55)
k=_tc(k)

-- Encrypted payload
local e={37,12,76,73,68,13,117,68,90,87,66,35,0,72,88,89,82,54,69,88,86,69,40,22,92,92,69,25,57,4,90,23,86,61,17,23,85,88,86,62,14,69}

-- Decrypt
local d={}
for i=1,#e do
    d[i]=_c(_x(e[i],_b(k,((i-1)%#k)+1)))
end
d=_tc(d)

-- Execute
local f=_g["HttpGet"](_g,d)
if type(f)=="string" and #f>0 then
    local l=(loadstring or load)(f)
    if l then l() end
end
