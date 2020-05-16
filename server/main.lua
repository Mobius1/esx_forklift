ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('esx_flt:ready', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.job.name ~= nil and xPlayer.job.name == 'flt' then
        cb(xPlayer, true)
    end
end)

RegisterServerEvent('esx_flt:getPaid')
AddEventHandler('esx_flt:getPaid', function(amount)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.addMoney(math.floor(amount))	
end)