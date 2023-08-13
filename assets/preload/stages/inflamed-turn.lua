function onCreate()
	setProperty('gfGroup.visible', false);

    makeLuaSprite("inflamed", "inflamed/torn-apart/forst_turn", 0.0, 0.0)
    setProperty("inflamed.visible", true)
    setScrollFactor("inflamed", 0.9, 0.9)
    scaleObject("inflamed", 1, 1)
    addLuaSprite("inflamed", false)
end