SMODS.Shader {
    key = 'dissolve_white',
    path = 'dissolve_white.fs',
}

SCP.Shadervars = {}
SCP.Shadervars.static = {}
SCP.Shadervars.static.intensity = 1.0
SCP.Shadervars.static.speed = 10.0
SCP.Shadervars.static.size = 5.0
SCP.Shadervars.static.shown = false
SCP.Shadervars.static.toggle = function() SCP.Shadervars.static.shown = not SCP.Shadervars.static.shown end
SCP.Shadervars.static.runtime = 0

SMODS.ScreenShader {
    key = 'scp_static',
    path = 'screen_static.fs',
    send_vars = function(self)
      return {iTime = G.TIMERS.REAL, intensity = SCP.Shadervars.static.intensity, speed = SCP.Shadervars.static.speed, size = SCP.Shadervars.static.size}
    end,
    should_apply = function(self)
      return SCP.Shadervars.static.shown
    end
}

SCP.Shadervars.blackout = {}
SCP.Shadervars.blackout.darkness = 0.0
SCP.Shadervars.blackout.darkness_on = 0.9
SCP.Shadervars.blackout.radius = 10.0
SCP.Shadervars.blackout.radius_on = -10.1
SCP.Shadervars.blackout.softness = 1.0
SCP.Shadervars.blackout.softness_on = -0.5
SCP.Shadervars.blackout.shown = false
SCP.Shadervars.blackout.toggle = function() SCP.Shadervars.blackout.shown = not SCP.Shadervars.blackout.shown end
SCP.Shadervars.blackout.runtime = 0


SMODS.ScreenShader {
    key = 'scp_blackout',
    path = 'screen_black.fs',
    send_vars = function(self)
      return {darkness = SCP.Shadervars.blackout.darkness, radius = SCP.Shadervars.blackout.radius, softness = SCP.Shadervars.blackout.softness}
    end,
    should_apply = function(self)
      return SCP.Shadervars.blackout.shown
    end
}