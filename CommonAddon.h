//
//  CommonAddon.h
//  iQTwist
//
//  Created by Jean-Francois Perusse on 13-07-06.
//  Copyright (c) 2013 MyCompany. All rights reserved.
//

#import "CodeaAddon.h"

@interface CommonAddOn : NSObject<CodeaAddon>

static int _isRuntime(struct lua_State *state);
static int _getDeviceLanguage(struct lua_State *state);

@end
