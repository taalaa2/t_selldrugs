local ESX = exports['es_extended']:getSharedObject()

local function notify(msg, type)
    lib.notify(source, {
        description = msg,
        type = type
    })
end

lib.callback.register('t_selldrugs:SellDrugs', function(source, amount, item, pedoffer, label)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.getInventoryItem(item).count > amount - 1 then
        exports.ox_inventory:RemoveItem(source, item, amount)

        exports.ox_inventory:AddItem(source, T.rewardType, amount * pedoffer)

        notify(T.strings.YouSold.. '' ..amount.. ' ' ..label, 'success')

        if T.logs.enable == true then
            LOG('## Drug Sales \n\n' ..T.logs.label.player.. '' ..GetPlayerName(source).. '\n\n' ..T.logs.label.sell.. '' ..amount.. ' - ' ..item.. '\n\n' ..GetPlayerIdentifier(source))
        end
    else
        notify(T.strings.notPretty, 'error')
    end
end)


lib.callback.register('t_selldrugs:getPoliceCount', function(source)
    return #ESX.GetExtendedPlayers('job', T.policeJob)
end)

function LOG(message, color)
    local webhook = T.logs.webhook or ''
    local connect = {  {  ["description"] = message, ["color"] = color, ["footer"] = { ["text"] = os.date("\n📅 %d.%m.%Y \n⏰ %X"), }, } }
    PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = T.logs.botname, embeds = connect}), { ['Content-Type'] = 'application/json' })
end