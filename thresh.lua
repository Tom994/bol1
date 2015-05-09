

function Update1()
local version = "1.2"
local author = "Tom94"



local autoupdateenabled = true
local UPDATE_SCRIPT_NAME = "thresh"
local UPDATE_HOST = "raw.github.com"
local UPDATE_PATH = "/Tom994/bol1/master/thresh.lua"
local UPDATE_FILE_PATH = SCRIPT_PATH..GetCurrentEnv().FILE_NAME
local UPDATE_URL = "https://"..UPDATE_HOST..UPDATE_PATH
 
local ServerData
if autoupdateenabled then
        GetAsyncWebResult(UPDATE_HOST, UPDATE_PATH, function(d) ServerData = d end)
        function update()
                if ServerData ~= nil then
                        local ServerVersion
                        local send, tmp, sstart = nil, string.find(ServerData, "local version = \"")
                        if sstart then
                                send, tmp = string.find(ServerData, "\"", sstart+1)
                        end
                        if send then
                                ServerVersion = tonumber(string.sub(ServerData, sstart+1, send-1))
                        end
 
                        if ServerVersion ~= nil and tonumber(ServerVersion) ~= nil and tonumber(ServerVersion) > tonumber(version) then
                                DownloadFile(UPDATE_URL.."?nocache"..myHero.charName..os.clock(), UPDATE_FILE_PATH, function () print("<font color=\"#6699FF\"><b>"..UPDATE_SCRIPT_NAME..":</b> successfully updated. Reload (double F9) Please. ("..version.." => "..ServerVersion..")</font>") end)    
                        elseif ServerVersion then
                                print("<font color=\"#6699FF\"><b>"..UPDATE_SCRIPT_NAME..":</b> You have got the latest version: <u><b>"..ServerVersion.."</b></u></font>")
                        end            
                        ServerData = nil
                end
        end
        AddTickCallback(update)
end
end


if myHero.charName ~= "Thresh" then return end
 
local ts
ts = TargetSelector(TARGET_MOST_AD, 1075, DAMAGE_PHYSHICAL, true)
local Qrange, Qwidth, Qspeed, Qdelay = 1075, 60, 1200, 0.5
local Erange, Ewidth, Espeed, Edelay = 515, 160, math.huge, 0.5
local Rrange, Rwidth, Rspeed, Rdelay = 420, 420, math.huge, 0.3
local VP
local version = "1.2"
local author = "Tom94"
local ignite = nil


 
require "VPrediction"
 
function OnLoad()
  VP = VPrediction()
Config = scriptConfig("Thresh", "Thresh")
Config:addSubMenu("Settings", "keys")
Config.keys:addParam("combo", "Use Q", SCRIPT_PARAM_ONKEYDOWN, false, string.byte (" "))
Config.keys:addParam("pull", "Pull Enemy", SCRIPT_PARAM_ONKEYDOWN, false, string.byte ("H"))
Config.keys:addParam("push", "Push Enemy", SCRIPT_PARAM_ONKEYDOWN, false, string.byte ("T"))
Config.keys:addParam("ulti", "Use Ultimate", SCRIPT_PARAM_ONKEYDOWN,false, string.byte (" "))

Config:addSubMenu("Ultimate Settings", "ultt")
Config.ultt:addParam("autoultx", "Ult if enemys in box", SCRIPT_PARAM_SLICE, 3, 0, 5, 0)


 Config:addSubMenu("DrawCircle", "draw")
 Config.draw:addParam("drawing", "Draw Q Range", SCRIPT_PARAM_ONOFF, true)
 Config.draw:addParam("drawE", "Draw E Range", SCRIPT_PARAM_ONOFF, true)
 Config:addSubMenu("Target Selector", "TS")
 Config.TS:addTS(ts)
 Config:addSubMenu("Ignite", "ignite")
 Config.ignite:addParam("useignite", "Use Ignite", SCRIPT_PARAM_ONOFF, false)
 Config:addParam("info", "Version:", SCRIPT_PARAM_INFO, ""..version.."")
 Config:addParam("info2", "Author:", SCRIPT_PARAM_INFO, ""..author.."")
 
print("<font color='#FF999'> [LeThresh Loaded] <font color='#FF5555'> By Tom94")
print("<font color='#FF5555'>[Tom94]<font color='#FF999'> Hello good luck thanks for using")
print("<font color='#FF5555'>[Tom94]<font color='#FF999'> I hope you land some good hooks! x)")
Update1()
summon()
end
 
 
function OnTick()
        ts:update()
				Ignite()
				Push()
				Pull()
        if Config.keys.combo then
                if myHero:CanUseSpell(_Q) == READY and ValidTarget(ts.target, Qrange) then
                        local CastPosition, HitChance, Position = VP:GetLineCastPosition(ts.target, Qdelay, Qwidth, Qrange, Qspeed, myHero, true)
                        if HitChance >= 2 then
                                CastSpell(_Q, CastPosition.x, CastPosition.z)
                        end
                end
        end
end
 
 
function OnDraw()
if Config.draw.drawing then
if myHero:CanUseSpell(_Q) == READY then
DrawCircle(myHero.x, myHero.y, myHero.z, Qrange, 0x12345) end
if Config.draw.drawE then
if myHero:CanUseSpell(_E) == READY then
DrawCircle(myHero.x, myHero.y, myHero.z, Erange, 0x12345) end
end
end
end


function summon()
      if myHero:GetSpellData(SUMMONER_1).name:find("summonerdot") then
                ignite = SUMMONER_1
                elseif myHero:GetSpellData(SUMMONER_2).name:find("summonerdot") then
                        ignite = SUMMONER_2
                end
 end
 
function Ignite()
local iDmg = (50 + (20 * myHero.level))
        for i, enemy in ipairs(GetEnemyHeroes()) do
                if GetDistance(enemy, myHero) < 600 and ValidTarget(enemy, 600) and Config.ignite.useignite then
                        if myHero:CanUseSpell(ignite) == READY then
                                if enemy.health < iDmg then
                                        CastSpell(ignite, enemy)
                                                                                end
            end
    end
end
end


function Push()
if Config.keys.push then
if ValidTarget(ts.target, Erange) and myHero:CanUseSpell(_E) == READY then
CastSpell(_E, ts.target.x, ts.target.z)
end
end
end


function Pull()
if Config.keys.pull then
if ValidTarget(ts.target, Erange) and myHero:CanUseSpell(_E) == READY then
xPos = myHero.x + (myHero.x - ts.target.x)
zPos = myHero.z + (myHero.z - ts.target.z)
CastSpell(_E, xPos, zPos)
end
end
end
