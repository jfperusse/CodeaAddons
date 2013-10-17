--- Class interfacing the AVAudioPlayer to play music files.
-- You can also play multiple musics at the same time using different instances of this class.
-- See @{MusicAddonExample.lua} for an example.
MusicAddon = class()

--- MusicAddon constructor.
-- @tparam string in_filename Name of the file to load
-- @usage music = MusicAddon("GameMusic.mp3)
-- @see MusicAddon:play
function MusicAddon:init(in_filename)
    self.selfName = tostring(self)
    
    if MusicAddon_load ~= nil then
        MusicAddon_load(self.selfName, in_filename)
    end
end

--- Load a different file.
-- @tparam string in_filename Name of the file to load
function MusicAddon:load(in_filename)
    if MusicAddon_load ~= nil then
        MusicAddon_load(self.selfName, in_filename)
    end
end

--- Unload the currently loaded file.
function MusicAddon:unload()
    if MusicAddon_unload ~= nil then
        MusicAddon_unload(self.selfName)
    end
end

--- Get the name of the loaded file.
-- @treturn string Name of the file currently loaded.
function MusicAddon:getURL()
    if MusicAddon_getURl ~= nil then
        return MusicAddon_getURL(self.selfName)
    end

    return ""
end

--- Enable controlling the play rate of the music.
-- To control the play rate, this function must be called before play or prepareForPlay.
function MusicAddon:enableRate()
    if MusicAddon_enableRate ~= nil then
        MusicAddon_enableRate(self.selfName)
    end
end

--- Enable metering of the music.
-- @see MusicAddon:getAveragePowerForChannel
-- @see MusicAddon:getPeakPowerForChannel
function MusicAddon:enableMetering()
    if MusicAddon_enableMetering ~= nil then
        MusicAddon_enableMetering(self.selfName)
    end
end

--- Prepare the music for play.
-- Starts buffering the music so there is no delay when you start playing it.
function MusicAddon:prepareToPlay()
    if MusicAddon_prepareToPlay ~= nil then
        MusicAddon_prepareToPlay(self.selfName)
    end
end

--- Get the number of times the music will loop.
-- @treturn integer Number of times the music will loop. A negative value means it will keep looping.
function MusicAddon:getLoops()
    if MusicAddon_getLoops ~= nil then
        return MusicAddon_getLoops(self.selfName)
    end
    
    return 0
end

--- Set the number of times the music will loop.
-- @tparam integer in_loops Number of times to loop the music. A negative value means it will keep looping.
function MusicAddon:setLoops(in_loops)
    if MusicAddon_setLoops ~= nil then
        MusicAddon_setLoops(self.selfName, in_loops)
    end
end

--- Get the pan value of the music.
-- @treturn number A value between -1 (left) and +1 (right).
function MusicAddon:getPan()
    if MusicAddon_getPan ~= nil then
        return MusicAddon_getPan(self.selfName)
    end
    
    return 0
end

--- Set the pan value of the music.
-- @tparam number in_pan Pan value between -1 (left) and +1 (right).
function MusicAddon:setPan(in_pan)
    if MusicAddon_setPan ~= nil then
        MusicAddon_setPan(self.selfName, in_pan)
    end
end

--- Get the play rate of the music.
-- @treturn number Current play rate between 0.5 (half-speed) and 2.0 (double speed).
function MusicAddon:getRate()
    if MusicAddon_getRate ~= nil then
        return MusicAddon_getRate(self.selfName)
    end
    
    return 1.0
end

--- Set the play rate of the music.
-- @tparam number in_rate Play rate between 0.5 (half-speed) and 2.0 (double speed).
function MusicAddon:setRate(in_rate)
    if MusicAddon_setRate ~= nil then
        MusicAddon_setRate(self.selfName, in_rate)
    end
end

--- Start playing the loaded music.
function MusicAddon:play()
    if MusicAddon_play ~= nil then
        MusicAddon_play(self.selfName)
    end
end

--- Start playing the music after a certain delay.
-- This can be used to start two musics at precisely the same time.
-- @tparam number in_delay Delay in seconds before the music starts playing.
function MusicAddon:playAfterDelay(in_delay)
    if MusicAddon_playAfterDelay ~= nil then
        MusicAddon_playAfterDelay(self.selfName, in_delay)
    end
end

--- Pause the music.
function MusicAddon:pause()
    if MusicAddon_pause ~= nil then
        MusicAddon_pause(self.selfName)
    end
end

--- Stop the music.
-- This does not rewind the music. Use @{MusicAddon:setCurrentTime} to do so.
-- If you want to resume the music where it was stopped, used @{MusicAddon:pause} instead to avoid buffering glitches.
function MusicAddon:stop()
    if MusicAddon_stop ~= nil then
        MusicAddon_stop(self.selfName)
    end
end

--- Check if the music is currently playing.
-- @treturn bool True if the music is currently playing, False otherwise.
function MusicAddon:isPlaying()
    if MusicAddon_isPlaying ~= nil then
        return MusicAddon_isPlaying(self.selfName)
    end
    
    return false
end

--- Get the current play position of the music.
-- If the sound is playing, currentTime is the offset of the current playback position, measured in seconds from the start of the sound. If the sound is not playing, currentTime is the offset of where playing starts upon calling the play method, measured in seconds from the start of the sound.
-- @treturn number The playback point, in seconds, within the timeline of the sound associated with the audio player.
function MusicAddon:getCurrentTime()
    if MusicAddon_getCurrentTime ~= nil then
        return MusicAddon_getCurrentTime(self.selfName)
    end
    
    return 0.0
end

--- Set the current play position of the music.
-- By setting this, you can seek to a specific point in a sound file or implement audio fast-forward and rewind functions.
-- @tparam number in_time The playback point, in seconds, within the timeline of the sound associated with the audio player.
function MusicAddon:setCurrentTime(in_time)
    if MusicAddon_setCurrentTime ~= nil then
        MusicAddon_setCurrentTime(self.selfName, in_time)
    end
end

--- Get the total duration of the music.
-- @treturn number Total duration, in seconds, of the sound associated with the audio player.
function MusicAddon:getDuration()
    if MusicAddon_getDuration ~= nil then
        return MusicAddon_getDuration(self.selfName)
    end
    
    return 0.0
end

--- Get the number of channels in the music.
-- @treturn integer The number of audio channels in the sound associated with the audio player.
function MusicAddon:getNumberOfChannels()
    if MusicAddon_getNumberOfChannels ~= nil then
        return MusicAddon_getNumberOfChannels(self.selfName)
    end
    
    return 0
end

--- Get the current volume of the music player.
-- @treturn number The playback gain for the audio player, ranging from 0.0 through 1.0.
function MusicAddon:getVolume()
    if MusicAddon_getVolume ~= nil then
        return MusicAddon_getVolume(self.selfName)
    end
    
    return 0.0
end

--- Set the volume of the music player.
-- @tparam number in_volume The playback gain for the audio player, ranging from 0.0 through 1.0.
function MusicAddon:setVolume(in_volume)
    if MusicAddon_setVolume ~= nil then
        MusicAddon_setVolume(self.selfName, in_volume)
    end
end

--- Returns the average power for a given channel, in decibels, for the sound being played.
-- @tparam integer in_channel The audio channel whose average power value you want to obtain. Channel numbers are zero-indexed. A monaural signal, or the left channel of a stereo signal, has channel number 0.
-- @treturn number A floating-point representation, in decibels, of a given audio channel’s current average power. A return value of 0 dB indicates full scale, or maximum power; a return value of -160 dB indicates minimum power (that is, near silence). If the signal provided to the audio player exceeds ±full scale, then the return value may exceed 0 (that is, it may enter the positive range).
-- @see MusicAddon:getPeakPowerForChannel
function MusicAddon:getAveragePowerForChannel(in_channel)
    if MusicAddon_getAveragePowerForChannel ~= nil then
        return MusicAddon_getAveragePowerForChannel(self.selfName, in_channel)
    end
    
    return -160.0
end

--- Returns the peak power for a given channel, in decibels, for the sound being played.
-- @tparam integer in_channel The audio channel whose peak power value you want to obtain. Channel numbers are zero-indexed. A monaural signal, or the left channel of a stereo signal, has channel number 0.
-- @treturn number A floating-point representation, in decibels, of a given audio channel’s current peak power. A return value of 0 dB indicates full scale, or maximum power; a return value of -160 dB indicates minimum power (that is, near silence). If the signal provided to the audio player exceeds ±full scale, then the return value may exceed 0 (that is, it may enter the positive range).
-- @see MusicAddon:getAveragePowerForChannel
function MusicAddon:getPeakPowerForChannel(in_channel)
    if MusicAddon_getPeakPowerForChannel ~= nil then
        return MusicAddon_getPeakPowerForChannel(self.selfName, in_channel)
    end
    
    return -160.0
end
