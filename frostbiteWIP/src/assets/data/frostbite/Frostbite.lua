--That Code is Made by Drawoon_

function onCreatePost()
    PositionX={defaultPlayerStrumX0,defaultPlayerStrumX1,defaultPlayerStrumX2,defaultPlayerStrumX3,defaultOpponentStrumX0,defaultOpponentStrumX1,defaultOpponentStrumX2,defaultOpponentStrumX3}
    for i=0,#PositionX-1 do
        setPropertyFromGroup('strumLineNotes',i,'x',PositionX[i+1])
      
    end
    AllTxt={'those psych engine ports go crazy','did you get a brain freeze?',"Freakachu's in your insides rip your skin off do it now"}
    BotPlayTxt=AllTxt[getRandomInt(1,3)]
end
function onUpdatePost(elapsed)
    healthBarPercent = getProperty('healthBar.percent')
    XoffsetP2=healthBarX+(healthBarWidth*healthBarPercent*0.01)+(150 *getProperty('iconP1.scale.x') - 150) / 2 - 26
    XoffsetP1=healthBarX+(healthBarWidth*healthBarPercent*0.01)-(150 *getProperty('iconP2.scale.x')) / 2 - 26* 2
    setProperty('iconP2.x',XoffsetP2)
    setProperty('iconP1.x',XoffsetP1) 
end
function onUpdate(elapsed)
    setTextString('botplayTxt',BotPlayTxt)

    setShaderFloat('ShaderCont','time',getSongPosition() / (stepCrochet * 8))
 
    IntensitySnow=getProperty('ShaderCont.y')
    AmountSnow=toInt(getProperty('ShaderCont.x'))
    setShaderFloat('ShaderCont','intensity',IntensitySnow)
    setShaderInt('ShaderCont','amount',AmountSnow)
end
local WasTrigger=false
function onGameOver()
    setGlobalFromScript('data/CameraMove','cameraCentred',false)
    if not WasTrigger then
        WasTrigger=true
        setProperty('camHUD.visible',false)
        openCustomSubstate('FrostbiteGameOver',false)
    end
    return Function_Stop
end
local IsGameOver=false
function onCustomSubstateCreate(name)
    if name=='FrostbiteGameOver' then
        IsGameOver=true
        setGlobalFromScript('data/CameraMove','ManualPos',{100,650})
        setGlobalFromScript('data/CameraMove','ForceCamPos',true)
        doTweenAlpha('FGm','Freakachu',0,1,'QuadInout')
        
        playSound('fnf_loss_sfx',1,'StartGameOver')
    end
end
function onPause()
    if IsGameOver then
        return Function_Stop
    end
end
function lerp(Min,Max,Ratio)
    return Min + Ratio * (Max - Min);
end
function onCustomSubstateUpdate(name, elapsed)
    if name=='FrostbiteGameOver' then
        setProperty('paused',true)
        runHaxeCode([[
            FlxG.sound.music.volume=0;
            game.vocals.volume=0;
            FlxG.sound.music.pause();
            PlayState.instance.vocals.pause();
            game.KillNotes();
        ]])
        if keyJustPressed('accept') and not EndGame then
            
            playSound('MtSilverEnd',1,'EndGameOver')
            EndGame=true
        end
        if keyJustPressed('back') then
            exitSong()
        end
        if EndGame then
            stopSound('LoopGameOver')
        end
        setProperty('camGame.zoom',lerp(1.2,getProperty('camGame.zoom'),0.95))
        setProperty('defaultCamZoom',getProperty('camGame.zoom'))
    end
end
local EndGame=false
function onSoundFinished(tag)
    if tag=='EndGameOver' then
        restartSong()
    end
    if tag=='LoopGameOver' and EndGame then
        playSound('MtSilverLoop',1,'LoopGameOver')
    end
    if tag=='StartGameOver' then
        playSound('MtSilverLoop',1,'LoopGameOver')
    end
end
function onCreate()
    setProperty('skipCountdown',true)
    addHaxeLibrary('Application', 'lime.app')
    setProperty('healthBar.flipX',true)
    addCharacterToList('Red_Dead', 'dad')
    healthBarWidth= getProperty('healthBar.width')
    setProperty('iconP1.flipX',true)
    healthBarX = getProperty('healthBar.x')
    AmountSnow=100
    IntensitySnow=0.2
    makeLuaSprite("ShaderCont",nil,AmountSnow,IntensitySnow)

  


if shadersEnabled then
    runHaxeCode([[
        var shaderName = "snowfall";
        
        game.initLuaShader(shaderName);
        
        var shader0 = game.createRuntimeShader(shaderName);
        //game.camGame.setFilters([new ShaderFilter(shader0)]);
        game.camHUD.setFilters([new ShaderFilter(shader0)]);
        game.getLuaObject("ShaderCont").shader = shader0; // setting it into temporary sprite so luas can set its shader uniforms/properties
        
        
        shader0.setFloat('intensity', 0.2);
        shader0.setInt('amount', 100);
        shader0.setFloat('time', 1);
    ]])
end
   

    runHaxeCode([[
   Application.current.window.title="]]..songName..'-'..difficultyName..[[";
   ]])
    
end
function onEvent(tag,v1,v2)
if tag =='SnowFall_amount' then
   doTweenX('Amount','ShaderCont',tonumber(v1),(tonumber(v2)*stepCrochet)/1000,'linear')

end
if tag =='SnowFall_intensity' then
   doTweenY('Intensity','ShaderCont',tonumber(v1),(tonumber(v2)*stepCrochet)/1000,'linear')

end
--130.435=stepCrochet
end
function onDestroy()
    runHaxeCode([[
        Application.current.window.title="Friday Night Funkin': Psych Engine";
        ]])
end
function toInt(float)
    if float<=math.floor(float)+0.5 then
        return math.floor(float)
    else
        return math.ceil(float)
    end
end


