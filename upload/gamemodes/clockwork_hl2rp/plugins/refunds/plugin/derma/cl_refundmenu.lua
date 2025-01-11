function refunds.CreateRefundMenu()
    local frame = vgui.Create("DFrame")
    frame:SetTitle("Refund Menu")
    frame:SetSize(800, 600)
    frame:Center()
    frame:MakePopup()
    frame:SetDraggable(false)
    frame:ShowCloseButton(true)

    /* -------------------------------------------------------------------------- */
    /*                                    Blur                                    */
    /* -------------------------------------------------------------------------- */
    frame.Paint = function(self, w, h)
        Derma_DrawBackgroundBlur(self, CurTime())
        draw.RoundedBox(8, 0, 0, w, h, Color(50, 50, 50, 200)) -- Slight dark background with transparency
    end

    local sheet = vgui.Create("DPropertySheet", frame)
    sheet:Dock(FILL)

    /* -------------------------------------------------------------------------- */
    /*                                Item List Tab                               */
    /* -------------------------------------------------------------------------- */
    local itemListPanel = vgui.Create("DPanel", sheet)
    itemListPanel:Dock(FILL)
    itemListPanel.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(255, 255, 255, 10)) -- Transparent base
    end

    local cart = refunds.cart or {}

    -- Organize items by category
    local itemsByCategory = {}

    for id, item in ipairs(Clockwork.item.stored) do
        local category = item.category or "Misc"
        itemsByCategory[category] = itemsByCategory[category] or {}
        table.insert(itemsByCategory[category], item)
    end

    -- Create category selection dropdown
    local categoryDropdown = vgui.Create("DComboBox", itemListPanel)
    categoryDropdown:Dock(TOP)
    categoryDropdown:SetHeight(30)
    categoryDropdown:SetValue("Select Category")

    for category, _ in pairs(itemsByCategory) do
        categoryDropdown:AddChoice(category)
    end

    local itemList = vgui.Create("DIconLayout", itemListPanel)
    itemList:Dock(FILL)
    itemList:SetSpaceX(5)
    itemList:SetSpaceY(5)

    -- Populate items based on the selected category
    local function PopulateItems(category)
        itemList:Clear()
        if itemsByCategory[category] then
            for _, item in ipairs(itemsByCategory[category]) do
                local itemIcon = itemList:Add("SpawnIcon")
                itemIcon:SetModel(item.model or "models/hunter/blocks/cube025x025x025.mdl")
                itemIcon:SetTooltip(item.name or "Unknown")

                itemIcon.DoClick = function()
                    table.insert(cart, item.name)
                    notification.AddLegacy(item.name .. " added to cart!", NOTIFY_GENERIC, 2)
                end
            end
        end
    end

    categoryDropdown.OnSelect = function(_, _, category)
        PopulateItems(category)
    end


    /* -------------------------------------------------------------------------- */
    /*                                 Side Panel                                 */
    /* -------------------------------------------------------------------------- */

    local buttonPanel = vgui.Create("DPanel", itemListPanel)
    buttonPanel:Dock(RIGHT)
    buttonPanel:SetWidth(150)
    buttonPanel.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(50, 50, 50, 150))
    end

    local clearButton = vgui.Create("DButton", buttonPanel)
    clearButton:SetText("Clear Cart")
    clearButton:Dock(TOP)
    clearButton:SetHeight(50)
    clearButton.DoClick = function()
        cart = {}
        notification.AddLegacy("Cart cleared!", NOTIFY_GENERIC, 2)
        surface.PlaySound("buttons/button10.wav")
    end

    local createRequestButton = vgui.Create("DButton", buttonPanel)
    createRequestButton:SetText("Create Request")
    createRequestButton:Dock(TOP)
    createRequestButton:SetHeight(50)
    createRequestButton.DoClick = function()
        if #cart == 0 then
            notification.AddLegacy("Cart is empty!", NOTIFY_ERROR, 2)
        else
            -- Send request to server
            net.Start("RefundRequest")
            net.WriteTable(cart)
            net.SendToServer()

            notification.AddLegacy("Refund request sent!", NOTIFY_GENERIC, 2)
            cart = {}
            surface.PlaySound("buttons/button14.wav")
        end
    end

    sheet:AddSheet("Item List", itemListPanel, "icon16/cart.png")

    /* -------------------------------------------------------------------------- */
    /*                                 My Requests                                */
    /* -------------------------------------------------------------------------- */
    local myRequestsPanel = vgui.Create("DPanel", sheet)
    myRequestsPanel:Dock(FILL)
    myRequestsPanel.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(255, 255, 255, 10)) -- Transparent base
    end

    local myRequestsList = vgui.Create("DListView", myRequestsPanel)
    myRequestsList:Dock(FILL)
    myRequestsList:AddColumn("Request ID")
    myRequestsList:AddColumn("Items")
    myRequestsList:AddColumn("Status")

    -- Example requests
    for i = 1, 10 do
        myRequestsList:AddLine(i, "Item 1, Item 2", "Pending")
    end

    sheet:AddSheet("My Requests", myRequestsPanel, "icon16/table.png")

    /* -------------------------------------------------------------------------- */
    /*                               Active Requests                              */
    /* -------------------------------------------------------------------------- */
    local staff = Clockwork.player:HasFlags(Clockwork.Client, "s")
    if staff then
        local activeRequestsPanel = vgui.Create("DPanel", sheet)
        activeRequestsPanel:Dock(FILL)
        activeRequestsPanel.Paint = function(self, w, h)
            draw.RoundedBox(0, 0, 0, w, h, Color(255, 255, 255, 10)) -- Transparent base
        end

        local activeRequestsList = vgui.Create("DListView", activeRequestsPanel)
        activeRequestsList:Dock(FILL)
        activeRequestsList:AddColumn("Request ID")
        activeRequestsList:AddColumn("Name")
        activeRequestsList:AddColumn("SteamID")
        activeRequestsList:AddColumn("Items")

        -- Example active requests
        for i = 1, 10 do
            local line = activeRequestsList:AddLine(i, "Player " .. i, "STEAM:ID", "Item 1, Item 2")
        end

        sheet:AddSheet("Active Requests", activeRequestsPanel, "icon16/group.png")
    end 
end

-- Bind the menu to a console command for testing
concommand.Add("open_refund_menu", refunds.CreateRefundMenu)
