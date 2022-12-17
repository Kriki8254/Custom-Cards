local s,id=GetID()
function s.initial_effect(c)
	-- Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.filter(c,e,tp)
	return true
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_MZONE+LOCATION_SZONE+LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,0,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local ft=2
	local tc=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_MZONE+LOCATION_SZONE+LOCATION_HAND,0,1,1,nil,e,tp):GetFirst()
	local ct=2
	
	local g=Group.CreateGroup()
	for i=1,ct do
		g:AddCard(Duel.CreateToken(tp,tc:GetOriginalCode()))
	end
	for i=1,ct do
		if tc:IsType(TYPE_MONSTER) and tc:IsFaceup() then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_ATTACK+POS_FACEUP_DEFENSE)
		else
			Duel.SendtoHand(g,tp,REASON_EFFECT)
		end
	end
end