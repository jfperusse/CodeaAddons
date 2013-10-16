#import "CodeaAddon.h"

@interface MusicAddOn : NSObject<CodeaAddon>

static int _playMusic(struct lua_State *state);
static int _stopMusic(struct lua_State *state);

static int _setVolume(struct lua_State *state);
static int _getVolume(struct lua_State *state);

static int _peakPowerForChannel(struct lua_State *state);
static int _averagePowerForChannel(struct lua_State *state);

@end
