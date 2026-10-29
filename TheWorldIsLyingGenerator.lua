-- THE WORLD IS LYING | Paste this entire file into Studio's Command Bar in EDIT mode.
-- Hard-but-fair edition. No external assets. Session-only personal progress.
-- Re-running replaces TWIL-owned objects; global lighting is also configured.
assert(not game:GetService('RunService'):IsRunning(), 'Run in Edit mode, then press Play.')
local Workspace = game:GetService('Workspace')
local SSS = game:GetService('ServerScriptService')
local RS = game:GetService('ReplicatedStorage')
local SP = game:GetService('StarterPlayer')
local Lighting = game:GetService('Lighting')
for _, entry in ipairs({{Workspace,'TWIL'},{SSS,'TWIL_Server'},{RS,'TWIL_Remote'},{RS,'TWIL_Config'},
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

-- The complete authored clue set is shared by geometry, journal, hints, and validation.
local defs={
 {title='THE WELCOME', memory='ASH', intro='Three plates. One release. The receptionist has corrected the rules in the ledger.',
  docs={
   {'Reception ledger','Exactly ONE of the three door plates states a true proposition. Each plate describes which named door releases the central lock. The other two plates are false. The doors do not describe their own honesty.'},
   {'ASH plate','The release is BRASS.'},
   {'BRASS plate','The release is not BRASS.'},
   {'CHALK plate','The release is not ASH.'}},
  hints={'Assume each possible release in turn. Count true plates under that assumption.', 'The ASH and BRASS plates contradict each other; exactly one of that pair must be true.', 'Therefore the CHALK plate must be false. What does its negation say?'},
  feedback='The brass bell rings without moving. Your first receipt reads ASH.'},
 {title='THE FLOOR LIES', memory='IVORY', intro='The tiles promise support. The ceiling carries the inspection record. Submit a route before crossing.',
  docs={
   {'Structural standard','Each ceiling record contains one repeated symbol. Only that symbol bears weight in that numbered floor row. Read rows from the entrance toward the exit. Columns A, B, C run left to right as you face the exit. Submit all four row selections at the desk; the whole crossing is then secured.'},
   {'Inspector note','Paint is not evidence. Red was applied after the last inspection. Ceiling records are numbered; inspect their hanging plates to read them clearly.'}},
  hints={'Compare each numbered ceiling record with the same floor row.', 'In each ceiling record, count symbol occurrences; ignore their order and the floor colors.', 'Write down the repeated symbol for rows 1 through 4, then find its column in each matching floor row.'},
  feedback='The inspection finally agrees with the floor. Receipt: IVORY.'},
 {title='DO NOT LOOK AWAY', memory='STILL', intro='The exhibit moves when unobserved. Its mechanism latches at every bay. No chase is necessary.',
  docs={
   {'Exhibit mechanism','The AVERT lever advances the witness ONE bay, wrapping IV to I. It responds only while the witness is outside your view. Each bay latches indefinitely. Return your gaze to inspect it, then use ACCEPT BAY. You can safely stand at the entrance controls.'},
   {'Bay order','Facing the exit, bays I to IV are RING, EYE, TRIANGLE, SQUARE. The witness begins at IV.'},
   {'Curator correction','The correct bay is not an end. It lies to the right of RING and to the left of SQUARE. The TRIANGLE was installed after the testimony and is inadmissible.'}},
  hints={'First deduce the bay; the statue is a movable pointer, not a pursuer.', 'Only the two middle bays satisfy the boundary restrictions. One is explicitly inadmissible.', 'Advance from IV with the lever while facing away; it stops by itself at each new bay. Accept only while looking at your chosen bay.'},
  feedback='The witness looks past you at someone who is not there. Receipt: STILL.'},
 {title='YOU HAVE BEEN HERE', memory='WEST', intro='The corridor repeats its architecture, not its direction. The operator follows a drawn observer.',
  docs={
   {'Survey map','Route: FURNACE to CISTERN to ARCHIVE to RELEASE. CISTERN is east of FURNACE. ARCHIVE is west of CISTERN. RELEASE is north of ARCHIVE.'},
   {'Observer stamps','The observer faces NORTH at FURNACE, SOUTH at CISTERN, and EAST at ARCHIVE. LEFT and RIGHT on the corridor operators mean the DRAWN OBSERVER\'s left and right, not your avatar\'s. North is up on the map; east is right.'},
   {'Loop maintenance','Accepted legs remain engraved even after a wrong turn. Consult the route strip above the controls to see the current station and observer bearing. No clock erases a correct leg.'}},
  hints={'For the current station, find the compass bearing of the next station.', 'Rotate the drawn observer mentally, then decide whether that bearing is on its left or right.', 'At the cistern the observer faces south, so west is on its right. At the archive it faces east, so north is on its left.'},
  feedback='A fourth footprint joins the three you made. Receipt: WEST.'},
 {title='PLEASE BE SILENT', memory='HUSH', intro='The room records silence. Its meter does not measure what you think it measures.',
  docs={
   {'Instrument manual','This detector measures mechanical vibration. The FAN and SPEAKER each generate vibration while powered. The MICROPHONE is passive: it adds no vibration, but must be powered to certify a recording. The ceiling lamps are isolated.'},
   {'Recording protocol','A valid silent sample needs an active recording channel, zero vibrating sources, and a still observer inside the pale sample area for FIVE seconds. Partial samples are discarded when the observer moves. Device settings remain. No voice or microphone permission is used.'}},
  hints={'Separate devices that generate vibration from the device that records it.', 'Turning everything off cannot certify a sample: the recording channel would also be off.', 'Remove power from both vibrating sources, retain the passive recorder, then stand still in the pale area. There is no deadline.'},
  feedback='The certified recording contains a breath taken before you entered. Receipt: HUSH.'},
 {title='THE OTHER SIDE', memory='EYE', intro='The reflection changes both position and identity. Four impressions fit the lock.',
  docs={
   {'Mirror inscription','EYE   SUN   KEY   MOON\nThis strip is on the reflected side of the glass. The lock is on this side.'},
   {'Silvering recipe','Crossing the glass reverses the entire strip. It also exchanges paired impressions: EYE with KEY, and SUN with MOON. Apply each change once. Read the resulting strip left to right.'},
   {'Lock care','Enter four impressions, then COMMIT. RESET clears only your draft. This is an inscription puzzle, not a live reflected image of your avatar.'}},
  hints={'There are two independent transformations. Reversing alone is incomplete.', 'Reverse the four positions on paper, then replace each symbol with its paired impression.', 'The leftmost reflected impression was MOON. Its partner becomes the first lock impression. Continue the same rule for the other three.'},
  feedback='The glass shows a handprint on your side before you touch it. Receipt: EYE.'},
 {title='NOTHING IS MISSING', memory='VOID', intro='The floor has two incompatible histories. You control when each history is shown.',
  docs={
   {'Conservation report','SUN and MOON are archived floor exposures, not timed phases. A stable tile exists in BOTH exposures of its row. A tile appearing in only one is an invention. Choose one stable column for each row, in entrance-to-exit order.'},
   {'Projection controls','Select SUN or MOON to hold an exposure indefinitely. Observe the tiles, change exposure, and compare. The permanent catch floor supports you even where an image disappears. Submit the four row settings; no jump or race is needed.'},
   {'Missing-entry standard','An absent entry still occupies a position. In an audit, it must be written BLANK; silently deleting it falsifies every position after it.'}},
  hints={'Record the visible letters in each row under SUN, then under MOON.', 'For each row, keep the intersection of those two sets, not their union.', 'One letter survives both exposures in every row. The route is a sequence of those four letters. You can switch views as often as needed.'},
  feedback='The absent tiles leave footprints. Yours. Receipt: VOID.'},
 {title='FOR YOUR SAFETY', memory='TRACE', intro='The cameras are always watching. Their authorization circuit can be disproved without outrunning them.',
  docs={
   {'Relay budget','Exactly TWO of the four relays A, B, C, D must be powered for a maintenance authorization. Red eyes indicate observation, not a timed damage zone.'},
   {'Wiring constraints','A and C must have different power states. B must have the same power state as A. If C is powered, D must be off. All three constraints and the relay budget apply simultaneously.'},
   {'Retrieval audit','Preserve this witness order for the final audit:\nINTERROGATION, REFLECTION, FLOOR INSPECTION, ARCHIVE, CORRIDOR.\nThen append one missing entry.\nA receipt belongs to the room that issued it, not to the word printed on it.'}},
  hints={'Try the two cases for A; the wiring fixes B and C in each case.', 'If A is off, B is off and C is on. The rule about C then forces D off.', 'That case cannot reach the required power budget. Examine the other case, then use the budget to determine D.'},
  feedback='The lenses close. The audit lists your movements tomorrow. Receipt: TRACE.'},
 {title='THE WITNESS', memory='SELF', intro='A genuine record must have been possible. Check both its author and its date.',
  docs={
   {'Staff registry','ADA: ENGINEER, employed 1970-1972. MARA: ARCHIVIST, employed 1973-1980. IVO: PORTER, employed 1970-1974. Employment endpoints are inclusive.'},
   {'Seal permissions','Only an ENGINEER may sign a POWER log. Only an ARCHIVIST may sign a MEMORY log. Only a PORTER may sign an ENTRY log. A valid record must use its author\'s permitted log AND fall within their employment dates.'},
   {'Recovered records','A: ADA signed an ENTRY log in 1971.\nB: MARA signed a MEMORY log in 1971.\nC: IVO signed an ENTRY log in 1971.\nClassify each as ROLE ERROR, DATE ERROR, or VALID. Each invalid record violates exactly one rule.'},
   {'Unopened intake','The original intake has no visitor name on its cover. Its recipient field will resolve only after the three records have been reconciled.'}},
  hints={'Check each record twice: permitted log first, employment dates second.', 'A record can have a possible date but an impossible seal, or a permitted seal but an impossible date.', 'ADA is present in 1971 but cannot sign entry logs. MARA can sign memory logs but is not employed in 1971. Apply both checks to IVO.'},
  feedback='The intake opens: the building requested YOU before it had rooms. Receipt: SELF.'},
 {title='THE WORLD IS LYING', memory='ORIGIN', intro='The building asks you to correct its account of you. Your notebook is admissible evidence.',
  docs={
   {'Final audit protocol','Recover the five room receipts in the witness order specified by the surveillance retrieval audit. Append the missing entry according to the conservation report. Submit exactly SIX entries. Then certify the corrected account using the silent-room recording protocol in the pale area. The recorder is already active; the sources are already isolated.'},
   {'Witness index','INTERROGATION = reception door plates. REFLECTION = the glass impressions. FLOOR INSPECTION = the ceiling load records. ARCHIVE = staff and log seals. CORRIDOR = the survey loop. Every solved room receipt and every inspected document remains in your notebook (N or the Notebook button).'},
   {'Sealed origin file','An intake dated 1971. An empty signature line. A photograph of the chair you are standing beside. READ FILE will release its contents only after the final audit and its silent certification.'}},
  hints={'Use the surveillance audit for the order, and your solved-room receipts for the entries. The witness index resolves each room name.', 'Use five receipts, not five puzzle answers. The floor with disappearing images is not the ceiling inspection room.', 'After the fifth receipt, append the literal BLANK entry. After COMMIT is accepted, stand still in the sample area for five seconds, then read the origin file.'},
  feedback='The audit accepts the one witness the building could never replace: you.'}
}
local floorSymbols={{'SUN','EYE','MOON'},{'SUN','MOON','EYE'},{'MOON','SUN','EYE'},{'EYE','MOON','SUN'}}
local ceilingRecords={'SUN MOON EYE MOON','EYE SUN MOON SUN','EYE MOON EYE SUN','MOON SUN EYE MOON'}
local exposures={SUN={{1,2},{2,3},{1,3},{1,2}},MOON={{2,3},{1,3},{1,2},{1,3}}}
local answers={floor={3,1,3,2},mirror={'SUN','EYE','MOON','KEY'},missing={2,3,1,1},relay={true,true,false,false},records={1,2,3},final={'ASH','EYE','IVORY','SELF','WEST','BLANK'}}
local config={rooms=defs,exposures=exposures,answers=answers,ceilingRecords=ceilingRecords,floorSymbols=floorSymbols}
local function serialize(v)
 if type(v)=='string' then return string.format('%q',v) end
 if type(v)=='number' or type(v)=='boolean' then return tostring(v) end
 assert(type(v)=='table','Unsupported configuration type')
 local result={'{'}
 for k,value in pairs(v) do result[#result+1]='['..serialize(k)..']='..serialize(value)..',' end
 result[#result+1]='}'; return table.concat(result)
end
local module=Instance.new('ModuleScript'); module.Name='TWIL_Config'; module.Source='return '..serialize(config); module.Parent=RS

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
	label(m,'Title',string.format('%02d / %s',i,defs[i].title),Vector3.new(x,12,-30.8),19,3)
	label(m,'Instructions',defs[i].intro,Vector3.new(x,8,29),28,4)
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
 local function control(name,text,id,pos,width)
  local b=label(m,name,text,pos,width or 8,2.6); action(b,id,'Operate'); return b
 end
 for j,doc in ipairs(defs[i].docs) do
  local dx=j%2==1 and -17 or 17
  local dz=j<=2 and 12 or -9
  local b=label(m,'Document'..j,doc[1]..'\n\n'..doc[2],Vector3.new(x+dx,6,dz),11,6)
  action(b,'inspect:'..j,'Read / keep in notebook')
 end
 control('HintTerminal','REQUEST A HINT','hint',Vector3.new(x+17,3,24),10)
 if i==1 then
  for j,name in ipairs({'ASH','BRASS','CHALK'}) do
   local b=part(m,name,Vector3.new(7,9,1),Vector3.new(x+(j-2)*14,3.5,-19),Color3.fromRGB(61,49,45),Enum.Material.Wood)
   action(b,'door:'..j,'Test deduction')
   label(m,'DoorPlate'..j,name..'\n'..defs[1].docs[j+1][2],b.Position+Vector3.new(0,6,0.7),10,4)
  end
 elseif i==2 or i==7 then
  for row=1,4 do
   for col=1,3 do
    local t=part(m,'Tile_'..row..'_'..col,Vector3.new(10,0.4,7),Vector3.new(x+(col-2)*10,0,21-row*7),Color3.fromRGB(86,57,52))
    t:SetAttribute('Row',row); t:SetAttribute('Column',col); t:SetAttribute('Projection',i==7)
    local caption=i==2 and floorSymbols[row][col] or ({'A','B','C'})[col]
    -- SurfaceGui on top, so letters remain readable from the broad walkway.
    local g=Instance.new('SurfaceGui'); g.Face=Enum.NormalId.Top; g.PixelsPerStud=35; g.Parent=t
    local txt=Instance.new('TextLabel'); txt.Size=UDim2.fromScale(1,1); txt.BackgroundTransparency=1
    txt.Text='ROW '..row..' / '..({'A','B','C'})[col]..'\n'..caption; txt.TextScaled=true
    txt.TextColor3=Color3.fromRGB(229,221,199); txt.Font=Enum.Font.Code; txt.Parent=g
   end
   if i==2 then
    local plate=label(m,'CeilingRecord'..row,'CEILING '..row..'\n'..ceilingRecords[row],Vector3.new(x,13,21-row*7),13,2.5)
    action(plate,'ceiling:'..row,'Read ceiling record')
    -- Prompt offset lowers the interaction target, keeping it within reach from the floor.
    plate:FindFirstChildOfClass('ProximityPrompt').UIOffset=Vector2.new(0,50)
    plate:FindFirstChildOfClass('ProximityPrompt').MaxActivationDistance=18
   end
   control('Dial'..row,'ROW '..row..': A','dial:'..row,Vector3.new(x+(row-2.5)*9,3,-19),8)
  end
  if i==7 then
   control('ViewSUN','EXPOSURE SUN','view:SUN',Vector3.new(x-10,3,22))
   control('ViewMOON','EXPOSURE MOON','view:MOON',Vector3.new(x+10,3,22))
  end
 elseif i==3 then
  local statue=Instance.new('Model'); statue.Name='Statue'; statue.Parent=m
  local body=part(statue,'Body',Vector3.new(3,6,2),Vector3.new(x+15,3,-11),Color3.fromRGB(129,132,127))
  part(statue,'Head',Vector3.new(2.7,2.7,2.7),Vector3.new(x+15,7.3,-11),body.Color)
  for _,dx in ipairs({-0.65,0.65}) do part(statue,'Eye',Vector3.new(0.35,0.35,0.1),Vector3.new(x+15+dx,7.5,-9.6),Color3.fromRGB(8,8,8)) end
  statue.PrimaryPart=body
  for _,v in ipairs(statue:GetChildren()) do if v:IsA('BasePart') then v.CanCollide=false end end
  for j,symbol in ipairs({'RING','EYE','TRIANGLE','SQUARE'}) do
   part(m,'Bay'..j,Vector3.new(7,0.2,7),Vector3.new(x+(j-2.5)*10,-0.7,-11),Color3.fromRGB(102,105,96))
   label(m,'BayLabel'..j,j..' / '..symbol,Vector3.new(x+(j-2.5)*10,10,-15),8,2)
  end
  -- Controls face the entrance wall: their position encourages a deliberate turn away.
  local avert=control('Avert','AVERT / ADVANCE','advance',Vector3.new(x-6,3,27))
  avert:FindFirstChildOfClass('SurfaceGui').Face=Enum.NormalId.Front
  control('AcceptBay','ACCEPT BAY','accept',Vector3.new(x+6,3,22))
 elseif i==4 then
  for _,side in ipairs({-1,1}) do
   part(m,'CorridorPartition',Vector3.new(1,16,28),Vector3.new(x+side*6,7,1),Color3.fromRGB(45,49,51))
  end
  -- Survey controls and reference documents stay outside the corridor partitions.
  for j,side in ipairs({'LEFT','RIGHT'}) do
   local b=part(m,'Operator'..side,Vector3.new(7,9,1),Vector3.new(x+(j==1 and -12 or 12),3.5,-19))
   action(b,'turn:'..j,'Choose observer '..side)
   label(m,'OperatorPlate'..j,'OBSERVER '..side,Vector3.new(b.Position.X,10,-18),10,2)
  end
  label(m,'RouteStrip','FURNACE / OBSERVER: NORTH',Vector3.new(x,11,-22),22,3)
 elseif i==5 then
  part(m,'SampleArea',Vector3.new(16,0.15,16),Vector3.new(x,0,0),Color3.fromRGB(132,140,133),Enum.Material.Marble)
  for j,name in ipairs({'FAN','SPEAKER','MICROPHONE'}) do
   control('Device'..j,name..': ON','device:'..j,Vector3.new(x+(j-2)*12,3,-19),10)
  end
 elseif i==6 then
  part(m,'Mirror',Vector3.new(20,11,0.6),Vector3.new(x,7,-20),Color3.fromRGB(153,176,188),Enum.Material.Glass).Reflectance=0.65
  label(m,'ReflectedStrip','EYE   SUN   KEY   MOON',Vector3.new(x,9,-19.5),18,3)
  for j,name in ipairs({'EYE','KEY','SUN','MOON'}) do
   control('Key'..name,name,'symbol:'..name,Vector3.new(x+(j-2.5)*9,3,-14),8)
  end
 elseif i==8 then
  for j=1,3 do
   local camera=part(m,'Camera'..j,Vector3.new(2,2,3),Vector3.new(x+(j%2==0 and -20 or 20),12,14-j*10),Color3.fromRGB(24,27,29),Enum.Material.Metal)
   local eye=part(m,'CameraEye'..j,Vector3.new(1,1,0.2),camera.Position+Vector3.new(0,0,1.6),Color3.fromRGB(230,45,40),Enum.Material.Neon)
   eye:SetAttribute('Eye',true)
  end
  for j,name in ipairs({'A','B','C','D'}) do control('Relay'..j,name..': OFF','relay:'..j,Vector3.new(x+(j-2.5)*9,3,-19),8) end
 elseif i==9 then
  for j,name in ipairs({'A','B','C'}) do control('Dial'..j,'RECORD '..name..': ROLE ERROR','dial:'..j,Vector3.new(x+(j-2)*12,3,-19),10) end
  part(m,'ArchiveDesk',Vector3.new(12,2,4),Vector3.new(x,1,-10),Color3.fromRGB(65,49,41),Enum.Material.Wood)
 elseif i==10 then
  part(m,'SampleArea',Vector3.new(16,0.15,12),Vector3.new(x,0,22),Color3.fromRGB(132,140,133),Enum.Material.Marble)
  for j,name in ipairs({'ASH','IVORY','STILL','WEST','HUSH','EYE','VOID','TRACE','SELF','BLANK'}) do
   control('Key'..name,name,'symbol:'..name,Vector3.new(x+(j%2==1 and -6 or 6),3,20-math.ceil(j/2)*7),8)
  end
  part(m,'Desk',Vector3.new(12,2,4),Vector3.new(x,1,-25),Color3.fromRGB(67,48,37),Enum.Material.Wood)
  control('OriginFile','READ FILE','file',Vector3.new(x,5,-25),11)
  control('Remember','REMEMBER','ending:1',Vector3.new(x-15,3,-25),10)
  control('Forget','FORGET','ending:2',Vector3.new(x+15,3,-25),10)
 end
 if i==2 or i==6 or i==7 or i==8 or i==9 or i==10 then
  control('Commit','COMMIT','commit',Vector3.new(x-5,3,-28),8)
  control('Reset','RESET DRAFT','reset',Vector3.new(x+5,3,-28),8)
 end
end
local spawn=Instance.new('SpawnLocation'); spawn.Name='TWIL_Spawn'; spawn.Size=Vector3.new(7,0.2,5)
spawn.Position=Vector3.new(0,0,24); spawn.Anchored=true; spawn.Neutral=true; spawn.Duration=0; spawn.Parent=root

local server=Instance.new('Script'); server.Name='TWIL_Server'
server.Source=[==[
local Players=game:GetService('Players')
local RunService=game:GetService('RunService')
local TweenService=game:GetService('TweenService')
local RS=game:GetService('ReplicatedStorage')
local root=workspace:WaitForChild('TWIL')
local remote=RS:WaitForChild('TWIL_Remote')
local config=require(RS:WaitForChild('TWIL_Config'))
local defs=config.rooms
local state={}
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
local function show(p,title,body) remote:FireClient(p,'document',{title=title,body=body}) end
local function place(p,n)
 local c=p.Character
 if c then c:PivotTo(CFrame.new((n-1)*100,4,24)) end
end
local function puzzle(s)
 if not s.puzzles[s.room] then
  s.puzzles[s.room]={dials={1,1,1,1},input={},devices={true,true,true},relays={false,false,false,false},bay=4,leg=0,view='SUN',quiet=0,phase=0}
 end
 return s.puzzles[s.room]
end
local function record(p,id,title,body)
 local s=state[p]
 if not s.seen[id] then s.seen[id]=true; s.journal[#s.journal+1]=title..'\n'..body end
end
local function snapshot(p)
 local s=state[p]; if not s then return end
 remote:FireClient(p,'state',{room=s.room,solved=s.solved[s.room]==true,puzzle=puzzle(s),journal=s.journal,hints=s.hints[s.room] or 0})
end
local function solved(p)
 local s=state[p]; if s.solved[s.room] then return end
 s.solved[s.room]=true
 local def=defs[s.room]
 for j,doc in ipairs(def.docs) do record(p,s.room..':doc:'..j,doc[1],doc[2]) end
 if s.room==2 then for j,text in ipairs(config.ceilingRecords) do record(p,'ceiling'..j,'CEILING '..j,text) end end
 record(p,'receipt'..s.room,string.format('ROOM %02d / %s',s.room,def.title),'RECEIPT: '..def.memory)
 tell(p,def.feedback..(s.room<10 and ' Central exit unlocked.' or ' Read the origin file.'))
 snapshot(p)
end
local function requestHint(p)
 local s=state[p]; if not s or s.ended then return end
 local now=os.clock(); if now<(s.hintAt or 0) then return end; s.hintAt=now+1
 local tier=math.min((s.hints[s.room] or 0)+1,3); s.hints[s.room]=tier
 show(p,'REQUESTED HINT '..tier..' / 3',defs[s.room].hints[tier]); snapshot(p)
end
local function addPlayer(p)
 if state[p] then return end
 local s={room=1,solved={},puzzles={},journal={},seen={},hints={}}
 state[p]=s; puzzle(s); p:SetAttribute('TWIL_Checkpoint',1)
 local function spawn(c)
  prepareCharacter(c)
  local hrp=c:WaitForChild('HumanoidRootPart',10)
  if not hrp or not state[p] or p.Character~=c then return end
  local q=puzzle(s); q.quiet=0; q.lastPos=nil
  place(p,s.room); snapshot(p)
  if s.endingText then remote:FireClient(p,'ending',s.endingText) end
 end
 p.CharacterAdded:Connect(spawn)
 if p.Character then task.spawn(spawn,p.Character) end
end
Players.PlayerAdded:Connect(addPlayer)
Players.PlayerRemoving:Connect(function(p) state[p]=nil end)
for _,p in ipairs(Players:GetPlayers()) do addPlayer(p) end
-- Camera input only selects an observation condition; it never awards a solution.
remote.OnServerEvent:Connect(function(p,kind,v)
 local s=state[p]; if not s then return end
 local now=os.clock()
 if kind=='sync' then
  if now<(s.syncAt or 0) then return end; s.syncAt=now+1
  snapshot(p); if s.endingText then remote:FireClient(p,'ending',s.endingText) end
 elseif kind=='hint' then requestHint(p)
 elseif kind=='look' and s.room==3 and typeof(v)=='Vector3' then
  if now<(s.lookAt or 0) then return end; s.lookAt=now+0.07
  if v.X==v.X and v.Y==v.Y and v.Z==v.Z and v.Magnitude>0.95 and v.Magnitude<1.05 then s.look=v.Unit; s.lookTime=now end
 end
end)
local function same(a,b)
 if #a~=#b then return false end
 for i,v in ipairs(b) do if a[i]~=v then return false end end
 return true
end
local function watching(p,s,q)
 local hrp=p.Character and p.Character:FindFirstChild('HumanoidRootPart')
 if not hrp then return false end
 local look=s.lookTime and os.clock()-s.lookTime<0.8 and s.look or hrp.CFrame.LookVector
 local target=Vector3.new(200+(q.bay-2.5)*10,6,-11)
 local delta=target-hrp.Position
 return delta.Magnitude<0.1 or look:Dot(delta.Unit)>0.25
end
local function commit(p)
 local s=state[p]; local q=puzzle(s); local n=s.room
 if s.solved[n] then tell(p,'This account has already been accepted.'); return end
 if n==2 or n==7 or n==9 then
  local key=n==2 and 'floor' or n==7 and 'missing' or 'records'
  local draft={}; local wrong={}
  for i,v in ipairs(config.answers[key]) do draft[i]=q.dials[i]; if q.dials[i]~=v then wrong[#wrong+1]=tostring(i) end end
  if same(draft,config.answers[key]) then solved(p) else
   tell(p,'Contradiction in '..(n==9 and 'record(s) ' or 'row(s) ')..table.concat(wrong,', ')..'. Your draft remains. Consult the original evidence.')
  end
 elseif n==6 then
  if same(q.input,config.answers.mirror) then solved(p) else tell(p,'The four-impression seal disagrees. Both position and identity must cross the glass. RESET edits the draft.') end
 elseif n==8 then
  local a,b,c,d=table.unpack(q.relays); local count=0; for _,on in ipairs(q.relays) do if on then count=count+1 end end
  if count==2 and a~=c and b==a and not(c and d) then solved(p) else
   tell(p,string.format('Power budget: %d / 2. Wiring: %s. Settings retained.',count,(a~=c and b==a and not(c and d)) and 'consistent' or 'contradiction detected'))
  end
 elseif n==10 then
  if q.phase>=1 then tell(p,'Audit accepted. Certify the silent sample in the pale area.'); return end
  if same(q.input,config.answers.final) then
   q.phase=1; q.quiet=0; q.lastPos=nil
   tell(p,'Six positions agree. The recorder opens. Certify the corrected account in the pale area; your notebook remains yours.')
  else tell(p,'The six-entry audit disagrees. Check witness order, room receipts, and the missing-entry standard. Your draft remains.') end
 end
 snapshot(p)
end
local function interact(p,obj)
 local s=state[p]; local c=p.Character; local hrp=c and c:FindFirstChild('HumanoidRootPart'); local hum=c and c:FindFirstChildOfClass('Humanoid')
 if not s or not hrp or not hum or hum.Health<=0 then return end
 if not obj:IsDescendantOf(room(s.room)) then return end
 local range=obj.Name:match('^CeilingRecord') and 19 or 12
 if (hrp.Position-obj.Position).Magnitude>range then return end
 local now=os.clock(); if now<(s.actionAt or 0) then return end; s.actionAt=now+0.25
 local a=obj:GetAttribute('Action'); if type(a)~='string' then return end
 local command,arg=a:match('^([^:]+):?(.*)$')
 local q=puzzle(s); local n=s.room
 -- Documents and hints remain readable after solving. Nothing changes another player's draft.
 if command=='inspect' then
  local j=tonumber(arg); local doc=j and defs[n].docs[j]
  if doc then record(p,n..':doc:'..j,doc[1],doc[2]); show(p,doc[1],doc[2]); snapshot(p) end
  return
 elseif command=='ceiling' and n==2 then
  local j=tonumber(arg); local value=j and config.ceilingRecords[j]
  if value then record(p,'ceiling'..j,'CEILING '..j,value); show(p,'CEILING '..j,value); snapshot(p) end
  return
 elseif command=='hint' then requestHint(p); return end
 if s.ended then return end
 if command=='exit' then
  if n==10 then tell(p,'The last door requires a decision, not another room.'); return end
  if not s.solved[n] then tell(p,'The account is unresolved. The door waits.'); return end
  local ghost=obj:Clone(); ghost.Name='DoorEcho'; ghost:ClearAllChildren(); ghost.CanCollide=false; ghost.Transparency=0.6; ghost.Parent=root
  TweenService:Create(ghost,TweenInfo.new(0.6),{CFrame=ghost.CFrame*CFrame.new(7,0,0),Transparency=1}):Play()
  game:GetService('Debris'):AddItem(ghost,0.7)
  s.room=n+1; puzzle(s); p:SetAttribute('TWIL_Checkpoint',s.room)
  place(p,s.room); snapshot(p); tell(p,'Checkpoint '..s.room..'. The building has already prepared your chair.'); return
 elseif command=='file' and n==10 then
  if not s.solved[10] then tell(p,'The origin file requires an accepted audit and certified sample.'); return end
  q.readFile=true
  local body='RECIPIENT: '..p.DisplayName..'\n\nThis building is not abandoned. It is an organ that learns to imitate a mind. The doors tested your contradictions; the floors measured what you would trust. The camera audit predates your arrival.\n\nThe 1971 intake requested your decisions, not your body. Every correct answer supplied a missing part. The signature forming below the request is yours.\n\nREMEMBER keeps the record. FORGET gives the building your place outside.'
  record(p,'origin','ORIGIN / PERSONAL INTAKE',body); show(p,'ORIGIN / PERSONAL INTAKE',body)
 elseif command=='ending' and n==10 then
  if not s.solved[10] or not q.readFile then tell(p,'Read the opened origin file before deciding.'); return end
  s.ended=true
  s.endingText=arg=='1' and 'YOU REMEMBER\nYou leave carrying every receipt.\nOutside, every window turns toward you.\nThe building has learned to recognize itself in other buildings.\n\nTHE WORLD IS STILL LYING.' or 'YOU FORGET\nYour name disappears from the intake.\nSomething wearing your decisions walks outside.\nInside, the receptionist welcomes you for the first time.\n\nTHE BUILDING REMEMBERS YOU.'
  remote:FireClient(p,'ending',s.endingText)
 elseif s.solved[n] then tell(p,'Accepted. Your receipt is in the notebook. Use the central exit.')
 elseif command=='door' and n==1 then
  if arg=='1' then solved(p) else tell(p,'That assumed release makes more than one plate true. The ledger permits exactly one. Nothing has been erased.') end
 elseif command=='dial' and (n==2 or n==7 or n==9) then
  local j=tonumber(arg); local limit=n==9 and 3 or 4
  if j and j>=1 and j<=limit then q.dials[j]=q.dials[j]%3+1; tell(p,'Draft updated. COMMIT checks the complete account.') end
 elseif command=='advance' and n==3 then
  if now<(q.movingUntil or 0) then tell(p,'The mechanism is settling into its latch.'); return end
  if watching(p,s,q) then tell(p,'The witness will not move while you observe it. Turn your view away, then pull AVERT.'); return end
  q.bay=q.bay%4+1; q.movingUntil=now+1.2
  tell(p,'A stone foot scrapes. The next bay latches; it will wait for you.')
 elseif command=='accept' and n==3 then
  if now<(q.movingUntil or 0) then tell(p,'Wait for the latch to settle.'); return end
  if not watching(p,s,q) then tell(p,'The exhibit must be observed when its bay is certified.'); return end
  if q.bay==2 then solved(p) else tell(p,'This bay contradicts the curator correction. The witness remains available.') end
 elseif command=='turn' and n==4 then
  local correct={2,2,1}
  if tonumber(arg)==correct[q.leg+1] then
   q.leg=q.leg+1
   if q.leg==3 then solved(p) else place(p,4); tell(p,'Accepted leg '..q.leg..' / 3. The next observer stamp is now active.') end
  else place(p,4); tell(p,'That bearing contradicts the survey. Accepted legs remain; reconsider the current observer.') end
 elseif command=='device' and n==5 then
  local j=tonumber(arg); if j and j>=1 and j<=3 then q.devices[j]=not q.devices[j]; q.quiet=0; tell(p,'Device setting retained. The meter waits for a valid sample.') end
 elseif command=='symbol' and (n==6 or n==10) then
  local allowed=n==6 and {'EYE','KEY','SUN','MOON'} or {'ASH','IVORY','STILL','WEST','HUSH','EYE','VOID','TRACE','SELF','BLANK'}
  local valid=false; for _,v in ipairs(allowed) do if v==arg then valid=true end end
  if n==10 and q.phase>=1 then tell(p,'The audit is sealed. Certify the silent sample.'); return end
  local max=n==6 and 4 or 6
  if valid and #q.input<max then q.input[#q.input+1]=arg; tell(p,'Draft '..#q.input..' / '..max..': '..table.concat(q.input,' > '))
  else tell(p,'Draft full. COMMIT checks it; RESET lets you edit.') end
 elseif command=='view' and n==7 and (arg=='SUN' or arg=='MOON') then
  q.view=arg; tell(p,arg..' exposure held. Nothing is counting down.')
 elseif command=='relay' and n==8 then
  local j=tonumber(arg); if j and j>=1 and j<=4 then q.relays[j]=not q.relays[j]; tell(p,'Relay state retained. The lenses follow your hand.') end
 elseif command=='commit' then commit(p); return
 elseif command=='reset' then
  if n==10 and q.phase>=1 then tell(p,'The corrected audit is already sealed; no need to repeat it.'); return end
  q.input={}; q.dials={1,1,1,1}; q.relays={false,false,false,false}
  tell(p,'Only your current draft was cleared. Evidence, receipts, and checkpoints remain.')
 end
 snapshot(p)
end
for _,obj in ipairs(root:GetDescendants()) do
 if obj:IsA('ProximityPrompt') then obj.Triggered:Connect(function(p) interact(p,obj.Parent) end) end
end
local accumulator=0
RunService.Heartbeat:Connect(function(dt)
 accumulator=accumulator+dt; if accumulator<0.15 then return end
 local step=math.min(accumulator,0.3); accumulator=0
 local function updatePlayer(p,s)
  local c=p.Character; local hrp=c and c:FindFirstChild('HumanoidRootPart'); local hum=c and c:FindFirstChildOfClass('Humanoid')
  if not hrp or not hum or hum.Health<=0 or s.ended then return end
  local q=puzzle(s); local pos=hrp.Position; local x=(s.room-1)*100
  if pos.Y< -12 or math.abs(pos.X-x)>25 or math.abs(pos.Z)>34 then
   place(p,s.room); q.quiet=0; q.lastPos=nil; tell(p,'The walls return you. Your evidence and accepted work remain.'); return
  end
  if not s.solved[s.room] and (s.room==5 or (s.room==10 and q.phase==1)) then
   local center=s.room==5 and 0 or 22
   local inside=math.abs(pos.X-x)<8 and math.abs(pos.Z-center)<(s.room==5 and 8 or 6)
   local still=q.lastPos and (pos-q.lastPos).Magnitude<0.18 and hum.MoveDirection.Magnitude<0.05 and hum.FloorMaterial~=Enum.Material.Air
   local ready=s.room==10 or (not q.devices[1] and not q.devices[2] and q.devices[3])
   if inside and still and ready then q.quiet=q.quiet+step else q.quiet=0 end
   q.lastPos=pos
   remote:FireClient(p,'sample',{seconds=math.min(5,math.floor(q.quiet)),ready=ready,inside=inside})
   if q.quiet>=5 then
    q.phase=2; solved(p)
    if s.room==10 then tell(p,'The certified silence contains your voice saying the next word before you choose it. The origin file opens.') end
   end
  end
 end
 for p,s in pairs(state) do updatePlayer(p,s) end
end)
]==]
server.Parent=SSS

local client=Instance.new('LocalScript'); client.Name='TWIL_Client'
client.Source=[==[
local Players=game:GetService('Players')
local RunService=game:GetService('RunService')
local UIS=game:GetService('UserInputService')
local RS=game:GetService('ReplicatedStorage')
local p=Players.LocalPlayer
local remote=RS:WaitForChild('TWIL_Remote')
local config=require(RS:WaitForChild('TWIL_Config'))
local root=workspace:WaitForChild('TWIL')
local gui=Instance.new('ScreenGui'); gui.Name='TWIL_HUD'; gui.ResetOnSpawn=false; gui.IgnoreGuiInset=false; gui.Parent=p:WaitForChild('PlayerGui')
local function text(parent,name,pos,size,fontSize)
 local t=Instance.new('TextLabel'); t.Name=name; t.Position=pos; t.Size=size
 t.BackgroundColor3=Color3.fromRGB(9,12,16); t.BackgroundTransparency=0.15; t.BorderSizePixel=0
 t.TextColor3=Color3.fromRGB(217,222,212); t.TextWrapped=true; t.Font=Enum.Font.Code; t.TextSize=fontSize; t.Parent=parent; return t
end
local status=text(gui,'Status',UDim2.fromScale(0.04,0.01),UDim2.fromScale(0.92,0.06),17)
local progress=text(gui,'Progress',UDim2.fromScale(0.04,0.15),UDim2.fromScale(0.92,0.08),16)
local message=text(gui,'Message',UDim2.fromScale(0.04,0.8),UDim2.fromScale(0.92,0.17),17)
local function button(parent,name,caption,pos,size,callback)
 local b=Instance.new('TextButton'); b.Name=name; b.Text=caption; b.Position=pos; b.Size=size
 b.BackgroundColor3=Color3.fromRGB(32,40,44); b.TextColor3=Color3.fromRGB(227,226,210)
 b.TextSize=17; b.Font=Enum.Font.Code; b.TextWrapped=true; b.Parent=parent; b.Activated:Connect(callback); return b
end
local panel=Instance.new('Frame'); panel.Name='ReadingPanel'; panel.Position=UDim2.fromScale(0.04,0.25); panel.Size=UDim2.fromScale(0.92,0.52)
panel.BackgroundColor3=Color3.fromRGB(12,17,21); panel.Visible=false; panel.Parent=gui
local title=text(panel,'Title',UDim2.fromScale(0.02,0.01),UDim2.fromScale(0.78,0.15),19)
local scroll=Instance.new('ScrollingFrame'); scroll.Position=UDim2.fromScale(0.02,0.18); scroll.Size=UDim2.fromScale(0.96,0.8)
scroll.BackgroundTransparency=1; scroll.BorderSizePixel=0; scroll.ScrollBarThickness=8; scroll.CanvasSize=UDim2.new()
scroll.AutomaticCanvasSize=Enum.AutomaticSize.Y; scroll.Parent=panel
local body=text(scroll,'Body',UDim2.new(0,0,0,0),UDim2.new(1,-16,0,0),18)
body.AutomaticSize=Enum.AutomaticSize.Y; body.TextXAlignment=Enum.TextXAlignment.Left; body.TextYAlignment=Enum.TextYAlignment.Top
local endingActive=false
button(panel,'Close','CLOSE',UDim2.fromScale(0.81,0.02),UDim2.fromScale(0.17,0.12),function() if not endingActive then panel.Visible=false end end)
local current=1; local latest; local lastSample; local journal={}; local notebookOpen=false; local token=0
local function open(titleText,bodyText)
 title.Text=titleText; body.Text=bodyText; scroll.CanvasPosition=Vector2.new(0,0); panel.Visible=true
end
local function notebook()
 if endingActive then return end
 notebookOpen=not notebookOpen
 if notebookOpen then open('PERSONAL EVIDENCE / SESSION RECORD',#journal>0 and table.concat(journal,'\n\n----------------\n\n') or 'No evidence yet. Inspect a document to retain it. Completed rooms archive their entire case file automatically.') else panel.Visible=false end
end
button(gui,'Notebook','NOTEBOOK [N]',UDim2.fromScale(0.04,0.08),UDim2.fromScale(0.43,0.06),notebook)
button(gui,'Hint','REQUEST NEXT HINT',UDim2.fromScale(0.53,0.08),UDim2.fromScale(0.43,0.06),function() if not endingActive then remote:FireServer('hint') end end)
UIS.InputBegan:Connect(function(input,processed) if not processed and input.KeyCode==Enum.KeyCode.N then notebook() end end)
local statue; local statueTarget
local function ensureStatue()
 if statue then return end
 local original=root:FindFirstChild('Room03'); original=original and original:FindFirstChild('Statue')
 if not original then return end -- Streaming may deliver it later; RenderStepped retries.
 statue=original:Clone(); statue.Name='PersonalWitness'; statue.Parent=workspace
 for _,v in ipairs(statue:GetDescendants()) do if v:IsA('BasePart') then v.CanCollide=false end end
 for _,v in ipairs(original:GetDescendants()) do if v:IsA('BasePart') then v.LocalTransparencyModifier=1 end end
end
local function caption(model,name,value)
 local part=model:FindFirstChild(name); local surface=part and part:FindFirstChildOfClass('SurfaceGui')
 local label=surface and surface:FindFirstChildOfClass('TextLabel'); if label then label.Text=value end
 local prompt=part and part:FindFirstChildOfClass('ProximityPrompt'); if prompt then prompt.ObjectText=value end
end
local function project(model,q)
 for _,tile in ipairs(model:GetChildren()) do
  if tile:GetAttribute('Projection') then
   local visible=false
   for _,col in ipairs(config.exposures[q.view][tile:GetAttribute('Row')]) do if col==tile:GetAttribute('Column') then visible=true end end
   tile.LocalTransparencyModifier=visible and 0 or 1
   local surface=tile:FindFirstChildOfClass('SurfaceGui'); if surface then surface.Enabled=visible end
   -- Collision is never removed: the puzzle is a comparison, not a platforming test.
  end
 end
end
local function refresh()
 if not latest then return end
 local model=root:FindFirstChild(string.format('Room%02d',current)); if not model then return end
 local q=latest.puzzle
 local draft=table.concat(q.input,' > ')
 if latest.solved then progress.Text='ACCOUNT ACCEPTED / RECEIPT ARCHIVED'..(current<10 and ' / CENTRAL EXIT UNLOCKED' or ' / READ THE ORIGIN FILE')
 elseif current==2 or current==7 then
  local row={}; for j=1,4 do local v=({'A','B','C'})[q.dials[j]]; row[j]=v; caption(model,'Dial'..j,'ROW '..j..': '..v) end
  progress.Text='ROUTE DRAFT: '..table.concat(row,' / ')..(current==7 and ' | EXPOSURE '..q.view or '')
 elseif current==3 then progress.Text='WITNESS AT BAY '..q.bay..' / EACH BAY LATCHES UNTIL YOU ADVANCE IT'
 elseif current==4 then
  local station=({'FURNACE','CISTERN','ARCHIVE','RELEASE'})[q.leg+1]
  local facing=({'NORTH','SOUTH','EAST','COMPLETE'})[q.leg+1]
  local line=station..' / OBSERVER: '..facing..' / ACCEPTED LEGS '..q.leg..' / 3'
  caption(model,'RouteStrip',line); progress.Text=line
 elseif current==5 then
  for j,name in ipairs({'FAN','SPEAKER','MICROPHONE'}) do caption(model,'Device'..j,name..': '..(q.devices[j] and 'ON' or 'OFF')) end
  progress.Text='SAMPLE METER / CONFIGURE THE INSTRUMENTS AND OBSERVE'
 elseif current==6 then progress.Text='IMPRESSION DRAFT '..#q.input..' / 4: '..draft
 elseif current==8 then
  local count=0
  for j,name in ipairs({'A','B','C','D'}) do if q.relays[j] then count=count+1 end; caption(model,'Relay'..j,name..': '..(q.relays[j] and 'ON' or 'OFF')) end
  progress.Text='POWERED RELAYS: '..count..' / REQUIRED BUDGET: 2'
 elseif current==9 then
  for j,name in ipairs({'A','B','C'}) do caption(model,'Dial'..j,'RECORD '..name..': '..({'ROLE ERROR','DATE ERROR','VALID'})[q.dials[j]]) end
  progress.Text='CLASSIFY ALL THREE RECORDS / COMMIT CHECKS THE COMPLETE ACCOUNT'
 elseif current==10 then progress.Text=q.phase>=1 and 'AUDIT ACCEPTED / SILENT CERTIFICATION REQUIRED IN THE PALE AREA' or ('AUDIT DRAFT '..#q.input..' / 6: '..draft)
 else progress.Text='OBSERVE / DEDUCE / TEST YOUR ACCOUNT. HINTS ARE OPTIONAL.' end
 if lastSample and not latest.solved and (current==5 or (current==10 and q.phase==1)) then
  progress.Text=lastSample.ready and (lastSample.inside and ('CERTIFIED STILLNESS: '..lastSample.seconds..' / 5 SECONDS') or 'RECORDER READY / SAMPLE AREA EMPTY') or 'NO VALID SILENT RECORDING / RECHECK THE INSTRUMENT MANUAL'
 end
 if current==3 then ensureStatue(); statueTarget=CFrame.new(200+(q.bay-2.5)*10,3,-11) end
 if current==7 then project(model,q) end
 if latest.solved then
  local door=model:FindFirstChild('ExitDoor'); if door then door.Color=Color3.fromRGB(83,124,106) end
  if current==2 or current==7 then for _,v in ipairs(model:GetChildren()) do if v:GetAttribute('Row') then v.Color=Color3.fromRGB(100,126,112) end end end
 end
 if current==8 then for _,v in ipairs(model:GetChildren()) do if v:GetAttribute('Eye') then v.Color=latest.solved and Color3.fromRGB(26,32,29) or Color3.fromRGB(230,45,40) end end end
end
remote.OnClientEvent:Connect(function(kind,value)
 if kind=='state' then
  local changed=current~=value.room; latest=value; current=value.room; journal=value.journal
  status.Text=string.format('THE WORLD IS LYING | ROOM %02d / 10 | HINTS %d / 3',current,value.hints)
  if changed then lastSample=nil end
  if changed and not endingActive then panel.Visible=false; notebookOpen=false end
  if notebookOpen then open('PERSONAL EVIDENCE / SESSION RECORD',table.concat(journal,'\n\n----------------\n\n')) end
  refresh()
 elseif kind=='message' then
  token=token+1; local mine=token; message.Text=value
  task.delay(12,function() if token==mine then message.Text='' end end)
 elseif kind=='document' then notebookOpen=false; open(value.title,value.body)
 elseif kind=='sample' then
  lastSample=value
  progress.Text=value.ready and (value.inside and ('CERTIFIED STILLNESS: '..value.seconds..' / 5 SECONDS') or 'RECORDER READY / SAMPLE AREA EMPTY') or 'NO VALID SILENT RECORDING / RECHECK THE INSTRUMENT MANUAL'
 elseif kind=='ending' then endingActive=true; notebookOpen=false; open('END OF CHAPTER ONE',value); progress.Text='Your choice has been recorded for this session.'; message.Text='' end
end)
local elapsed=0; local refreshTime=0
RunService.RenderStepped:Connect(function(dt)
 elapsed=elapsed+dt; refreshTime=refreshTime+dt
 if current==3 then
  ensureStatue()
  if statue and statueTarget then statue:PivotTo(statue:GetPivot():Lerp(statueTarget,math.min(dt*5,1))) end
  if elapsed>=0.1 then elapsed=0; local camera=workspace.CurrentCamera; if camera then remote:FireServer('look',camera.CFrame.LookVector) end end
 end
 if refreshTime>=1 then refreshTime=0; refresh() end
end)
remote:FireServer('sync')
]==]
client.Parent=SP.StarterPlayerScripts
print('THE WORLD IS LYING: hard-but-fair edition generated. Ten rooms, requested hints, personal notebook, session checkpoints. Save the place and press Play. Studio playtesting is required.')
