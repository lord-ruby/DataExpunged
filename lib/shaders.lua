SMODS.Shader {
    key = 'dissolve_white',
    path = 'dissolve_white.fs',
}

SCP.Shadervars = {}
SCP.Shadervars.static = {}
SCP.Shadervars.static.intensity = 1.0
SCP.Shadervars.static.speed = 10.0
SCP.Shadervars.static.size = 5.0
SCP.Shadervars.static.toggle = false
SCP.Shadervars.static.runtime = 0

SMODS.ScreenShader {
    key = 'scp_static',
    path = 'screen_static.fs',
    send_vars = function(self)
      return {iTime = G.TIMERS.REAL, intensity = SCP.Shadervars.static.intensity, speed = SCP.Shadervars.static.speed, size = SCP.Shadervars.static.size}
    end,
    should_apply = function(self)
      return SCP.Shadervars.static.toggle
    end

}