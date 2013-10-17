// Based on code by David Such (http://codeatuts.blogspot.com.au/2013/04/tutorial-30-codea-v152-objective-c-add.html)

#import "CodeaAddon.h"
#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>

id gameCenterAddonInstance;

@interface GameCenterAddon : NSObject<CodeaAddon, GKLeaderboardViewControllerDelegate, GKAchievementViewControllerDelegate>
{
	bool hasGameCenter;
}

@property (weak, nonatomic) CodeaViewController *codeaViewController;
 
static int _gameCenterStart(struct lua_State *state);
static int _showLeaderBoardWithIdentifier(struct lua_State *state);
static int _showAchievementsView(struct lua_State *state);
static int _playerIsAuthenticated(struct lua_State *state);

@end
