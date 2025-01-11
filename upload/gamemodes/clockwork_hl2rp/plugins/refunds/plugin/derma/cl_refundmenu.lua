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

    -- Create the cart panel
    local cartPanel = vgui.Create("DPanel", itemListPanel)
    cartPanel:Dock(BOTTOM)
    cartPanel:SetHeight(150)
    cartPanel.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(50, 50, 50, 150)) -- Background for the cart
    end

    local cartList = vgui.Create("DListView", cartPanel)
    cartList:Dock(FILL)
    cartList:AddColumn("Item")
    cartList:AddColumn("Amount")

    -- Function to update the cart display
    local function UpdateCart()
        cartList:Clear()
        for uniqueID, amount in pairs(cart) do
            if amount > 0 then
                local item = Clockwork.item.stored[uniqueID]
                cartList:AddLine(T(item.name) or "Unknown", amount)
            end
        end
    end

    -- Organize items by category
    local itemsByCategory = {}

    for id, item in pairs(Clockwork.item.stored) do
        local category = item.category or "Misc"
        itemsByCategory[category] = itemsByCategory[category] or {}
        table.insert(itemsByCategory[category], item)
    end

    -- Create a scrollable area for categories and items
    local scrollPanel = vgui.Create("DScrollPanel", itemListPanel)
    scrollPanel:Dock(FILL)

    for category, items in pairs(itemsByCategory) do
        -- Add category label
        local categoryLabel = vgui.Create("DLabel", scrollPanel)
        categoryLabel:SetText(category)
        categoryLabel:SetFont("DermaLarge")
        categoryLabel:Dock(TOP)
        categoryLabel:DockMargin(5, 10, 5, 5)
        categoryLabel:SetTextColor(Color(255, 255, 255))

        -- Add a container for the icons
        local categoryIcons = vgui.Create("DIconLayout", scrollPanel)
        categoryIcons:SetSpaceX(5)
        categoryIcons:SetSpaceY(5)
        categoryIcons:Dock(TOP)
        categoryIcons:SetHeight(128) -- Adjust height based on number of items

        for _, item in ipairs(items) do
            local itemIcon = categoryIcons:Add("SpawnIcon")
            itemIcon:SetModel(item.model or "models/hunter/blocks/cube025x025x025.mdl")
            itemIcon:SetTooltip(T(item.name) or "Unknown")
            itemIcon:SetSize(64, 64)

            -- Update color based on cart status
            local function UpdateIconColor()
                if cart[item.uniqueID] and cart[item.uniqueID] > 0 then
                    itemIcon:SetColor(Color(0, 255, 0)) -- Green for added items
                else
                    itemIcon:SetColor(Color(255, 255, 255)) -- Default
                end
            end

            -- Add to cart on left click
            itemIcon.DoClick = function()
                cart[item.uniqueID] = cart[item.uniqueID] or 0
                cart[item.uniqueID] = cart[item.uniqueID] + 1
                notification.AddLegacy(item.name .. " added to cart!", NOTIFY_GENERIC, 2)
                UpdateIconColor()
                UpdateCart()
            end

            -- Remove from cart on right click
            itemIcon.DoRightClick = function()
                if cart[item.uniqueID] and cart[item.uniqueID] > 0 then
                    cart[item.uniqueID] = cart[item.uniqueID] - 1
                    if cart[item.uniqueID] <= 0 then
                        cart[item.uniqueID] = nil
                    end
                    notification.AddLegacy(item.name .. " removed from cart!", NOTIFY_GENERIC, 2)
                    UpdateIconColor()
                    UpdateCart()
                end
            end

            -- Initial color setup
            UpdateIconColor()
        end
    end

    -- Initial cart population
    UpdateCart()


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
        UpdateCart()
    end

    local createRequestButton = vgui.Create("DButton", buttonPanel)
    createRequestButton:SetText("Create Request")
    createRequestButton:Dock(TOP)
    createRequestButton:SetHeight(50)
    createRequestButton.DoClick = function()
        if table.IsEmpty(cart) then
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
    myRequestsList:AddColumn("Character")
    myRequestsList:AddColumn("Items")
    myRequestsList:AddColumn("Status")

    -- Example requests
    for i = 1, 10 do
        myRequestsList:AddLine(i,"John Doe", "Item 1, Item 2", "Pending")
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

        -- Active requests list
        local activeRequestsList = vgui.Create("DListView", activeRequestsPanel)
        activeRequestsList:Dock(TOP)
        activeRequestsList:SetHeight(200)
        activeRequestsList:AddColumn("Request ID")
        activeRequestsList:AddColumn("Character")
        activeRequestsList:AddColumn("Player")
        activeRequestsList:AddColumn("SteamID")
        activeRequestsList:AddColumn("Items")

        -- Icon panel for selected request's items
        local selectedItemsPanel = vgui.Create("DScrollPanel", activeRequestsPanel)
        selectedItemsPanel:Dock(FILL)
        selectedItemsPanel.Paint = function(self, w, h)
            draw.RoundedBox(0, 0, 0, w, h, Color(50, 50, 50, 150)) -- Background for selected items
        end

        local iconLayout = vgui.Create("DIconLayout", selectedItemsPanel)
        iconLayout:Dock(FILL)
        iconLayout:SetSpaceX(5)
        iconLayout:SetSpaceY(5)

        -- Function to update icons based on selected request
        local function UpdateSelectedRequestItems(itemList)
            iconLayout:Clear()
            for _, itemID in ipairs(itemList) do
                local item = Clockwork.item.stored[itemID]
                if item then
                    local itemIcon = iconLayout:Add("SpawnIcon")
                    itemIcon:SetModel(item.model or "models/hunter/blocks/cube025x025x025.mdl")
                    itemIcon:SetTooltip(item.name or "Unknown")
                    itemIcon:SetSize(64, 64)
                end
            end
        end

        -- Example active requests (placeholder logic)
        for i = 1, 10 do
            local requestItems = {"item_1", "item_2", "item_3"} -- Replace with real item IDs
            local line = activeRequestsList:AddLine(
                i,
                "Character " .. i,
                "Player " .. i,
                "STEAM:ID",
                table.concat(requestItems, ", ")
            )
            line.RequestItems = requestItems
        end

        -- On row selection, show items in the icon panel
        activeRequestsList.OnRowSelected = function(_, rowIndex, row)
            if row.RequestItems then
                UpdateSelectedRequestItems(row.RequestItems)
            end
        end

        sheet:AddSheet("Active Requests", activeRequestsPanel, "icon16/group.png")
    end

end

-- Bind the menu to a console command for testing
concommand.Add("open_refund_menu", refunds.CreateRefundMenu)
