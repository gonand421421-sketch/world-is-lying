-- Run from the repository root with Lua 5.3+ or texlua.
-- A deterministic construction/server-logic fixture, NOT a Roblox engine emulator.
-- Does not test rendering, Roblox API compatibility, prompts, networking, or physics.
local generator='TheWorldIsLyingGenerator.lua'
local function signal()
 local s={handlers={}}
 function s:Connect(f) self.handlers[#self.handlers+1]=f; return {Disconnect=function() end} end
 function s:Fire(...) for _,f in ipairs(self.handlers) do f(...) end end
 return s
end
local vm={}
local function vec(x,y,z) return setmetatable({X=x or 0,Y=y or 0,Z=z or 0},vm) end
function vm.__add(a,b) return vec(a.X+b.X,a.Y+b.Y,a.Z+b.Z) end
function vm.__sub(a,b) return vec(a.X-b.X,a.Y-b.Y,a.Z-b.Z) end
function vm.__mul(a,b) if type(a)=='number' then a,b=b,a end; return vec(a.X*b,a.Y*b,a.Z*b) end
function vm.__index(v,k)
 local length=math.sqrt(v.X*v.X+v.Y*v.Y+v.Z*v.Z)
 if k=='Magnitude' then return length elseif k=='Unit' then return length>0 and v*(1/length) or vec() end
 if k=='Dot' then return function(a,b) return a.X*b.X+a.Y*b.Y+a.Z*b.Z end end
end
Vector3={new=vec}; Vector2={new=function(x,y) return vec(x,y) end}
local fm={}
local function frame(x,y,z) return setmetatable({Position=type(x)=='table' and x or vec(x,y,z),LookVector=vec(0,0,-1)},fm) end
function fm.__mul(a,b) return frame(a.Position+b.Position) end
CFrame={new=frame}; TweenInfo={new=function(...) return {...} end}
Color3={fromRGB=function(...) return {...} end}; UDim2={fromScale=function(...) return {...} end}
Enum=setmetatable({},{__index=function(t,k) local e=setmetatable({},{__index=function(_,v) return k..'.'..v end}); rawset(t,k,e); return e end})
local methods={}; local meta={}
function meta.__index(t,k) return methods[k] or t.props[k] end
function meta.__newindex(t,k,v)
 t.props[k]=v
 if k=='Parent' and v then table.insert(v.children,t) end
 if k=='Position' then t.props.CFrame=frame(v) end
end
Instance={new=function(class)
 local t=setmetatable({props={ClassName=class,Name=class},children={},attrs={}},meta)
 if class=='ProximityPrompt' then t.Triggered=signal() end
 return t
end}
function methods:FindFirstChild(name) for _,c in ipairs(self.children) do if c.Name==name then return c end end end
function methods:WaitForChild(name) return assert(self:FindFirstChild(name),'Missing child '..name) end
function methods:FindFirstChildOfClass(class) for _,c in ipairs(self.children) do if c.ClassName==class then return c end end end
function methods:GetChildren() return self.children end
function methods:GetDescendants()
 local out={}; local function visit(t) for _,c in ipairs(t.children) do out[#out+1]=c; visit(c) end end; visit(self); return out
end
function methods:IsA(class) return self.ClassName==class or (class=='BasePart' and (self.ClassName=='Part' or self.ClassName=='SpawnLocation')) end
function methods:IsDescendantOf(parent) local t=self.Parent; while t do if t==parent then return true end; t=t.Parent end; return false end
function methods:SetAttribute(k,v) self.attrs[k]=v end
function methods:GetAttribute(k) return self.attrs[k] end
function methods:Destroy() self.destroyed=true end
function methods:ClearAllChildren() self.children={} end
function methods:Clone() local t=Instance.new(self.ClassName); for k,v in pairs(self.props) do if k~='Parent' then t[k]=v end end; return t end
function methods:PivotTo(cf) self:FindFirstChild('HumanoidRootPart').Position=cf.Position end
function methods:IsRunning() return false end
local services={}; for _,n in ipairs({'Workspace','ServerScriptService','ReplicatedStorage','StarterPlayer','Lighting','RunService','Players','PhysicsService','TweenService','Debris'}) do services[n]=Instance.new(n) end
services.StarterPlayer.StarterPlayerScripts=Instance.new('StarterPlayerScripts')
services.Players.PlayerAdded=signal(); services.Players.PlayerRemoving=signal(); services.RunService.Heartbeat=signal()
function services.PhysicsService:RegisterCollisionGroup() end
function services.PhysicsService:CollisionGroupSetCollidable() end
function services.TweenService:Create() return {Play=function() end} end
function services.Debris:AddItem() end
local function player(name)
 local p=Instance.new('Player'); p.DisplayName=name; p.CharacterAdded=signal(); p.Character=Instance.new('Model'); p.Character.DescendantAdded=signal()
 local hrp=Instance.new('Part'); hrp.Name='HumanoidRootPart'; hrp.Position=vec(0,4,24); hrp.Parent=p.Character
 local hum=Instance.new('Humanoid'); hum.Health=100; hum.MoveDirection=vec(); hum.FloorMaterial=Enum.Material.Concrete; hum.Parent=p.Character
 return p
end
local p1,p2=player('Observer One'),player('Observer Two')
function services.Players:GetPlayers() return {p1,p2} end
game={GetService=function(_,name) return assert(services[name],name) end}
assert(loadfile(generator))()
local root=services.Workspace:WaitForChild('TWIL')
local module=services.ReplicatedStorage:WaitForChild('TWIL_Config')
local config=assert(load(module.Source))()
local prompts=0
for i=1,10 do
 local r=root:WaitForChild(string.format('Room%02d',i)); assert(r:FindFirstChild('Foundation') and r:FindFirstChild('Ceiling') and r:FindFirstChild('ExitDoor'))
 assert(#config.rooms[i].hints==3 and #config.rooms[i].docs>0 and config.rooms[i].memory)
end
for _,obj in ipairs(root:GetDescendants()) do if obj:IsA('ProximityPrompt') then assert(obj.Parent:GetAttribute('Action')); prompts=prompts+1 end end
-- Prove uniqueness from the authored logical constraints, independently of input handlers.
local releases={}
for door=1,3 do local trueCount=(door==2 and 1 or 0)+(door~=2 and 1 or 0)+(door~=1 and 1 or 0); if trueCount==1 then releases[#releases+1]=door end end
assert(#releases==1 and releases[1]==1)
for row=1,4 do
 local counts={}; for word in config.ceilingRecords[row]:gmatch('%S+') do counts[word]=(counts[word] or 0)+1 end
 local bearing; for word,count in pairs(counts) do if count==2 then assert(not bearing); bearing=word end end
 assert(config.floorSymbols[row][config.answers.floor[row]]==bearing)
 local common={}; for _,a in ipairs(config.exposures.SUN[row]) do for _,b in ipairs(config.exposures.MOON[row]) do if a==b then common[#common+1]=a end end end
 assert(#common==1 and common[1]==config.answers.missing[row])
end
local relaySolutions=0
for bits=0,15 do
 local a,b,c,d=bits%2==1,math.floor(bits/2)%2==1,math.floor(bits/4)%2==1,math.floor(bits/8)%2==1
 local count=(a and 1 or 0)+(b and 1 or 0)+(c and 1 or 0)+(d and 1 or 0)
 if count==2 and a~=c and b==a and not(c and d) then relaySolutions=relaySolutions+1; assert(a and b and not c and not d) end
end
assert(relaySolutions==1)
local bays={}; for j=1,4 do if j>1 and j<4 and j~=3 then bays[#bays+1]=j end end
assert(#bays==1 and bays[1]==2)
local silentConfigurations=0
for bits=0,7 do
 local fan,speaker,mic=bits%2==1,math.floor(bits/2)%2==1,math.floor(bits/4)%2==1
 if not fan and not speaker and mic then silentConfigurations=silentConfigurations+1 end
end
assert(silentConfigurations==1)
local roles={ADA='POWER',MARA='MEMORY',IVO='ENTRY'}
local dates={ADA={1970,1972},MARA={1973,1980},IVO={1970,1974}}
for j,r in ipairs({{'ADA','ENTRY',1971},{'MARA','MEMORY',1971},{'IVO','ENTRY',1971}}) do
 local roleOK=roles[r[1]]==r[2]; local dateOK=r[3]>=dates[r[1]][1] and r[3]<=dates[r[1]][2]
 local category=not roleOK and 1 or not dateOK and 2 or 3
 assert(category==config.answers.records[j])
end
-- Compass bearings clockwise N,E,S,W; observer-right adds one, left subtracts one.
local facing,bearing={0,2,1},{1,3,0}
for j,choice in ipairs({2,2,1}) do assert((facing[j]+(choice==2 and 1 or 3))%4==bearing[j]) end
local pairings={EYE='KEY',KEY='EYE',SUN='MOON',MOON='SUN'}
local reflected={'EYE','SUN','KEY','MOON'}
for i=1,4 do assert(config.answers.mirror[i]==pairings[reflected[5-i]]) end
for i,n in ipairs({1,6,2,9,4}) do assert(config.answers.final[i]==config.rooms[n].memory) end
assert(config.answers.final[6]=='BLANK')
local remote=services.ReplicatedStorage:WaitForChild('TWIL_Remote'); remote.OnServerEvent=signal()
local latest={}; local events={}; local now=0
local function copy(t) if type(t)~='table' or getmetatable(t) then return t end; local out={}; for k,v in pairs(t) do out[k]=copy(v) end; return out end
function remote:FireClient(p,kind,value) events[#events+1]={p,kind,value}; if kind=='state' then latest[p]=copy(value) end end
local env=setmetatable({typeof=function(v) return getmetatable(v)==vm and 'Vector3' or type(v) end,workspace=services.Workspace,require=function(v) assert(v==module); return config end,os={clock=function() return now end},task={spawn=function(f,...) f(...) end}}, {__index=_G})
local server=services.ServerScriptService:WaitForChild('TWIL_Server').Source
assert(load(server,'TWIL_Server','t',env))()
-- The client is parsed unchanged, but cannot be executed without Roblox UI/camera services.
assert(load(services.StarterPlayer.StarterPlayerScripts:WaitForChild('TWIL_Client').Source,'TWIL_Client'))
local cameraLook={}
local function action(a,p)
 p=p or p1; now=now+1.5
 local model=root:WaitForChild(string.format('Room%02d',latest[p].room))
 for _,obj in ipairs(model:GetDescendants()) do
  if obj:IsA('ProximityPrompt') and obj.Parent:GetAttribute('Action')==a then
   p.Character:FindFirstChild('HumanoidRootPart').Position=obj.Parent.Position+vec(0,0,2)
   if cameraLook[p] then remote.OnServerEvent:Fire(p,'look',cameraLook[p]) end
   obj.Triggered:Fire(p); return
  end
 end
 error('Missing action '..a)
end
local function sync() now=now+1.5; remote.OnServerEvent:Fire(p1,'sync') end
local peerCheckpoint=1
local function leave() assert(latest[p1].solved); action('exit'); assert(latest[p2].room==peerCheckpoint and not latest[p2].solved) end
local function setDials(values)
 for i,v in ipairs(values) do while latest[p1].puzzle.dials[i]~=v do action('dial:'..i) end end
end
local function sample(z)
 p1.Character:FindFirstChild('HumanoidRootPart').Position=vec((latest[p1].room-1)*100,3,z)
 for i=1,30 do now=now+0.2; services.RunService.Heartbeat:Fire(0.2) end
end
-- Every hint ladder caps at three and does not solve the room.
for i=1,4 do now=now+1.5; remote.OnServerEvent:Fire(p1,'hint') end
assert(latest[p1].hints==3 and not latest[p1].solved)
action('door:2'); assert(not latest[p1].solved); action('door:1'); leave()
action('door:1',p2); action('exit',p2); peerCheckpoint=2
action('commit'); assert(not latest[p1].solved); setDials(config.answers.floor); assert(latest[p2].puzzle.dials[1]==1); action('commit'); leave()
-- Statue: observed advances fail; aversion advances exactly one latched bay.
cameraLook[p1]=vec(0,0,-1); action('advance'); assert(latest[p1].puzzle.bay==4)
cameraLook[p1]=vec(0,0,1); action('advance'); assert(latest[p1].puzzle.bay==1)
cameraLook[p1]=vec(0,0,1); action('advance'); assert(latest[p1].puzzle.bay==2)
local hrp=p1.Character:FindFirstChild('HumanoidRootPart')
-- Set orientation immediately before firing accept (the action helper advances simulated time).
now=now+1.5; local accept=root:WaitForChild('Room03'):WaitForChild('AcceptBay'); hrp.Position=accept.Position+vec(0,0,2)
remote.OnServerEvent:Fire(p1,'look',(vec(195,6,-11)-hrp.Position).Unit)
accept:FindFirstChildOfClass('ProximityPrompt').Triggered:Fire(p1); assert(latest[p1].solved); leave()
action('turn:2'); action('turn:1'); assert(latest[p1].puzzle.leg==1); action('turn:2'); action('turn:1'); leave()
sample(0); sync(); assert(not latest[p1].solved)
action('device:1'); action('device:2'); sample(0); assert(latest[p1].solved); leave()
for _,v in ipairs(config.answers.mirror) do action('symbol:'..v) end; action('commit'); leave()
action('view:MOON'); assert(latest[p1].puzzle.view=='MOON'); setDials(config.answers.missing); action('commit'); leave()
action('relay:1'); action('relay:2'); action('commit'); leave()
setDials(config.answers.records); action('commit'); leave()
-- Finale requires six correct entries, certification, then reading before choosing.
action('ending:1'); assert(not latest[p1].solved)
for _,v in ipairs(config.answers.final) do action('symbol:'..v) end; action('commit'); assert(latest[p1].puzzle.phase==1 and not latest[p1].solved)
sample(22); assert(latest[p1].solved); action('file'); assert(latest[p1].puzzle.readFile)
local journal=table.concat(latest[p1].journal,'\n'); assert(journal:find('Retrieval audit') and journal:find('Missing%-entry standard'))
-- Simulate respawn: current room, draft, evidence and solved state survive.
p1.CharacterAdded:Fire(p1.Character); assert(latest[p1].room==10 and latest[p1].solved)
local choice=arg and arg[1]=='forget' and 2 or 1
action('ending:'..choice); local found=false
for _,e in ipairs(events) do if e[1]==p1 and e[2]=='ending' and e[3]:find(choice==1 and 'YOU REMEMBER' or 'YOU FORGET') then found=true end end
assert(found and latest[p2].room==peerCheckpoint and not latest[p2].solved)
services.Players.PlayerRemoving:Fire(p1)
print(string.format('PASS: ten-room construction; %d routed prompts; unique logical solutions; complete server-logic playthrough; hints; wrong inputs; session respawn; finale gates; two-player isolation.',prompts))
print('NOT TESTED: Roblox engine APIs, physics, camera visibility, prompt reach/line of sight, UI layout, streaming, native Luau compilation, real networking, or completion times.')
