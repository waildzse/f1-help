-- ===========================================
-- نظام قائمة المساعدة الاحترافية - MTA RP
-- Client Side Script
-- ===========================================

local screenW, screenH = guiGetScreenSize()
local helpWindow = nil
local helpWindowVisible = false
local currentCategory = "general"

-- إعدادات التصميم
local windowWidth = 900
local windowHeight = 600
local windowX = (screenW - windowWidth) / 2
local windowY = (screenH - windowHeight) / 2

-- الألوان
local colors = {
    primary = tocolor(41, 128, 185, 255),     -- أزرق
    secondary = tocolor(52, 73, 94, 255),     -- رمادي داكن
    success = tocolor(39, 174, 96, 255),      -- أخضر
    warning = tocolor(241, 196, 15, 255),     -- أصفر
    danger = tocolor(231, 76, 60, 255),       -- أحمر
    white = tocolor(255, 255, 255, 255),
    black = tocolor(0, 0, 0, 200),
    background = tocolor(44, 62, 80, 240),
    hover = tocolor(52, 152, 219, 100)
}

-- بيانات المساعدة
local helpData = {
    ["general"] = {
        title = "المساعدة العامة",
        icon = "🏠",
        items = {
            {title = "كيفية البدء", desc = "تعلم أساسيات اللعب في السيرفر", cmd = "/newbie"},
            {title = "القوانين", desc = "قوانين السيرفر المهمة", cmd = "/rules"},
            {title = "الدعم الفني", desc = "طلب المساعدة من الإدارة", cmd = "/report"},
            {title = "معلومات الشخصية", desc = "عرض معلومات شخصيتك", cmd = "/stats"},
            {title = "تغيير الإعدادات", desc = "تخصيص إعدادات اللعب", cmd = "/settings"},
        }
    },
    ["roleplay"] = {
        title = "الأدوار التمثيلية",
        icon = "🎭",
        items = {
            {title = "الإجراءات التمثيلية", desc = "أوامر التمثيل والتفاعل", cmd = "/me /do /try"},
            {title = "نظام الإصابات", desc = "كيفية التعامل مع الإصابات", cmd = "/injured"},
            {title = "الزواج", desc = "نظام الزواج والطلاق", cmd = "/marry /divorce"},
            {title = "الأعمال", desc = "إنشاء وإدارة الأعمال", cmd = "/business"},
            {title = "المنظمات", desc = "الانضمام للمنظمات", cmd = "/faction"},
        }
    },
    ["vehicles"] = {
        title = "المركبات",
        icon = "🚗",
        items = {
            {title = "شراء المركبات", desc = "كيفية شراء السيارات والدراجات", cmd = "/buycar"},
            {title = "إدارة المركبات", desc = "أوامر إدارة مركباتك", cmd = "/veh /park /lock"},
            {title = "التأمين", desc = "تأمين المركبات ضد السرقة", cmd = "/insure"},
            {title = "الصيانة", desc = "إصلاح وتعديل المركبات", cmd = "/repair /mod"},
            {title = "الوقود", desc = "نظام الوقود والتزود", cmd = "/fuel"},
        }
    },
    ["economy"] = {
        title = "الاقتصاد",
        icon = "💰",
        items = {
            {title = "الوظائف", desc = "العثور على عمل وكسب المال", cmd = "/jobs"},
            {title = "البنك", desc = "إدارة حسابك البنكي", cmd = "/bank"},
            {title = "التجارة", desc = "شراء وبيع البضائع", cmd = "/trade"},
            {title = "العقارات", desc = "شراء وبيع العقارات", cmd = "/property"},
            {title = "الاستثمار", desc = "الاستثمار في الأسهم", cmd = "/invest"},
        }
    },
    ["commands"] = {
        title = "الأوامر",
        icon = "⌨️",
        items = {
            {title = "الأوامر الأساسية", desc = "أهم الأوامر للاعبين الجدد", cmd = "انظر القائمة أدناه"},
            {title = "أوامر التفاعل", desc = "أوامر التفاعل مع اللاعبين", cmd = "/givemoney /trade"},
            {title = "أوامر الإدارة", desc = "أوامر خاصة بالإدارة", cmd = "للإدارة فقط"},
            {title = "أوامر VIP", desc = "أوامر خاصة بالـ VIP", cmd = "/vip"},
            {title = "الاختصارات", desc = "اختصارات مفيدة للوحة المفاتيح", cmd = "F1-F12"},
        }
    }
}

-- قائمة الأوامر الأساسية
local basicCommands = {
    {cmd = "/help", desc = "عرض قائمة المساعدة"},
    {cmd = "/pm [id] [message]", desc = "إرسال رسالة خاصة"},
    {cmd = "/stats", desc = "عرض إحصائياتك"},
    {cmd = "/time", desc = "عرض الوقت"},
    {cmd = "/admins", desc = "عرض الإدارة المتصلة"},
    {cmd = "/players", desc = "عرض اللاعبين المتصلين"},
    {cmd = "/report [reason]", desc = "الإبلاغ عن مشكلة"},
    {cmd = "/newbie [question]", desc = "طرح سؤال للمبتدئين"},
    {cmd = "/changename [name]", desc = "تغيير اسم الشخصية"},
    {cmd = "/quit", desc = "الخروج من اللعبة"},
}

function createHelpWindow()
    if helpWindow then return end
    
    -- النافذة الرئيسية
    helpWindow = dgsCreateWindow(windowX, windowY, windowWidth, windowHeight, "قائمة المساعدة - " .. helpData[currentCategory].title, false)
    dgsWindowSetSizable(helpWindow, false)
    dgsSetProperty(helpWindow, "alpha", 0.95)
    
    -- خلفية النافذة
    local background = dgsCreateRectangle(0, 0, windowWidth, windowHeight, colors.background, false, helpWindow)
    
    -- شريط علوي
    local topBar = dgsCreateRectangle(0, 0, windowWidth, 60, colors.primary, false, helpWindow)
    local titleLabel = dgsCreateLabel(20, 15, windowWidth-40, 30, "🎮 قائمة المساعدة الاحترافية", false, helpWindow)
    dgsSetProperty(titleLabel, "color", colors.white)
    dgsSetProperty(titleLabel, "font", "default-bold")
    
    -- زر الإغلاق
    local closeBtn = dgsCreateButton(windowWidth-50, 10, 40, 40, "✖", false, helpWindow)
    dgsSetProperty(closeBtn, "color", colors.white)
    dgsSetProperty(closeBtn, "bgColor", colors.danger)
    
    -- القائمة الجانبية للفئات
    local sidebarWidth = 200
    local sidebar = dgsCreateRectangle(0, 60, sidebarWidth, windowHeight-60, colors.secondary, false, helpWindow)
    
    -- إنشاء أزرار الفئات
    local categoryButtons = {}
    local yPos = 80
    for category, data in pairs(helpData) do
        local btn = dgsCreateButton(10, yPos, sidebarWidth-20, 50, data.icon .. " " .. data.title, false, helpWindow)
        dgsSetProperty(btn, "color", colors.white)
        dgsSetProperty(btn, "bgColor", category == currentCategory and colors.primary or colors.secondary)
        categoryButtons[category] = btn
        yPos = yPos + 60
        
        addEventHandler("onDgsMouseClick", btn, function()
            currentCategory = category
            updateHelpContent()
            updateCategoryButtons(categoryButtons)
        end)
    end
    
    -- منطقة المحتوى
    local contentArea = dgsCreateScrollPane(sidebarWidth + 20, 80, windowWidth - sidebarWidth - 40, windowHeight - 100, false, helpWindow)
    dgsSetProperty(contentArea, "bgColor", colors.white)
    
    -- تحديث المحتوى
    updateHelpContent()
    
    -- أحداث الإغلاق
    addEventHandler("onDgsMouseClick", closeBtn, function()
        closeHelpWindow()
    end)
    
    -- إغلاق بالضغط على ESC
    addEventHandler("onClientKey", root, function(key, press)
        if key == "F1" and press and helpWindowVisible then
            closeHelpWindow()
        end
    end)
    
    helpWindowVisible = true
end

function updateHelpContent()
    if not helpWindow then return end
    
    -- البحث عن منطقة المحتوى وتنظيفها
    local contentArea = dgsGetChild(helpWindow, 11) -- ScrollPane
    if contentArea then
        dgsScrollPaneSetScrollPosition(contentArea, 0, 0)
        for i, child in ipairs(dgsGetChildren(contentArea)) do
            dgsDestroyElement(child)
        end
    end
    
    local yPos = 10
    local data = helpData[currentCategory]
    
    -- عنوان الفئة
    local categoryTitle = dgsCreateLabel(10, yPos, 600, 40, data.icon .. " " .. data.title, false, contentArea)
    dgsSetProperty(categoryTitle, "color", colors.primary)
    dgsSetProperty(categoryTitle, "font", "default-bold")
    yPos = yPos + 50
    
    -- عرض العناصر
    if currentCategory == "commands" and data.items[1].title == "الأوامر الأساسية" then
        -- عرض قائمة الأوامر الأساسية
        for i, item in ipairs(data.items) do
            if i == 1 then
                -- العنوان
                local itemTitle = dgsCreateLabel(10, yPos, 600, 30, "📋 " .. item.title, false, contentArea)
                dgsSetProperty(itemTitle, "color", colors.secondary)
                dgsSetProperty(itemTitle, "font", "default-bold")
                yPos = yPos + 40
                
                -- الأوامر
                for j, cmd in ipairs(basicCommands) do
                    local cmdBg = dgsCreateRectangle(10, yPos, 620, 40, colors.background, false, contentArea)
                    local cmdLabel = dgsCreateLabel(20, yPos + 5, 300, 30, cmd.cmd, false, contentArea)
                    dgsSetProperty(cmdLabel, "color", colors.success)
                    dgsSetProperty(cmdLabel, "font", "default-bold")
                    
                    local descLabel = dgsCreateLabel(320, yPos + 5, 300, 30, cmd.desc, false, contentArea)
                    dgsSetProperty(descLabel, "color", colors.white)
                    
                    yPos = yPos + 45
                end
            else
                -- باقي العناصر
                local itemBg = dgsCreateRectangle(10, yPos, 620, 80, colors.hover, false, contentArea)
                local itemTitle = dgsCreateLabel(20, yPos + 10, 600, 25, "🔹 " .. item.title, false, contentArea)
                dgsSetProperty(itemTitle, "color", colors.primary)
                dgsSetProperty(itemTitle, "font", "default-bold")
                
                local itemDesc = dgsCreateLabel(20, yPos + 35, 600, 20, item.desc, false, contentArea)
                dgsSetProperty(itemDesc, "color", colors.white)
                
                local itemCmd = dgsCreateLabel(20, yPos + 55, 600, 20, "الأمر: " .. item.cmd, false, contentArea)
                dgsSetProperty(itemCmd, "color", colors.warning)
                
                yPos = yPos + 90
            end
        end
    else
        -- عرض العناصر العادية
        for i, item in ipairs(data.items) do
            local itemBg = dgsCreateRectangle(10, yPos, 620, 80, colors.hover, false, contentArea)
            local itemTitle = dgsCreateLabel(20, yPos + 10, 600, 25, "🔹 " .. item.title, false, contentArea)
            dgsSetProperty(itemTitle, "color", colors.primary)
            dgsSetProperty(itemTitle, "font", "default-bold")
            
            local itemDesc = dgsCreateLabel(20, yPos + 35, 600, 20, item.desc, false, contentArea)
            dgsSetProperty(itemDesc, "color", colors.white)
            
            local itemCmd = dgsCreateLabel(20, yPos + 55, 600, 20, "الأمر: " .. item.cmd, false, contentArea)
            dgsSetProperty(itemCmd, "color", colors.warning)
            
            -- إضافة تأثير hover
            addEventHandler("onDgsMouseEnter", itemBg, function()
                dgsSetProperty(itemBg, "color", colors.primary)
            end)
            
            addEventHandler("onDgsMouseLeave", itemBg, function()
                dgsSetProperty(itemBg, "color", colors.hover)
            end)
            
            yPos = yPos + 90
        end
    end
    
    -- تحديث حجم المحتوى
    dgsSetProperty(contentArea, "scrollBarThick", 10)
end

function updateCategoryButtons(buttons)
    for category, btn in pairs(buttons) do
        local bgColor = category == currentCategory and colors.primary or colors.secondary
        dgsSetProperty(btn, "bgColor", bgColor)
    end
end

function closeHelpWindow()
    if helpWindow then
        dgsDestroyElement(helpWindow)
        helpWindow = nil
        helpWindowVisible = false
        showCursor(false)
    end
end

-- فتح قائمة المساعدة بالضغط على F1
addEventHandler("onClientKey", root, function(key, press)
    if key == "F1" and press then
        if not helpWindowVisible then
            createHelpWindow()
            showCursor(true)
        else
            closeHelpWindow()
        end
    end
end)

-- أمر لفتح قائمة المساعدة
addCommandHandler("help", function()
    if not helpWindowVisible then
        createHelpWindow()
        showCursor(true)
    else
        closeHelpWindow()
    end
end)

-- رسالة ترحيبية عند دخول السيرفر
addEventHandler("onClientResourceStart", resourceRoot, function()
    outputChatBox("🎮 مرحباً بك في السيرفر! اضغط F1 لفتح قائمة المساعدة", 0, 255, 0)
    outputChatBox("💡 لا تتردد في طرح أسئلتك باستخدام /newbie", 255, 255, 0)
end)