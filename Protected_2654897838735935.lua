--wow, you got the code, ggz
local a = game:GetService("Players")
local b = a.LocalPlayer or a:GetPropertyChangedSignal("LocalPlayer"):Wait()
repeat task.wait() until b and b:IsDescendantOf(a)

local c = loadstring(game:HttpGet("https://github.com/biggaboy212/Maclib/releases/latest/download/maclib.txt"))()
game:GetService("HttpService").HttpEnabled = true

local d = c:Window({
    Title = "CometHub",
    Subtitle = "Free | discord.gg/SVGHg9ChJe",
    Size = UDim2.fromOffset(850, 650),
    DragStyle = 2,
    DisabledWindowControls = {},
    ShowUserInfo = true,
    UserInfo = {
        Username = b.Name,
        UserId = b.UserId
    },
    Keybind = Enum.KeyCode.RightControl,
    AcrylicBlur = true,
})

c:SetFolder("CometHub")

local e = b.Name .. "_config_arx"
local f = d:TabGroup()
local g = "rbxassetid://99275039709063"
local h = "rbxassetid://121700697298748"
local i = "rbxassetid://110807522910450"

local j = f:Tab({ Name = "main", Image = g, Default = true })
local k = f:Tab({ Name = "joiner", Image = h })
local l = f:Tab({ Name = "webhook", Image = i })

local m = k:Section({ Name = "Joiner Options", Side = "Left" })
local n = k:Section({ Name = "Ranger Selector", Side = "Right" })
local o = j:Section({ Name = "Gameplay" })
local p = j:Section({ Name = "Upgrades", Side = "Left"})
local q = j:Section({ Name = "Speed Options", Side = "Right" })
local r = k:Section({ Name = "Portal Joiner", Side = "Left" })
local s = k:Section({ Name = "swarm", Side = "Right" })

local function t(u, v)
    local w = u
    for _, x in ipairs(v) do
        w = w:WaitForChild(x)
    end
    return w
end

local y = game:GetService("ReplicatedStorage")
local z = {}
local aa = nil

local ab, ac = pcall(function()
    aa = y:WaitForChild("Shared"):WaitForChild("Info"):WaitForChild("GameWorld"):WaitForChild("World")
end)

if ab and aa then
    for _, ad in ipairs(aa:GetChildren()) do
        if ad:IsA("ModuleScript") then
            local ae, af = pcall(require, ad)
            if ae and typeof(af) == "table" then
                for ag, ah in pairs(af) do
                    if typeof(ah) == "table" then
                        local ai = ah.Levels
                        if typeof(ai) == "table" then
                            local aj = 0
                            for _, ak in ipairs(ai) do
                                if typeof(ak) == "table" and ak.id and string.find(ak.id, "Chapter") then
                                    aj = aj + 1
                                end
                            end
                            local al = ah.Name or ag
                            if aj >= 1 then
                                table.insert(z, {
                                    module = ad.Name,
                                    worldKey = ag,
                                    worldName = al,
                                    chapters = aj
                                })
                            end
                        end
                    end
                end
            end
        end
    end
end

local am = {}
local an = {}
for _, ao in ipairs(z) do
    table.insert(am, ao.worldName)
    an[ao.worldName] = ao.worldKey
end
if #am == 0 then
    am = { "No stories found" }
end

local ap = nil
local aq = "Normal"
local ar = 1

if #am > 0 and am[1] ~= "No stories found" then
    ap = an[am[1]]
end

local as = {}
for at = 1, 10 do
    table.insert(as, tostring(at))
end

local au = m:Dropdown({
    Name = "Story",
    Search = true,
    Multi = false,
    Required = true,
    Options = am,
    Default = 1,
    Callback = function(av)
        ap = an[av]
        c:SaveConfig(e)
    end,
}, "storyDropdownFlag")

local aw = m:Dropdown({
    Name = "Chapter",
    Search = false,
    Multi = false,
    Required = true,
    Options = as,
    Default = 1,
    Callback = function(av)
        ar = tonumber(av)
        c:SaveConfig(e)
    end,
}, "chapterDropdownFlag")

local ax = k:Section({ Name = "Challenge Options", Side = "Left" })
local ay = {}
local az = {}

for _, ao in ipairs(z) do
    table.insert(ay, ao.worldName)
    az[ao.worldName] = ao.worldKey
end
if #ay == 0 then
    ay = { "No challenges found" }
end

local ba = {}

ax:Dropdown({
    Name = "Challenges",
    Search = true,
    Multi = true,
    Required = false,
    Options = ay,
    Default = {},
    Callback = function(av)
        ba = av
        local bb = {}
        for bc, bd in pairs(ba) do
            if bd then
                table.insert(bb, bc)
            end
        end
        c:SaveConfig(e)
    end,
}, "challengeDropdownFlag")

ax:Toggle({
    Name = "Join Challenge",
    Default = false,
    Callback = function(be)
        if not game.Workspace:FindFirstChild("Lobby") then return end
        if be then
            local bf = 0
            for _, bd in pairs(ba) do
                if bd then
                    bf = bf + 1
                end
            end

            if bf > 0 then
                for bg, bd in pairs(ba) do
                    if bd then
                        local bh = az[bg]
                        if bh and bh ~= "No challenges found" then
                            local bi, bj = pcall(function()
                                local bk = nil
                                local bl, bm = pcall(function()
                                    return y:WaitForChild("Gameplay", 1):WaitForChild("Game", 1):WaitForChild("Challenge", 1):WaitForChild("World", 1)
                                end)

                                if bl and bm and bm:IsA("StringValue") then
                                    bk = bm.Value
                                end

                                if bk and bh == bk then
                                    local bn = y:WaitForChild("Remote"):WaitForChild("Server"):WaitForChild("PlayRoom"):WaitForChild("Event")
                                    if not bn then
                                        error("ERROR: PlayRoom remote event not found!")
                                    end

                                    local bo = {
                                        "Create",
                                        {
                                            CreateChallengeRoom = true
                                        }
                                    }
                                    bn:FireServer(unpack(bo))
                                    bn:FireServer("Start")
                                end
                            end)
                        end
                    end
                end
            end
        end
        c:SaveConfig(e)
    end,
}, "JoinChallengeToggleFlag")

local bp = {}
local bq = {}
local br = nil

do
    local bs, bt = pcall(function()
        local bu = y:WaitForChild("Shared"):WaitForChild("Info"):WaitForChild("Items"):WaitForChild("Portal"):WaitForChild("Temp")
        return require(bu)
    end)

    if bs and type(bt) == "table" then
        bp = bt
        for bv, _ in pairs(bp) do
            table.insert(bq, bv)
        end
        table.sort(bq)
    else
        bq = { "No portals found" }
    end
end

r:Dropdown({
    Name = "Select Portal",
    Search = true,
    Multi = false,
    Required = false,
    Options = bq,
    Default = 1,
    Callback = function(av)
        br = av
        c:SaveConfig(e)
    end,
}, "portalDropdownFlag")

r:Toggle({
    Name = "Join Portal",
    Default = false,
    Callback = function(be)
        if not game.Workspace:FindFirstChild("Lobby") then return end
        if be and br and br ~= "No portals found" then
            local bi, bj = pcall(function()
                local bw = y:WaitForChild("Remote"):WaitForChild("Server"):WaitForChild("OnGame")
                bw:FireServer("Join", {
                    Portal = br,
                    Difficulty = aq
                })
            end)
        end
        c:SaveConfig(e)
    end,
}, "JoinPortalToggleFlag")

local bx = m:Dropdown({
    Name = "Difficulty",
    Search = false,
    Multi = false,
    Required = true,
    Options = { "Nightmare", "Hard", "Normal" },
    Default = 3,
    Callback = function(av)
        aq = av
        c:SaveConfig(e)
    end,
}, "difficultyDropdownFlag")

local by = { "2", "3" }
local bz = "2"
local ca = false

local cb = q:Toggle({
    Name = "Speed",
    Default = false,
    Callback = function(be)
        ca = be
        if ca then
            local bi, bj = pcall(function()
                local cc = game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("SpeedGamepass")
                cc:FireServer(tonumber(bz))
            end)
        end
        c:SaveConfig(e)
    end,
}, "SpeedToggleFlag")

local cd = q:Dropdown({
    Name = "Speed Value",
    Search = false,
    Multi = false,
    Required = true,
    Options = by,
    Default = 1,
    Callback = function(av)
        bz = av
        if ca then
            local bi, bj = pcall(function()
                local cc = game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("SpeedGamepass")
                cc:FireServer(tonumber(bz))
            end)
        end
        c:SaveConfig(e)
    end,
}, "SpeedDropdownFlag")

local ce = {}
local cf = {}
local cg = nil

local ch, ci = pcall(function()
    cg = y:WaitForChild("Shared"):WaitForChild("Info"):WaitForChild("GameWorld"):WaitForChild("Levels")
end)

if ch and cg then
    for _, ad in ipairs(cg:GetChildren()) do
        if ad:IsA("ModuleScript") then
            local ae, cj = pcall(require, ad)
            if ae and typeof(cj) == "table" then
                for ag, ck in pairs(cj) do
                    if typeof(ck) == "table" then
                        local cl = false
                        for cm in pairs(ck) do
                            if string.find(cm:lower(), "ranger") then
                                cl = true
                                break
                            end
                        end

                        if cl then
                            local al = ag
                            local cn = aa:FindFirstChild(ad.Name)
                            if cn then
                                local ae, co = pcall(require, cn)
                                if ae and co[ag] and co[ag].Name then
                                    al = co[ag].Name
                                end
                            end

                            table.insert(ce, al)
                            table.insert(cf, {
                                worldName = al,
                                worldKey = ag,
                                moduleName = ad.Name
                            })
                        end
                    end
                end
            end
        end
    end
end

if #ce == 0 then
    ce = { "No ranger chapters found" }
end

local cp = nil
local cq = nil
local cr = 1
local cs = {}
for at = 1, 3 do table.insert(cs, tostring(at)) end

local ct = n:Dropdown({
    Name = "Ranger World",
    Search = false,
    Multi = false,
    Required = true,
    Options = ce,
    Default = 1,
    Callback = function(av)
        cp = av
        for _, cu in ipairs(cf) do
            if cu.worldName == av then
                cq = cu.worldKey
                break
            end
        end
        c:SaveConfig(e)
    end,
}, "rangerDropdownFlag")

local cv = n:Dropdown({
    Name = "Ranger Stage",
    Search = false,
    Multi = false,
    Required = true,
    Options = cs,
    Default = 1,
    Callback = function(av)
        cr = tonumber(av)
        c:SaveConfig(e)
    end,
}, "rangerStageDropdownFlag")

local cw = k:Section({ Name = "Dungeon Events", Side = "Right" })
local cx = {"Easy", "Hard", "Hell"}
local cy = cx[1]

cw:Dropdown({
    Name = "Dungeon",
    Search = false,
    Multi = false,
    Required = true,
    Options = cx,
    Default = 1,
    Callback = function(av)
        cy = av
        c:SaveConfig(e)
    end,
}, "dungeonDropdownFlag")

cw:Toggle({
    Name = "Join Dungeon",
    Default = false,
    Callback = function(be)
        if not game.Workspace:FindFirstChild("Lobby") then return end
        if be then
            local bi, bj = pcall(function()
                local y = game:GetService("ReplicatedStorage")
                local cz = y.Remote.Server.PlayRoom.Event

                if cz and cz:IsA("RemoteEvent") then
                    cz:FireServer(
                        "Dungeon",
                        {
                            Difficulty = cy
                        }
                    )
                else
                    error("ERROR: PlayRoom RemoteEvent not found or is not a RemoteEvent!")
                end
            end)
        end
        c:SaveConfig(e)
    end,
}, "joinDungeonToggleFlag")

local da = k:Section({ Name = "Rift & Summer Events", Side = "Right" })

da:Toggle({
    Name = "Auto Join Rift",
    Default = false,
    Callback = function(be)
        if not game.Workspace:FindFirstChild("Lobby") then return end
        if be then
            local bi, bj = pcall(function()
                local y = game:GetService("ReplicatedStorage")
                local cz = y.Remote.Server.PlayRoom.Event

                if cz and cz:IsA("RemoteEvent") then
                    cz:FireServer("RiftStorm")
                else
                    error("ERROR: PlayRoom RemoteEvent not found or is not a RemoteEvent!")
                end
            end)
        end
        c:SaveConfig(e)
    end,
}, "autoJoinRiftToggleFlag")

da:Toggle({
    Name = "Join Summer",
    Default = false,
    Callback = function(be)
        if not game.Workspace:FindFirstChild("Lobby") then return end
        if be then
            local bi, bj = pcall(function()
                local y = game:GetService("ReplicatedStorage")
                local cz = y.Remote.Server.PlayRoom.Event

                if cz and cz:IsA("RemoteEvent") then
                    cz:FireServer("Summer-Event")
                else
                    error("ERROR: PlayRoom RemoteEvent not found or is not a RemoteEvent!")
                end
            end)
        end
        c:SaveConfig(e)
    end,
}, "joinSummerToggleFlag")

local db = false

s:Toggle({
    Name = "Auto Join Swarm",
    Default = false,
    Callback = function(be)
        db = be
        c:SaveConfig(e)

        if db then
            task.spawn(function()
                while db do
                    if workspace:FindFirstChild("Lobby") then
                        local ae, bj = pcall(function()
                            local y = game:GetService("ReplicatedStorage")
                            local bo = { "Swarm Event" }
                            y:WaitForChild("Remote")
                                :WaitForChild("Server")
                                :WaitForChild("PlayRoom")
                                :WaitForChild("Event")
                                :FireServer(unpack(bo))
                        end)
                    end
                    task.wait(5)
                end
            end)
        end
    end,
}, "AutoJoinSwarmToggleFlag")

m:Toggle({
    Name = "Join Story",
    Default = false,
    Callback = function(be)
        if not game.Workspace:FindFirstChild("Lobby") then return end
        if be then
            if ap and ap ~= "No stories found" then
                local bi, bj = pcall(function()
                    local dc = y:WaitForChild("Remote"):WaitForChild("Server"):WaitForChild("PlayRoom"):WaitForChild("Event")
                    if not dc then
                        error("ERROR: PlayRoom remote event not found!")
                    end
                    
                    dc:FireServer("Create")
                    dc:FireServer("Change-World", { World = ap })
                    dc:FireServer("Change-Chapter", { Chapter = ap .. "_Chapter" .. ar })
                    dc:FireServer("Change-Difficulty", { Difficulty = aq })
                    dc:FireServer("Submit")
                    dc:FireServer("Start")
                end)
            end
        end
        c:SaveConfig(e)
    end,
}, "JoinToggleFlag")

n:Toggle({
    Name = "Join Ranger",
    Default = false,
    Callback = function(be)
        if not game.Workspace:FindFirstChild("Lobby") then return end
        if be then
            if cq and cq ~= "No ranger chapters found" then
                local bi, bj = pcall(function()
                    local dc = y:WaitForChild("Remote"):WaitForChild("Server"):WaitForChild("PlayRoom"):WaitForChild("Event")
                    if not dc then
                        error("ERROR: PlayRoom remote event not found!")
                    end

                    dc:FireServer("Create")
                    dc:FireServer("Change-Mode", { Mode = "Ranger Stage" })
                    dc:FireServer("Change-World", { World = cq })
                    dc:FireServer("Change-Chapter", { Chapter = cq .. "_RangerStage" .. cr })
                    dc:FireServer("Submit")
                    dc:FireServer("Start")
                end)
            end
        end
        c:SaveConfig(e)
    end,
}, "JoinRangerToggleFlag")

local dd = l:Section({ Name = "Webhook Settings" })
local de = ""

dd:Input({
    Name = "Webhook URL",
    Placeholder = "Paste your webhook URL here",
    Default = "",
    Callback = function(av)
        de = av
        c:SaveConfig(e)
    end,
})

local function df(dg)
    if de == "" then
        return
    end

    local dh = game:GetService("HttpService")
    local di = dh:JSONEncode(dg)
    local dj = request or http_request or (syn and syn.request) or (fluxus and fluxus.request)

    if dj and type(dj) == "function" then
        local bi, dk = pcall(dj, {
            Url = de,
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json"
            },
            Body = di
        })
        if bi then
            return
        end
    end

    if pcall(function()
        if type(game.HttpPost) == "function" then
            local bi, dk = pcall(game.HttpPost, game, de, di, "application/json")
            if bi then
                return true
            end
        end
        return false
    end) then
        return
    end

    local bi, bj = pcall(function()
        dh:PostAsync(de, di, Enum.HttpContentType.ApplicationJson)
    end)
end

local dl = false

do
    local a = game:GetService("Players")
    local y = game:GetService("ReplicatedStorage")
    local b = a.LocalPlayer

    local dm = y:WaitForChild("Player_Data"):WaitForChild(b.Name):WaitForChild("Data")
    local dn = dm:WaitForChild("AutoPlay")

    local function dp()
        if dl and not dn.Value then
            local dq = y:WaitForChild("Remote"):WaitForChild("Server")
                :WaitForChild("Units"):WaitForChild("AutoPlay")
            dq:FireServer()
        end
    end

    dn:GetPropertyChangedSignal("Value"):Connect(function()
        dp()
    end)

    dp()
end

local dr = false
local ds = false
local dt = false

o:Toggle({
    Name = "Auto Play",
    Default = false,
    Callback = function(be)
        dl = be
        if be then
            local bi, bj = pcall(function()
                local dq = y:WaitForChild("Remote"):WaitForChild("Server"):WaitForChild("Units"):WaitForChild("AutoPlay")
                dq:FireServer()
            end)
        end
        c:SaveConfig(e)
    end,
}, "AutoPlayToggleFlag")

o:Toggle({
    Name = "Auto Next",
    Default = false,
    Callback = function(be)
        dr = be
        c:SaveConfig(e)
    end,
}, "AutoNextToggleFlag")

o:Toggle({
    Name = "Auto Start",
    Default = false,
    Callback = function(be)
        dt = be
        if be then
            local bi, bj = pcall(function()
                local bo = {
                    "Auto Vote Start",
                    true
                }
                local du = y:WaitForChild("Remote"):WaitForChild("Server"):WaitForChild("Settings"):WaitForChild("Setting_Event")
                du:FireServer(unpack(bo))
            end)
        end
        c:SaveConfig(e)
    end,
}, "AutoStartToggleFlag")

o:Toggle({
    Name = "Auto Replay",
    Default = false,
    Callback = function(be)
        ds = be
        c:SaveConfig(e)
    end,
}, "AutoReplayToggleFlag")

do
    local a = game:GetService("Players")
    local y = game:GetService("ReplicatedStorage")

    task.spawn(function()
        local bi, dv = pcall(function()
            return a.LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("RewardsUI")
        end)
        if not bi or not dv then return end

        dv:GetPropertyChangedSignal("Enabled"):Connect(function()
            if dv.Enabled and ds then
                task.wait(1)
                local ae, bj = pcall(function()
                    local dw = y:WaitForChild("Remote"):WaitForChild("Server"):WaitForChild("OnGame"):WaitForChild("Voting"):WaitForChild("VoteRetry")
                    if not dw then
                        error("ERROR: VoteRetry remote event not found for Auto Replay!")
                    end
                    dw:FireServer()
                end)
            end
        end)
    end)
end

local dx = table.create(6)
local dy = false

p:Toggle({
    Name = "Auto Upgrade",
    Default = false,
    Callback = function(be)
        dy = be

        if dy then
            task.spawn(function()
                while dy do
                    for at = 1, 6 do
                        local dz = dx[at]
                        local ea = p["Unit " .. at]
                        local eb = 0
                        if ea and typeof(ea.GetValue) == "function" then
                            eb = ea:GetValue()
                        else
                            continue
                        end

                        if dz and dz ~= "Unit " .. at .. " (No Units Found)" and dz ~= "Unit " .. at .. " (Not Found)" and dz ~= "Unit " .. at .. " (Invalid Value)" then
                            local ec, ed = pcall(function()
                                return b:WaitForChild("UnitsFolder", 5):FindFirstChild(dz)
                            end)

                            if ec and ed then
                                local ee = ed:FindFirstChild("Upgrade_Folder")
                                local ef = 0
                                if ee then
                                    local eg = ee:FindFirstChild("Level")
                                    if eg and eg:IsA("NumberValue") then
                                        ef = eg.Value
                                    end
                                end

                                if ef < eb then
                                    if ee then
                                        local eh = ee:FindFirstChild("Upgrade_Cost")
                                        if eh and eh:IsA("NumberValue") then
                                            local ei = eh.Value
                                            local ej = b.PlayerGui:WaitForChild("HUD", 5):WaitForChild("InGame", 5):WaitForChild("Main", 5):WaitForChild("Stats", 5):WaitForChild("Yen", 5):WaitForChild("YenValue", 5)
                                            local ek = 0
                                            if ej and ej:IsA("NumberValue") then
                                                ek = ej.Value
                                            end

                                            if ek >= ei then
                                                local el, em = pcall(function()
                                                    local en = y:WaitForChild("Remote"):WaitForChild("Server"):WaitForChild("Units"):WaitForChild("Upgrade")
                                                    en:FireServer(ed)
                                                end)
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                    task.wait(1)
                end
            end)
        end
        c:SaveConfig(e)
    end,
}, "AutoUpgradeToggleFlag")

for at = 1, 6 do
    local eo = {}
    local ep, eq = pcall(function()
        local er = b:WaitForChild("PlayerGui", 5)
        if not er then return nil end
        local es = er:WaitForChild("UnitsLoadout", 5)
        if not es then return nil end
        local et = es:WaitForChild("Main", 5)
        if not et then return nil end
        local eu = et:WaitForChild("UnitLoadout" .. at, 5)
        if not eu then return nil end
        local ev = eu:WaitForChild("Frame", 5)
        if not ev then return nil end
        local ew = ev:WaitForChild("UnitFrame", 5)
        if not ew then return nil end
        local ex = ew:WaitForChild("Info", 5)
        if not ex then return nil end
        local eq = ex:WaitForChild("Folder", 5)
        if not eq then return nil end
        return eq
    end)

    if ep and eq then
        local ey = eq.Value
        if ey and typeof(ey) == "Instance" then
            table.insert(eo, ey.Name)
        elseif typeof(ey) == "string" and ey ~= "" then
            table.insert(eo, ey)
        else
            if #eq:GetChildren() > 0 then
                for _, ez in ipairs(eq:GetChildren()) do
                    table.insert(eo, ez.Name)
                end
            end
        end
        table.sort(eo)
    end

    if #eo == 0 then
        table.insert(eo, "Unit " .. at .. " (No Units Found)")
    end

    dx[at] = eo[1] or nil

    p:Dropdown({
        Name = "Unit " .. at .. " Selection",
        Search = true,
        Multi = false,
        Required = false,
        Options = eo,
        Default = 1,
        Callback = function(av)
            dx[at] = av
            c:SaveConfig(e)
        end,
    }, "Unit" .. at .. "SelectionDropdown")

    p["Unit " .. at] = p:Slider({
        Name = "Unit " .. at,
        Default = 5,
        Minimum = 0,
        Maximum = 10,
        DisplayMethod = "Value",
        Precision = 0,
        Callback = function(av)
            c:SaveConfig(e)
        end,
    }, "Unit" .. at .. "Slider")
end

local fa = y:WaitForChild("Remote"):WaitForChild("Client"):WaitForChild("UI"):WaitForChild("GameEndedUI")

fa.OnClientEvent:Connect(function(fb, fc, fd)
    local fe = fb
    local ff
    
    if fe == "GameEnded_TextAnimation" then
        ff = fc
    elseif fe == "Rewards - Items" then
        ff = "Victory"
    else
        return
    end

    if fe == "GameEnded_TextAnimation" and dr and ff == "Won" then
        task.wait(5)
        local bi, bj = pcall(function()
            local fg = y:WaitForChild("Remote"):WaitForChild("Server"):WaitForChild("VoteNext")
            fg:FireServer(true)
        end)
    end

    if fe == "GameEnded_TextAnimation" and ds and (ff == "Won" or ff == "Defeat") then
        task.wait(5)
        local bi, bj = pcall(function()
            local dw = y:WaitForChild("Remote"):WaitForChild("Server"):WaitForChild("OnGame"):WaitForChild("Voting"):WaitForChild("VoteRetry")
            if not dw then
                error("ERROR: VoteRetry remote event not found for Auto Replay!")
            end
            dw:FireServer()
        end)
    end

    if fe == "Rewards - Items" then
        local fh = "Unknown Map"
        local fi = "Unknown Time"
        local fj = b.Name
        local fk = ff

        local fl, fm = pcall(function()
            return b.PlayerGui:WaitForChild("RewardsUI", 5):WaitForChild("Main", 5):WaitForChild("LeftSide", 5):WaitForChild("World", 5)
        end)
        if fl and fm and fm:IsA("TextLabel") then
            fh = fm.Text
        end

        local fn, fo = pcall(function()
            return b.PlayerGui:WaitForChild("RewardsUI", 5):WaitForChild("Main", 5):WaitForChild("LeftSide", 5):WaitForChild("TotalTime", 5)
        end)
        if fn and fo and fo:IsA("TextLabel") then
            fi = fo.Text
        end

        local fp = ""
        local fq, fr = pcall(function()
            return b:WaitForChild("RewardsShow", 5)
        end)

        if fq and fr and typeof(fr) == "Instance" then
            for _, fs in ipairs(fr:GetChildren()) do
                if fs:IsA("Folder") then
                    local ft = fs.Name
                    local fu = fs:FindFirstChild("Amount")
                    if fu and (fu:IsA("NumberValue") or fu:IsA("IntValue")) then
                        fp = fp .. "+ " .. tostring(fu.Value) .. " " .. ft .. "\n"
                    else
                        fp = fp .. "+ N/A " .. ft .. " (Amount not found in folder)\n"
                    end
                end
            end
        else
            fp = "Rewards data structure (RewardsShow) unexpected or not found."
        end
        
        if fp == "" then
            fp = "No specific rewards listed."
        end

        local fv = string.format(
            "Name: ||%s||\n\n**Result**\n%s - %s\n- **Time**: %s\n- **Reward**:\n%s",
            fj,
            fh,
            fk,
            fi,
            fp
        )

        local fw = os.date("!%Y-%m-%d %H:%M:%S UTC")
        local fx = 0xCCCCFF 

        local fy = {
            title = "Anime RangerX",
            description = fv,
            footer = {
                text = "discord.gg/SVGHg9ChJe • " .. fw
            },
            color = fx
        }

        local fz = {
            embeds = { fy }
        }
        
        df(fz)
    end
end)

local ga = j:Section({ Name = "Auto Open Chest", Side = "Right" })
local gb = "Gold"
local gc = false

local gd = {"Gold", "Platinum", "Silver", "Wooden"}
local ge = {
    Gold = "GoldChests",
    Platinum = "PlatinumChests",
    Silver = "SilverChests",
    Wooden = "WoodenChests"
}

ga:Dropdown({
    Name = "Chest Type",
    Search = false,
    Multi = false,
    Required = true,
    Options = gd,
    Default = 1,
    Callback = function(av)
        gb = av
        c:SaveConfig(e)
    end,
}, "AutoOpenChestTypeDropdown")

ga:Toggle({
    Name = "Auto Open Chest",
    Default = false,
    Callback = function(be)
        gc = be

        if gc then
            task.spawn(function()
                while gc do
                    local gf = ge[gb]
                    if gf then
                        local gg, gh = pcall(function()
                            return y:WaitForChild("Remote", 5):WaitForChild("Server", 5):WaitForChild("Lobby", 5):WaitForChild("ItemUse", 5)
                        end)

                        if gg and gh and gh:IsA("RemoteEvent") then
                            local gi, gj = pcall(function()
                                return y:WaitForChild("Items", 5):FindFirstChild(gf)
                            end)

                            if gi and gj and gj:IsA("Folder") then
                                local gk, gl = pcall(function()
                                    gh:FireServer(
                                        gj,
                                        {
                                            SummonAmount = 1
                                        }
                                    )
                                end)
                            end
                        end
                    end
                    task.wait(5)
                end
            end)
        end
        c:SaveConfig(e)
    end,
}, "AutoOpenChestToggle")

o:Toggle({
    Name = "FPS Boost",
    Default = false,
    Callback = function(be)
        if be then
            local gm = game:GetService("Workspace")
            local gn = gm:FindFirstChildOfClass("Terrain")
            local go = Color3.fromRGB(128,128,128)
            local gp = Enum.Material.SmoothPlastic

            for _, gq in ipairs(gm:GetDescendants()) do
                if gq:IsA("SurfaceAppearance") then
                    pcall(function() gq:Destroy() end)
                end
            end

            for _, gr in ipairs(gm:GetDescendants()) do
                if gr:IsA("BasePart") then
                    pcall(function()
                        gr.Color = go
                        gr.Material = gp
                        gr.Reflectance = 0
                        gr.Transparency = 0
                    end)
                    if gr:IsA("MeshPart") then
                        pcall(function()
                            gr.TextureID = ""
                            gr.NormalMap = ""
                            gr.ColorMap = ""
                        end)
                    end
                elseif gr:IsA("Decal") or gr:IsA("Texture") then
                    pcall(function() gr.Transparency = 1 end)
                elseif gr:IsA("ParticleEmitter") or gr:IsA("Trail") then
                    pcall(function() gr.Enabled = false end)
                end
            end

            if gn then
                local gs = {
                    Enum.Material.Grass, Enum.Material.Rock, Enum.Material.Sand, Enum.Material.Mud,
                    Enum.Material.Dirt, Enum.Material.Snow, Enum.Material.Slate, Enum.Material.Ground,
                    Enum.Material.Concrete, Enum.Material.Metal, Enum.Material.Sandstone
                }
                for _, gt in ipairs(gs) do
                    pcall(function()
                        gn:SetMaterialColor(gt, go)
                    end)
                end
                gn:FillBlock(CFrame.new(0, -1000, 0), Vector3.new(1, 1, 1), Enum.Material.Air)
            end

            local gu = gm:FindFirstChild("Agent")
            if gu then
                pcall(function() gu:Destroy() end)
            end
        end
        c:SaveConfig(e)
    end,
}, "FPSBoostToggle")

local gv = nil

o:Toggle({
    Name = "Black Screen",
    Default = false,
    Callback = function(be)
        local gw = game:GetService("CoreGui")
        if be then
            if not gv then
                gv = Instance.new("ScreenGui")
                gv.Name = "FullBlackScreenGui"
                gv.ResetOnSpawn = false
                gv.IgnoreGuiInset = true
                gv.Parent = gw

                local gx = Instance.new("Frame")
                gx.Size = UDim2.new(1, 0, 1, 0)
                gx.BackgroundColor3 = Color3.new(0, 0, 0)
                gx.BorderSizePixel = 0
                gx.Parent = gv
            end
        else
            if gv then
                pcall(function() gv:Destroy() end)
                gv = nil
            end
        end
        c:SaveConfig(e)
    end,
}, "BlackScreenToggle")

local gz = j:Section({ Name = "Swamp Event", Side = "Right" })
local gA = false

gz:Toggle({
    Name = "20seconds swamp event",
    Default = false,
    Callback = function(be)
        gA = be
        c:SaveConfig(e)

        if gA then
            task.spawn(function()
                local Players = game:GetService("Players")
                local ReplicatedStorage = game:GetService("ReplicatedStorage")

                local player = Players.LocalPlayer

                -- Path to the wave number label
                local waveLabel = player:WaitForChild("PlayerGui")
                    :WaitForChild("HUD")
                    :WaitForChild("InGame")
                    :WaitForChild("Main")
                    :WaitForChild("TOP")
                    :WaitForChild("List")
                    :WaitForChild("Waves")
                    :WaitForChild("Numbers")

                -- Path to the RestartMatch remote
                local restartMatchRemote = ReplicatedStorage
                    :WaitForChild("Remote")
                    :WaitForChild("Server")
                    :WaitForChild("OnGame")
                    :WaitForChild("RestartMatch")

                local hasFiredThisWave = false

                while gA do
                    task.wait(0.5) -- check twice per second

                    local waveText = waveLabel.Text

                    if waveText == "2/2" then
                        if not hasFiredThisWave then
                            hasFiredThisWave = true
                            restartMatchRemote:FireServer()
                        end
                    else
                        hasFiredThisWave = false
                    end
                end
            end)
        end
    end,
}, "SwampEventToggleFlag")


local gy = {
    UIBlurToggle = d:GlobalSetting({
        Name = "UI Blur",
        Default = d:GetAcrylicBlurState(),
        Callback = function(gz)
            d:SetAcrylicBlurState(gz)
            d:Notify({
                Title = d.Settings.Title,
                Description = (gz and "Enabled" or "Disabled") .. " UI Blur",
                Lifetime = 5
            })
            c:SaveConfig(e)
        end,
    }),
    NotificationToggler = d:GlobalSetting({
        Name = "Notifications",
        Default = d:GetNotificationsState(),
        Callback = function(gz)
            d:SetNotificationsState(gz)
            d:Notify({
                Title = d.Settings.Title,
                Description = (gz and "Enabled" or "Disabled") .. " Notifications",
                Lifetime = 5
            })
            c:SaveConfig(e)
        end,
    }),
    ShowUserInfo = d:GlobalSetting({
        Name = "Show User Info",
        Default = d:GetUserInfoState(),
        Callback = function(gz)
            d:SetUserInfoState(gz)
            d:Notify({
                Title = d.Settings.Title,
                Description = (gz and "Enabled" or "Disabled") .. " User Info",
                Lifetime = 5
            })
            c:SaveConfig(e)
        end,
    }),
}

c:LoadConfig(e)
c:SaveConfig(e)
j:Select()

