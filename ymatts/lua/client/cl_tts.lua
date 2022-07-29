net.Receive("DoTTS", function()
	TextMessage = net.ReadString()

	----------- Config -----------
    VOICE_NUMBER = 3  -- Choose voice from 1 to 6
    ------------------------------
    
    local function callbackSuccess(code, body)
        local j = util.JSONToTable(body)
        local link = j['URL']

        if file.Exists("ymattsconfig/ymattsconfig.json", "DATA") then
        	local TTSConfig = util.JSONToTable(file.Read("ymattsconfig/ymattsconfig.json", "DATA")) 
        end

        if file.Exists("ymattsconfig/ymattsconfig.json", "DATA") and TTSConfig != nil and TTSConfig[1] == "false" then
        else
        	if link == nil then
        		print(body)
        	else
		        sound.PlayURL(link, "noplay noblock", function(channel, errorid, errorname)
		        	if IsValid(channel) then
		        		channel:SetPos(LocalPlayer():GetPos())
		        		channel:SetVolume(0.7)
		        		channel:Play()
		        	end

		        	if errorname != nil then
		        		print("Не смогли произнести текст: " .. errorname)
		        	end
		    	end)
	    	end
	    end
    end
    
    local function requestSound(text)
        url = 'https://ttsmp3.com/makemp3_new.php'

        Body = {msg = text, lang = "Maxim", source = "ttsmp3"}
        local j = util.TableToJSON(Body, false)

        HTTP({success = callbackSuccess, failed = nil, method = "POST", url = url, parameters = Body, body = nil, type = "application/json", timeout = 5})
    end

    requestSound(TextMessage)
end)

-- TTS MENU

surface.CreateFont( "ttsText", {
	font = "Arial",
	extended = false,
	size = 24,
	weight = 1500,
	antialias = true,
} )

local function toggleTTSMenu()
	local scrw, scrh = ScrW(), ScrH()

	if IsValid(TTS) then
		return
	end

	local TTS = vgui.Create("DFrame")
	TTS:SetTitle("")
	TTS:SetSize(scrw / 3, scrh / 6)
	TTS:Center()
	
	TTS:MakePopup()
	TTS:RequestFocus()
	TTS:ShowCloseButton(false)
	TTS:SetDraggable(true)
	local TTSX, TTSY = TTS:GetSize()

	TTS.Paint = function(self,w,h)
		draw.RoundedBox( 10, 0, 0, w, h, Color( 35, 35, 35, 199 ) )
	end

	local TTSClose = vgui.Create("DButton", TTS)
	TTSClose:SetText("")
	TTSClose:SetSize(20, 20)
	TTSClose:SetPos((TTSX - 30), 10)
	local TTSCloseX, TTSCloseY = TTSClose:GetSize()
	TTSClose.Paint = function(self,w,h)
		draw.RoundedBox( 10, 0, 0, w, h, Color( 255, 100, 100, 155 ) )
		draw.RoundedBox( TTSClose:GetWide()/2, 5, 5, w - 10, h - 10, Color( 255, 100, 100, 255 ) )
	end

	TTSClose.DoClick = function()
		if IsValid(TTS) then
			TTS:Remove()
		end
	end

	local TTSEnable = TTS:Add("DCheckBox")
	TTSEnable:SetPos( 25, 50 )
	TTSEnable:SetSize(TTSX, 30)
	TTSEnable:SetValue( true )
	local TTSEnableX, TTSEnableY = TTSEnable:GetSize()

	TTSEnable.Paint = function(self,w,h)
		if TTSEnable:GetChecked() then
			draw.RoundedBox( 15, 5, 5 - 2, (TTSEnableY * 2) - 6, TTSEnableY - 6, Color( 100, 255, 100, 100 ) )
			draw.RoundedBox( 15, 5 + 2  + TTSEnableY, 5, TTSEnableY - 10, TTSEnableY - 10, Color( 255, 255, 255, 255 ) )
			draw.SimpleText("Включить озвучку текста", "ttsText", 65, TTSEnableY / 2, Color( 255, 255, 255, 235 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		else
			draw.RoundedBox( 15, 5, 5 - 2, (TTSEnableY * 2) - 6, TTSEnableY - 6, Color( 100, 100, 100, 100 ) )
			draw.RoundedBox( 15, 5 + 2, 5 + 2 - 2, TTSEnableY - 10, TTSEnableY - 10, Color( 255, 255, 255, 255 ) )
			draw.SimpleText("Включить озвучку текста", "ttsText", 65, TTSEnableY / 2, Color( 255, 255, 255, 235 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		end
	end

	local TTSSave = vgui.Create("DButton", TTS)
	TTSSave:SetText("")
	TTSSave:SetSize(150, 50)
	TTSSave:SetPos(TTSX / 2 - 60 - 10, TTSY - 50 - 10)
	local TTSSaveX, TTSSaveY = TTSSave:GetSize()
	TTSSave.Paint = function(self,w,h)
		draw.RoundedBox( 10, 0, 0, w, h, Color( 100, 255, 100, 155 ) )
		draw.SimpleText("Сохранить", "ttsText", TTSSaveX / 2, TTSSaveY / 2 - 1, Color( 255, 255, 255, 235 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

	TTSSave.DoClick = function()
		if IsValid(TTS) then
			if !file.Exists("ymattsconfig", "DATA") then
				file.CreateDir("ymattsconfig")
			end


			TTSConfig = {tostring(TTSEnable:GetChecked())}
			file.Write("ymattsconfig/ymattsconfig.json", util.TableToJSON(TTSConfig, true))
			TTS:Close()
		end
	end

end

net.Receive("OpenTTSMenu", function()
	toggleTTSMenu()
end)