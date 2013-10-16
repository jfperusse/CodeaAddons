--- Test if the game has been compiled.
function isRuntime()
    return _isRuntime ~= nil
end

--- Get the device's preferred language code.
-- 
-- Returns an IETF code like "en" and "fr". Can be used to localize your games.
function getDeviceLanguage()
    if _getDeviceLanguage ~= nil then
        return _getDeviceLanguage()
    else
        return "<Not available>"
    end
end
