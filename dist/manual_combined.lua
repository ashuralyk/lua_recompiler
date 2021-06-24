--[[
	class.lua
]]

Class = {}

-- default (empty) constructor
function Class:init(...) end

-- create a subclass
function Class:extend(obj)
    local obj = obj or {}

    local function copyTable(table, destination)
        local table = table or {}
        local result = destination or {}

        for k, v in pairs(table) do
            if not result[k] then
                if type(v) == "table" and k ~= "__index" and k ~= "__newindex" then
                    result[k] = copyTable(v)
                else
                    result[k] = v
                end
            end
        end

        return result
    end

    copyTable(self, obj)

    obj._ = obj._ or {}

    local mt = {}

    -- create new objects directly, like o = Object()
    mt.__call = function(self, ...)
        return self:new(...)
    end

    -- allow for getters and setters
    mt.__index = function(table, key)
        local val = rawget(table._, key)
        if val and type(val) == "table" and (val.get ~= nil or val.value ~= nil) then
            if val.get then
                if type(val.get) == "function" then
                    return val.get(table, val.value)
                else
                    return val.get
                end
            elseif val.value then
                return val.value
            end
        else
            return val
        end
    end

    mt.__newindex = function(table, key, value)
        local val = rawget(table._, key)
        if val and type(val) == "table" and ((val.set ~= nil and val._ == nil) or val.value ~= nil) then
            local v = value
            if val.set then
                if type(val.set) == "function" then
                    v = val.set(table, value, val.value)
                else
                    v = val.set
                end
            end
            val.value = v
            if val and val.afterSet then val.afterSet(table, v) end
        else
            table._[key] = value
        end
    end

    setmetatable(obj, mt)

    return obj
end

-- set properties outside the constructor or other functions
function Class:set(prop, value)
    if not value and type(prop) == "table" then
        for k, v in pairs(prop) do
            rawset(self._, k, v)
        end
    else
        rawset(self._, prop, value)
    end
end

-- create an instance of an object with constructor parameters
function Class:new(...)
    local obj = self:extend({})
    if obj.init then obj:init(...) end
    return obj
end

function class(attr)
    attr = attr or {}
    return Class:extend(attr)
end

--[[
	card/base.lua
]]

local card_base = class({
    name   = "名字",
    color  = "颜色",
    type   = "类型",
    rare   = "稀有度",
    target = "目标类型"
})

function card_base:spell(user1, user2)
    local str = string.format("%s对%s施放%s卡 %s[%s] 造成%s%s伤害",
        user1, user2, self.type, self.name, self.color, self.rare, self.target)
    print(str)
end

--[[
	card/1.lua
]]

local card_1 = card_base:extend()

card_1.name   = "狂风之怒"
card_1.color  = "白色"
card_1.type   = "魔法"
card_1.rare   = "普通"
card_1.target = "群体"

--[[
	card/2.lua
]]

local card_2 = card_base:extend()

card_2.name   = "无情践踏"
card_2.color  = "蓝色"
card_2.type   = "魔法"
card_2.rare   = "稀有"
card_2.target = "单体"

--[[
	card/3.lua
]]

local card_3 = card_base:extend()

card_3.name   = "荒野巨人"
card_3.color  = "绿色"
card_3.type   = "怪物"
card_3.rare   = "普通"
card_3.target = "单体"

--[[
	card/4.lua
]]

local card_4 = card_base:extend()

card_4.name   = "愤怒的纳尔施小偷"
card_4.color  = "黑色"
card_4.type   = "怪物"
card_4.rare   = "史诗"
card_4.target = "群体"

--[[
	card/5.lua
]]

local card_5 = card_base:extend()

card_5.name   = "决斗"
card_5.color  = "红色"
card_5.type   = "瞬间魔法"
card_5.rare   = "稀有"
card_5.target = "单体"

--[[
	card/6.lua
]]

local card_6 = card_base:extend()

card_6.name   = "塔莫耶夫"
card_6.color  = "黑色"
card_6.type   = "怪物"
card_6.rare   = "史诗"
card_6.target = "单体"

--[[
	card/main.lua
]]

local cards = {
    ["b9aaddf96f7f5c742950611835c040af6b7024ad"] = card_1,
    ["10ad3f5012ce514f409e4da4c011c24a31443488"] = card_2,
    ["f37dfa5b009ea001acd3617886d9efecf31bb153"] = card_3,
    ["97bff01bcad316a4b534ef221bd66da97018df90"] = card_4,
    ["d046a18f7e01cb42e911fae2f11ba60c9c6834f8"] = card_5,
    ["36248218d2808d668ae3c0d35990c12712f6b9d2"] = card_6
}

function spell_card(source, target, card_hash)
    local card = cards[card_hash]
    if card == nil then
	error("non-existent hash: " .. card_hash)
    end
    card:spell(source, target)
end

function set_winner(user_type)
    _winner = user_type
end
