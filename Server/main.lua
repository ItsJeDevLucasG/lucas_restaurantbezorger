local orders = {}
local recentCompletedOrders = {}

RegisterServerEvent('lucas:restaurantbezorger:getData')
AddEventHandler('lucas:restaurantbezorger:getData', function(id)
    return GetData(id)
end)

RegisterServerEvent('lucas:restaurantbezorger:resetOrder')
AddEventHandler('lucas:restaurantbezorger:resetOrder', function(orderId, id)

end)

RegisterServerEvent('lucas:restaurantbezorger:finishOrder')
AddEventHandler('lucas:restaurantbezorger:finishOrder', function(id, orderId)
    local xPlayer = ESX.GetPlayerFromId(id)
    local identifier = xPlayer.getIdentifier()

    if not orders[orderId] and recentCompletedOrders[orderId] ~= nil then
        return exports['esx_addons']:fg_BanPlayer(id, "Probeerde de triger lucas:restaurantbezorger:betaal te triggeren. Maar de order bestond niet en stond in de lijst van de recente gedaan orders.", true)
    end

    if orders[orderId].Bezorger ~= identifier then
        return exports['esx_addons']:fg_BanPlayer(id, "Probeerde de triger lucas:restaurantbezorger:betaal te triggeren. Maar deze persoon was niet de bezorger.", true)
    end

    local kmStand = orders[orderId].km
    local playerLevel = GetPlayerLevelFromXP(id)
    local multiplier = 0
    local geldVerdient = math.random(Config.Payouts.prijsPerKilometer.min, Config.Payouts.prijsPerKilometer.max) * kmStand

    for _, item in pairs(orders[orderId].OrderItems) do
        multiplier = multiplier + Config.Payouts.prijsPerItem
    end

    multiplier = multiplier + (Config.Payouts.bonusPerLevel * playerLevel)

    local totalGeld = math.floor(geldVerdient / 100 * (100 + multiplier))
    local totalXp = math.floor(totalGeld / 10)

    local response = MySQL.query.await('SELECT `verdientGeld` FROM `lucas_bezorger` WHERE `identifier` = ?', {
        identifier
    })

    local heeftAlAccount = false

    if response then
        for i = 1, #response do
            local row = response[i]
            if row.verdientGeld ~= nil then
                heeftAlAccount = true
            end
        end
    end

    if not heeftAlAccount then
        MySQL.insert('INSERT INTO `lucas_bezorger` (identifier, verdientGeld, verdientXp, geredenRitten) VALUES (?, ?, ?, ?)', {
            identifier, totalGeld, totalXp, 1
        }, function()
            SNotify(id, 'success', 'Bezorger', 'Je hebt succesvol de rit voltooid, je hebt: ' .. totalGeld .. ' en ' .. totalXp .. ' XP verdient met deze rit!')
            xPlayer.addAccountMoney('bank', totalGeld)
                    
            orders[orderId] = nil
            recentCompletedOrders[orderId] = true
            TriggerClientEvent('lucas:restaurantbezorger:finishOrderClient', id)
        end)
    else
        exports.oxmysql:update('UPDATE lucas_bezorger SET verdientGeld = verdientGeld + ?, verdientXp = verdientXp + ?, geredenRitten = geredenRitten + ? WHERE identifier = ?',
            { totalGeld, totalXp, 1, identifier },
            function(affectedRows)
                if affectedRows > 0 then
                    SNotify(id, 'success', 'Bezorger', 'Je hebt succesvol de rit voltooid, je hebt: ' .. totalGeld .. ' en ' .. totalXp .. ' XP verdient met deze rit!')
                    xPlayer.addAccountMoney('bank', totalGeld)

                    orders[orderId] = nil
                    recentCompletedOrders[orderId] = true
                    TriggerClientEvent('lucas:restaurantbezorger:finishOrderClient', id)
                else
                    SNotify(id, 'error', 'Bezorger', '2')
                end
            end
        )
    end
end)

RegisterServerEvent('lucas:restaurantbezorger:maakOrder')
AddEventHandler('lucas:restaurantbezorger:maakOrder', function(id)
    local xPlayer = ESX.GetPlayerFromId(id)
    local identifier = xPlayer.getIdentifier()

    local orderId = math.random(1000, 9999)
    local vehicle = GetVehicleByLevel(id)
    local restaurant, items, afhaalLocatie, bezorgLocatie, naamBestelling = GetRandomRestaurantOrder()
    local afstand = #(afhaalLocatie - bezorgLocatie)
    local afstandHemelsbreed = math.floor(afstand) / 1000

    orders[orderId] = { ['Bezorger'] = identifier, ['km'] = afstandHemelsbreed, ['OrderItems'] = items, ['Restaurant'] = restaurant }
    TriggerClientEvent('lucas:restaurantbezorger:maakOrderClient', id, afhaalLocatie, bezorgLocatie, restaurant, orderId, vehicle)
    SNotify(id, 'success', 'Bezorger', 'Je hebt een nieuwe bestelling gestart, je moet naar de locatie aangegeven op je GPS en je rijd voor het bedrijf: ' .. restaurant .. '.')
    SNotify(id, 'inform', 'Bezorger', 'De order info is alsvolgd: OrderId: ' .. orderId .. ', je vervoert de volgende item(s): ' .. table.unpack(items) .. ', de persoon zijn naam is: ' .. naamBestelling .. '.', 15000)

end)
