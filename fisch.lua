-- Script Lua cho game Fisch (Roblox)
-- Tính năng: Auto Fish, Auto Sell, GUI
-- Tác giả: Grok

-- Kiểm tra xem script có chạy trong game Fisch không
if game.PlaceId ~= 16732694052 then -- PlaceId của Fisch
    warn("Script này chỉ hoạt động trong game Fisch!")
    return
end

-- Tải thư viện Lunor Hub để tạo GUI
local Lunor = loadstring(game:HttpGet('https://raw.githubusercontent.com/LunorHub/UI/main/source.lua'))()
local Window = Lunor:CreateWindow({
    Title = "Fisch v1.5.1 | discord.gg/lunor",
    Subtitle = "Free Version",
    Theme = "Dark",
})

-- Khai báo các dịch vụ và biến toàn cục
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local autoFishEnabled = false
local autoSellEnabled = false

-- Hàm tự động câu cá (Auto Fish)
local function autoFish()
    while autoFishEnabled do
        local character = LocalPlayer.Character
        if character then
            -- Tìm công cụ câu cá trong nhân vật
            local tool = character:FindFirstChildOfClass("Tool")
            if tool then
                -- Ném cần câu
                local castEvent = tool:FindFirstChild("events") and tool.events:FindFirstChild("cast")
                if castEvent then
                    castEvent:FireServer(100.5) -- Giá trị lực ném, có thể cần điều chỉnh
                end
                wait(1) -- Đợi 1 giây để cần được ném
                
                -- Rung cần để thu hút cá
                local shakeEvent = tool:FindFirstChild("events") and tool.events:FindFirstChild("shake")
                if shakeEvent then
                    shakeEvent:FireServer()
                end
                wait(2) -- Đợi 2 giây để cá cắn câu
                
                -- Mô phỏng trò chơi mini kéo cá (giả định)
                local reelEvent = game:GetService("ReplicatedStorage"):FindFirstChild("events") and game.ReplicatedStorage.events:FindFirstChild("reelfinished")
                if reelEvent then
                    reelEvent:FireServer()
                end
            end
        end
        wait(5) -- Đợi 5 giây trước khi câu lần tiếp theo
    end
end

-- Hàm tự động bán cá (Auto Sell)
local function autoSell()
    while autoSellEnabled do
        -- Tìm đối tượng thương nhân trong game
        local merchant = workspace:FindFirstChild("Merchant")
        if merchant then
            -- Kích hoạt sự kiện bán cá (giả định)
            local sellEvent = merchant:FindFirstChild("events") and merchant.events:FindFirstChild("sell")
            if sellEvent then
                sellEvent:FireServer()
            end
        end
        wait(10) -- Bán cá mỗi 10 giây
    end
end

-- Tạo tab chính trong GUI
local MainTab = Window:CreateTab("Main")

-- Nút bật/tắt Auto Fish
MainTab:CreateToggle("Auto Fish", false, function(Value)
    autoFishEnabled = Value
    if autoFishEnabled then
        Lunor:Notify("Auto Fish", "Enabled Auto Fish!")
        spawn(autoFish) -- Chạy hàm Auto Fish trong luồng riêng
    else
        Lunor:Notify("Auto Fish", "Disabled Auto Fish!")
    end
end)

-- Nút bật/tắt Auto Sell
MainTab:CreateToggle("Auto Sell", false, function(Value)
    autoSellEnabled = Value
    if autoSellEnabled then
        Lunor:Notify("Auto Sell", "Enabled Auto Sell!")
        spawn(autoSell) -- Chạy hàm Auto Sell trong luồng riêng
    else
        Lunor:Notify("Auto Sell", "Disabled Auto Sell!")
    end
end)

-- Thông báo khi script khởi chạy thành công
Lunor:Notify("Fisch v1.5.1", "Welcome to Fisch Pro Hub!")
