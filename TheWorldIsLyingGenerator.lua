-- THE WORLD IS LYING | Paste this entire file into Studio's Command Bar in EDIT mode.
-- Creates only TWIL-owned objects. Re-running replaces this generated experience.
assert(not game:GetService('RunService'):IsRunning(), 'Run in Edit mode, then press Play.')
local Workspace = game:GetService('Workspace')
local SSS = game:GetService('ServerScriptService')
local RS = game:GetService('ReplicatedStorage')
local SP = game:GetService('StarterPlayer')
local Lighting = game:GetService('Lighting')
for _, entry in ipairs({{Workspace,'TWIL'},{SSS,'TWIL_Server'},{RS,'TWIL_Remote'},
	{SP.StarterPlayerScripts,'TWIL_Client'},{Lighting,'TWIL_Atmosphere'},{Lighting,'TWIL_Color'}}) do
	local old = entry[1]:FindFirstChild(entry[2]); if old then old:Destroy() end
end
local root = Instance.new('Model'); root.Name='TWIL'; root.Parent=Workspace
local remote=Instance.new('RemoteEvent'); remote.Name='TWIL_Remote'; remote.Parent=RS
Lighting.ClockTime=0; Lighting.Brightness=1; Lighting.Ambient=Color3.fromRGB(27,30,39)
Lighting.OutdoorAmbient=Color3.fromRGB(12,14,20)
local atmosphere=Instance.new('Atmosphere'); atmosphere.Name='TWIL_Atmosphere'
atmosphere.Density=0.24; atmosphere.Color=Color3.fromRGB(117,129,142); atmosphere.Parent=Lighting
local cc=Instance.new('ColorCorrectionEffect'); cc.Name='TWIL_Color'; cc.Saturation=-0.55
cc.Contrast=0.15; cc.TintColor=Color3.fromRGB(208,223,239); cc.Parent=Lighting
local function part(parent,name,size,pos,color,material)
	local p=Instance.new('Part'); p.Name=name; p.Size=size; p.Position=pos; p.Anchored=true
	p.Color=color or Color3.fromRGB(57,60,65); p.Material=material or Enum.Material.Concrete
	p.TopSurface=Enum.SurfaceType.Smooth; p.BottomSurface=Enum.SurfaceType.Smooth; p.Parent=parent; return p
end
local function label(parent,name,text,pos,width,height)
	local board=part(parent,name,Vector3.new(width or 13,height or 3,0.2),pos,Color3.fromRGB(18,21,25))
	board.CanCollide=false
	local gui=Instance.new('SurfaceGui'); gui.Face=name=='Instructions' and Enum.NormalId.Front or Enum.NormalId.Back; gui.PixelsPerStud=45; gui.Parent=board
	local t=Instance.new('TextLabel'); t.Size=UDim2.fromScale(1,1); t.BackgroundTransparency=1
	t.Text=text; t.TextWrapped=true; t.TextScaled=true; t.Font=Enum.Font.Code
	t.TextColor3=Color3.fromRGB(200,209,204); t.Parent=gui; return board
end
local function action(p,id,text)
	p:SetAttribute('Action',id)
	local q=Instance.new('ProximityPrompt'); q.ActionText=text or 'Inspect'; q.ObjectText=p.Name
	q.HoldDuration=0.35; q.MaxActivationDistance=10; q.RequiresLineOfSight=true; q.Parent=p
end
local names={'THE WELCOME','THE FLOOR LIES','DO NOT LOOK AWAY','YOU HAVE BEEN HERE',
	'PLEASE BE SILENT','THE OTHER SIDE','NOTHING IS MISSING','FOR YOUR SAFETY','THE WITNESS','THE WORLD IS LYING'}
local clues={
	'One door promises safety. One admits uncertainty. Trust the honest answer.',
	'The floor says red is death. Look UP. Follow the pale ceiling marks to the far switch.',
	'The witness approaches when unseen. Face it while reaching the seal behind it.',
	'The corridor repeats. Read what remains scratched on the floor. Wrong choices erase the route.',
	'The room listens to motion, not your microphone. Stand still in the circle for seven seconds.',
	'The mirror keeps the answer. Read its three symbols from the OTHER side.',
	'The floor forgets itself. Pale tiles remain; dark tiles vanish. Reach the far switch.',
	'The cameras protect the lie. Cross while their eyes are DARK. Exposure returns you to the entrance.',
	'Three records disagree. Compare their dates. Choose the record that could have witnessed the beginning.',
	'You opened every door. Who opened the first? Read the desk, then choose what to carry outside.'}
for i=1,10 do
	local m=Instance.new('Model'); m.Name=string.format('Room%02d',i); m:SetAttribute('Room',i); m.Parent=root
	local x=(i-1)*100
	part(m,'Foundation',Vector3.new(48,2,64),Vector3.new(x,-2,0))
	part(m,'Ceiling',Vector3.new(48,1,64),Vector3.new(x,18,0))
	part(m,'WestWall',Vector3.new(1,20,64),Vector3.new(x-24,8,0))
	part(m,'EastWall',Vector3.new(1,20,64),Vector3.new(x+24,8,0))
	part(m,'RearWall',Vector3.new(48,20,1),Vector3.new(x,8,32))
	part(m,'FrontLeft',Vector3.new(20,20,1),Vector3.new(x-14,8,-32))
	part(m,'FrontRight',Vector3.new(20,20,1),Vector3.new(x+14,8,-32))
	part(m,'Lintel',Vector3.new(8,9,1),Vector3.new(x,13.5,-32))
	local door=part(m,'ExitDoor',Vector3.new(8,9,1),Vector3.new(x,3.5,-32),Color3.fromRGB(48,58,56),Enum.Material.Metal)
	action(door,'exit','Open door')
	part(m,'DoorHandle',Vector3.new(0.3,1.2,0.5),Vector3.new(x+2.7,3,-31.3),Color3.fromRGB(130,123,98),Enum.Material.Metal)
	part(m,'DrainPipe',Vector3.new(0.6,0.6,60),Vector3.new(x+21.5,15,0),Color3.fromRGB(49,58,56),Enum.Material.CorrodedMetal)
	for n=1,3 do
		local paper=part(m,'ScatteredPaper'..n,Vector3.new(1.6,0.03,2.2),Vector3.new(x+12+n*1.7,-0.95,19-n*2),Color3.fromRGB(131,127,106),Enum.Material.SmoothPlastic)
		paper.Rotation=Vector3.new(0,n*33,0)
	end
	label(m,'Title',string.format('%02d / %s',i,names[i]),Vector3.new(x,12,-30.8),19,3)
	label(m,'Instructions',clues[i],Vector3.new(x,8,29),28,4)
	local entry=part(m,'Entry',Vector3.new(8,0.1,5),Vector3.new(x,0,23),Color3.fromRGB(100,109,107)); entry.Transparency=1; entry.CanCollide=false
	for j=1,3 do
		local lamp=part(m,'Lamp'..j,Vector3.new(5,0.25,1.5),Vector3.new(x,17,-22+j*14),Color3.fromRGB(189,203,192),Enum.Material.Neon)
		local l=Instance.new('PointLight'); l.Brightness=0.9; l.Range=25; l.Color=lamp.Color; l.Shadows=true; l.Parent=lamp
	end
	for j=1,5 do
		part(m,'WallRib'..j,Vector3.new(0.5,18,0.7),Vector3.new(x-23.3,8,-26+j*10),Color3.fromRGB(33,37,40),Enum.Material.Metal)
		local stain=part(m,'Crack'..j,Vector3.new(0.08,3+j,0.03),Vector3.new(x-18+j*6,3,31.4),Color3.fromRGB(19,22,25)); stain.Rotation=Vector3.new(0,0,j*11)
	end
	part(m,'Bench',Vector3.new(9,1,3),Vector3.new(x-16,1,22),Color3.fromRGB(52,42,36),Enum.Material.Wood)
	if i==1 then
		for k,text in ipairs({'SAFE','I DO NOT KNOW','EXIT'}) do
			local p=part(m,text,Vector3.new(7,9,1),Vector3.new(x+(k-2)*14,3.5,-16),Color3.fromRGB(61,49,45),Enum.Material.Wood)
			action(p,k==2 and 'truth' or 'false','Try door'); label(m,'DoorSign'..k,text,p.Position+Vector3.new(0,6,0.7),9,2)
		end
	elseif i==2 or i==7 then
		-- A continuous zigzag path. Every tile has a solid foundation beneath it.
		for row=1,7 do
			local safeCol=({2,2,3,3,2,2,2})[row]
			for col=1,4 do
				local safe=col==safeCol or (row>1 and col==({2,2,3,3,2,2,2})[row-1])
				local p=part(m,'Tile_'..row..'_'..col,Vector3.new(10,0.5,6),Vector3.new(x-25+col*10,0,20-row*6),safe and Color3.fromRGB(135,53,49) or Color3.fromRGB(57,64,67))
				p:SetAttribute('Safe',safe); p:SetAttribute('Tile',true)
				if i==7 then p.Color=safe and Color3.fromRGB(149,157,150) or Color3.fromRGB(38,42,47) end
				if i==2 and safe then part(m,'CeilingMark',Vector3.new(2,0.1,2),Vector3.new(p.Position.X,17.3,p.Position.Z),Color3.fromRGB(213,218,191),Enum.Material.Neon) end
			end
		end
		local sw=part(m,'FarSwitch',Vector3.new(3,3,1),Vector3.new(x,3,-27),Color3.fromRGB(153,139,86)); action(sw,'floor','Restore exit')
	elseif i==3 then
		local statue=Instance.new('Model'); statue.Name='Statue'; statue.Parent=m
		local body=part(statue,'Body',Vector3.new(3,6,2),Vector3.new(x,3,-12),Color3.fromRGB(129,132,127))
		part(statue,'Head',Vector3.new(2.7,2.7,2.7),Vector3.new(x,7.3,-12),body.Color)
		for _,dx in ipairs({-0.65,0.65}) do part(statue,'Eye',Vector3.new(0.35,0.35,0.1),Vector3.new(x+dx,7.5,-10.6),Color3.fromRGB(10,10,10)) end
		statue.PrimaryPart=body
		for _,v in ipairs(statue:GetChildren()) do if v:IsA('BasePart') then v.CanCollide=false end end
		local seal=part(m,'Seal',Vector3.new(3,3,1),Vector3.new(x,3,-27),Color3.fromRGB(99,113,113)); action(seal,'seal','Break seal')
	elseif i==4 then
		for _,side in ipairs({-1,1}) do
			part(m,'CorridorPartition',Vector3.new(1,16,32),Vector3.new(x+side*6,7,3),Color3.fromRGB(45,49,51))
			part(m,'ReturnPartition',Vector3.new(9,16,1),Vector3.new(x+side*18,7,-9),Color3.fromRGB(45,49,51))
		end
		label(m,'Scratches','LEFT  /  RIGHT  /  LEFT',Vector3.new(x,1,4),16,1.5)
		for k,side in ipairs({'LEFT','RIGHT'}) do
			local p=part(m,side,Vector3.new(8,9,1),Vector3.new(x+(k==1 and -12 or 12),3.5,-18)); action(p,'loop'..k,'Enter corridor')
		end
	elseif i==5 then
		local p=part(m,'QuietCircle',Vector3.new(12,0.15,12),Vector3.new(x,0,0),Color3.fromRGB(132,140,133)); p.Material=Enum.Material.Marble
	elseif i==6 then
		part(m,'Mirror',Vector3.new(18,11,0.6),Vector3.new(x,6,-20),Color3.fromRGB(153,176,188),Enum.Material.Glass).Reflectance=0.65
		label(m,'MirrorWriting','III     II     I',Vector3.new(x,7,-19.5),15,3)
		label(m,'MirrorNote','A reflection reverses the order.\nBegin where the reflection ends.',Vector3.new(x-13,6,5),10,4)
		for k=1,3 do local p=part(m,({'I','II','III'})[k],Vector3.new(3,3,2),Vector3.new(x+(k-2)*7,2,-6)); action(p,'mirror'..k,'Press symbol') end
	elseif i==8 then
		for k=1,3 do
			local p=part(m,'Camera'..k,Vector3.new(2,2,3),Vector3.new(x+(k%2==0 and -18 or 18),12,13-k*10),Color3.fromRGB(24,27,29),Enum.Material.Metal)
			local eye=part(m,'CameraEye'..k,Vector3.new(1,1,0.2),p.Position+Vector3.new(0,0,1.6),Color3.fromRGB(230,45,40),Enum.Material.Neon)
			eye:SetAttribute('Eye',true)
		end
		label(m,'CameraRule','RED: WATCHING  /  DARK: CROSS\nWait at either end until the lights go dark.',Vector3.new(x,7,14),20,3)
		local sw=part(m,'SecurityTerminal',Vector3.new(4,4,2),Vector3.new(x,2,-27)); action(sw,'security','Disconnect cameras')
	elseif i==9 then
		for k,text in ipairs({'1998: I saw the first door.','1971: The building opened. I was inside.','2006: I invented yesterday.'}) do
			local p=label(m,'Record'..k,text,Vector3.new(x+(k-2)*14,5,-12),12,6); action(p,'record'..k,'Accept testimony')
		end
		label(m,'Archive','BUILDING OPENED: 1971',Vector3.new(x,9,4),20,2)
	elseif i==10 then
		part(m,'Desk',Vector3.new(12,2,5),Vector3.new(x,2,0),Color3.fromRGB(67,48,37),Enum.Material.Wood)
		local p=label(m,'YourFile','SUBJECT: YOU\nYou asked us to make a place you could not leave.\nEvery lie was a lock. Every answer was yours.',Vector3.new(x,5,-2),14,5); action(p,'file','Read your file')
		for k,text in ipairs({'REMEMBER','FORGET'}) do local b=part(m,text,Vector3.new(6,4,2),Vector3.new(x+(k==1 and -10 or 10),2,-19)); action(b,'ending'..k,text) end
	end
end
local spawn=Instance.new('SpawnLocation'); spawn.Name='TWIL_Spawn'; spawn.Size=Vector3.new(7,0.2,5)
spawn.Position=Vector3.new(0,0,24); spawn.Anchored=true; spawn.Neutral=true; spawn.Duration=0; spawn.Parent=root
local server=Instance.new('Script'); server.Name='TWIL_Server'
server.Source=[==[
local Players=game:GetService('Players')
local RunService=game:GetService('RunService')
local TweenService=game:GetService('TweenService')
local root=workspace:WaitForChild('TWIL')
local remote=game:GetService('ReplicatedStorage'):WaitForChild('TWIL_Remote')
local state={}
-- Players may share narrow puzzle routes without physically trapping each other.
local PhysicsService=game:GetService('PhysicsService')
pcall(function() PhysicsService:RegisterCollisionGroup('TWIL_Players') end)
PhysicsService:CollisionGroupSetCollidable('TWIL_Players','TWIL_Players',false)
local function prepareCharacter(c)
	local function assign(v) if v:IsA('BasePart') then v.CollisionGroup='TWIL_Players' end end
	for _,v in ipairs(c:GetDescendants()) do assign(v) end
	c.DescendantAdded:Connect(assign)
end
local function room(n) return root:FindFirstChild(string.format('Room%02d',n)) end
local function tell(p,t) remote:FireClient(p,'message',t) end
local function place(p,n)
	local c=p.Character; if c then c:PivotTo(CFrame.new((n-1)*100,4,23)) end
end
local function resetPuzzle(s)
	s.loop=0; s.mirror=0; s.quiet=0; s.lastPos=nil; s.statue=Vector3.new(200,3,-12); s.floorStarted=false
end
local function solved(p,text)
	local s=state[p]; if not s then return end
	s.solved=true; tell(p,text or 'The lock releases. Find the exit door.')
	remote:FireClient(p,'solved',s.room)
end
local function hazard(p,text)
	local s=state[p]; if not s or s.ended then return end
	local now=os.clock(); if now<(s.hazardAt or 0) then return end
	s.hazardAt=now+1.5; resetPuzzle(s); place(p,s.room); tell(p,text)
end
local function addPlayer(p)
	if state[p] then return end
	state[p]={room=1,solved=false,loop=0,mirror=0,quiet=0,statue=Vector3.new(200,3,-12)}
	p:SetAttribute('TWIL_Checkpoint',1)
	p.CharacterAdded:Connect(function(c)
		prepareCharacter(c)
		c:WaitForChild('HumanoidRootPart',10)
		if not state[p] or p.Character~=c then return end
		resetPuzzle(state[p]); place(p,state[p].room)
		remote:FireClient(p,'room',state[p].room)
		if state[p].solved then remote:FireClient(p,'solved',state[p].room) end
		tell(p,'THE WORLD IS LYING — Read the wall behind you. Progress is saved for this server session.')
	end)
	if p.Character then prepareCharacter(p.Character); place(p,1) end
end
Players.PlayerAdded:Connect(addPlayer)
Players.PlayerRemoving:Connect(function(p) state[p]=nil end)
for _,p in ipairs(Players:GetPlayers()) do addPlayer(p) end
-- Remote accepts camera orientation only. Solutions and positions stay server-authoritative.
remote.OnServerEvent:Connect(function(p,kind,v)
	local s=state[p]; if not s then return end
	if kind=='sync' then
		if os.clock()<(s.syncAt or 0) then return end
		s.syncAt=os.clock()+2; remote:FireClient(p,'room',s.room)
		if s.solved then remote:FireClient(p,'solved',s.room) end
	elseif kind=='look' and typeof(v)=='Vector3' and s.room==3 then
		local now=os.clock(); if now<(s.lookAt or 0) then return end
		s.lookAt=now+0.08
		if v.X==v.X and v.Y==v.Y and v.Z==v.Z and v.Magnitude>0.95 and v.Magnitude<1.05 then s.look=v.Unit; s.lookTime=now end
	end
end)
local function interact(p,obj)
	local s=state[p]; local c=p.Character; local hrp=c and c:FindFirstChild('HumanoidRootPart')
	local hum=c and c:FindFirstChildOfClass('Humanoid')
	if not s or not hrp or not hum or hum.Health<=0 or s.ended then return end
	if not obj:IsDescendantOf(room(s.room)) or (hrp.Position-obj.Position).Magnitude>12 then return end
	local now=os.clock(); if now<(s.actionAt or 0) then return end; s.actionAt=now+0.45
	local a=obj:GetAttribute('Action')
	if a=='exit' then
		if s.room==10 then tell(p,'The last door is a choice. Read the file and choose REMEMBER or FORGET.'); return end
		if not s.solved then tell(p,'Locked. This room has not admitted its lie.'); return end
		-- A personal crossing: never removes another player's puzzle barrier.
		local ghost=obj:Clone(); ghost.Name='DoorEcho'; ghost:ClearAllChildren(); ghost.CanCollide=false; ghost.Transparency=0.6; ghost.Parent=root
		TweenService:Create(ghost,TweenInfo.new(0.6),{CFrame=ghost.CFrame*CFrame.new(7,0,0),Transparency=1}):Play()
		game:GetService('Debris'):AddItem(ghost,0.7)
		s.room=s.room+1; s.solved=false; resetPuzzle(s); p:SetAttribute('TWIL_Checkpoint',s.room)
		place(p,s.room); remote:FireClient(p,'room',s.room); tell(p,'Checkpoint '..s.room..' — Read the wall behind you.')
	elseif a=='truth' then solved(p,'Uncertainty was the only honest answer. The exit unlocks.')
	elseif a=='false' then hazard(p,'The promise was a lie. You are back where you began.')
	elseif a=='floor' then
		if s.floorStarted then solved(p) else tell(p,'Cross the marked floor first.') end
	elseif a=='seal' then solved(p,'The witness cannot follow you through the next door.')
	elseif a=='loop1' or a=='loop2' then
		if s.solved then tell(p,'The route is complete. Use the central exit.'); return end
		local choice=a=='loop1' and 1 or 2
		if choice==({1,2,1})[s.loop+1] then
			s.loop=s.loop+1
			if s.loop==3 then solved(p,'The corridor finally ends.') else place(p,4); tell(p,'Again. But a scratch remains. '..s.loop..'/3') end
		else s.loop=0; place(p,4); tell(p,'The corridor forgets your steps. Start again.') end
	elseif string.sub(a,1,6)=='mirror' then
		local k=tonumber(string.sub(a,7)); if k==s.mirror+1 then s.mirror=s.mirror+1 else s.mirror=0 end
		if s.mirror==3 then solved(p,'The reflection agrees.') else tell(p,'The mirror answers: '..s.mirror..'/3') end
	elseif a=='security' then solved(p,'Your image has been erased from the record.')
	elseif a=='record2' then solved(p,'Only the witness present at the beginning could know.')
	elseif string.sub(a,1,6)=='record' then tell(p,'That testimony arrived too late. Compare the opening date.')
	elseif a=='file' then s.readFile=true; tell(p,'You commissioned the building. The signature is yours. Remember, or forget?')
	elseif a=='ending1' or a=='ending2' then
		if not s.readFile then tell(p,'The file on the desk is waiting for you.'); return end
		s.ended=true; s.solved=true
		remote:FireClient(p,'ending',a=='ending1' and 'YOU REMEMBER\nThe building was built to hide one memory.\nOutside, someone knocks from inside your reflection.\n\nTHE WORLD IS STILL LYING.' or 'YOU FORGET\nYou wake with a key and no name.\nOn the key: ROOM 01.\n\nTHE BUILDING REMEMBERS YOU.')
	end
end
for _,obj in ipairs(root:GetDescendants()) do
	if obj:IsA('ProximityPrompt') then obj.Triggered:Connect(function(p) interact(p,obj.Parent) end) end
end
local accumulator=0
RunService.Heartbeat:Connect(function(dt)
	accumulator=accumulator+dt; if accumulator<0.1 then return end
	local step=math.min(accumulator,0.3); accumulator=0
	local now=os.clock(); local watching=now%8<4
	for _,eye in ipairs(room(8):GetChildren()) do
		if eye:GetAttribute('Eye') then eye.Color=watching and Color3.fromRGB(230,45,40) or Color3.fromRGB(24,27,29) end
	end
	-- Disappearing tiles are visual and non-colliding; the catch foundation prevents void falls.
	for _,tile in ipairs(room(7):GetChildren()) do
		if tile:GetAttribute('Tile') and not tile:GetAttribute('Safe') then
			tile.Transparency=now%5<2.5 and 0 or 1; tile.CanCollide=tile.Transparency==0
		end
	end
	for p,s in pairs(state) do
		local c=p.Character; local hrp=c and c:FindFirstChild('HumanoidRootPart'); local hum=c and c:FindFirstChildOfClass('Humanoid')
		if not hrp or not hum or hum.Health<=0 or s.ended then continue end
		local pos=hrp.Position; local x=(s.room-1)*100
		if pos.Y< -12 or math.abs(pos.X-x)>25 or math.abs(pos.Z)>34 then hazard(p,'The building puts you back.'); continue end
		if s.room==2 or s.room==7 then
			if pos.Z<18 and pos.Z> -25 then
				local nearest=nil; local dist=math.huge
				for _,tile in ipairs(room(s.room):GetChildren()) do
					if tile:GetAttribute('Tile') then local d=(Vector2.new(pos.X,pos.Z)-Vector2.new(tile.Position.X,tile.Position.Z)).Magnitude; if d<dist then nearest=tile; dist=d end end
				end
				if nearest then
					if not nearest:GetAttribute('Safe') then
						if s.room==2 or now%5>=2.5 then hazard(p,'The floor lied. Follow the reliable marks.'); continue end
					end
					s.floorStarted=true
				end
			end
		elseif s.room==3 and not s.solved then
			local target=Vector3.new(pos.X,3,pos.Z); local delta=target-s.statue
			local look=s.lookTime and now-s.lookTime<0.7 and s.look or hrp.CFrame.LookVector
			local toStatue=(s.statue+Vector3.new(0,4,0))-pos
			local seen=toStatue.Magnitude<0.1 or look:Dot(toStatue.Unit)>0.25
			if not seen and delta.Magnitude>0.1 then s.statue=s.statue+delta.Unit*math.min(5*step,delta.Magnitude) end
			remote:FireClient(p,'statue',s.statue)
			if delta.Magnitude<3.3 then hazard(p,'You looked away. The witness moved.'); continue end
		elseif s.room==5 and not s.solved then
			local inside=math.abs(pos.X-x)<6 and math.abs(pos.Z)<6
			local still=s.lastPos and (pos-s.lastPos).Magnitude<0.12 and hum.MoveDirection.Magnitude<0.05
			if inside and still then s.quiet=s.quiet+step else s.quiet=0 end
			s.lastPos=pos
			remote:FireClient(p,'quiet',math.floor(s.quiet))
			if s.quiet>=7 then solved(p,'For seven seconds, the building could not hear you.') end
		elseif s.room==8 and not s.solved and watching and pos.Z<12 and pos.Z> -23 then
			hazard(p,'The cameras saw you. Wait for the dark interval, then RUN.')
		end
	end
end)
]==]
server.Parent=SSS
local client=Instance.new('LocalScript'); client.Name='TWIL_Client'
client.Source=[==[
local Players=game:GetService('Players')
local RunService=game:GetService('RunService')
local p=Players.LocalPlayer
local remote=game:GetService('ReplicatedStorage'):WaitForChild('TWIL_Remote')
local gui=Instance.new('ScreenGui'); gui.Name='TWIL_HUD'; gui.ResetOnSpawn=false; gui.IgnoreGuiInset=true; gui.Parent=p:WaitForChild('PlayerGui')
local function text(name,y,h,size)
	local t=Instance.new('TextLabel'); t.Name=name; t.Size=UDim2.new(0.86,0,0,h); t.Position=UDim2.new(0.07,0,y,0)
	t.BackgroundColor3=Color3.fromRGB(9,12,16); t.BackgroundTransparency=0.2; t.BorderSizePixel=0
	t.TextColor3=Color3.fromRGB(210,218,210); t.TextWrapped=true; t.Font=Enum.Font.Code; t.TextSize=size; t.Parent=gui; return t
end
local status=text('Status',0.03,44,18)
local message=text('Message',0.77,100,20)
local hint=text('Hint',0.13,38,16); hint.Text='Use proximity prompts to interact. Checkpoints last for this server session.'
local ending=text('Ending',0.23,300,24); ending.Visible=false
local current=1; local token=0; local statue
local function ensureStatue()
	if statue then return end
	local original=workspace:WaitForChild('TWIL'):WaitForChild('Room03'):WaitForChild('Statue')
	statue=original:Clone(); statue.Name='PersonalWitness'; statue.Parent=workspace
	for _,v in ipairs(statue:GetDescendants()) do if v:IsA('BasePart') then v.CanCollide=false end end
	for _,v in ipairs(original:GetDescendants()) do if v:IsA('BasePart') then v.LocalTransparencyModifier=1 end end
end
remote.OnClientEvent:Connect(function(kind,value)
	if kind=='room' then
		current=value; status.Text=string.format('THE WORLD IS LYING   |   ROOM %02d / 10',value)
		hint.Text='Read the wall behind the entrance. Use the interaction prompts.'
		if value==3 then ensureStatue() end
	elseif kind=='message' then
		token=token+1; local mine=token; message.Text=value
		task.delay(10,function() if token==mine then message.Text='' end end)
	elseif kind=='solved' then hint.Text='SOLVED — use the exit door to reach the next checkpoint.'
	elseif kind=='quiet' then hint.Text='Remain still in the circle: '..value..' / 7 seconds'
	elseif kind=='statue' then ensureStatue(); statue:PivotTo(CFrame.new(value))
	elseif kind=='ending' then ending.Visible=true; ending.Text=value; hint.Text='End of Chapter One. Your choice remains with you.'; message.Text='' end
end)
local elapsed=0
RunService.RenderStepped:Connect(function(dt)
	elapsed=elapsed+dt
	if current==3 and elapsed>=0.1 then
		elapsed=0; local camera=workspace.CurrentCamera
		if camera then remote:FireServer('look',camera.CFrame.LookVector) end
	end
end)
remote:FireServer('sync')
]==]
client.Parent=SP.StarterPlayerScripts
print('THE WORLD IS LYING generated: 10 rooms, server gameplay, personal puzzles, session checkpoints. Press Play to test. Save your place to retain the generated content.')
