local Sync={};
local Parent=script.Parent

print('Sync module callback was successfull. Loading constants...');

local ReplicatedStorage=Game:GetService 'ReplicatedStorage';

local DataModule=require(Parent.DataModule);

function Sync:GetGlobalData()
    return DataModule:GetGlobalData()
end

function Sync:GetPlayerData(uid)
    return DataModule:GetPlayerData(uid)
end

ReplicatedStorage.GetSyncData.OnServerInvoke=function(Request)
    if Request==nil then
        return DataModule:GetGlobalData();
    end
end;

return Sync;