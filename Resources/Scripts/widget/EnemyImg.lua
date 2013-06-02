
-- EnemyImg ����ͼ��
-- @param scr �㶮��
-- @param pos �ؼ�����λ�ã�Ĭ��Ϊ (0,0)
-- @param enm ������󣬴˲�����ѡ
Widget.EnemyImg = Class(Widget.Widget, function(self, scr, pos, enm)

    -- ���һ�������������κ����壬ֻ���ø����и�����֪������һ�������ڵ��ø��๹�캯����
    Widget.Widget._ctor(self, scr, pos, "WIDGET.ENEMYIMG")
    
    local list = self._viewlist
    list[1] = flux.TextView(ScreenFight.scr, nil, 'wqy')
    list[1]:SetSize(3, 4):SetTextColor(1, 1, 1):SetHUD(true):SetColor(0, 0, 0)
    
    self.title = list[1]

    if enm then
        self:SetEnemy(ch)
    end
    
    self:_UpdatePos()
end)

-- ���ù������
-- @param enm �������
function Widget.EnemyImg:SetEnemy(enm)
    self.enm = enm
    self:Refresh()
end

function Widget.EnemyImg:_UpdatePos()
    local list = self._viewlist
    list[1]:SetPosition(self.pos[1], self.pos[2])
end

-- ����
function Widget.EnemyImg:Refresh()
    local enm = self.enm
    local list = self._viewlist    
    if not enm then return end
    list[1]:SetText(enm:GetAttr('name'))
end
