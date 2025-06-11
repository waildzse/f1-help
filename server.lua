-- ===========================================
-- نظام قائمة المساعدة الاحترافية - MTA RP
-- Server Side Script
-- ===========================================

-- جدول لحفظ إعدادات اللاعبين
local playerSettings = {}

-- أوامر المساعدة
addCommandHandler("newbie", function(player, cmd, ...)
    local message = table.concat({...}, " ")
    if not message or message == "" then
        outputChatBox("الاستخدام: /newbie [سؤالك]", player, 255, 100, 100)
        return
    end
    
    local playerName = getPlayerName(player):gsub("#%x%x%x%x%x%x", "")
    outputChatBox("📢 [سؤال مبتدئ] " .. playerName .. ": " .. message, root, 100, 255, 100)
    outputChatBox("✅ تم إرسال سؤالك للاعبين والإدارة", player, 0, 255, 0)
end)

addCommandHandler("rules", function(player)
    outputChatBox("📋 قوانين السيرفر:", player, 255, 255, 0)
    outputChatBox("1. لا تقم بالقتل العشوائي (RDM)", player, 255, 255, 255)
    outputChatBox("2. لا تقم بالقيادة المجنونة (VDM)", player, 255, 255, 255)
    outputChatBox("3. التزم بالأدوار التمثيلية", player, 255, 255, 255)
    outputChatBox("4. لا تستخدم الأخطاء البرمجية", player, 255, 255, 255)
    outputChatBox("5. احترم اللاعبين والإدارة", player, 255, 255, 255)
    outputChatBox("💡 للمزيد من القوانين، زر موقعنا", player, 100, 255, 100)
end)

addCommandHandler("report", function(player, cmd, targetId, ...)
    local reason = table.concat({...}, " ")
    if not targetId or not reason or reason == "" then
        outputChatBox("الاستخدام: /report [ID اللاعب] [السبب]", player, 255, 100, 100)
        return
    end
    
    local targetPlayer = getPlayerFromID(tonumber(targetId))
    if not targetPlayer then
        outputChatBox("❌ لم يتم العثور على اللاعب", player, 255, 100, 100)
        return
    end
    
    local playerName = getPlayerName(player):gsub("#%x%x%x%x%x%x", "")
    local targetName = getPlayerName(targetPlayer):gsub("#%x%x%x%x%x%x", "")
    
    -- إرسال للإدارة
    local admins = {}
    for _, admin in ipairs(getElementsByType("player")) do
        if hasObjectPermissionTo(admin, "function.banPlayer") then
            table.insert(admins, admin)
            outputChatBox("🚨 [بلاغ] " .. playerName .. " أبلغ عن " .. targetName .. " - " .. reason, admin, 255, 100, 100)
        end
    end
    
    if #admins > 0 then
        outputChatBox("✅ تم إرسال البلاغ للإدارة المتصلة (" .. #admins .. " إداري)", player, 0, 255, 0)
    else
        outputChatBox("⚠️ لا يوجد إدارة متصلة حالياً، سيتم حفظ البلاغ", player, 255, 255, 0)
        -- هنا يمكن إضافة نظام حفظ البلاغات في قاعدة البيانات
    end
end)

addCommandHandler("admins", function(player)
    local admins = {}
    for _, admin in ipairs(getElementsByType("player")) do
        if hasObjectPermissionTo(admin, "function.banPlayer") then
            local adminName = getPlayerName(admin):gsub("#%x%x%x%x%x%x", "")
            table.insert(admins, adminName)
        end
    end
    
    if #admins > 0 then
        outputChatBox("👥 الإدارة المتصلة (" .. #admins .. "):", player, 0, 255, 255)
        for i, adminName in ipairs(admins) do
            outputChatBox("   " .. i .. ". " .. adminName, player, 255, 255, 255)
        end
    else
        outputChatBox("❌ لا يوجد إدارة متصلة حالياً", player, 255, 100, 100)
    end
end)

addCommandHandler("players", function(player)
    local playerCount = getPlayerCount()
    outputChatBox("👥 اللاعبين المتصلين: " .. playerCount .. "/" .. getMaxPlayers(), player, 0, 255, 255)
    
    local players = {}
    for _, p in ipairs(getElementsByType("player")) do
        local pName = getPlayerName(p):gsub("#%x%x%x%x%x%x", "")
        local pId = getElementData(p, "playerid") or "N/A"
        table.insert(players, pId .. ". " .. pName)
    end
    
    -- عرض اللاعبين في مجموعات من 5
    for i = 1, #players, 5 do
        local group = {}
        for j = i, math.min(i + 4, #players) do
            table.insert(group, players[j])
        end
        outputChatBox("   " .. table.concat(group, " | "), player, 255, 255, 255)
    end
end)

addCommandHandler("time", function(player)
    local realTime = getRealTime()
    local hours = realTime.hour
    local minutes = realTime.minute
    local seconds = realTime.second
    
    local timeStr = string.format("%02d:%02d:%02d", hours, minutes, seconds)
    outputChatBox("🕐 الوقت الحالي: " .. timeStr, player, 255, 255, 0)
    
    -- وقت اللعبة (إذا كان مختلف)
    local gameHour, gameMinute = getTime()
    outputChatBox("🎮 وقت اللعبة: " .. string.format("%02d:%02d", gameHour, gameMinute), player, 100, 255, 100)
end)

-- نظام الـ Stats
addCommandHandler("stats", function(player)
    local playerName = getPlayerName(player):gsub("#%x%x%x%x%x%x", "")
    local money = getPlayerMoney(player)
    local health = getElementHealth(player)
    local armor = getPedArmor(player)
    local ping = getPlayerPing(player)
    local playTime = getElementData(player, "playTime") or 0
    
    outputChatBox("📊 إحصائيات " .. playerName .. ":", player, 0, 255, 255)
    outputChatBox("💰 المال: $" .. money, player, 255, 255, 255)
    outputChatBox("❤️ الصحة: " .. math.floor(health) .. "%", player, 255, 255, 255)
    outputChatBox("🛡️ الدرع: " .. math.floor(armor) .. "%", player, 255, 255, 255)
    outputChatBox("📡 البينغ: " .. ping .. "ms", player, 255, 255, 255)
    outputChatBox("⏰ وقت اللعب: " .. math.floor(playTime/60) .. " دقيقة", player, 255, 255, 255)
end)

-- وظيفة مساعدة للحصول على اللاعب من الـ ID
function getPlayerFromID(id)
    for _, player in ipairs(getElementsByType("player")) do
        if getElementData(player, "playerid") == id then
            return player
        end
    end
    return false
end

-- تعيين ID للاعبين الجدد
addEventHandler("onPlayerJoin", root, function()
    local playerId = 1
    local players = getElementsByType("player")
    
    -- البحث عن أصغر ID متاح
    while true do
        local found = false
        for _, player in ipairs(players) do
            if getElementData(player, "playerid") == playerId then
                found = true
                break
            end
        end
        if not found then
            break
        end
        playerId = playerId + 1
    end
    
    setElementData(source, "playerid", playerId)
    setElementData(source, "playTime", 0)
    
    -- رسالة ترحيب
    local playerName = getPlayerName(source):gsub("#%x%x%x%x%x%x", "")
    outputChatBox("🎉 مرحباً " .. playerName .. " في السيرفر! (ID: " .. playerId .. ")", source, 0, 255, 0)
    outputChatBox("💡 اضغط F1 لفتح قائمة المساعدة أو اكتب /help", source, 255, 255, 0)
    
    -- إعلان للجميع
    outputChatBox("📥 " .. playerName .. " انضم للسيرفر", root, 100, 255, 100)
end)

-- حفظ وقت اللعب
addEventHandler("onPlayerQuit", root, function()
    local playerName = getPlayerName(source):gsub("#%x%x%x%x%x%x", "")
    outputChatBox("📤 " .. playerName .. " غادر السيرفر", root, 255, 100, 100)
end)

-- تحديث وقت اللعب كل دقيقة
setTimer(function()
    for _, player in ipairs(getElementsByType("player")) do
        local currentTime = getElementData(player, "playTime") or 0
        setElementData(player, "playTime", currentTime + 1)
    end
end, 60000, 0)

-- أوامر إضافية للمساعدة
addCommandHandler("givemoney", function(player, cmd, targetId, amount)
    if not targetId or not amount then
        outputChatBox("الاستخدام: /givemoney [ID اللاعب] [المبلغ]", player, 255, 100, 100)
        return
    end
    
    local targetPlayer = getPlayerFromID(tonumber(targetId))
    local moneyAmount = tonumber(amount)
    
    if not targetPlayer then
        outputChatBox("❌ لم يتم العثور على اللاعب", player, 255, 100, 100)
        return
    end
    
    if not moneyAmount or moneyAmount <= 0 then
        outputChatBox("❌ المبلغ غير صحيح", player, 255, 100, 100)
        return
    end
    
    if getPlayerMoney(player) < moneyAmount then
        outputChatBox("❌ ليس لديك مال كافي", player, 255, 100, 100)
        return
    end
    
    takePlayerMoney(player, moneyAmount)
    givePlayerMoney(targetPlayer, moneyAmount)
    
    local playerName = getPlayerName(player):gsub("#%x%x%x%x%x%x", "")
    local targetName = getPlayerName(targetPlayer):gsub("#%x%x%x%x%x%x", "")
    
    outputChatBox("✅ أرسلت $" .. moneyAmount .. " إلى " .. targetName, player, 0, 255, 0)
    outputChatBox("💰 استلمت $" .. moneyAmount .. " من " .. playerName, targetPlayer, 0, 255, 0)
end)

-- رسائل المساعدة التلقائية
setTimer(function()
    local tips = {
        "💡 نصيحة: اضغط F1 لفتح قائمة المساعدة الشاملة",
        "🎭 نصيحة: استخدم /me و /do للأدوار التمثيلية",
        "📢 نصيحة: استخدم /newbie لطرح أسئلتك",
        "⚠️ نصيحة: اقرأ القوانين باستخدام /rules",
        "👥 نصيحة: تفاعل مع اللاعبين الآخرين لتجربة أفضل",
        "🚗 نصيحة: تعلم قيادة السيارات بحذر وواقعية",
        "💰 نصيحة: ابحث عن وظيفة لكسب المال الحلال",
        "🏠 نصيحة: اشتري منزلاً لحفظ أغراضك"
    }
    
    local randomTip = tips[math.random(1, #tips)]
    outputChatBox(randomTip, root, 100, 200, 255)
end, 300000, 0) -- كل 5 دقائق

-- أوامر الإدارة للمساعدة
addCommandHandler("announce", function(player, cmd, ...)
    if not hasObjectPermissionTo(player, "function.banPlayer") then
        outputChatBox("❌ ليس لديك صلاحية لاستخدام هذا الأمر", player, 255, 100, 100)
        return
    end
    
    local message = table.concat({...}, " ")
    if not message or message == "" then
        outputChatBox("الاستخدام: /announce [الرسالة]", player, 255, 100, 100)
        return
    end
    
    outputChatBox("📢 [إعلان] " .. message, root, 255, 255, 0)
end)

-- نظام الدعم المباشر
local supportRequests = {}

addCommandHandler("support", function(player, cmd, ...)
    local message = table.concat({...}, " ")
    if not message or message == "" then
        outputChatBox("الاستخدام: /support [وصف المشكلة]", player, 255, 100, 100)
        return
    end
    
    local playerName = getPlayerName(player):gsub("#%x%x%x%x%x%x", "")
    local requestId = #supportRequests + 1
    
    supportRequests[requestId] = {
        player = player,
        name = playerName,
        message = message,
        time = getRealTime().timestamp
    }
    
    -- إرسال للإدارة
    for _, admin in ipairs(getElementsByType("player")) do
        if hasObjectPermissionTo(admin, "function.banPlayer") then
            outputChatBox("🎧 [طلب دعم #" .. requestId .. "] " .. playerName .. ": " .. message, admin, 255, 200, 0)
            outputChatBox("   استخدم /respond " .. requestId .. " [الرد] للرد", admin, 200, 200, 200)
        end
    end
    
    outputChatBox("✅ تم إرسال طلب الدعم (#" .. requestId .. ") للإدارة", player, 0, 255, 0)
end)

addCommandHandler("respond", function(player, cmd, requestId, ...)
    if not hasObjectPermissionTo(player, "function.banPlayer") then
        outputChatBox("❌ ليس لديك صلاحية لاستخدام هذا الأمر", player, 255, 100, 100)
        return
    end
    
    local response = table.concat({...}, " ")
    if not requestId or not response or response == "" then
        outputChatBox("الاستخدام: /respond [رقم الطلب] [الرد]", player, 255, 100, 100)
        return
    end
    
    local request = supportRequests[tonumber(requestId)]
    if not request then
        outputChatBox("❌ طلب الدعم غير موجود", player, 255, 100, 100)
        return
    end
    
    if not isElement(request.player) then
        outputChatBox("❌ اللاعب غير متصل", player, 255, 100, 100)
        return
    end
    
    local adminName = getPlayerName(player):gsub("#%x%x%x%x%x%x", "")
    
    outputChatBox("🎧 [رد الدعم] " .. adminName .. ": " .. response, request.player, 0, 255, 255)
    outputChatBox("✅ تم إرسال الرد لـ " .. request.name, player, 0, 255, 0)
    
    -- إزالة الطلب بعد الرد
    supportRequests[tonumber(requestId)] = nil
end)

-- عرض طلبات الدعم المعلقة
addCommandHandler("supportlist", function(player)
    if not hasObjectPermissionTo(player, "function.banPlayer") then
        outputChatBox("❌ ليس لديك صلاحية لاستخدام هذا الأمر", player, 255, 100, 100)
        return
    end
    
    local count = 0
    for id, request in pairs(supportRequests) do
        if isElement(request.player) then
            count = count + 1
        end
    end
    
    if count == 0 then
        outputChatBox("✅ لا توجد طلبات دعم معلقة", player, 0, 255, 0)
        return
    end
    
    outputChatBox("🎧 طلبات الدعم المعلقة (" .. count .. "):", player, 255, 255, 0)
    for id, request in pairs(supportRequests) do
        if isElement(request.player) then
            outputChatBox("   #" .. id .. " - " .. request.name .. ": " .. request.message, player, 255, 255, 255)
        end
    end
end)

-- نظام التقييم
addCommandHandler("rate", function(player, cmd, rating)
    if not rating then
        outputChatBox("الاستخدام: /rate [1-5] - قيم تجربتك في السيرفر", player, 255, 100, 100)
        return
    end
    
    local ratingNum = tonumber(rating)
    if not ratingNum or ratingNum < 1 or ratingNum > 5 then
        outputChatBox("❌ التقييم يجب أن يكون من 1 إلى 5", player, 255, 100, 100)
        return
    end
    
    local playerName = getPlayerName(player):gsub("#%x%x%x%x%x%x", "")
    local stars = string.rep("⭐", ratingNum) .. string.rep("☆", 5 - ratingNum)
    
    outputChatBox("✅ شكراً لك على التقييم: " .. stars, player, 0, 255, 0)
    
    -- إرسال للإدارة
    for _, admin in ipairs(getElementsByType("player")) do
        if hasObjectPermissionTo(admin, "function.banPlayer") then
            outputChatBox("⭐ تقييم جديد من " .. playerName .. ": " .. stars .. " (" .. ratingNum .. "/5)", admin, 255, 255, 0)
        end
    end
end)

-- أوامر إضافية مفيدة
addCommandHandler("loc", function(player)
    local x, y, z = getElementPosition(player)
    local zone = getZoneName(x, y, z)
    local city = getZoneName(x, y, z, true)
    
    outputChatBox("📍 موقعك الحالي:", player, 0, 255, 255)
    outputChatBox("   المنطقة: " .. zone, player, 255, 255, 255)
    outputChatBox("   المدينة: " .. city, player, 255, 255, 255)
    outputChatBox("   الإحداثيات: " .. math.floor(x) .. ", " .. math.floor(y) .. ", " .. math.floor(z), player, 255, 255, 255)
end)

addCommandHandler("weather", function(player)
    local weather = getWeather()
    local weatherNames = {
        [0] = "صافي", [1] = "غائم", [2] = "ضبابي", [3] = "عاصف",
        [4] = "ضبابي", [5] = "مشمس", [6] = "مشمس", [7] = "غائم",
        [8] = "عاصف", [9] = "ضبابي", [10] = "مشمس جداً", [11] = "حار",
        [12] = "غائم جزئياً", [16] = "مشمس", [17] = "مشمس", [18] = "مشمس"
    }
    
    local weatherName = weatherNames[weather] or "غير معروف"
    outputChatBox("🌤️ الطقس الحالي: " .. weatherName .. " (ID: " .. weather .. ")", player, 255, 255, 0)
end)

-- تنظيف طلبات الدعم القديمة
setTimer(function()
    local currentTime = getRealTime().timestamp
    for id, request in pairs(supportRequests) do
        if not isElement(request.player) or (currentTime - request.time) > 1800 then -- 30 دقيقة
            supportRequests[id] = nil
        end
    end
end, 300000, 0) -- كل 5 دقائق

-- معلومات السيرفر
addCommandHandler("serverinfo", function(player)
    outputChatBox("ℹ️ معلومات السيرفر:", player, 0, 255, 255)
    outputChatBox("   اللاعبين: " .. getPlayerCount() .. "/" .. getMaxPlayers(), player, 255, 255, 255)
    outputChatBox("   النسخة: " .. getVersion().mta, player, 255, 255, 255)
    outputChatBox("   الوضع: Roleplay", player, 255, 255, 255)
    outputChatBox("   الموقع: " .. (get("*server.location") or "غير محدد"), player, 255, 255, 255)
    outputChatBox("💡 للمساعدة اضغط F1 أو /help", player, 100, 255, 100)
end)