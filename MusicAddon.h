//
//  MusicAddon.h
//  iQTwist
//
//  Created by Jean-Francois Perusse on 13-07-06.
//  Copyright (c) 2013 MyCompany. All rights reserved.
//

#import "CodeaAddon.h"

@interface MusicAddOn : NSObject<CodeaAddon>

static int _playMusic(struct lua_State *state);
static int _setVolume(struct lua_State *state);
static int _stopMusic(struct lua_State *state);

@end
