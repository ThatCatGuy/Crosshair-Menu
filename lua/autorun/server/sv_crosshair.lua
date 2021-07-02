hook.Add("PlayerInitialSpawn", "CatGuy_DisableDefaultCrosshair", function(ply)
	ply:CrosshairDisable()
end)
