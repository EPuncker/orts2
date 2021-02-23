-- Core API functions implemented in Lua
dofile('data/lib/core/core.lua')

-- Customs library:
dofile('data/lib/features/features.lua')
dofile('data/lib/quests/quests.lua')

-- Compatibility library for our old Lua API
dofile('data/lib/compat/compat.lua')

-- Debugging helper function for Lua developers
dofile('data/lib/debugging/dump.lua')
dofile('data/lib/debugging/lua_version.lua')
