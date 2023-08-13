function onCreate()
	setProperty('gfGroup.visible', false);

    makeLuaSprite("inflamed", "inflamed/foraging/inflamed", 0.0, 0.0)
    setProperty("inflamed.visible", false)
    setScrollFactor("inflamed", 0.9, 0.9)
    scaleObject("inflamed", 1, 1)
    addLuaSprite("inflamed", false)

    makeLuaSprite("intro", "inflamed/foraging/intro", 0.0, 0.0)
    setProperty("intro.visible", true)
    setScrollFactor("intro", 0.9, 0.9)
    scaleObject("intro", 1, 1)
    addLuaSprite("intro", true)
end