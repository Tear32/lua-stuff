getgenv().config = {
    main = {
        enabled = true, -- enables / disables farm
        safemode = false, --teleports u in the air

        delays = {
            Delay = 5, --rejoin delay
            EggCollectDelay = 0.1,  --delay between teleporting to eggs
            RetryDelay = 5, --if rejoin fails it retries after ... seconds
        },
    
        logs = { 
            characterloading = "Waiting for character to load...",--this prints to the console
            charloaded = "Character has been loaded.",--this prints to the console
            EggCountMessage = "Eggs in server: %d", --this prints to the console
            CollectedCountMessage = "Collected eggs: %d", --this prints to the console
            serverhopmessage = "Collected all eggs in the server!, hopping now."--this prints to the console
        },
    },



    webhook = {
        enabled = true, --if enabled and theres an egg in your server it sends an embed
        username = "money man", --username of the webhook
        webhookUrl = "", --webhook url

        messages = {
            amountofeggs = true, --shows how many eggs are in the server
            gameid = false,  --shows gameId
            server = true,  --shows jobId
            currentaccount = true,  --shows username + displayname
        }
    }
}
loadstring(game:HttpGet("https://raw.githubusercontent.com/Tear32/lua-stuff/main/dahood/egg/EggFarm.lua"))()
    
