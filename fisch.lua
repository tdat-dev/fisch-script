--[[
  Fisch Ultimate Script v1.5.1-RC
  Tương thích Solara/Fluxus
  Auto-Config Enabled
]]

local Rayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/rayfield/main/source"))()
local _ = Rayfield:Notify({Title = "INJECTION SUCCESS", Content = "Lunoria Engine Activated", Duration = 2})

--#region Auto-Configuration Module
getgenv().DefaultSettings = {
    ReelMode = "Auto Reel V2",
    AntiCheatProfile = "Ghost",
    UIMode = "Compact",
    HeatReduction = true
}
--#endregion

--#region Core Functions
local function AntiDetect()
    spawn(function()
        while task.wait(5) do
            game:GetService("Stats").PerformanceStats.Memory:GetValueString()
            setfpscap(math.random(45,60))
        end
    end)
end

local function SmartFishing()
    require(game.ReplicatedStorage.Modules.FishingSystem).CastBobber(game:GetService("Players").LocalPlayer:GetMouse().Hit)
    task.wait(math.clamp(3/_G.NukePower, 0.5, 3))
    game:GetService("ReplicatedStorage").RemoteEvents.FishReel:FireServer()
end
--#endregion

--#region Pre-Built UI System
local Window = Rayfield:CreateWindow({
    Name = "Fisch v1.5.1 | Lunoria Edition",
    LoadingTitle = "Optimizing Game State...",
    ConfigurationSaving = {Enabled = true, FileName = "Fisch_Presets"}
})

local MainTab = Window:CreateTab("Main", 6026568198)
MainTab:CreateToggle({
    Name = "AUTO FARM MASTER",
    CurrentValue = false,
    Callback = function(State)
        getgenv().MasterSwitch = State
        AntiDetect()
        while MasterSwitch do
            SmartFishing()
            if _G.AutoShake then
                game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame *= CFrame.Angles(math.rad(2),0,0)
            end
        end
    end
})
--#endregion

--#region One-Click Execution
Rayfield:CreateButton({
    Name = "🚀 KÍCH HOẠT TOÀN HỆ THỐNG",
    Callback = function()
        getgenv().AutoEquipRod = true
        getgenv().AutoDrop = true
        getgenv().MasterSwitch = true
        Rayfield:Notify({Title = "AUTO FARM ENABLED", Content = "All systems nominal"})
    end
})
--#endregion
