#import "AppDelegate.h"
#import "CodeaViewController.h"
#import "MusicAddOn.h"
#import "lua.h"

#import <AVFoundation/AVAudioPlayer.h>

static MusicAddOn *musicAddOn;

@implementation MusicAddOn

+ (void) load
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(registerAddOn:)
                                                 name:@"RegisterAddOns"
                                               object:nil];
}

+ (void) registerAddOn:(NSNotification *)notification
{
    musicAddOn = [[MusicAddOn alloc] init];
    CodeaViewController *viewController = (CodeaViewController*)[(AppDelegate*)[[UIApplication sharedApplication]delegate] viewController];
    [viewController registerAddon:musicAddOn];
}

NSMutableDictionary *audioPlayers = nil;

- (id)init
{
    self = [super init];
    if (self)
    {
        // Initialization stuff
		audioPlayers = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void) codea:(CodeaViewController*)controller didCreateLuaState:(struct lua_State*)L
{
    NSLog(@"MusicAddOn Registering Functions");
    
    //  Register the functions, defined below
    
	lua_register(L, "MusicAddon_load", MusicAddon_load);
	lua_register(L, "MusicAddon_unload", MusicAddon_unload);
	lua_register(L, "MusicAddon_getURL", MusicAddon_getURL);
	lua_register(L, "MusicAddon_enableRate", MusicAddon_enableRate);
	lua_register(L, "MusicAddon_enableMetering", MusicAddon_enableMetering);
	lua_register(L, "MusicAddon_prepareToPlay", MusicAddon_prepareToPlay);
	lua_register(L, "MusicAddon_getLoops", MusicAddon_getLoops);
	lua_register(L, "MusicAddon_setLoops", MusicAddon_setLoops);
	lua_register(L, "MusicAddon_getPan", MusicAddon_getPan);
	lua_register(L, "MusicAddon_setPan", MusicAddon_setPan);
	lua_register(L, "MusicAddon_getRate", MusicAddon_getRate);
	lua_register(L, "MusicAddon_setRate", MusicAddon_setRate);
	lua_register(L, "MusicAddon_play", MusicAddon_play);
	lua_register(L, "MusicAddon_playAfterDelay", MusicAddon_playAfterDelay);
	lua_register(L, "MusicAddon_pause", MusicAddon_pause);
	lua_register(L, "MusicAddon_stop", MusicAddon_stop);
	lua_register(L, "MusicAddon_isPlaying", MusicAddon_isPlaying);
	lua_register(L, "MusicAddon_getCurrentTime", MusicAddon_getCurrentTime);
	lua_register(L, "MusicAddon_setCurrentTime", MusicAddon_setCurrentTime);
	lua_register(L, "MusicAddon_getDuration", MusicAddon_getDuration);
	lua_register(L, "MusicAddon_getNumberOfChannels", MusicAddon_getNumberOfChannels);
	lua_register(L, "MusicAddon_getVolume", MusicAddon_getVolume);
	lua_register(L, "MusicAddon_setVolume", MusicAddon_setVolume);
	lua_register(L, "MusicAddon_getAveragePowerForChannel", MusicAddon_getAveragePowerForChannel);
	lua_register(L, "MusicAddon_getPeakPowerForChannel", MusicAddon_getPeakPowerForChannel);
}

static AVAudioPlayer* GetAudioPlayer(const char* in_name)
{
	NSString* key = [NSString stringWithCString:in_name encoding:NSUTF8StringEncoding];
	return [audioPlayers objectForKey:key];
}

static AVAudioPlayer* CreateAudioPlayer(const char* in_name, NSString* in_resourcePath)
{
	NSString* key = [NSString stringWithCString:in_name encoding:NSUTF8StringEncoding];

	NSError* err;

	AVAudioPlayer* audioPlayer = GetAudioPlayer(in_name);
	
	if (audioPlayer && [audioPlayer isPlaying])
	{
		[audioPlayer stop];
	}
	
	audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:in_resourcePath] error:&err];
	
	if (err)
	{
		//bail!
		NSLog(@"Failed with reason: %@", [err localizedDescription]);
		[audioPlayers setObject:nil forKey:key];
	}
	else
	{
		[audioPlayers setObject:audioPlayer forKey:key];
	}
	
	return audioPlayer;
}

static int MusicAddon_load(struct lua_State *state)
{
	const char* key = lua_tostring(state, 2);
	NSString* resourcePath = [[NSBundle mainBundle] resourcePath];
	NSString* song = [NSString stringWithCString:key encoding:NSUTF8StringEncoding];
	
	if ([song isEqualToString:@""])
	{
		return 0;
	}
	
	resourcePath = [resourcePath stringByAppendingPathComponent:song];
	
	CreateAudioPlayer(lua_tostring(state, 1), resourcePath);
	
	return 0;
}

static int MusicAddon_unload(struct lua_State *state)
{
	const char* objectName = lua_tostring(state, 1);
	
	AVAudioPlayer* audioPlayer = GetAudioPlayer(objectName);
	
	if (audioPlayer)
	{
		if ([audioPlayer isPlaying])
		{
			[audioPlayer stop];
		}
		
		NSString* key = [NSString stringWithCString:objectName encoding:NSUTF8StringEncoding];
		[audioPlayers setObject:nil forKey:key];
	}
	
	return 0;
}

static int MusicAddon_getURL(struct lua_State *state)
{
	AVAudioPlayer* audioPlayer = GetAudioPlayer(lua_tostring(state, 1));
	
	if (audioPlayer)
	{
		lua_pushstring(state, [[audioPlayer.url path] UTF8String]);
	}
	else
	{
		lua_pushstring(state, "");
	}
	
	return 1;
}

static int MusicAddon_enableRate(struct lua_State *state)
{
	AVAudioPlayer* audioPlayer = GetAudioPlayer(lua_tostring(state, 1));
	
	if (audioPlayer)
	{
		audioPlayer.enableRate = YES;
	}
	return 0;
}

static int MusicAddon_enableMetering(struct lua_State *state)
{
	AVAudioPlayer* audioPlayer = GetAudioPlayer(lua_tostring(state, 1));
	
	if (audioPlayer)
	{
		[audioPlayer setMeteringEnabled:YES];
	}
	
	return 0;
}

static int MusicAddon_prepareToPlay(struct lua_State *state)
{
	AVAudioPlayer* audioPlayer = GetAudioPlayer(lua_tostring(state, 1));
	
	if (audioPlayer)
	{
		[audioPlayer prepareToPlay];
	}
	
	return 0;
}

static int MusicAddon_getLoops(struct lua_State *state)
{
	AVAudioPlayer* audioPlayer = GetAudioPlayer(lua_tostring(state, 1));

	if (audioPlayer)
	{
		lua_pushinteger(state, audioPlayer.numberOfLoops);
	}
	else
	{
		lua_pushinteger(state, 0);		
	}
	
	return 1;
}

static int MusicAddon_setLoops(struct lua_State *state)
{
	AVAudioPlayer* audioPlayer = GetAudioPlayer(lua_tostring(state, 1));

	if (audioPlayer)
	{
		audioPlayer.numberOfLoops = lua_tointeger(state, 2);
	}
	
	return 0;
}

static int MusicAddon_getPan(struct lua_State *state)
{
	AVAudioPlayer* audioPlayer = GetAudioPlayer(lua_tostring(state, 1));

	if (audioPlayer)
	{
		lua_pushnumber(state, audioPlayer.pan);
	}
	else
	{
		lua_pushnumber(state, 0.0f);		
	}
	
	return 1;
}

static int MusicAddon_setPan(struct lua_State *state)
{
	AVAudioPlayer* audioPlayer = GetAudioPlayer(lua_tostring(state, 1));

	if (audioPlayer)
	{
		audioPlayer.pan = lua_tonumber(state, 2);
	}
	
	return 0;
}

static int MusicAddon_getRate(struct lua_State *state)
{
	AVAudioPlayer* audioPlayer = GetAudioPlayer(lua_tostring(state, 1));

	if (audioPlayer)
	{
		lua_pushnumber(state, audioPlayer.rate);
	}
	else
	{
		lua_pushnumber(state, 1.0f);		
	}
	
	return 1;
}

static int MusicAddon_setRate(struct lua_State *state)
{
	AVAudioPlayer* audioPlayer = GetAudioPlayer(lua_tostring(state, 1));

	if (audioPlayer)
	{
		audioPlayer.rate = lua_tonumber(state, 2);
	}
	
	return 0;
}

static int MusicAddon_play(struct lua_State *state)
{
	AVAudioPlayer* audioPlayer = GetAudioPlayer(lua_tostring(state, 1));

	if (audioPlayer)
	{
		[audioPlayer play];
	}
	
	return 0;
}
	
static int MusicAddon_playAfterDelay(struct lua_State *state)
{
	AVAudioPlayer* audioPlayer = GetAudioPlayer(lua_tostring(state, 1));

	if (audioPlayer)
	{
		[audioPlayer playAtTime:audioPlayer.deviceCurrentTime + lua_tonumber(state, 2)];
	}
	
	return 0;
}

static int MusicAddon_pause(struct lua_State *state)
{
	AVAudioPlayer* audioPlayer = GetAudioPlayer(lua_tostring(state, 1));

	if (audioPlayer)
	{
		[audioPlayer pause];
	}
	
	return 0;
}

static int MusicAddon_stop(struct lua_State *state)
{
	AVAudioPlayer* audioPlayer = GetAudioPlayer(lua_tostring(state, 1));

	if (audioPlayer)
	{
		[audioPlayer stop];
	}
	
	return 0;
}

static int MusicAddon_isPlaying(struct lua_State *state)
{
	AVAudioPlayer* audioPlayer = GetAudioPlayer(lua_tostring(state, 1));

	if (audioPlayer)
	{
		lua_pushboolean(state, audioPlayer.playing ? true : false);
	}
	else
	{
		lua_pushboolean(state, false);
	}
	
	return 1;
}

static int MusicAddon_getCurrentTime(struct lua_State *state)
{
	AVAudioPlayer* audioPlayer = GetAudioPlayer(lua_tostring(state, 1));

	if (audioPlayer)
	{
		lua_pushnumber(state, audioPlayer.currentTime);
	}
	else
	{
		lua_pushnumber(state, 0.0f);
	}
	
	return 1;
}

static int MusicAddon_setCurrentTime(struct lua_State *state)
{
	AVAudioPlayer* audioPlayer = GetAudioPlayer(lua_tostring(state, 1));

	if (audioPlayer)
	{
		audioPlayer.currentTime = lua_tonumber(state, 2);
	}
	
	return 0;
}
	
static int MusicAddon_getDuration(struct lua_State *state)
{
	AVAudioPlayer* audioPlayer = GetAudioPlayer(lua_tostring(state, 1));

	if (audioPlayer)
	{
		lua_pushnumber(state, audioPlayer.duration);
	}
	else
	{
		lua_pushnumber(state, 0.0f);
	}
	
	return 1;
}

static int MusicAddon_getNumberOfChannels(struct lua_State *state)
{
	AVAudioPlayer* audioPlayer = GetAudioPlayer(lua_tostring(state, 1));

	if (audioPlayer)
	{
		lua_pushinteger(state, audioPlayer.numberOfChannels);
	}
	else
	{
		lua_pushinteger(state, 0);		
	}
	
	return 1;
}

static int MusicAddon_getVolume(struct lua_State *state)
{
	AVAudioPlayer* audioPlayer = GetAudioPlayer(lua_tostring(state, 1));

	if (audioPlayer)
	{
		lua_pushnumber(state, audioPlayer.volume);
	}
	else
	{
		lua_pushnumber(state, 0);		
	}
	
	return 1;
}

static int MusicAddon_setVolume(struct lua_State *state)
{
	AVAudioPlayer* audioPlayer = GetAudioPlayer(lua_tostring(state, 1));

	if (audioPlayer)
	{
		audioPlayer.volume = lua_tonumber(state, 2);
	}
	
	return 0;
}

static int MusicAddon_getAveragePowerForChannel(struct lua_State *state)
{
	AVAudioPlayer* audioPlayer = GetAudioPlayer(lua_tostring(state, 1));

	NSUInteger channel = lua_tonumber(state, 2);
	
	float power = -160.0f;  // Initialise to silence
	
	if (audioPlayer && [audioPlayer isPlaying])
	{
        [audioPlayer updateMeters];
        
        if (channel <= [audioPlayer numberOfChannels])
            power = [audioPlayer averagePowerForChannel: channel];		
	}
	
	lua_pushnumber(state, power);
	
	return 1;
}

static int MusicAddon_getPeakPowerForChannel(struct lua_State *state)
{
	AVAudioPlayer* audioPlayer = GetAudioPlayer(lua_tostring(state, 1));

	NSUInteger channel = lua_tonumber(state, 2);
	
	float power = -160.0f;  // Initialise to silence
	
	if (audioPlayer && [audioPlayer isPlaying])
	{
        [audioPlayer updateMeters];
        
        if (channel <= [audioPlayer numberOfChannels])
            power = [audioPlayer peakPowerForChannel: channel];		
	}
	
	lua_pushnumber(state, power);
	
	return 1;
}

@end