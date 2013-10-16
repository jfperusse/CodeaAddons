--- Play a music file.
--
-- Uses the AVAudioPlayer to play a music resource file.
--
-- Supports : AAC, ALAC, HE-AAC, iLBC, IMA4, Linear PCM, MP3.
--
-- @usage playMusic("GameMusic.mp3", 0.5)
--
-- @param in_filename Name of the resource file to play. (e.g. "music.mp3")
-- @param in_volume Initial volume between 0.0 and 1.0. (optional, defaults to 1.0)
function playMusic(in_filename, in_volume)
    if _playMusic ~= nil then
        playMusicVolume = 1.0
        if in_volume ~= nil then
            playMusicVolume = in_volume
        end
        _playMusic(in_filename, playMusicVolume)
    end
end

--- Stop the currently playing music.
function stopMusic()
    if _stopMusic ~= nil then
        _stopMusic()
    end
end

--- Set the volume of the currently playing music.
--
-- @param in_volume Value between 0.0 and 1.0.
function setVolume(in_volume)
    if _setVolume ~= nil then
        _setVolume(in_volume)
    end
end

--- Get the volume of the currently playing music.
function getVolume()
    if _getVolume ~= nil then
        return _getVolume()
    end
    
    return 0.0
end

--- Get the peak power for the specified channel
--
-- @param in_channel Index of the channel (0 for left or mono channel)
function peakPowerForChannel(in_channel)
    if _peakPowerForChannel ~= nil then
        return _peakPowerForChannel(in_channel)
    end
    
    return -160.0
end

--- Get the average power for the specified channel
--
-- @param in_channel Index of the channel (0 for left or mono channel)
function averagePowerForChannel(in_channel)
    if _averagePowerForChannel ~= nil then
        return _averagePowerForChannel(in_channel)
    end
    
    return -160.0
end
