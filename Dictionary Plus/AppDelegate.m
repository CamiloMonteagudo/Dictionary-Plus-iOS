//=========================================================================================================================================================
//  AppDelegate.m
//  Dictionary Plus
//
//  Created by Admin on 13/3/18.
//  Copyright © 2018 bigxsoft. All rights reserved.
//=========================================================================================================================================================

#import "AppDelegate.h"
#import "AppData.h"

//=========================================================================================================================================================
@interface AppDelegate ()

@end

//=========================================================================================================================================================
@implementation AppDelegate

//--------------------------------------------------------------------------------------------------------------------------------------------------------
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
  {
  [self LoadUserDefaults ];
 
//  NSDate *tm = [NSDate date];
//  
//  for(;;)
//    {
//    double nSeg = (-[tm timeIntervalSinceNow]);
//    if( nSeg > 10 )
//      break;
//    }

  return YES;
  }


//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Carga los valores por defecto de algunos parametros
-(void) LoadUserDefaults
  {
  iUser = NSLocalizedString(@"UILang", nil).intValue;
  
  NSUserDefaults* UserDef = [NSUserDefaults standardUserDefaults];

  NSNumber* pDir = [UserDef objectForKey:@"lastDir"];       // Última dirección de traducción utilizada
  int iDir = (pDir != nil)? pDir.intValue : -1;             // Obtiene el valor
  
  if( iDir >= 0 )                                           // Si se obtuvo la dirección
    {
    LGSrc = DIRSrc(iDir);                                   // Obtiene el idioma fuente de la dirección
    LGDes = DIRDes(iDir);                                   // Obtiene el idioma destino de la dirección

    //NSLog(@"Dirección guardada src=%d dest=%d", LGSrc, LGDes);
    }
  else DIRFirst();                                          // Obtiene la primera dirección de traducción instalada
  }


//--------------------------------------------------------------------------------------------------------------------------------------------------------
- (void)applicationWillResignActive:(UIApplication *)application
  {
  // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
- (void)applicationDidEnterBackground:(UIApplication *)application
  {
  // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
  // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
- (void)applicationWillEnterForeground:(UIApplication *)application
  {
  // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
- (void)applicationDidBecomeActive:(UIApplication *)application
  {
  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
- (void)applicationWillTerminate:(UIApplication *)application
  {
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }

@end
