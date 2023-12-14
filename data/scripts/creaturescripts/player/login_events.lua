local events = {
	"AdvanceRookgaard",
	"BigfootBurdenVersperoth",
	"BigfootBurdenWarzone",
	"BigfootBurdenWeeper",
	"BigfootBurdenWiggler",
	"ElementalSpheresOverlords",
	"InquisitionBosses",
	"InquisitionUngreez",
	"KillingInTheNameOfKills",
	"MastersVoiceServants",
	"NewFrontierShardOfCorruption",
	"NewFrontierTirecz",
	"PythiusTheRotten",
	"SecretServiceBlackKnight",
	"ServiceOfYalaharAzerus",
	"ServiceOfYalaharDiseasedTrio",
	"ServiceOfYalaharQuaraLeaders",
	"SvargrondArenaKill",
	"ThievesGuildNomad",
	"WotEBosses",
	"WotEKeeper",
	"WotELizardMagistratus",
	"WotELizardNoble",
	"WotEZalamon",
	"TutorialCockroach",
}

local loginEvents = CreatureEvent("LoginEvents")

function loginEvents.onLogin(player)
	for i = 1, #events do
		player:registerEvent(events[i])
	end

	return true
end

loginEvents:register()
