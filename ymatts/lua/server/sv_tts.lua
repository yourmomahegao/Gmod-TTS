print( "-----------------------" )
print( "YMA Text To Speech is loading..." )


util.AddNetworkString("DoTTS")
util.AddNetworkString("OpenTTSMenu")

hook.Add("PlayerSay", "OnPlayerSay", function(sender, txt, teamChat)
	local TextMessage = txt

	if string.lower(TextMessage) != "!tts" then
		net.Start("DoTTS")
			net.WriteString(TextMessage)
		net.Broadcast()
	else
		net.Start("OpenTTSMenu")
		net.Send(sender)
	end
end)