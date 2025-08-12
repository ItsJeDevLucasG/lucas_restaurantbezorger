fx_version 'cerulean'
game 'gta5'

shared_scripts {
    "Config/config.lua",
    "@mysql-async/lib/MySQL.lua",
    "@ox_lib/init.lua",
    "@es_extended/imports.lua"
}

server_scripts {
    "Server/**.*"
}

client_scripts {
    "Client/**.*"
}

ui_page 'html/index.html'

files {
    'html/**.*'
}

