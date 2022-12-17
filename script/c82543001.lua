local s,id=GetID()
local con=1
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_POSITION+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_BATTLE_START+TIMING_BATTLE_END)
	e2:SetTarget(s.target)
	e2:SetOperation(s.activate)
	c:RegisterEffect(e2)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==1-tp and Duel.IsBattlePhase()
end
function s.filter(c)
	return c:GetSequence()<5 and not c:IsType(TYPE_TOKEN+TYPE_LINK)
end
function s.spfilter(c,e,tp)
	return c:IsType(TYPE_SPELL+TYPE_TRAP+TYPE_MONSTER)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
	end
	--Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_HAND)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	local g=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_HAND+LOCATION_SZONE+LOCATION_MZONE,0,nil,e,tp)
	if #g<1 then Duel.GoatConfirm(tp,LOCATION_HAND+LOCATION_SZONE) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:Select(tp,1,5,nil)
	local fid=e:GetHandler():GetFieldID()
	for tg in aux.Next(sg) do
		local c=e:GetHandler()
		local e1=Effect.CreateEffect(tg)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(TYPE_NORMAL+TYPE_MONSTER+TYPE_LINK)
		tg:RegisterEffect(e1,true)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CHANGE_RACE)
		e2:SetValue(RACE_FIEND)
		tg:RegisterEffect(e2,true)
		local e3=e1:Clone()
		e3:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e3:SetValue(ATTRIBUTE_DARK)
		tg:RegisterEffect(e3,true)
		local e4=e1:Clone()
		e4:SetCode(EFFECT_SET_BASE_ATTACK)
		e4:SetValue(100)
		tg:RegisterEffect(e4,true)
		local e5=e1:Clone()
		e5:SetCode(EFFECT_CHANGE_LEVEL)
		e5:SetValue(1)
		tg:RegisterEffect(e5,true)
		local e6=e1:Clone()
		e6:SetCode(EFFECT_SET_BASE_DEFENSE)
		e6:SetValue(500)
		tg:RegisterEffect(e6,true)
		local e7=e1:Clone()
		e7:SetCode(EFFECT_CHANGE_LINKMARKER)
		e7:SetValue(LINK_MARKER_TOP)
		tg:RegisterEffect(e7,true)
		local e8=Effect.CreateEffect(tg)
		e8:SetType(EFFECT_TYPE_IGNITION)
		e8:SetRange(LOCATION_MZONE)
		e8:SetCountLimit(4)
		e8:SetCode(EFFECT_MONSTER_SSET)
		e8:SetOperation(s.dmtf)
		tg:RegisterEffect(e8,true)
		local e9=Effect.CreateEffect(tg)
		e9:SetType(EFFECT_TYPE_IGNITION)
		e9:SetRange(LOCATION_SZONE)
		e9:SetCountLimit(4)
		e9:SetCode(EFFECT_MONSTER_SSET)
		e9:SetOperation(s.dmtg)
		tg:RegisterEffect(e9,true)
		local e10=Effect.CreateEffect(tg)
		e10:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
		e10:SetRange(LOCATION_MZONE+LOCATION_SZONE)
		e10:SetCode(EVENT_PHASE+PHASE_END)
		e10:SetCountLimit(1)
		e10:SetCondition(s.clac)
		e10:SetOperation(s.clal)
		tg:RegisterEffect(e10,true)
	end
	Duel.SpecialSummon(sg,0,tp,tp,true,false,POS_FACEUP_ATTACK)
	Duel.ConfirmCards(1-tp,sg)
	sg:KeepAlive()
	
end
function s.desfilter(c,fid)
	return c:GetFlagEffectLabel(id)==fid
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local fid=e:GetLabel()
	local tg=g:Filter(s.desfilter,nil,fid)
	g:DeleteGroup()
	Duel.Destroy(tg,REASON_EFFECT)
	local tg2=tg:Filter(s.desfilter,nil,fid)
	Duel.SendtoGrave(tg2,REASON_EFFECT)
end
function s.dmtf(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
end
function s.dmtg(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP_ATTACK)
end
function s.tar(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.FilterFaceupFunction(Card.IsSetCard,0x10ec),tp,LOCATION_MZONE,0,1,nil) end
end
function s.clal(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_LINKMARKER)
	con=con+1
	if con==2 then
		e1:SetValue(LINK_MARKER_TOP_RIGHT)
	elseif con==3 then
		e1:SetValue(LINK_MARKER_RIGHT)
	elseif con==4 then
		e1:SetValue(LINK_MARKER_BOTTOM_RIGHT)
	elseif con==5 then
		e1:SetValue(LINK_MARKER_BOTTOM)
	elseif con==6 then
		e1:SetValue(LINK_MARKER_BOTTOM_LEFT)
	elseif con==7 then
		e1:SetValue(LINK_MARKER_LEFT)
	elseif con==8 then
		e1:SetValue(LINK_MARKER_TOP_LEFT)
	elseif con==9 then
		con=1
		e1:SetValue(LINK_MARKER_TOP)
	end
	c:RegisterEffect(e1,true)
end
function s.clac(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end