--[[----------------------------------------------------------------------------
Helper Module for writing out simple INI files. Not much is being done to 
validate input.

@usage
local my_settings = require("INILua")("my_settings.ini")
my_settings:WriteKV("Foo", "Bar")
my_settings:WriteSection("Section 1")
my_settings:WriteKV("FooBar", 1,2,3,4)

@author Chris Tallman
@copyright (c) 2016 Chris Tallman
@module INI
------------------------------------------------------------------------------]]

local unpack = unpack or table.unpack
local valid_key_types = {["string"] = true}
local valid_val_types = {["string"] = true, ["number"] = true, ["boolean"] = true}
local valid_section_types = {["string"] = true}

local function valid_type(type_table, ...)
    local argv = {...}
    local argc = #argv
    if argc > 0 then
        for _,v in ipairs(argv) do
            if type_table[type(v)] ~= true then
                return false
            end
        end
        return true
    else
        return false
    end
end

local Writer = {}
function Writer:WriteSection(section)
    if valid_type(valid_section_types, section) then
        local file, err = io.open(self.filename, "a")
        if file and io.type(file) == "file" then
            file:write(string.format("\n[%s]\n", section))
            file:flush()
            file:close()
            return true
        else
            return nil, err
        end
    else
        return nil, "Invalid or missing parameters."
    end
end

function Writer:WriteKV(k, ...)
    if valid_type(valid_key_types, k) and valid_type(valid_val_types, ...) then
        local file, err = io.open(self.filename, "a")
        if file and io.type(file) == "file" then
            file:write(string.format("%s = %s\n", tostring(k), table.concat({...}, ",")))
            file:flush()
            file:close()
            return true
        else
            return nil, err
        end
    else
        return nil, "Invalid or missing parameters."
    end
end

local function CreateWriter(filename)
    if type(filename) == "string" then
        local file, err = io.open(filename, "w")
        if file then
            file:flush()
            file:close()
        else
            return nil, err
        end
        
        return setmetatable({}, {__index = setmetatable({filename = filename}, {__index = Writer})})
    else
        return nil, "Invalid or missing paramters."
    end
end

local INI =
{
    Writer = CreateWriter;
}

return setmetatable(INI, {__call = function(_,...) return CreateWriter(...) end})
