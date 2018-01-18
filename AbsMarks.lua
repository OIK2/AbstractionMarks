function AbsMarkLoader(self)
  self.marks={}
  self:SetBackdropColor(0.1,0.1,0.1,0.1,0.7)
  self:SetScript("OnMouseDown", function(self,button) if (button=="LeftButton" and Defaults.locked == false) then self:StartMoving() end end)
  self:SetScript("OnMouseUp", function(self) self:StopMovingOrSizing() end)
  for i = 8, 1, -1 do
    local t = (i-1)%4
    self.marks[i] = CreateFrame("Button", "AbsMark"..i, self, "AbsMarkTemplate")
    self.marks[i]:GetNormalTexture():SetTexCoord(t/4, (t+1)/4, ((i > 4) and .25 or 0), ((i > 4) and .5 or .25))
    self.marks[i]:SetScript("OnClick", function(self) SetRaidTargetIcon("target", i) end)
    if i == 8 then
      self.marks[i]:SetPoint("TOPLEFT", self, "TOPLEFT", 5, -5)
    else
      self.marks[i]:SetPoint("LEFT", self.marks[i+1], "RIGHT")
    end
  end
  AM_LockIcon = CreateFrame("Button", "AM_LockIcon", self)
  AM_LockIcon:SetSize(20,20)
  AM_LockIcon:SetPoint("LEFT", self.marks[1] , "RIGHT")
  AM_LockIcon:SetNormalTexture("Interface\\GLUES\\CharacterSelect\\Glues-Addon-Icons")
  AM_LockIcon:GetNormalTexture():SetTexCoord(0, 0.25, 0, 1)
  AM_LockIcon:EnableMouse(true)
end

function AbsCommonFrame(self)
  self:SetMovable(true)
  self:EnableMouse(true)
  self:SetClampedToScreen(true)
end