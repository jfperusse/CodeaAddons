--- Initialize GameCenter and try to authenticate the player.
function gameCenterStart()
	if _gameCenterStart ~= nil then
		_gameCenterStart()
	end
end

--- Show the GameCenter leaderboard with the corresponding identifier.
--
-- @param in_identifier Leaderboard ID used on iTunesConnect
function showLeaderBoardWithIdentifier(in_identifier)
	if _showLeaderBoardWithIdentifier ~= nil then
		_showLeaderBoardWithIdentifier(in_identifier)
	end
end

--- Show the GameCenter achievements view.
function showAchievementsView()
	if _showAchievementsView ~= nil then
		_showAchievementsView()
	end
end

--- Check if the player is authenticated in GameCenter.
function playerIsAuthenticated()
	if _playerIsAuthenticated ~= nil then
		return _playerIsAuthenticated()
	end
	
	return false
end
