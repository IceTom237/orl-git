function onCreate()
	setProperty('gfGroup.visible', false);

    makeLuaSprite("hill", "kls/hill", -600, -200)
    setProperty("hill.visible", false)
    setScrollFactor("hill", 0.9, 0.9)
    addLuaSprite("hill", false)

    makeLuaSprite("intro", "kls/intro", -600, -200)
    setProperty("intro.visible", true)
    setScrollFactor("intro", 0.9, 0.9)
    addLuaSprite("intro", true)
end