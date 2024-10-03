fx_version('cerulean')
game({ 'gta5' })
lua54('yes')

author('hajdenkoo')
description('Car Deleter System')
version('1.0.0')

shared_scripts({
    '@ox_lib/init.lua',
    'config/config_shared.lua'
});

client_scripts({
    'config/config_client.lua',
    'client/*.lua'
});

server_scripts({
    'config/config_server.lua',
    'server/*.lua'
});

files({
    'locales/*.json'
});

dependencies({
    'ox_lib'
});