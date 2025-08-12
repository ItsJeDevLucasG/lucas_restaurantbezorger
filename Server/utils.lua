function SNotify(id, type, titel, beschrijving, duration)
    if not duration then
        duration = 5000
    end

    TriggerClientEvent('ox_lib:notify', id, { type = type, title = titel, description = beschrijving, duration = duration })
end



