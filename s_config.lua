T = {
    policeAmount = 1,
    policeJob = 'police', 
    max = 5, --Can only sell max pieces
    sellTime = 10, -- seconds
    rewardType = 'black_money', -- money / black_money / cash
    dispatch = {
        type = 'cd', -- aty / cd
        aty = { -- https://github.com/atiysuu/aty_dispatch
            title = 'Drug sales',
            code = 'B',
            blip = 140, -- https://docs.fivem.net/docs/game-references/blips/
        },
        cd = { -- https://codesign.pro/package/4206357
            title = '10-68 - Drug sales',
            message = ' sell drugs at ',
            blip = 140,
            scale = 1.0,
            colour = 1,
        }
    },
    drugs = { -- easy add!
        {
            label = 'Sell coke',
            icon = 'fa-solid fa-pills',
            item = 'coke', -- item spawn name
            min = 10, -- minimal price / kpl
            max = 50, -- maximal price / kpl
        },
        {
            label = 'Sell weed',
            icon = 'fa-solid fa-cannabis',
            item = 'weed', -- item spawn name
            min = 10, -- minimal price / kpl
            max = 50, -- maximal price / kpl
        }
    },
    strings = {
        nopolices = 'Not enough cops!',
        howManySell = 'Amount?',
        notPretty = 'You don´t have enought drugs..',
        sellingDrug = 'Selling..',
        canceled = 'Sell canceled!',
        pedoffer = 'I offer drugs',
        sell = 'Sell',
        dontSell = 'Dont Sell',
        YouSold = 'You sold x'
    },
    logs = {
        enable = false, -- true / false
        webhook = '', -- Discord webhook
        botname = 'T-Scripts',
        label = {
            player = 'Player: ',
            sell = 'Player sold drugs: x'
        }
    }
}