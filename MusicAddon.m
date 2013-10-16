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

- (id)init
{
    self = [super init];
    if (self)
    {
        // Initialization stuff
    }
    return self;
}

- (void) codea:(CodeaViewController*)controller didCreateLuaState:(struct lua_State*)L
{
    NSLog(@"MusicAddOn Registering Functions");
    
    //  Register the functions, defined below
    
    lua_register(L, "_playMusic", _playMusic);
    lua_register(L, "_stopMusic", _stopMusic);

    lua_register(L, "_setVolume", _setVolume);
	lua_register(L, "_getVolume", _getVolume);

    lua_register(L, "_peakPowerForChannel", _peakPowerForChannel);
	lua_register(L, "_averagePowerForChannel", _averagePowerForChannel);
}

static AVAudioPlayer* _musicPlayer = NULL;

static int _playMusic(struct lua_State *state)
{
    int n = lua_gettop(state);
	
	if (n != 1 && n != 2)
	{
		lua_error(state);
		return 0;
	}
	
	lua_Number volume = 1.0;
	if (n == 2)
	{
		volume = lua_tonumber(state, 2);
	}
	
	const char* key = lua_tostring(state, 1);
	NSString* resourcePath = [[NSBundle mainBundle] resourcePath];
	NSString* song = [NSString stringWithCString:key encoding:NSUTF8StringEncoding];
	
	if ([song isEqualToString:@""])
	{
		return 0;
	}
	
	resourcePath = [resourcePath stringByAppendingPathComponent:song];
	
	//Initialize our player pointing to the path to our resource
	if (_musicPlayer && [_musicPlayer isPlaying])
	{
		[_musicPlayer stop];
	}
	
	NSError* err;

	_musicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:resourcePath] error:&err];
	
	if (err)
	{
		//bail!
		NSLog(@"Failed with reason: %@", [err localizedDescription]);
	}
	else
	{
		//begin playback
		[_musicPlayer prepareToPlay];
		_musicPlayer.volume = volume;
		_musicPlayer.numberOfLoops = -1;
		[_musicPlayer setMeteringEnabled:YES];
		[_musicPlayer play];
	}
	
	return 0;
}

static int _stopMusic(struct lua_State *state)
{
	if (_musicPlayer && [_musicPlayer isPlaying])
	{
		[_musicPlayer stop];
	}
	return 0;
}

static int _setVolume(struct lua_State *state)
{
    int n = lua_gettop(state);
	
	if (n != 1)
	{
		lua_error(state);
		return 0;
	}
	
	lua_Number volume = 1.0;
	if (n == 1)
	{
		volume = lua_tonumber(state, 1);
		if (_musicPlayer && [_musicPlayer isPlaying])
    	{
    		_musicPlayer.volume = volume;
    	}
    }
	return 0;
}

static int _getVolume(struct lua_State *state)
{
	if (_musicPlayer && [_musicPlayer isPlaying])
	{
    	lua_pushnumber(state, _musicPlayer.volume);
	}
	else
	{
		lua_pushnumber(state, 0.0);
	}
    
    return 1;
}

static int _peakPowerForChannel(struct lua_State *state)
{
	NSUInteger channel = lua_tonumber(state, 1);
	
    float power = -160.0f;  // Initialise to silence
        
    if (_musicPlayer && [_musicPlayer isPlaying])
    {
        [_musicPlayer updateMeters];
        
        if (channel <= [_musicPlayer numberOfChannels])
            power = [_musicPlayer peakPowerForChannel: channel];
    }

	lua_pushnumber(state, power);
	
	return 1;
}

static int _averagePowerForChannel(struct lua_State *state)
{
	NSUInteger channel = lua_tonumber(state, 1);
	
    float power = -160.0f;  // Initialise to silence
        
    if (_musicPlayer && [_musicPlayer isPlaying])
    {
        [_musicPlayer updateMeters];
        
        if (channel <= [_musicPlayer numberOfChannels])
            power = [_musicPlayer averagePowerForChannel: channel];
    }

	lua_pushnumber(state, power);
	
	return 1;
}

@end