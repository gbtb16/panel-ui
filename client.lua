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

vRPl = {}
vRP = Proxy.getInterface("vRP")
Lserver = Tunnel.getInterface("vrp_carapicuiba")
Tunnel.bindInterface("vrp_carapicuiba",vRPl)
Proxy.addInterface("vrp_carapicuiba",vRPl)

local display = true -- variável que verifica se está mostrando a UI
 
--	Funções para controle do mouse na tela de interação (UI)

local isCursorShowing = true -- Verifica se o cursor está sendo mostrado
local uiHasFocus = true -- verifica se a UI está em foco

-- Altera a variável isCursorShowing que controla se o mouse é mostrado ou não
function ShowCursor(bEnabled, bUIFocus)
	if(bEnabled) then
		isCursorShowing = true
	else
		isCursorShowing = false
	end
	-- Argumento opcional, para que possamos basicamente fazer SetUIFocused com esta função
	if(bUIFocus == true) then
		uiHasFocus = true
	end
end

-- Retorna se o cursor está mostrando ou não no momento
function IsCursorShowing()
	return isCursorShowing
end

-- Define a interface do usuário como focada, desativa a entrada do mouse para olhar ao redor
function SetUIFocused(bEnabled)
	if(bEnabled) then
		uiHasFocus = true
	else
		uiHasFocus = false
	end
end

-- Retorna se no momneto a UI está focada ou não
function IsUIFocused()
	return uiHasFocus
end

-- Obtém a posição do cursor, valores relativos. 0,0, 0,0 = canto superior esquerdo. 1,0, 1,0 = canto inferior direito.
function GetCursorPosition()
	if(isCursorShowing) then
		local cursorX, cursorY = GetControlNormal(0, 239), GetControlNormal(0, 240)
		return cursorX, cursorY
	end
end

-- Verifica se o cursor está dentro da área especificada. Útil para simular o mouse com botão de girar
function IsCursorWithinArea(posX, posY, sizeX, sizeY)
	if(isCursorShowing) then
		local cursorX, cursorY = GetCursorPosition()
		if(cursorX >= posX and cursorX <= posX+sizeX) and (cursorY >= posY and cursorY <= posY+sizeY) then
			return true
		else
			return false
		end
	else
		return false
	end
end

-- Open Form and Focus NUI
function vRPl.openPainel()
	display = true
  	ShowCursor(true, true)
	SetUIFocused(true)
  SetNuiFocus(true, true)
  SendNUIMessage({openPainel = true})
end

-- Close Form and Unfocus NUI
function vRPl.closePainel()
	display = false
	ShowCursor(false, false)
	SetUIFocused(false)
	SetNuiFocus(false, false)
	SendNUIMessage({closePainel = true})
end

RegisterNUICallback('close', function(data, cb)
 	vRPl.closePainel()

 	cb('ok')
end)

-- Thread assíncrono que faz toda a magia
Citizen.CreateThread(function()
	openPainel();
	SetNuiFocus(true,true)
	while (true) do
		Citizen.Wait(0)
		-- Mostra o Cursor
		if(isCursorShowing) then
			ShowCursorThisFrame()
		end
		-- Foco da UI
        if(uiHasFocus) then
			DisableControlAction(0, 1, uiHasFocus)		-- Movimento do Mouse, Esquerda/Direita
			DisableControlAction(0, 2, uiHasFocus)		-- Movimento do Mouse, Cima/Baixo
            DisableControlAction(0, 142, uiHasFocus)	-- Botão Direito
            if IsDisabledControlJustReleased(0, 1) then -- Detect trying attack
       			SendNUIMessage({type = "click"}) -- Send attack as click
      		end
		else
			EnableControlAction(0, 1, not uiHasFocus)	-- Movimento do Mouse, Esquerda/Direita
			EnableControlAction(0, 2, not uiHasFocus)	-- Mouse Look, Up/Down
            EnableControlAction(0, 142, not uiHasFocus)	-- Botão Direito
		end
		if (display) then
			ShowCursor(true, true)
			SetUIFocused(true)
			SetNuiFocus(true,true) -- muito importante deixar essa função
			SendNUIMessage({openPainel = true})
		else
			ShowCursor(false, false)
			SetUIFocused(false)
			SetNuiFocus(false,false) -- muito importante deixar essa função
			SendNUIMessage({closePainel = true})
		end
	end
end)

-- --Thread que faz o mouse aparecer e estar focado na UI quando o player entra no servidor

-- Citizen.CreateThread(function()
-- 	TriggerEvent("send",true)
-- 	ShowCursor(true, true)
-- 	SetUIFocused(true)
-- 	SetNuiFocus(true,true) -- muito importante deixar essa função
-- end)

-- -- Registrando o evento "send"

-- RegisterNetEvent("send")
-- AddEventHandler("send", function() -- Função desse evento
--     SendNUIMessage({
--         type = "ui",
--         display = true
--     })
-- end)

-- -- Registrando a chamada de volta do JS quando o botão é pressionado
-- RegisterNUICallback("send", function(data, cb)
-- 	ShowCursor(false, false)
-- 	SetUIFocused(false)
-- 	SetNuiFocus(false,false)
-- 	cb('ok')
-- end)