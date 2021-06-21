local cards = {
    ["b9aaddf96f7f5c742950611835c040af6b7024ad"] = require "cards.1",
    ["10ad3f5012ce514f409e4da4c011c24a31443488"] = require "cards.2",
    ["f37dfa5b009ea001acd3617886d9efecf31bb153"] = require "cards.3",
    ["97bff01bcad316a4b534ef221bd66da97018df90"] = require "cards.4",
    ["d046a18f7e01cb42e911fae2f11ba60c9c6834f8"] = require "cards.5",
    ["36248218d2808d668ae3c0d35990c12712f6b9d2"] = require "cards.6"
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