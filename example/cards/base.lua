require "class"

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

return card_base