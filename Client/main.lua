local restaurant = ''
local orderId = ''
local bestellingCoords = ''
local afhaalCoords = ''
local heeftActieveBestelling = false
local isLangsAfhaalGeweest = false
local heeftBezorgd = false
local jobVehicle, jobVehicleProps

exports.ox_target:addBoxZone({ 
    coords = Config.Locaties.Bezorger.pos, 
    options = {
        {
            label = "Open het Bezorger Menu",
            icon = "fa-solid fa-box",
            onSelect = function()
                if ESX.PlayerData.job.name == "restaurantbezorger" or ESX.PlayerData.job2.name == "restaurantbezorger" then
                    TriggerServerEvent('lucas:restaurantbezorger:getData', GetPlayerServerId(PlayerId()))
                else
                    CNotify("error", "Bezorger", "Je moet naar het UWV Bureau gaan om de Restaurant Bezorger baan aan te nemen.")
                end
            end
        }
    } 
})

Citizen.CreateThread(function()
    if ESX.PlayerData.job.name == "restaurantbezorger" then
        MainLoop()
    end
end)

RegisterNetEvent("esx:setJob") 
AddEventHandler('esx:setJob', function(job)
    if job.name == "restaurantbezorger" then
        MainLoop()
    end
end)

function MainLoop()
	for _, info in pairs(Config.Locaties) do
        info.blip = AddBlipForCoord(info.pos.x, info.pos.y, info.pos.z)
        SetBlipSprite(info.blip, info.sprite)
        SetBlipDisplay(info.blip, 4)
        SetBlipScale(info.blip, 1.0)
        SetBlipColour(info.blip, 2)
        SetBlipAsShortRange(info.blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(info.naam)
        EndTextCommandSetBlipName(info.blip)
	end
end

local function ResetBestelling()
    restaurant = ''
    orderId = ''
    bestellingCoords = ''
    afhaalCoords = ''
    heeftActieveBestelling = false
    isLangsAfhaalGeweest = false
    heeftBezorgd = false
    if IsWaypointActive() then
        SetWaypointOff()
    end
    if jobVehicle then
        DeleteEntity(jobVehicle)
        jobVehicle = nil
    end
end

RegisterNetEvent('lucas:restaurantbezorger:openUI')
AddEventHandler('lucas:restaurantbezorger:openUI', function(xpData, verdientGeldData, geredenRittenData, levelData)
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = "open",
        heeftBestelling = heeftActieveBestelling,
        xp = xpData,
        verdientGeld = verdientGeldData,
        geredenRitten = geredenRittenData,
        level = levelData,
    })
end)

RegisterNetEvent('lucas:restaurantbezorger:finishOrderClient')
AddEventHandler('lucas:restaurantbezorger:finishOrderClient', function()
    ResetBestelling()
end)

RegisterNetEvent('lucas:restaurantbezorger:maakOrderClient')
AddEventHandler('lucas:restaurantbezorger:maakOrderClient', function(afhaalVector, bestellingVector, restaurantNaam, bestellingId, model)
    if not afhaalVector or not bestellingVector or not restaurantNaam or not bestellingId then return end
    SetNewWaypoint(afhaalVector.x, afhaalVector.y)
    bestellingCoords = bestellingVector
    heeftActieveBestelling = true
    restaurant = restaurantNaam
    orderId = bestellingId

    afhaalCoords = Config.Restaurants[restaurantNaam].afhaalLocatie

    local ped = PlayerPedId()
    local modelHash = GetHashKey(model)
    RequestModel(modelHash)
    while not HasModelLoaded(modelHash) do Wait(10) end
    local veh = CreateVehicle(modelHash, 256.5731, 357.5355, 105.5254 + 0.5, 158.9342, true, false)
    SetVehicleNumberPlateText(veh, 'BEZORGER')
    TaskWarpPedIntoVehicle(ped, veh, -1)
    SetEntityAsNoLongerNeeded(veh)

    local vehProps = ESX.Game.GetVehicleProperties(veh)
    TriggerServerEvent('esx_givecarkeys:setVehicleOwnedPlayerId', GetPlayerServerId(PlayerId()), vehicleProps)

    jobVehicle = veh
    jobVehicleProps = vehProps
end)

Citizen.CreateThread(function()
    while true do
        while heeftActieveBestelling do
            if not isLangsAfhaalGeweest then
                DrawMarker(2, afhaalCoords.x, afhaalCoords.y, afhaalCoords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 0, 255, 0, 50, true, false, 2, nil, nil, false)
            end
            if not heeftBezorgd and isLangsAfhaalGeweest then
                DrawMarker(2, bestellingCoords.x, bestellingCoords.y, bestellingCoords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 0, 255, 0, 50, true, false, 2, nil, nil, false)
            end
            if heeftBezorgd then
                DrawMarker(2, 227.5173, 359.4827, 105.8895, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 0, 255, 0, 50, true, false, 2, nil, nil, false)
            end

            Wait(0)
            local playerPos = GetEntityCoords(PlayerPedId())
            local afhaalDist = GetDistanceBetweenCoords(afhaalCoords.x, afhaalCoords.y, afhaalCoords.z, playerPos.x, playerPos.y, playerPos.z, true)
            local bezorgDist = GetDistanceBetweenCoords(bestellingCoords.x, bestellingCoords.y, bestellingCoords.z, playerPos.x, playerPos.y, playerPos.z, true)
            local eindDist = GetDistanceBetweenCoords(227.5173, 359.4827, 105.8895, playerPos.x, playerPos.y, playerPos.z, true)

            if afhaalDist <= 3 and bezorgDist <= 3 and eindDist <= 3 then
                lib.hideTextUI()
            end

            if afhaalDist <= 3 then
                lib.showTextUI('[E] - Haal de bestelling op')
                if IsControlJustReleased(0, 51) then
                    FreezeEntityPosition(jobVehicle, true)
                    if lib.progressBar({
                        duration = 10000,
                        label = 'Bestelling aan het ophalen...',
                        useWhileDead = false,
                        canCancel = false,
                        disable = {
                            move = true,
                            car = true,
                            combat = true,
                            mouse = false,
                            sprint = true
                        },
                    }) then
                        FreezeEntityPosition(jobVehicle, false)
                        SetNewWaypoint(bestellingCoords.x, bestellingCoords.y)
                        CNotify('success', 'Bezorger', 'Je hebt de bestelling opgehaald bij ' .. restaurant .. ', Je kan nu naar de klant toe rijden de GPS is ingesteld.')
                        isLangsAfhaalGeweest = true
                    end
                end
            else
                lib.hideTextUI()
            end

            if bezorgDist <= 3 and isLangsAfhaalGeweest and not heeftBezorgd then
                lib.showTextUI('[E] - Lever de bestelling af')
                if IsControlJustReleased(0, 51) then
                    if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
                        CNotify('error', 'Bezorger', 'Stap uit het voertuig om de bestellig af te leveren.')
                    else
                        if lib.progressBar({
                            duration = 10000,
                            label = 'Bestelling aan het afleveren...',
                            useWhileDead = false,
                            canCancel = false,
                            disable = {
                                move = true,
                                car = true,
                                combat = true,
                                mouse = false,
                                sprint = true
                            },
                            anim = {
                                dict = 'timetable@jimmy@doorknock@',
                                clip = 'knockdoor_idle'
                            },
                        }) then
                            heeftBezorgd = true
                            CNotify('success', 'Bezorger', 'Je hebt de bestelling afgeleverd bij de klant, rij nu terug naar de werkgever om de opdracht af te ronden.')
                            SetNewWaypoint(227.5173, 359.4827, 105.8895)
                        end
                    end
                end
            else
                lib.hideTextUI()
            end  

            if eindDist <= 3 and heeftBezorgd then
                lib.showTextUI('[E] - Zet auto weg')
                if IsControlJustReleased(0, 51) then
                    if not IsPedInAnyVehicle(GetPlayerPed(-1), false) then
                        CNotify('error', 'Bezorger', 'Je moet in het bezorger voertuig zitten om de bezorging af te maken.')
                    else
                        local currentVehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
                        if GetVehicleNumberPlateText(currentVehicle) ~= 'BEZORGER' then
                            CNotify('error', 'Bezorger', 'Je moet in het bezorger voertuig zitten om de bezorging af te maken. Eigen auto`s zijn niet toegestaan.')
                        else
                            FreezeEntityPosition(jobVehicle, true)
                            if lib.progressBar({
                                duration = 10000,
                                label = 'Auto aan het wegzetten...',
                                useWhileDead = false,
                                canCancel = false,
                                disable = {
                                    move = true,
                                    car = true,
                                    combat = true,
                                    mouse = false,
                                    sprint = true
                                }
                            }) then
                                FreezeEntityPosition(jobVehicle, false)
                                TriggerServerEvent('lucas:restaurantbezorger:finishOrder', GetPlayerServerId(PlayerId()), orderId)
                                ResetBestelling()
                                DeleteVehicle(jobVehicle)
                            end
                        end
                    end
                end
            else
                lib.hideTextUI()
            end
        end
        Wait(200)
    end
end)

RegisterNUICallback("close", function(_, cb)
    SetNuiFocus(false, false)
    uiOpen = false
    cb("ok")
end)

RegisterNUICallback("startLevering", function(_, cb)
    TriggerServerEvent('lucas:restaurantbezorger:maakOrder', GetPlayerServerId(PlayerId()))
    cb("ok")
end)

RegisterNUICallback("stopLevering", function(_, cb)
    ResetBestelling()
    cb("ok")
end)