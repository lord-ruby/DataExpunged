function SCP.update()
    SCP.Shadervars.static.runtime = SCP.Shadervars.static.runtime - 1
    if SCP.Shadervars.static.runtime > 0 and not SCP.Shadervars.static.shown then
        SCP.Shadervars.static.toggle()
    elseif SCP.Shadervars.static.runtime <= 0 and SCP.Shadervars.static.shown then
        SCP.Shadervars.static.toggle()
    end
    
     SCP.Shadervars.blackout.runtime = SCP.Shadervars.blackout.runtime - 1
    if SCP.Shadervars.blackout.runtime > 0 and not SCP.Shadervars.blackout.shown then
        SCP.Shadervars.blackout.toggle()
        ease_value(SCP.Shadervars.blackout, "darkness", SCP.Shadervars.blackout.darkness_on)
        ease_value(SCP.Shadervars.blackout, "radius", SCP.Shadervars.blackout.radius_on)
        ease_value(SCP.Shadervars.blackout, "softness", SCP.Shadervars.blackout.softness_on)
    elseif SCP.Shadervars.blackout.runtime == 0 and SCP.Shadervars.blackout.shown then
        ease_value(SCP.Shadervars.blackout, "darkness", -SCP.Shadervars.blackout.darkness_on)
        ease_value(SCP.Shadervars.blackout, "radius", -SCP.Shadervars.blackout.radius_on)
        ease_value(SCP.Shadervars.blackout, "softness", -SCP.Shadervars.blackout.softness_on)
    elseif SCP.Shadervars.blackout.runtime < 0 and SCP.Shadervars.blackout.radius == 10.0 and SCP.Shadervars.blackout.shown then
        SCP.Shadervars.blackout.toggle()
    end

end