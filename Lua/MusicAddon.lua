-- Play a music using the AVAudioPlayer
-- 
-- in_filename : name of the resource file to play (e.g. "music.mp3")
-- in_volume   : initial volume [0.0, 1.0] (optional, defaults to 1.0)
function playMusic(in_filename, in_volume)
    if _playMusic ~= nil then
        playMusicVolume = 1.0
        if in_volume ~= nil then
            playMusicVolume = in_volume
        end
        _playMusic(in_filename, playMusicVolume)
    end
end

-- Stops the currently playing music
function stopMusic()
    if _stopMusic ~= nil then
        _stopMusic()
    end
end

-- Sets the volume of the currently playing music
--
-- in_volume : value [0.0, 1.0]
function setVolume(in_volume)
    if _setVolume ~= nil then
        _setVolume(in_volume)
    end
end

-- Gets the volume of the currently playing music
function getVolume(in_volume)
    if _getVolume ~= nil then
        return _getVolume(in_volume)
    end
    
    return 0.0
end

-- Gets the peak power for the specified channel
--
-- in_channel : index of the channel (0 for left or mono channel)
function peakPowerForChannel(in_channel)
    if _peakPowerForChannel ~= nil then
        return _peakPowerForChannel(in_channel)
    end
    
    return -160.0
end

-- Gets the average power for the specified channel
--
-- in_channel : index of the channel (0 for left or mono channel)
function averagePowerForChannel(in_channel)
    if _averagePowerForChannel ~= nil then
        return _averagePowerForChannel(in_channel)
    end
    
    return -160.0
end