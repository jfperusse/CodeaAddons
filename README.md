CodeaAddons
===========

These add-ons are compatible with the plug-and-play modification described at http://codeatricks.blogspot.ca/2013/07/codea-addons-auto-registration.html.

To use these, simply do the following modification to AppDelegate.mm and add the add-ons to your Xcode project.

If you are using the [CodeaProjectBuilder](https://github.com/jfperusse/CodeaProjectBuilder), this step is automatically done for you by the build machine.

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

