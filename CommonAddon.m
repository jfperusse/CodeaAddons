//
//  CommonAddon.m
//  iQTwist
//
//  Created by Jean-Francois Perusse on 13-07-06.
//  Copyright (c) 2013 MyCompany. All rights reserved.
//

#import "AppDelegate.h"
#import "CodeaViewController.h"
#import "CommonAddOn.h"
#import "lua.h"

static CommonAddOn *commonAddOn;

@implementation CommonAddOn

+ (void) load
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(registerAddOn:)
                                                 name:@"RegisterAddOns"
                                               object:nil];
}

+ (void) registerAddOn:(NSNotification *)notification
{
    commonAddOn = [[CommonAddOn alloc] init];
    CodeaViewController *viewController = (CodeaViewController*)[(AppDelegate*)[[UIApplication sharedApplication]delegate] viewController];
    [viewController registerAddon:commonAddOn];
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
    NSLog(@"CommonAddon Registering Functions");
    
    //  Register the functions, defined below
    
    lua_register(L, "_isRuntime", _isRuntime);
    lua_register(L, "_getDeviceLanguage", _getDeviceLanguage);
}

static int _isRuntime(struct lua_State *state)
{
    return 0;
}

static int _getDeviceLanguage(struct lua_State *state)
{
    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    lua_pushstring(state, [language UTF8String]);
    return 1;
}

@end