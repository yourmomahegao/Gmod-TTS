if SERVER then
	include( "server/sv_tts.lua" )
	AddCSLuaFile( "client/cl_tts.lua" )
end

if CLIENT then
	include( "client/cl_tts.lua" )
end

print( "YMA Text To Speech loading done." )
print( "-----------------------" )