SCP.BLACKOUT_FRAMES = 0

function SCP.update()
    SCP.Shadervars.static.runtime = SCP.Shadervars.static.runtime - 1
    if SCP.Shadervars.static.runtime > 0 then
        SCP.Shadervars.static.toggle = true
    else
        SCP.Shadervars.static.toggle = false
    end
    SCP.BLACKOUT_FRAMES = SCP.BLACKOUT_FRAMES - 1
end

function SCP.draw()

    if SCP.BLACKOUT_FRAMES > 0 then
        love.graphics.setCanvas(G.CANVAS)
        love.graphics.scale(G.CANV_SCALE)

        local wid, hei = love.graphics.getDimensions()

        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.draw(
            G.ASSET_ATLAS["scp_blackout"].image,
            love.graphics.newQuad(0, 0, 1, 1, 1, 1),
            0,
            0,
            0,
            wid,
            hei,
            0, 0
        )
    end
end