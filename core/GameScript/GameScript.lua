local Players=Game:GetService'Players';

local Lighting=Game:GetService'Lighting';
local ReplicatedStorage=Game:GetService'ReplicatedStorage';
local ServerStorage=Game:GetService'ServerStorage';


Players.CharacterAutoLoads=false;

local Internal=Instance.new('Folder',Lighting)
local PlayersInGame=Instance.new('Folder',Internal);
local MapVotingReady=Instance.new('BoolValue',Internal)
local GameRoundReady=Instance.new('BoolValue',Internal)
local Sync;pcall(function() Sync=require(script.Sync) end);
-- local DataModule;pcall(function() DataModule=require(script.DataModule) end);

if not (script:WaitForChild'Sync' and Sync) then warn('could not require a GameScript utility: Sync') return end
-- if not (script:WaitForChild'DataModule' and DataModule) then warn('could not require a GameScript utility: DataModule') return end

repeat wait()until Sync:GetGlobalData()~=false or Sync:GetGlobalData()~=nil;

local Dead=ReplicatedStorage:WaitForChild'Dead';
--utilites
_G.CurrentGameMode=nil;

local Maps=ServerStorage:WaitForChild'Maps' ;

Dead.OnServerEvent:connect(function(Player)
    if not PlayersInGame[Player.UserId] then error(Player.Name,'(UserId:',Player.UserId..') could not be resolved!') end
    local InGameBv=PlayersInGame:FindFirstChild(Player.UserId);
    InGameBv.Value=false;

end)

Players.PlayerAdded:connect(function(Player)

    local IngameBoolean=Instance.new('BoolValue',PlayersInGame)
    IngameBoolean.Name=Player.UserId
    print('Player',IngameBoolean.Name,'joined the game')
    local Success,ErrorMsg=pcall(function()
        if Sync:GetPlayerData(Player.UserId) then
            Player:LoadCharacter();
        end
    end)
        -- if #Players:GetChildren()>=2 then
        --     MapVotingReady.Value=true;
        -- else
        --     print('Player amount not relative');
        -- end
    if #game.Players:GetChildren()>=2 then 
        MapVotingReady.Value=true;
    else 
        -- print('not ok')
    end
    Player.CharacterAdded:connect(function(Charcter)
        for _,Script in pairs(Charcter:GetChildren())do
            if Script:IsA'LocalScript' or Script:IsA'ModuleScript' or Script:IsA'Script' then
                Script.Disabled=false;
            end;
        end;
    end)

end)
Players.PlayerRemoving:connect(function(Player)

    if PlayersInGame:FindFirstChild(Player.UserId) then
        print('Player',PlayersInGame[Player.UserId].Name,'has left the game')
        PlayersInGame[Player.UserId]:destroy();
    end

end)

-- PlayersInGame.ChildAdded:connect(function(UIDPlayer)
--     if not Game:GetService'Players':FindFirstChild(UIDPlayer.Name) then return end
--     local Player=PlayersInGame[UIDPlayer.Name];
--     if #PlayersInGame:GetChildren()>= 2 then
--         MapVotingReady.Value=true;
--     end;
-- end)

MapVotingReady.Changed:connect(function(Prop) --GetPropertyChangedSignal is cooler than ts :(
    print('Map voting!')
    local Pool=Maps:GetChildren()
    if #Pool<=2 then return end
    local Current=MapVotingReady.Value
    if Current==true then
        do
            local VoteIcons=Workspace['VoteIcons'];
            local VotePads=Workspace.VotePads;
            -- local arr=Maps:GetChildren();
            local M1,M2,M3
            local R1,R2,R3={},{},{}
            local Pool2={};
            M1=Pool[math.random(1,#Pool)];
            repeat M2=Pool[math.random(1,#Pool)];until M2~=M1
            repeat M3=Pool[math.random(1,#Pool)];until M3~=M2;
            R1[1]=0;
            R2[1]=0;
            R3[1]=0;
            Pool2[1]=M1;
            Pool2[3]=M2;
            Pool2[3]=M3;
            -- print(M1,M2,M3)
            delay(10,function()
                local chosen
                if R1[1]==0 and R2[1]==0 and R3[1]==0 then
                    chosen=Pool2[math.random(1,#Pool2)];
                elseif R1[1]>R1[1]then
                    chosen=R1[3]
                elseif R1[1]>R2[1]then
                    chosen=R1[3]
                elseif R1[1]>R3[1]then
                    chosen=R1[3]
                elseif R2[1]>R2[1]then
                    chosen=R2[3]
                elseif R2[1]>R1[1]then
                    chosen=R2[3]
                elseif R2[1]>R3[1]then
                    chosen=R2[3]
                elseif R3[1]>R3[1]then
                    chosen=R3[3]
                elseif R3[1]>R3[1]then
                    chosen=R3[3]
                elseif R3[1]>R2[1]then
                    chosen=R3[3]
                end

                if chosen then
                    local Map=chosen:Clone();
                    Map.Parent=Workspace;
                end
            end);
            for _,v in pairs(VoteIcons:GetChildren())do
                for n in string.gmatch(v.Name,'%d+')do
                    if n=='1' then
                        R1[2]=v.MapNamePart.TagGui.Label
                        local Map=M1
                        R1[3]=Map
                        R1[2].Text=Map.Name..': '..R1[1]
                        if Map:FindFirstChild'IconSq' then
                            v.MapIconPart.Dec.Texture=Map.IconSq.Texture;
                        end
                    elseif n=='2' then
                        R2[2]=v.MapNamePart.TagGui.Label
                        local Map=M2
                        R2[3]=Map
                        R2[2].Text=Map.Name..': '..R2[1]
                        if Map:FindFirstChild'IconSq' then
                            v.MapIconPart.Dec.Texture=Map.IconSq.Texture;
                        end
                    elseif n=='3' then
                        R3[2]=v.MapNamePart.TagGui.Label
                        local Map=M3
                        R3[3]=Map
                        R3[2].Text=Map.Name..': '..R3[1]
                        if Map:FindFirstChild'IconSq' then
                            v.MapIconPart.Dec.Texture=Map.IconSq.Texture;
                        end
                    end
                end
            end;
            local _V={};
            local _P={
                [1]=R1;
                [2]=R2;
                [3]=R3;
            };
            for _,pd in pairs(VotePads:GetChildren())do
                for s in string.gmatch(pd.Name,'%d+')do
                    local c=tonumber(s)
                    if _P[c] then
                        pd.Touched:connect(function(t)
                            local p=Players:GetPlayerFromCharacter(t.Parent)
                            if not p then return end
                            if _V[p]==c then return end
                            if _V[p] then
                                local old=_P[_V[p]];
                                old[1]=math.max(0,old[1]-1)
                                old[2].Text=old[3].Name..': '..old[1]
                            end
                            _V[p]=c;
                            _P[c][1]=_P[c][1]+1;
                            _P[c][2].Text=_P[c][3].Name..': '.._P[c][1];
                        end)
                    end
                end
            end
        end
    end;
end)

--[[
local Internal=Instance.new('Folder',Lighting)
local PlayersInGame=Instance.new('Folder',Internal);
local MapVotingReady=Instance.new('BoolValue',Internal)
local GameRoundReady=Instance.new('BoolValue',Internal)]]
Internal.Name='Internal';
PlayersInGame.Name='PlayersInGame';
MapVotingReady.Name='MapVotingReady';
GameRoundReady.Name='GameRoundReady';