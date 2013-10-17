--- Common functions.
-- Useful utilities for every project.

--- Use this to test if the game has been compiled.
-- @treturn bool True if the Objective-C function is found, False otherwise.
function isRuntime()
    return _isRuntime ~= nil
end

--- Get the device's preferred language code.
-- Can be used to localize your games.
-- @treturn string Returns an IETF code like "en" and "fr".
function getDeviceLanguage()
    if _getDeviceLanguage ~= nil then
        return _getDeviceLanguage()
    else
        return "<Not available>"
    end
end
