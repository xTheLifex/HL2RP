refunds.cart = refunds.cart or {}
refunds.requests = refund.requests or {}

net.Receive("UpdateRequests", function ()
    local amount = net.ReadInt()
    
end)