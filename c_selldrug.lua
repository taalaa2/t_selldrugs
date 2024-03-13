local ESX = exports['es_extended']:getSharedObject()

local function notify(msg, type)
    lib.notify({
        description = msg,
        type = type
    })
end

local function Dispatch()
    if T.dispatch.type == 'cd' then
        local data = exports['cd_dispatch']:GetPlayerInfo()
        TriggerServerEvent('cd_dispatch:AddNotification', {
            job_table = {T.policeJob}, 
            coords = data.coords,
            title = T.dispatch.cd.title,
            message = ''..data.sex..'' ..T.dispatch.cd.message.. '' ..data.street, 
            flash = 0,
            unique_id = data.unique_id,
            sound = 1,
            blip = {
                sprite = T.dispatch.cd.blip, 
                scale = T.dispatch.cd.scale, 
                colour = T.dispatch.cd.colour,
                flashes = false, 
                text = T.dispatch.cd.title,
                time = 5,
                radius = 0,
            }
        })
    elseif T.dispatch.type == 'aty' then
        exports['aty_dispatch']:SendDispatch(T.dispatch.aty.title, T.dispatch.aty.code, T.dispatch.aty.blip, {T.policeJob})
    end
end


for i,v in ipairs(T.drugs) do
    exports.ox_target:addGlobalPed({
        {
            label = v.label,
            icon = v.icon,
            items = v.item,
            distance = 2,
            canInteract = function()
                return not cache.vehicle
            end,
            onSelect = function(data)
                local policeCount = lib.callback.await('t_selldrugs:getPoliceCount', false)
                if policeCount < T.policeAmount then
                    notify(T.strings.nopolices, 'error')
                    return
                end

                if not IsEntityDead(data.entity) then
                    lib.requestAnimDict('anim@heists@humane_labs@finale@strip_club', 100)
                    TaskPlayAnim(data.entity, 'anim@heists@humane_labs@finale@strip_club', 'ped_b_celebrate_loop', 3.0, 3.0, -1, 19, 0, false, false, false)
    
                    FreezeEntityPosition(data.entity, true)
    
                    local drugsMenu = lib.inputDialog(v.label, {
                        { type = 'number', label = T.strings.howManySell, icon = v.icon, required = true, max = T.max}
                    })
    
                    if drugsMenu then
                        Dispatch()
                        local selling = lib.progressCircle({
                            label = T.strings.sellingDrug,
                            duration = T.sellTime * 1000,
                            position = 'bottom',
                            allowCuffed = false,
                            allowFalling = false,
                            canCancel = true,
                            allowRagdoll = false,
                            disable = {
                                car = true,
                                move = true,
                            },
                            anim = {
                                dict = 'anim@heists@humane_labs@finale@strip_club',
                                clip = 'ped_b_celebrate_loop',
                                flag = 1,
                            }
                        })
    
                        if selling then
                            local pedoffer = math.random(v.min, v.max)
    
                            local offer = lib.alertDialog({
                                header = v.label,
                                content = T.strings.pedoffer.. ' $' ..pedoffer,
                                centered = true,
                                cancel = true,
                                labels = {
                                    confirm = T.strings.sell,
                                    cancel = T.strings.dontSell,
                                }
                            })
    
                            if offer == 'confirm' then
                                lib.requestAnimDict('mp_common', 100)
                                TaskPlayAnim(data.entity, 'mp_common', 'givetake1_a', 3.0, 3.0, -1, 19, 0, false, false, false)
        
                                -- you
                                lib.requestAnimDict('mp_common', 100)
                                TaskPlayAnim(cache.ped, 'mp_common', 'givetake1_a', 3.0, 3.0, -1, 19, 0, false, false, false)
        
                                Citizen.Wait(2000)
        
                                FreezeEntityPosition(data.entity, false)
                                ClearPedTasks(data.entity)
                                ClearPedTasks(cache.ped)
        
                                -- success
                                
                                local amount = drugsMenu[1]
                                local item = v.item
                                local label = v.item
            
                                lib.callback.await('t_selldrugs:SellDrugs', source, amount, item, pedoffer, label)
                            else
                                FreezeEntityPosition(data.entity, false)
                                ClearPedTasks(data.entity)
                            end
                        else
                            notify(T.strings.canceled, 'error')
                        end
                    else
                        ClearPedTasks(data.entity)
                        FreezeEntityPosition(data.entity, false)
                    end
                else
                    notify(T.strings.YouCantSellDeath, 'error')
                end
            end
        }
    })
end
