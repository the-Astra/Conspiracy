SMODS.Consumable {
    key = 'sighting',
    set = 'Conspiracy',
    atlas = 'Placeholder',
    pos = {
        x = 1,
        y = 2
    },
    config = {
        extra = {
            odds = 5,
            size = 1
        }
    },
    cost = 4,
    loc_vars = function(self, info_queue, card)
        local stg = card.ability.extra
        info_queue[#info_queue + 1] = G.P_CENTERS['c_cspy_conspiracy_dummy']

        local consp_count = Conspiracy.count_conspiracy_cards()

        return { vars = { SMODS.get_probability_vars(card, consp_count, stg.odds, 'sighting'), stg.size } }
    end,
    use = function(self, card, area, copier)
        local stg = card.ability.extra

        local consp_count = Conspiracy.count_conspiracy_cards() + 1

        if SMODS.pseudorandom_probability(card, 'sighting', consp_count, stg.odds) then
            G.GAME.round_resets.temp_handsize = G.GAME.round_resets.temp_handsize or 0
            G.GAME.round_resets.temp_handsize = G.GAME.round_resets.temp_handsize + stg.size
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.4,
                func = function()
                    card:juice_up()
                    play_sound('tarot1')
                    G.hand:change_size(stg.size)
                    return true;
                end
            }))
            delay(0.5)
        else
            G.E_MANAGER:add_event(Event({
                func = function()
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        delay = 0.4,
                        func = function()
                            attention_text({
                                text = localize('k_nope_ex'),
                                scale = 1.3,
                                hold = 1.4,
                                major = card,
                                backdrop_colour = G.C.SECONDARY_SET.Tarot,
                                align = (G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK or G.STATE == G.STATES.SMODS_BOOSTER_OPENED) and
                                'tm' or 'cm',
                                offset = { x = 0, y = (G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK or G.STATE == G.STATES.SMODS_BOOSTER_OPENED) and -0.2 or 0 },
                                silent = true
                            })
                            G.E_MANAGER:add_event(Event({
                                trigger = 'after',
                                delay = 0.06 * G.SETTINGS.GAMESPEED,
                                blockable = false,
                                blocking = false,
                                func = function()
                                    play_sound('tarot2', 0.76, 0.4); return true
                                end
                            }))
                            play_sound('tarot2', 1, 0.4)
                            card:juice_up(0.3, 0.5)
                            return true
                        end
                    }))
                    return true;
                end
            }))
        end
    end,
    can_use = function(self, card)
        return true
    end,
    set_badges = function(self, card, badges)
        if self.discovered then
            badges[#badges + 1] = create_badge(localize('k_cspy_artist') .. ': anerdymous', G.C.BLACK, G.C.WHITE, 1)
        end
    end
}
