local orders = {}
local recentCompletedOrders = {}

function GetPlayerLevelFromXP(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.getIdentifier()

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

    if heeftAlAccount then
        if response then
            for i = 1, #response do
                local row = response[i]
                local xp = row.verdientXp

                if not xp then
                    xp = 0
                end

                for _, i in pairs(Config.Level) do
                    if xp >= i.minXp and xp < i.maxXp then
                        return i.level
                    elseif xp <= i.minXp and xp > i.maxXp then
                        return 0
                    end
                end
            end
        end
    else
        return 0
    end
end

function GetData(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.getIdentifier()

    local response = MySQL.query.await('SELECT * FROM `lucas_bezorger` WHERE `identifier` = ?', {
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

    if heeftAlAccount then
        if response then
            for i = 1, #response do
                local row = response[i]
                local xp = row.verdientXp
                local verdientGeld = row.verdientGeld
                local geredenRitten = row.geredenRitten
                local level = GetPlayerLevelFromXP(source)

                if not xp then
                    xp = 0
                end

                if not verdientGeld then
                    verdientGeld = 0
                end

                if not geredenRitten then
                    geredenRitten = 0
                end

                TriggerClientEvent('lucas:restaurantbezorger:openUI', source, xp, verdientGeld, geredenRitten, level)
            end
        end
    else
        TriggerClientEvent('lucas:restaurantbezorger:openUI', source, 0, 0, 0, 0, 0)
    end
end

function GetVehicleByLevel(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.getIdentifier()
    local level = GetPlayerLevelFromXP(source)

    for _, auto in pairs(Config.Autos) do
        if level >= auto.minLevel then
            return auto.autoNaam
        end
    end
end

function GetRandomRestaurantOrder()
    local restaurantNames = {}
    for name in pairs(Config.Restaurants) do
        table.insert(restaurantNames, name)
    end

    local randomNaam = Config.Namen[math.random(1, #Config.Namen)]
    local chosenRestaurant = restaurantNames[math.random(1, #restaurantNames)]
    local restaurantItems = Config.Restaurants[chosenRestaurant].items
    local afhaalLocatie = Config.Restaurants[chosenRestaurant].afhaalLocatie
    local bezorgLocatie = Config.Restaurants[chosenRestaurant].bezorgLocaties[math.random(1, #Config.Restaurants[chosenRestaurant].bezorgLocaties)]

    local itemCount = math.random(1, math.min(4, #restaurantItems))

    local selectedItems = {}
    local usedIndexes = {}

    while #selectedItems < itemCount do
        local randomIndex = math.random(1, #restaurantItems)
        if not usedIndexes[randomIndex] then
            table.insert(selectedItems, restaurantItems[randomIndex])
            usedIndexes[randomIndex] = true
        end
    end

    return chosenRestaurant, selectedItems, afhaalLocatie, bezorgLocatie, randomNaam
end

RegisterServerEvent('lucas:restaurantbezorger:getData')
AddEventHandler('lucas:restaurantbezorger:getData', function(id)
    return GetData(id)
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
