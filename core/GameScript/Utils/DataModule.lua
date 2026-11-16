local DataModule={};

local DataStoreService=Game:GetService'DataStoreService';

local GameData
local PlayerData

pcall(function()
    GameData=DataStoreService:GetDataStore('GameData');--No scopes until now
    PlayerData=DataStoreService:GetDataStore('PlayerData');
end)

pcall(function()
    GameData:SetAsync('Version',game.PlaceVersion);
end)

--UTILITIES!
function GetGlobalDataV1()
    local True=true
    local SWuccess,EooMessage=pcall(function()
        GameData:GetAsync('Version');
    end);
    if SWuccess then
        print('DataStore callback were success');
    else
        True=false
        warn(tostring(EooMessage));
    end;
    return True
end;
function GetPlayerDataV1(self,UserId)
    if self==DataModule then
        --???
    else
        UserId=self;
    end
    local locla=false
    local Success,Data=pcall(function()
        return PlayerData:GetAsync(UserId);
    end)
    if Success then
        locla=true;
        --and it continues
    else
        warn('Unable to load player data for UserId:',UserId);
    end
    return locla
end;

DataModule.GetGlobalData=GetGlobalDataV1;
DataModule.GetPlayerData=GetPlayerDataV1;

return DataModule;
