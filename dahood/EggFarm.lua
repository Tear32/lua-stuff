--yes its open source
local Player = game.Players.LocalPlayer
local Http = game:GetService("HttpService")
local TPS = game:GetService("TeleportService")
local Api = "https://games.roblox.com/v1/games/"

local _place, _id = game.PlaceId, game.JobId

if not game.Loaded then repeat wait(1) until game.Loaded end;

if config.main.safemode then
    if not game.Loaded then repeat wait(1) until game.Loaded end;
    Player.Character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(9999999,9999999,9999999)
    Player.Character:WaitForChild("HumanoidRootPart").Anchored = true
end

local _servers = Api.._place.."/servers/Public?sortOrder=Asc&limit=10"

function ListServers(cursor)
    local Raw = game:HttpGet(_servers .. ((cursor and "&cursor="..cursor) or ""))
    return Http:JSONDecode(Raw)
end

function WebhookRequest(url, embed)
    local http = game:GetService("HttpService")
    local headers = {
        ["Content-Type"] = "application/json"
    }
    local data = {
        ["embeds"] = {
            {
                ["title"] = embed.title,
                ["description"] = embed.description,
                ["color"] = embed.color,
                ["fields"] = embed.fields,
                ["footer"] = {
                    ["text"] = embed.footer.text
                }
            }
        },
        ["username"] = embed.username,
        ["avatar_url"] = embed.url,
    }
    local body = http:JSONEncode(data)
    local response = request({
        Url = url,
        Method = "POST",
        Headers = headers,
        Body = body
    })
end


local function CountEggs()
    local eggCount = 0
    for _, v in pairs(workspace.Ignored:GetChildren()) do
        if string.find(v.Name, "Egg") then
            eggCount = eggCount + 1
        end
    end
    return eggCount
end
local eggCountforwebhook = CountEggs()

local embed = {
    title = "8ho.solutions Egg Farm",
    description = "Server Egg Collection Status:",
    color = 000000, 
    fields = {}, 
    footer = {
        text = os.date("%Y-%m-%d %H:%M:%S")
    },
    username = config.webhook.username,
    url = "https://cdn.discordapp.com/attachments/1041717562272141334/1225099564734877767/money-finance-icon-free-to-pull-the-dollar-sign-creative-removebg-preview.png?ex=661fe5e1&is=660d70e1&hm=3261e1e9d27dce609d0d202625987f4b7ba7bd5a2d47a0c7e995472504d2632f&"
}

if config.webhook.messages.amountofeggs then
    table.insert(embed.fields, {
        name = "Eggs In Server:",
        value = eggCountforwebhook,
        inline = true,
    })
end
if config.webhook.messages.gameid then
    table.insert(embed.fields, {
        name = "Id:",
        value = game.PlaceId,
        inline = true,
    })
end

if config.webhook.messages.server then
    table.insert(embed.fields, {
        name = "Server:",
        value = game.JobId,
        inline = false,
    })
end

if config.webhook.messages.currentaccount then
    table.insert(embed.fields, {
        name = "Account Name:",
        value = game.Players.LocalPlayer.Name,
        inline = true,
    })

    table.insert(embed.fields, {
        name = "Account Display:",
        value = game.Players.LocalPlayer.DisplayName,
        inline = true,
    })
end



local function WaitForCharacterLoad()
    while not Player.Character or not Player.Character:FindFirstChild("FULLY_LOADED_CHAR") do
        wait(1)
    end
end

local function CollectEggs()
    local eggCount = CountEggs()
    if eggCount > 0 then
        if config.webhook.enabled then
            WebhookRequest(config.webhook.webhookUrl, embed)
        end
    end
    print(config.main.logs.EggCountMessage:format(eggCount))
    WaitForCharacterLoad()
    if config.main.safemode then
        Player.Character.HumanoidRootPart.Anchored = false
    end
    for _, v in pairs(workspace.Ignored:GetChildren()) do
        if string.find(v.Name, "Egg") then
            Player.Character.HumanoidRootPart.CFrame = v.CFrame + Vector3.new(0, 3, 0)
            wait(config.main.EggCollectDelay)
        end
    end
    local collectedCount = CountEggs()
    print(config.main.logs.CollectedCountMessage:format(eggCount - collectedCount))
    Player.Character.HumanoidRootPart.Anchored = true
end

local function TeleportToRandomServer()
    local Servers = ListServers()
    local Server = Servers.data[math.random(1, #Servers.data)]
    TPS:TeleportToPlaceInstance(_place, Server.id, Player)
    if Enum.TeleportResult.Unauthorized then
        TPS:TeleportToPlaceInstance(_place, Server.id, Player)
    elseif Enum.TeleportResult.Flooded then
        TPS:TeleportToPlaceInstance(_place, Server.id, Player)
    elseif Enum.TeleportResult.Failure then
        TPS:TeleportToPlaceInstance(_place, Server.id, Player)
    end
end

local serverHopped = true

while true do
    if serverHopped then
        CollectEggs()
        print(config.main.logs.serverhopmessage)
        wait(config.main.Delay)
        TeleportToRandomServer()
        serverHopped = false
    end
    wait(1) 
end
