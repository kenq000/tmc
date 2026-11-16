--[[
Summary:
local Internal=Instance.new('Folder',Lighting)
local PlayersInGame=Instance.new('Folder',Internal);
local MapVotingReady=Instance.new('BoolValue',Internal)
local GameRoundReady=Instance.new('BoolValue',Internal)

Written proudly by @dircs in VSCode.
]]
local Lighting=Game:GetService'Lighting'
local Debris=Game:GetService'Debris';
local Players=Game:GetService'Players';

-- local ReplicatedStorage=Game:GetService'ReplicatedStorage';

local Root=script.Parent;
local Handle=Root:WaitForChild'Handle';
local RF

while not RF do
    RF=Root:WaitForChild'RemoteFunction';--"RemoteFunction - Reference"
    wait(1);
end

if not Root:IsA'Tool' then return end;

Root.CanBeDropped=false;
Root.RequiresHandle=true;


if not Handle then return end

local Active=false;
local Throwing=false;

--Functions / utility.