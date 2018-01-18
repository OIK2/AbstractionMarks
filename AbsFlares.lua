function AbsFlareLoader(self)
  self.flares={}
  self:SetBackdropColor(0.1,0.1,0.1,0.1,0.7)
  self:SetScript("OnMouseDown", function(self,button) if (button=="LeftButton" and Defaults.locked == false) then self:StartMoving() end end)
  self:SetScript("OnMouseUp", function(self) self:StopMovingOrSizing() end)
  for i = 1, 9 do
    local t = (i-1)%4
    self.flares[i] = CreateFrame("Button", "AbsMark"..i, self, "AbsFlareTemplate")
    self.flares[i]:SetAttribute("type", "macro")
    self.flares[i]:SetAttribute("macrotext1", "/click CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton\n/click DropDownList1Button"..i)
    if i == 1 then
      self.flares[i]:SetPoint("TOPLEFT", self, "TOPLEFT", 5, -5)
    else
      self.flares[i]:SetPoint("LEFT", self.flares[i-1], "RIGHT")
    end
  end
  self.flares[1]:GetNormalTexture():SetTexCoord(.5,.625,0,.25)
  self.flares[2]:GetNormalTexture():SetTexCoord(.625,.75,0,.25)
  self.flares[3]:GetNormalTexture():SetTexCoord(.75,.875,0,.25)
  self.flares[4]:GetNormalTexture():SetTexCoord(.875,1,0,.25)
  self.flares[5]:GetNormalTexture():SetTexCoord(.25,.375,0,.25)
  self.flares[6]:GetNormalTexture():SetTexCoord(0,.125,.25,.5)
  self.flares[7]:GetNormalTexture():SetTexCoord(.25,.375,.25,.5)
  self.flares[8]:GetNormalTexture():SetTexCoord(.375,.5,0,.25)
  self.flares[9]:SetNormalTexture("interface\\glues\\loadingscreens\\dynamicelements")
  self.flares[9]:GetNormalTexture():SetTexCoord(0, 0.5, 0, 0.5)
end