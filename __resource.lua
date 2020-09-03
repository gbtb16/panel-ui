dependency 'vrp'
ui_page "html/index.html"

server_scripts {
	'@vrp/lib/utils.lua',
	'server.lua'
} 

client_script {
	'@vrp/lib/utils.lua',
	'client.lua'
} 

files {
    "html/index.html",
    "html/css/style.css",
    "html/css/reset.css",
    "html/fonts/chaletlondon.woff",
    "html/fonts/housescript.woff",
    "html/fonts/pricedown.woff"
}