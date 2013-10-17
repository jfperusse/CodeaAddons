#import "CodeaAddon.h"

@interface MusicAddOn : NSObject<CodeaAddon>

static int MusicAddon_load(struct lua_State *state);
static int MusicAddon_unload(struct lua_State *state);

static int MusicAddon_getURL(struct lua_State *state);

static int MusicAddon_enableRate(struct lua_State *state);
static int MusicAddon_enableMetering(struct lua_State *state);

static int MusicAddon_prepareToPlay(struct lua_State *state);

static int MusicAddon_getLoops(struct lua_State *state);
static int MusicAddon_setLoops(struct lua_State *state);

static int MusicAddon_getPan(struct lua_State *state);
static int MusicAddon_setPan(struct lua_State *state);

static int MusicAddon_getRate(struct lua_State *state);
static int MusicAddon_setRate(struct lua_State *state);

static int MusicAddon_play(struct lua_State *state);
static int MusicAddon_playAfterDelay(struct lua_State *state);
static int MusicAddon_pause(struct lua_State *state);
static int MusicAddon_stop(struct lua_State *state);

static int MusicAddon_isPlaying(struct lua_State *state);

static int MusicAddon_getCurrentTime(struct lua_State *state);
static int MusicAddon_setCurrentTime(struct lua_State *state);

static int MusicAddon_getDuration(struct lua_State *state);

static int MusicAddon_getNumberOfChannels(struct lua_State *state);

static int MusicAddon_getVolume(struct lua_State *state);
static int MusicAddon_setVolume(struct lua_State *state);

static int MusicAddon_getAveragePowerForChannel(struct lua_State *state);
static int MusicAddon_getPeakPowerForChannel(struct lua_State *state);

@end
