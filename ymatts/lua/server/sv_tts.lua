print( "-----------------------" )
print( "YMA Text To Speech is loading..." )


util.AddNetworkString("DoTTS")
util.AddNetworkString("OpenTTSMenu")

hook.Add("PlayerSay", "OnPlayerSay", function(sender, txt, teamChat)
	local TextMessage = txt

	if string.sub(string.lower(TextMessage), 0, 1) != "!" then
		net.Start("DoTTS")
			net.WriteString(TextMessage)
		net.Broadcast()
	elseif string.lower(TextMessage) == "!tts" then
		net.Start("OpenTTSMenu")
		net.Send(sender)
	end
end)