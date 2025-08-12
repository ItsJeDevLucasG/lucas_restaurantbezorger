function SNotify(id, type, titel, beschrijving, duration)
    if not duration then
        duration = 5000
    end

    TriggerClientEvent('ox_lib:notify', id, { type = type, title = titel, description = beschrijving, duration = duration })
end

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
