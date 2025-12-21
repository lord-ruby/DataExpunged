SCP.NOISE_FRAMES = 0
SCP.BLACKOUT_FRAMES = 0

function SCP.update()
    SCP.NOISE_FRAMES = SCP.NOISE_FRAMES - 1
    SCP.BLACKOUT_FRAMES = SCP.BLACKOUT_FRAMES - 1
end

function SCP.draw()
    if SCP.NOISE_FRAMES > 0 then
        love.graphics.setCanvas(G.CANVAS)
        love.graphics.scale(G.CANV_SCALE)

        local wid, hei = love.graphics.getDimensions()

        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.draw(
            G.ASSET_ATLAS["scp_noise"].image,
            love.graphics.newQuad(0, 0, 1, 1, 1, 1),
            0,
            0,
            0,
            wid,
            hei,
            0, 0
        )
    end

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