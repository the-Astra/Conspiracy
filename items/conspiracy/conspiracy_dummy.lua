SMODS.Consumable {
    key = 'conspiracy_dummy',
    set = 'Conspiracy',
    atlas = 'Placeholder',
    pos = {
        x = 1,
        y = 2
    },
    config = {

    },
    cost = 4,
    no_collection = true,
    loc_vars = function(self, info_queue, card)
        local stg = card.ability.extra

        return { vars = {} }
    end,
    in_pool = function(self, args)
        return false
    end,
    set_badges = function(self, card, badges)
        if self.discovered then
            badges[#badges + 1] = create_badge(localize('k_cspy_artist') .. ': anerdymous', G.C.BLACK, G.C.WHITE, 1)
        end
    end
}
