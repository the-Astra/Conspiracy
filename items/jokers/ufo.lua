SMODS.Joker {
    key = 'ufo',
    atlas = 'Placeholder',
    pos = {
        x = 1,
        y = 0
    },
    rarity = 2,
    config = {
        extra = {
            multiplier = 2,
            prob = 1,
            odds = 4
        }
    },
    blueprint_compat = false,
    cost = 6,
    loc_vars = function(self, info_queue, card)
        local stg = card.ability.extra
        return {
            vars = { stg.multiplier, stg.prob * G.GAME.probabilities.normal, stg.odds }
        }
    end,
    calculate = function(self, card, context)
        local stg = card.ability.extra

        if context.end_of_round and not context.individual and not context.repetition and not context.blueprint then
            if pseudorandom('ufo') < (stg.prob * G.GAME.probabilities.normal) / stg.odds then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        card:start_dissolve()
                        return true;
                    end
                }))
                return {
                    message = localize('k_cspy_covered_up'),
                    func = function()
                        if next(SMODS.find_mod('Maximus')) then
                            SMODS.calculate_context({ failed_prob = true, odds = stg.odds - (stg.prob * G.GAME.probabilities.normal), card = card })
                        end
                    end
                }
            else
                return {
                    message = localize('k_saved_ex')
                }
            end
        end
    end,
    add_to_deck = function(self, card, from_debuff)
        local stg = card.ability.extra

        G.GAME.conspiracy_prob.normal = G.GAME.conspiracy_prob.normal * stg.multiplier
    end,
    remove_from_deck = function(self, card, from_debuff)
        local stg = card.ability.extra

        G.GAME.conspiracy_prob.normal = G.GAME.conspiracy_prob.normal / stg.multiplier
    end,
    set_badges = function(self, card, badges)
        if self.discovered then
            badges[#badges + 1] = create_badge(localize('k_mxms_artist') .. ': anerdymous', G.C.BLACK, G.C.WHITE, 1)
        end
    end
}
