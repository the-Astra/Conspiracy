SMODS.Consumable {
    key = 'society',
    set = 'Conspiracy',
    atlas = 'Placeholder',
    pos = {
        x = 1,
        y = 2
    },
    config = {
        extra = {
            prob = 0,
            odds = 5
        }
    },
    cost = 4,
    loc_vars = function(self, info_queue, card)
        local stg = card.ability.extra
        info_queue[#info_queue + 1] = G.P_CENTERS['c_cspy_conspiracy_dummy']

        local consp_count = 0
        if G.consumeables then
            for k, v in pairs(G.consumeables.cards) do
                if v.ability.set == 'Conspiracy' then
                    consp_count = consp_count + 1
                end
            end
        end

        return { vars = { stg.prob + consp_count, stg.odds } }
    end,
    use = function(self, card, area, copier)
        local stg = card.ability.extra

        local consp_count = 1
        for k, v in pairs(G.consumeables.cards) do
            if v.ability.set == 'Conspiracy' then
                consp_count = consp_count + 1
            end
        end

        if pseudorandom('society') < consp_count / stg.odds then
            for k, v in pairs(G.hand.cards) do
                if v:is_suit("Clubs") then
                    local eligible_jokers = {}
                    for kk, vv in pairs(G.jokers.cards) do
                        if not vv.edition or vv.marked_for_edition then
                            eligible_jokers[#eligible_jokers + 1] = vv
                        end
                    end

                    if next(eligible_jokers) then
                        local chosen_joker = pseudorandom_element(eligible_jokers, pseudoseed('society'))
                        chosen_joker.marked_for_edition = true
                        local _edition = poll_edition('society', nil, nil, true)

                        G.E_MANAGER:add_event(Event({
                            trigger = 'after',
                            delay = 0.3,
                            func = function()
                                chosen_joker.marked_for_edition = nil

                                chosen_joker:set_edition(_edition, true)
                                card:juice_up()
                                return true;
                            end
                        }))
                    end
                end
            end
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
                            if next(SMODS.find_mod('Maximus')) then
                                SMODS.calculate_context({ failed_prob = true, odds = consp_count, card = card })
                            end
                            return true
                        end
                    }))
                    return true;
                end
            }))
        end
    end,
    can_use = function(self, card)
        local stg = card.ability.extra

        return #G.hand.cards > 0
    end,
    set_badges = function(self, card, badges)
        if self.discovered then
            badges[#badges + 1] = create_badge(localize('k_cspy_artist') .. ': anerdymous', G.C.BLACK, G.C.WHITE, 1)
        end
    end
}
