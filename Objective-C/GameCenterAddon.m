// Based on code by David Such (http://codeatuts.blogspot.com.au/2013/04/tutorial-30-codea-v152-objective-c-add.html)

#import "AppDelegate.h"
#import "CodeaViewController.h"
#import "GameCenterAddon.h"
#import "lua.h"

static GameCenterAddon *gameCenterAddon;

@implementation GameCenterAddon

+ (void) load
{
	NSLog(@"Loading GameCenterAddon");
	
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(registerAddOn:)
                                                 name:@"RegisterAddOns"
                                               object:nil];
}

+ (void) registerAddOn:(NSNotification *)notification
{
	NSLog(@"Registering GameCenterAddon");
	
    gameCenterAddon = [[GameCenterAddon alloc] init];
    CodeaViewController *viewController = (CodeaViewController*)[(AppDelegate*)[[UIApplication sharedApplication]delegate] viewController];
    [viewController registerAddon:gameCenterAddon];
}

- (id)init
{
    self = [super init];
    if (self)
    {
		gameCenterAddonInstance = self;
		hasGameCenter = false;
    }
    return self;
}

- (void) codea:(CodeaViewController*)controller didCreateLuaState:(struct lua_State*)L
{
    NSLog(@"GameCenterAddon Registering Functions");

    lua_register(L, "gameCenterStart", gameCenterStart);
    lua_register(L, "showLeaderBoardWithIdentifier", showLeaderBoardWithIdentifier);
    lua_register(L, "showAchievementsView", showAchievementsView);
    lua_register(L, "playerIsAuthenticated", playerIsAuthenticated);

    self.codeaViewController = controller;
}

- (BOOL)isGameCenterAvailable
{
    // Check for presence of GKLocalPlayer API.
    
    Class gcClass = (NSClassFromString(@"GKLocalPlayer"));
    
    // The device must be running running iOS 4.1 or later.
    
    NSString *reqSysVer = @"4.1";
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    BOOL osVersionSupported = ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending);
    
    if (gcClass && osVersionSupported)
        NSLog(@"Game Center is Available");
    else
        NSLog(@"Game Center is not Available");
    
    return (gcClass && osVersionSupported);
}
 
- (void)registerForAuthenticationNotification
{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver: self selector: @selector(authenticationChanged) name: GKPlayerAuthenticationDidChangeNotificationName object: nil];
}
 
//  Your game must authenticate a local player before you can use any Game Center classes.
//  If there is no authenticated player, your game receives a GKErrorNotAuthenticated error.
 
- (bool)isPlayerAuthenticated
{
    return hasGameCenter;
}
 
- (void)authenticateLocalPlayer
{
    
    if(![self isGameCenterAvailable])
    {
        hasGameCenter = false;
        return;
    }
    
    [[GKLocalPlayer localPlayer] authenticateWithCompletionHandler:^(NSError *error)
     {
         if (error == nil)
         {
             [self registerForAuthenticationNotification];
             hasGameCenter = true;
             NSLog(@"Game Center - local player authenticated.");
         }
         else
         {
             hasGameCenter = false;
             NSLog(@"Game Center - failed to authenticate, error: %@", [error localizedDescription]);
         }
     }];
}
 
- (void)authenticationChanged
{
    if([self isGameCenterAvailable])
    {
        return;
    }
    
    if ([GKLocalPlayer localPlayer].isAuthenticated)
    {
        hasGameCenter = true;
    }
    else
    {
        hasGameCenter = false;
    }
}
 
#pragma mark - Game Center C Functions
 
static int gameCenterStart(struct lua_State *state)
{
    [gameCenterAddonInstance authenticateLocalPlayer];
    
    return 0;
}
 
static int showLeaderBoardWithIdentifier(struct lua_State *state)
{
    [gameCenterAddonInstance showLeaderboard: lua_tostring(state, 1)];
    
    return 0;
}
 
static int showAchievementsView(struct lua_State *state)
{
    [gameCenterAddonInstance showAchievements];
    
    return 0;
}
 
static int playerIsAuthenticated(struct lua_State *state)
{
    lua_pushboolean(state, [gameCenterAddonInstance isPlayerAuthenticated]);
    
    return 1;
}
 
#pragma mark - GKLeaderboardViewControllerDelegate Methods
 
- (void)showLeaderboard: (const char*)ident
{
    NSString *identifier = [NSString stringWithCString:ident encoding:NSUTF8StringEncoding];
    
    GKLeaderboardViewController *leaderBoardCont = [[GKLeaderboardViewController alloc] init];
    
    if (leaderBoardCont)
    {
        leaderBoardCont.category=identifier;
        leaderBoardCont.timeScope=GKLeaderboardTimeScopeToday;
        leaderBoardCont.leaderboardDelegate=self;
        self.codeaViewController.paused = YES;
        [self.codeaViewController presentModalViewController: leaderBoardCont animated: YES];
    }
}
 
- (void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
    //  Dismiss the Game Center Leader Board view
    
    [self.codeaViewController dismissViewControllerAnimated: YES completion:^
     {
         self.codeaViewController.paused = NO;          // Unpause Codea
     }];
}
 
#pragma mark - GKAchievementViewControllerDelegate Methods
 
- (void)showAchievements
{
    GKAchievementViewController *achievements = [[GKAchievementViewController alloc] init];
    
    if (achievements != nil)
    {
        achievements.achievementDelegate = self;
        self.codeaViewController.paused = YES;
        [self.codeaViewController presentViewController: achievements animated: YES completion: nil];
    }
}
 
- (void)achievementViewControllerDidFinish:(GKAchievementViewController *)viewController
{
    //  Dismiss the Game Center Achievement view
    
    [self.codeaViewController dismissViewControllerAnimated: YES completion:^
     {
         self.codeaViewController.paused = NO;          // Unpause Codea
     }];
}

@end