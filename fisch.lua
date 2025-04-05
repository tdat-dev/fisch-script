--[[
  Fisch Ultimate Script v1.5.1-RC (Solara Optimized)
  Tác giả: tdat-dev | Cập nhật: 05/04/2025
]]

--#region Khởi tạo phiên bản an toàn
local _G = getfenv()
local Success, Rayfield = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/tdat-dev/fisch-script/main/fisch.lua", true))()
end)

if not Success then
    warn("[Lỗi] Không tải được core script! Nguyên nhân:", Rayfield)
    return
end
--#endregion

--#region Cấu hình tự động
local DefaultSettings = {
    ReelMode = "Auto Reel V3",
    AntiCheatProfile = "GhostV2",
    UIMode = "Compact+",
    HeatReduction = true
}

for k,v in pairs(DefaultSettings) do
    _G[k] = _G[k] or v
end
--#endregion

--#region Hệ thống chống phát hiện nâng cao
local function HumanizedAntiDetect()
    local Randomizer = Random.new(tick())
    spawn(function()
        while task.wait(Randomizer:NextNumber(3,7)) do
            -- Giả lập hành vi người dùng thực
            game:GetService("VirtualInputManager"):SendMouseMoveEvent(
                Randomizer:NextNumber(0,1), 
                Randomizer:NextNumber(0,1),
                game:GetService("Players").LocalPlayer.PlayerGui
            )
            
            -- Tối ưu hiệu năng động
            setfpscap(Randomizer:NextInteger(30,60))
            sethiddenproperty(game.Players.LocalPlayer, "SimulationRadius", 1000)
        end
    end)
end
--#endregion

--#region Logic câu cá thông minh
local function SmartFishing()
    local FishingModule = require(game.ReplicatedStorage.Modules.FishingSystem)
    local Mouse = game:GetService("Players").LocalPlayer:GetMouse()
    
    -- Kiểm tra trạng thái cần câu
    if not _G.AutoEquipRod then
        FishingModule.EquipFishingRod()
    end

    -- Cast bobber với độ trễ ngẫu nhiên
    FishingModule.CastBobber(Mouse.Hit)
    task.wait(math.clamp(3/(_G.NukePower or 1), 0.5, 1.5))
    
    -- Xử lý reel với phân tích thời gian thực
    local Bobber = workspace:FindFirstChild("Bobber")
    if Bobber and Bobber:FindFirstChild("FishOnLine") then
        game:GetService("ReplicatedStorage").RemoteEvents.FishReel:FireServer()
        if _G.AutoDrop then
            task.wait(0.5)
            game:GetService("ReplicatedStorage").RemoteEvents.DropFish:FireServer()
        end
    end
end
--#endregion

--#region Giao diện người dùng tối ưu
local Window = Rayfield:CreateWindow({
    Name = "Fisch v1.5.1 | Solara Edition",
    LoadingTitle = "Đang phân tích môi trường game...",
    LoadingSubtitle = "Hệ thống chống phát hiện đang khởi động",
    ConfigurationSaving = {
        Enabled = true,
        FileName = "Fisch_Solara_Presets",
        Folder = "tdat-dev/configs"
    }
})

local MainTab = Window:CreateTab("Chính", 6026568198)
local AutoFarmToggle = MainTab:CreateToggle({
    Name = "AUTO FARM MASTER",
    CurrentValue = false,
    Callback = function(State)
        _G.MasterSwitch = State
        HumanizedAntiDetect()
        
        -- Luồng xử lý chính với độ ưu tiên
        coroutine.wrap(function()
            while _G.MasterSwitch do
                SmartFishing()
                if _G.AutoShake then
                    game:GetService("RunService").Heartbeat:Wait()
                    game.Players.LocalPlayer.Character:MoveTo(Vector3.new(
                        math.random(-2,2),
                        0,
                        math.random(-2,2)
                    ))
                end
            end
        end)()
    end
})
--#endregion

--#region Hệ thống kích hoạt thông minh
Rayfield:CreateButton({
    Name = "🚀 KÍCH HOẠT THÔNG MINH",
    Callback = function()
        -- Kiểm tra phiên bản trước khi kích hoạt
        if not Rayfield.VersionCheck("1.5.1") then
            Rayfield:Notify({
                Title = "CẢNH BÁO BẢO MẬT",
                Content = "Vui lòng cập nhật phiên bản mới nhất!",
                Duration = 5,
                Image = 6023426915
            })
            return
        end

        -- Kích hoạt hệ thống
        _G.AutoEquipRod = true
        _G.AutoDrop = true
        _G.MasterSwitch = true
        
        -- Tối ưu hóa bộ nhớ
        game:GetService("ScriptContext").ScriptsDisabled = true
        Rayfield:Notify({
            Title = "KÍCH HOẠT THÀNH CÔNG",
            Content = "Chế độ Ghost Mode đang hoạt động",
            Duration = 3
        })
    end
})
--#endregion
