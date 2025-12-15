SMODS.DrawStep {
    key = 'dissolve_white',
    order = 20,
    func = function(self, layer)
        if self.scp_breach_started then
            self.children.center:draw_shader('scp_dissolve_white', nil, self.ARGS.send_to_shader)
            if self.children.front and not self:should_hide_front() then
                self.children.front:draw_shader('scp_dissolve_white', nil, self.ARGS.send_to_shader)
            end
        end
    end,
    conditions = { vortex = false, facing = 'front' },
}