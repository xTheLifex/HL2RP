/* -------------------------------------------------------------------------- */
/*                                Message Flash                               */
/* -------------------------------------------------------------------------- */

PLUGIN:SetGlobalAlias("messageflash");

/* ------------------------------- Client Side ------------------------------ */
if SERVER then return end

Clockwork.kernel:CreateClientConVar("cwMessageFlashEnable", 1, true, true)
Clockwork.setting:AddCheckBox("Framework", "Enable Message Flash", "cwMessageFlashEnable", "Whether or not to flash your gmod icon when receiving a message.", function () return system.IsLinux() end)

function PLUGIN:ChatBoxTextChanged()
    if (!system.IsWindows()) then return end -- Windows only
    if (!system.HasFocus()) then return end -- Without focus only.
    if (LocalPlayer():GetInfoNum("cwMessageFlashEnable", 1) == 0) then return end -- If client enabled it only.

    system.FlashWindow()
end