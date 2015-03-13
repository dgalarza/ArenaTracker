WowApi = {}

function WowApi.CreateFrame(name)
  return CreateFrame(name)
end

function WowApi.GetBattlefieldWinner()
  return GetBattlefieldWinner()
end

function WowApi.GetPlayerArenaFaction()
  return GetBattlefieldArenaFaction()
end

function WowApi.GetNumberOfArenaOpponents()
  return GetNumArenaOpponentSpecs()
end

function WowApi.GetArenaOpponentSpec(opponentNumber)
  return GetArenaOpponentSpec(opponentNumber)
end

function WowApi.GetUnitName(unit)
  return UnitName(unit)
end

function WowApi.IsInArena()
  local _, instanceType = IsInInstance()
  return instanceType == "arena"
end
