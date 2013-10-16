CodeaAddons
===========

These [Codea](http://twolivesleft.com/Codea/) add-ons are compatible with the plug-and-play modification presented on my [blog](http://codeatricks.blogspot.ca/2013/07/codea-addons-auto-registration.html).

Documentation
-------------

https://rawgithub.com/jfperusse/CodeaAddons/master/Documentation/index.html

Installation
------------

To use these add-ons, you need the following modification to AppDelegate.mm and add the Objective-C files to your Xcode project.

If you are using the [CodeaProjectBuilder](https://github.com/jfperusse/CodeaProjectBuilder), this step is automatically done for you by the build machine.

Then, use the corresponding Lua files in your Codea projects to interface with the addons.

```objectivec
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions  
{  
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];  
  self.viewController = [[CodeaViewController alloc] init];  
   
  // Add the following line
  [[NSNotificationCenter defaultCenter] postNotificationName:@"RegisterAddOns" object:self];
   
  NSString* projectPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"MyProject.codea"];  
    
  [self.viewController loadProjectAtPath:projectPath];  
    
  self.window.rootViewController = self.viewController;  
  [self.window makeKeyAndVisible];  
    
  return YES;  
}
```

