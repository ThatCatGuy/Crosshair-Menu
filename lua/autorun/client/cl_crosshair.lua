local OpenWithKey = CatGuy_Crosshair.OpenWithKey
local OpenKey		= CatGuy_Crosshair.OpenKey
-- Paste the SVG Code and remove the style="fill:#abc;" is present to allow color overwrite
local Crosshairs = CatGuy_Crosshair.List
local FrameOpen = CatGuy_Crosshair.FrameOpen
local ActiveCrosshair 	= CatGuy_Crosshair.Default -- DEFAULT CROSSHAIR
local ActiveColor = CatGuy_Crosshair.DefaultColour
local ActiveSize = CatGuy_Crosshair.DefaultSize	-- DEFAULT SIZE
local function SetActiveColor(x,func)
	--if !IsColor(x) then return false end
	ActiveColor = x["r"]..","..x["g"]..","..x["b"]
	if func != nil then func() end
end
-- CONFIG END
local CanISEETHAT = false
hook.Add( "HUDPaint", "CatGuy_Crosshair", function()
	if !CanISEETHAT then
		CanISEETHAT = true
		
		local CrosshairPanel = vgui.Create("HTML")
		CrosshairPanel:SetSize(ActiveSize, ActiveSize)
		CrosshairPanel:Center()
		CrosshairPanel:SetHTML(Crosshairs[ActiveCrosshair]..[[<style> *{margin:0;padding:0;} svg{width:100%;height:100%;fill:rgb(]]..ActiveColor..[[);}</style>]])
		
		
		local function CrosshairGUI()
			
			SetActiveColor(Color(30,30,30,255)) -- DEFAULT COLOR
			if OldFrameCross and IsValid(OldFrameCross) then OldFrameCross:Remove() OldFrameCross = nil end
    		local Frame = vgui.Create("DFrame")
    		Frame:SetTitle("Pick your Crosshair")
    		Frame:SetPos(ScrW() / 2, ScrH() / 2)

    		Frame:SetSize(600, 340)
    		Frame:ShowCloseButton(true)
    		Frame:MakePopup()
    		OldFrameCross = Frame

			function Frame:OnClose()
				hook.Remove("Think", "CrosshairMenuColorChange")
				FrameOpen = false
			end

			local ConfirmBtn = vgui.Create("DButton", Frame)
			ConfirmBtn:Dock(BOTTOM)
			ConfirmBtn:DockMargin(5, 5, 5, 5)
			ConfirmBtn:SetTall(45)
			ConfirmBtn:SetFont("DebugFixed")
			ConfirmBtn:SetTextColor(Color(220, 220, 220))
			ConfirmBtn:SetText("Confirm")
			ConfirmBtn.Paint = function(s,w,h)
				draw.RoundedBox(5, 0, 0, w, h, Color(45,45,45, 100))
			end
			ConfirmBtn.DoClick = function()
				CrosshairPanel:SetSize(ActiveSize, ActiveSize)
				CrosshairPanel:Center()
				CrosshairPanel:SetHTML(Crosshairs[ActiveCrosshair]..[[<style> *{margin:0;padding:0;} svg{width:100%;height:100%;fill:rgb(]]..ActiveColor..[[);}</style>]])
				FrameOpen = false
				Frame:Remove()
				hook.Remove("Think", "CrosshairMenuColorChange")
			end

			local RightPanel = vgui.Create("Panel", Frame)
			RightPanel:Dock( RIGHT )
			RightPanel:SetWide(Frame:GetWide() / 2 - 2.5)
			RightPanel:DockMargin(0, 5, 5, 0)

			CrosshairList = vgui.Create( "DIconLayout", Frame )
			CrosshairList:Dock( LEFT )
			CrosshairList:SetWide(Frame:GetWide() / 2 - 2.5)
			CrosshairList:DockMargin(3, 5, 0, 0)
			CrosshairList:SetSpaceY( 5 ) -- Sets the space in between the panels on the Y Axis by 5
			CrosshairList:SetSpaceX( 5 ) -- Sets the space in between the panels on the X Axis by 5

			local Mixer = vgui.Create( "DColorMixer", RightPanel )
			Mixer:Dock( TOP )			--Make Mixer fill place of Frame
			Mixer:SetTall(200)
			Mixer:SetPalette( false ) 		--Show/hide the palette			DEF:true
			Mixer:SetAlphaBar( false ) 		--Show/hide the alpha bar		DEF:true
			Mixer:SetWangs( true )			--Show/hide the R G B A indicators 	DEF:true
			Mixer:SetColor( Color(220, 220, 220, 245) )	--Set the default color	
			local MixerUpdateTimeout = false
			hook.Add("Think", "CrosshairMenuColorChange", function()
				local C = Mixer:GetColor()
				if ActiveColor != C["r"]..","..C["g"]..","..C["b"] and !MixerUpdateTimeout then
					MixerUpdateTimeout = true
					timer.Simple(0.1, function() MixerUpdateTimeout = false end)
					SetActiveColor(C,function()
						for k , v in pairs(CrosshairList:GetChildren()) do
							if v.CrosshairID == ActiveCrosshair then
								v:GetChildren()[1]:SetHTML(Crosshairs[v.CrosshairID]..[[<style> *{margin:0;padding:0;} svg{width:100%;height:100%;fill:rgb(]]..ActiveColor..[[);}</style>]])
							end
						end
					end)
				end
			end)

			local DermaNumSlider = vgui.Create( "DNumSlider", RightPanel )
			DermaNumSlider:Dock(TOP)
			DermaNumSlider:DockMargin(0, 5, 0, 0)
			DermaNumSlider:DockPadding(5, 0, 10, 0)
			DermaNumSlider:SetTall(30)			// Set the position
			DermaNumSlider:SetText( "Crosshair Size :" )	// Set the text above the slider
			DermaNumSlider:SetMin( 0 )				// Set the minimum number you can slide to
			DermaNumSlider:SetMax( 100 )				// Set the maximum number you can slide to
			DermaNumSlider:SetDecimals( 0 )			// Decimal places - zero for whole number
			DermaNumSlider:SetValue(ActiveSize)
			DermaNumSlider.Paint = function(s,w,h)
				draw.RoundedBox(5, 0, 0, w, h, Color(30,30,30,255))
			end
			DermaNumSlider.OnValueChanged = function(val)
				ActiveSize = DermaNumSlider:GetValue()
			end

			--DermaNumSlider:SetConVar( "sbox_maxprops" ) // Changes the ConVar when you slide

			Delay = 0
			for k , v in pairs(Crosshairs) do
				timer.Simple(Delay, function()
					local Box = CrosshairList:Add("Awesomium") -- LATER HTML
					Box.CrosshairID = k
					Box:SetSize(52, 52)
					Box.Paint = function(s,w,h)
						if ActiveCrosshair != Box.CrosshairID then
							draw.RoundedBox(5, 0, 0, w, h, Color(60,60,60,255))
							draw.RoundedBox(5, 2, 2, w-4, h-4, Color(60,60,60,255))
						else
							draw.RoundedBox(5, 0, 0, w, h, Color(100, 100, 100, 245))
							draw.RoundedBox(5, 2, 2, w-4, h-4, Color(100, 100, 0))
						end
					end

					local CrosshairVector = vgui.Create("HTML", Box)
					CrosshairVector:SetSize(44, 44)
					CrosshairVector:SetPos(4,4)
					CrosshairVector:SetHTML(v..[[<style>*{margin:0;padding:0;}svg {width:100%;height:100%;fill:rgb(]]..ActiveColor..[[);}</style>]])

					local OverlayBtn = vgui.Create("DButton", Box)
					OverlayBtn:Dock(FILL)
					OverlayBtn:SetText("")
					OverlayBtn.Paint = nil
					OverlayBtn.DoClick = function()
						if ActiveCrosshair != Box.CrosshairID then
							ActiveCrosshair = Box.CrosshairID
							Box:GetChildren()[1]:SetHTML(Crosshairs[Box.CrosshairID]..[[<style> *{margin:0;padding:0;} svg{width:100%;height:100%;fill:rgb(]]..ActiveColor..[[);}</style>]])
						end
					end


				end)
				Delay = Delay + 0.1
			end

		end

		local TimeOut = false
		net.Receive("CatGuy_Crosshair", function()
			TimeOut = true
			FrameOpen = true
			timer.Simple(2, function() TimeOut = false end)
			CrosshairGUI()
		end)
		if OpenWithKey then
			hook.Remove("Think", "CatGuy_Crosshair_Key")
			hook.Add("Think", "CatGuy_Crosshair_Key", function()
				if input.IsKeyDown(OpenKey) and !TimeOut then
					TimeOut = true
					FrameOpen = true
					timer.Simple(2, function() TimeOut = false end)
					CrosshairGUI()
				end
			end)
		end
	end
end )