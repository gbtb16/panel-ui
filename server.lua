--[[
Informações:

	Nome do Servidor: SERVER (GTA 5)
	
	Versão: 0.1.2 (Beta 2019)
	
	Descrição: Plugin de interface do usuário. Informações inclusas, como:
	nome, servidor do discord, e IPs. (GTA 5)

	Feito para: Server

	Autoria de: Gabriel Tavares | Noorth
]]

Tunnel = module("vrp", "lib/Tunnel")
Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
Lclient = Tunnel.getInterface("vrp_carapicuiba")
Tunnel.bindInterface("vrp_carapicuiba",vRPl)
Proxy.addInterface("vrp_carapicuiba",vRPl)

AddEventHandler("vRP:playerSpawn", function(user_id, source, first_spawn)
  if first_spawn then
	local user_id = vRP.getUserId(source)
	local data = vRP.getUData(user_id,"vRP:firstid")
	if not data then
      Lclient.closePainel()
	else
	  local ldate = json.decode(data)
	  if not ldate then
        Lclient.closePainel()
	  end
	end
  end
end)