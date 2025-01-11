staffpm.codenameList = {
    "Aegis",        -- Shield of protection
    "Tempest",      -- A storm of fury
    "Poseidon",     -- God of the sea
    "Phantom",      -- Mysterious and unseen
    "Valkyrie",     -- Chooser of the slain
    "Havoc",        -- Chaos and destruction
    "Eclipse",      -- A celestial phenomenon
    "Talon",        -- A sharp claw
    "Sentinel",     -- A watchful guardian
    "Inferno",      -- A raging fire
    "Warden",       -- Protector or overseer
    "Onyx",         -- Resilient and dark stone
    "Ragnarok",     -- End of the world in Norse myth
    "Shadow",       -- Stealthy and elusive
    "Titan",        -- A giant of immense strength
    "Oblivion",     -- A void of forgetfulness
    "Sovereign",    -- Supreme ruler
    "Zephyr",       -- A gentle wind
    "Nova",         -- A star bursting with brilliance
    "Guardian",     -- Defender and protector
    "Chimera",      -- A mythical hybrid beast
    "Cerberus",     -- Guardian of the underworld
    "Specter",      -- A ghostly apparition
    "Leviathan",    -- A sea monster of legend
    "Striker",      -- Swift and impactfulwords
    "Oracle",       -- Source of wisdom and foresight
    "Reaper",       -- Harbinger of fate
    "Bastion",      -- A stronghold of defense
    "Aurora",       -- The dawn or northern lights
    "Nemesis",      -- Agent of retribution
    "Cypher",        -- Keeper of secrets
    "Apollo",       -- God of light and prophecy
    "Artemis",      -- Goddess of the hunt and wilderness
    "Hades",        -- God of the underworld
    "Hyperion",     -- Titan of light
    "Nyx",          -- Primordial goddess of the night
    "Erebus",       -- Personification of darkness
    "Helios",       -- God of the sun
    "Thanatos",     -- Personification of death
    "Selene",       -- Goddess of the moon
    "Anubis",       -- Egyptian god of the dead and mummification
    "Raijin",       -- Japanese god of thunder
    "Susanoo",      -- Japanese god of storms and the sea
    "Kali",         -- Hindu goddess of destruction and transformation
    "Odin",         -- Allfather and Norse god of wisdom and war
    "Thor",         -- Norse god of thunder and strength
    "Freya",        -- Norse goddess of love and battle
    "Morrigan",     -- Celtic goddess of war and fate
    "Ares",         -- Greek god of war
    "Set",          -- Egyptian god of chaos and storms
    "Azazel",       -- Fallen angel, leader of the Watchers
    "Lilith",       -- First woman in some myths, later demonized
    "Behemoth",     -- Mythical beast of chaos
    "Asmodeus",     -- Demon of lust and wrath
    "Belial",       -- Symbol of worthlessness or deceit
    "Baal",         -- Ancient demon or god of storms
    "Leviathan",    -- Sea monster representing chaos
    "Mammon",       -- Demon of greed
    "Astaroth",     -- Demon prince of knowledge
    "Charybdis",    -- Sea monster creating deadly whirlpools
    "Fenrir",       -- Norse wolf destined to bring Ragnarok
    "Chernobog",    -- Slavic god of darkness and chaos
    "Abaddon",      -- Angel of destruction or abyss
    "Zagan",        -- Demon of alchemy and transformation
    "Dagon",        -- Philistine deity, later seen as a sea demon
    "Moloch",       -- God or demon associated with child sacrifice
    "Barbatos",     -- Demon of harmony and prophecy
    "Baphomet",     -- Symbol of balance and occult wisdom
    "Prometheus",   -- Titan who gifted fire to humanity
    "Hephaestus",   -- God of fire and craftsmanship
    "Janus",        -- Roman god of beginnings and duality
    "Eris",         -- Goddess of discord and chaos
    "Tiamat",       -- Babylonian primordial chaos dragon
    "Typhon",       -- Father of monsters in Greek mythology
    "Nemain",       -- Irish goddess of battle frenzy
    "Pele",         -- Hawaiian goddess of volcanoes and fire
    "Kukulkan",     -- Feathered serpent god of the Mayans
    "Moros",        -- Greek spirit of doom and fate
    "Izanami",      -- Japanese goddess of creation and death
    "Amaterasu",    -- Japanese sun goddess
    "Hecate",       -- Greek goddess of magic and crossroads
    "Skadi",        -- Norse goddess of winter and hunting
    "Ereshkigal",   -- Sumerian goddess of the underworld
    "Ouroboros",    -- Symbolic serpent eating its own tail
    "Phobos",       -- Greek god of fear and terror
    "Deimos",       -- Greek god of dread and panic
    "Yama",         -- Hindu and Buddhist lord of death
}


function staffpm.IsAdmin(ply)
    if ply:IsUserGroup("operator") then return true end
    if ply:IsUserGroup("admin") then return true end
    if ply:IsUserGroup("superadmin") then return true end
    if (Clockwork.player:IsAdmin(ply)) then return true end
    return false
end


staffpm.codenames = {}

function staffpm.AssignCodename(ply)
    if not IsValid(ply) then return end
    if not staffpm.IsAdmin(ply) then
        --print(string.format("[STAFF PM] %s is not admin to gain codename.", ply:Nick()))
        return
    end
    --print("[STAFF PM]Assigning a codename to " .. ply:Nick())
    -- Assign a random codename from the list
    if staffpm.codenames[ply] == nil then
        local availableCodenames = {}

        -- Find codenames not already assigned
        for _, codename in ipairs(staffpm.codenameList) do
            if not table.HasValue(staffpm.codenames, codename) then
                table.insert(availableCodenames, codename)
            end
        end

        -- Assign a codename if any are available
        if #availableCodenames > 0 then
            local randomCodename = availableCodenames[math.random(#availableCodenames)]
            staffpm.codenames[ply] = randomCodename
            --print(string.format("[STAFF PM] %s is now %s. ", ply:Nick(), randomCodename))
        else
            -- Fallback if all codenames are taken
            staffpm.codenames[ply] = "Anonymous"
        end
    end
end

function staffpm.RemoveCodename(ply)
    if IsValid(ply) then
        staffpm.codenames[ply] = nil
    end
end

function staffpm.GetCodename(ply)
    if not IsValid(ply) then return "Null" end
    local codename = staffpm.codenames[ply]
    return codename or "Null"
end

/* -------------------------------------------------------------------------- */
/*                                    Hooks                                   */
/* -------------------------------------------------------------------------- */

-- Hook for player connection
hook.Add("PlayerInitialSpawn", "AssignCodenameOnConnect", function(ply)
    staffpm.AssignCodename(ply)
end)

-- Hook for player disconnection
hook.Add("PlayerDisconnected", "RemoveCodenameOnDisconnect", function(ply)
    staffpm.RemoveCodename(ply)
end)

function PLUGIN:ChatBoxAdjustInfo(info)
    if (info.class == "staffpm") then
        staffpm.AssignCodename(info.speaker)
        info.data.codename = staffpm.GetCodename(info.speaker)
    end
end
