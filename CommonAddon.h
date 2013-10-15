#import "CodeaAddon.h"

@interface CommonAddOn : NSObject<CodeaAddon>

static int _isRuntime(struct lua_State *state);
static int _getDeviceLanguage(struct lua_State *state);

@end
