fx_version 'adamant'

game 'gta5'

description 'ESX Forklift Driver Job'

author 'Karl Saunders'

version '0.1.1'

server_scripts {
    '@async/async.lua',
    '@mysql-async/lib/MySQL.lua',
    '@es_extended/locale.lua',
    'locales/en.lua',
    'config.lua',
    'server/main.lua'
}

client_scripts {
    '@es_extended/locale.lua',
    'locales/en.lua',
    'config.lua',
    'client/utils.lua',
    'client/main.lua'
}

dependencies {
    'es_extended',
    'esx_billing'
}