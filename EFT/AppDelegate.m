//
//  AppDelegate.m
//  EFT
//
//  Created by Twinklestar on 12/7/15.
//  Copyright © 2015 Twinklestar. All rights reserved.
//

#import "AppDelegate.h"

#import "RearViewController.h"
#import "HomeViewController.h"
#import "CGlobal.h"
#import "NetworkParser.h"

#import <KSCrash/KSCrash.h> // TODO: Remove this
#import <KSCrash/KSCrashInstallation+Alert.h>
#import <KSCrash/KSCrashInstallationStandard.h>
#import <KSCrash/KSCrashInstallationQuincyHockey.h>
#import <KSCrash/KSCrashInstallationEmail.h>
#import <KSCrash/KSCrashInstallationVictory.h>

@interface AppDelegate()
@property (assign,nonatomic) BOOL isLoading;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self initData];
    g_curUser = nil;
    [self installCrashHandler];
//    [self performLogin];
    
    
    
    return YES;
}
- (void) installCrashHandler
{
    // Create an installation (choose one)
    //    KSCrashInstallation* installation = [self makeStandardInstallation];
    KSCrashInstallation* installation = [self makeEmailInstallation];
    //    KSCrashInstallation* installation = [self makeHockeyInstallation];
    //    KSCrashInstallation* installation = [self makeQuincyInstallation];
    //    KSCrashInstallation *installation = [self makeVictoryInstallation];
    
    
    // Install the crash handler. This should be done as early as possible.
    // This will record any crashes that occur, but it doesn't automatically send them.
    [installation install];
    [KSCrash sharedInstance].deleteBehaviorAfterSendAll = KSCDeleteNever; // TODO: Remove this
    
    
    // Send all outstanding reports. You can do this any time; it doesn't need
    // to happen right as the app launches. Advanced-Example shows how to defer
    // displaying the main view controller until crash reporting completes.
    [installation sendAllReportsWithCompletion:^(NSArray* reports, BOOL completed, NSError* error)
     {
         if(completed)
         {
             NSLog(@"Sent %d reports", (int)[reports count]);
         }
         else
         {
             NSLog(@"Failed to send reports: %@", error);
         }
     }];
}

- (KSCrashInstallation*) makeEmailInstallation
{
    NSString* emailAddress = @"bohuang29@hotmail.com";
    
    KSCrashInstallationEmail* email = [KSCrashInstallationEmail sharedInstance];
    email.recipients = @[emailAddress];
    email.subject = @"Crash Report";
    email.message = @"This is a crash report";
    email.filenameFmt = @"crash-report-%d.txt.gz";
    
    [email addConditionalAlertWithTitle:@"Crash Detected"
                                message:@"The app crashed last time it was launched. Send a crash report?"
                              yesAnswer:@"Sure!"
                               noAnswer:@"No thanks"];
    
    // Uncomment to send Apple style reports instead of JSON.
    [email setReportStyle:KSCrashEmailReportStyleApple useDefaultFilenameFormat:YES];
    
    return email;
}
-(void)saveCurrentRegion{
    if (g_curRegion != nil) {
        if ([_dbManager insertLocation:g_curRegion] >= 0) {
            g_savedLocations = [_dbManager getLocation];
            g_curRegion.isSavedToDb = true;
            
            [[NSNotificationCenter defaultCenter] postNotificationName:GLOBALNOTIFICATION_DATACHANGE_SAVEDLOCATION object:self userInfo:@{@"id":GLOBALNOTIFICATION_DATACHANGE_SAVEDLOCATION}];
        }
        
        
    }
}
-(void)performLogin{
    EnvVar*env = [CGlobal sharedId].env;
    if (_isLoading) {
        return;
    }
    if (env.lastLogin == 1) {
        _isLoading = true;
        g_userid = env.username;
        EftUser * user = [[EftUser alloc] init];
        user.eu_username = env.username;
        
        NetworkParser *manager = [NetworkParser sharedManager];
        [manager onLoginByPhone:user withCompletionBlock:^(NSDictionary *dict, NSError *error) {
            BOOL received=false;
            if (error == nil) {
                if ([dict objectForKey:@"row"]) {
                    g_curUser = [[EftUser alloc] initWithDictionary:[dict objectForKey:@"row"]];
                    
                    EftCategory *eat = [[EftCategory alloc] initWithDictionary:[dict objectForKey:@"eat"]];
                    EftCategory *fit = [[EftCategory alloc] initWithDictionary:[dict objectForKey:@"fit"]];
                    EftCategory *travel = [[EftCategory alloc] initWithDictionary:[dict objectForKey:@"travel"]];
                    
                    NSArray*placearray =  [dict objectForKey:@"places"];
                    for (id subdict in placearray) {
                        EftPlace* place = [[EftPlace alloc] initWithDictionary:subdict];
                        [g_myplaces addObject:place];
                    }
                    
                    NSArray*reviewarray =  [dict objectForKey:@"reviews"];
                    for (id subdict in reviewarray) {
                        EftReview* review = [[EftReview alloc] initWithDictionary:subdict];
                        [g_myreviews addObject:review];
                    }
                    
                    [g_category addObject:eat];
                    [g_category addObject:fit];
//                    [g_category addObject:travel];
                    
                    received = true;
                    [[NSNotificationCenter defaultCenter] postNotificationName:GLOBALNOTIFICATION_RECEIVE_USERINFO_SUCC object:self];
                    
                }
                
            }
            if (received == false) {
                [[NSNotificationCenter defaultCenter] postNotificationName:GLOBALNOTIFICATION_RECEIVE_USERINFO_FAIL object:self];
            }
            _isLoading = false;
        }];
        
    }else{
        //
        _isLoading = true;
        NSString* uuid = [[UIDevice currentDevice].identifierForVendor UUIDString];
        NetworkParser *manager = [NetworkParser sharedManager];
        [manager onRegisterByPhone:uuid withCompletionBlock:^(NSDictionary *dict, NSError *error) {
            BOOL received=false;
            if (error == nil) {
                if ([dict objectForKey:@"row"]) {
                    g_curUser = [[EftUser alloc] initWithDictionary:[dict objectForKey:@"row"]];
                    [env setUsername:g_curUser.eu_username];
                    [env setLastLogin:1];
                    
                    received = true;
                    [[NSNotificationCenter defaultCenter] postNotificationName:GLOBALNOTIFICATION_RECEIVE_USERINFO_SUCC object:self];
                    
                }
                
            }
            if (received == false) {
                [[NSNotificationCenter defaultCenter] postNotificationName:GLOBALNOTIFICATION_RECEIVE_USERINFO_FAIL object:self];
            }
            _isLoading = false;
        }];
    }
}-(BOOL)hasThisRegion:(EftRegion*)region{
    return [_dbManager checkDatabaseForRegion:region];
}
-(void) initData{
    _dbManager = [[DBManager alloc] initWithDatabaseFilename:@"sqldatabase.db"];
    
    g_savedLocations = [_dbManager getLocation];
    g_category = [[NSMutableArray alloc] init];
    g_curRadius = 5000;
    g_myreviews = [[NSMutableArray alloc] init];
    g_myplaces = [[NSMutableArray alloc] init];
    
}
#pragma mark - SWRevealViewDelegate

//- (id <UIViewControllerAnimatedTransitioning>)revealController:(SWRevealViewController *)revealController animationControllerForOperation:(SWRevealControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
//{
//    if ( operation != SWRevealControllerOperationReplaceRightController )
//        return nil;
//    
//    
//    return nil;
//}

#define LogDelegates 0

#if LogDelegates
- (NSString*)stringFromFrontViewPosition:(FrontViewPosition)position
{
    NSString *str = nil;
    if ( position == FrontViewPositionLeftSideMostRemoved ) str = @"FrontViewPositionLeftSideMostRemoved";
    if ( position == FrontViewPositionLeftSideMost) str = @"FrontViewPositionLeftSideMost";
    if ( position == FrontViewPositionLeftSide) str = @"FrontViewPositionLeftSide";
    if ( position == FrontViewPositionLeft ) str = @"FrontViewPositionLeft";
    if ( position == FrontViewPositionRight ) str = @"FrontViewPositionRight";
    if ( position == FrontViewPositionRightMost ) str = @"FrontViewPositionRightMost";
    if ( position == FrontViewPositionRightMostRemoved ) str = @"FrontViewPositionRightMostRemoved";
    return str;
}

- (void)revealController:(SWRevealViewController *)revealController willMoveToPosition:(FrontViewPosition)position
{
    NSLog( @"%@: %@", NSStringFromSelector(_cmd), [self stringFromFrontViewPosition:position]);
}

- (void)revealController:(SWRevealViewController *)revealController didMoveToPosition:(FrontViewPosition)position
{
    NSLog( @"%@: %@", NSStringFromSelector(_cmd), [self stringFromFrontViewPosition:position]);
}

- (void)revealController:(SWRevealViewController *)revealController animateToPosition:(FrontViewPosition)position
{
    NSLog( @"%@: %@", NSStringFromSelector(_cmd), [self stringFromFrontViewPosition:position]);
}

- (void)revealControllerPanGestureBegan:(SWRevealViewController *)revealController;
{
    NSLog( @"%@", NSStringFromSelector(_cmd) );
}

- (void)revealControllerPanGestureEnded:(SWRevealViewController *)revealController;
{
    NSLog( @"%@", NSStringFromSelector(_cmd) );
}

- (void)revealController:(SWRevealViewController *)revealController panGestureBeganFromLocation:(CGFloat)location progress:(CGFloat)progress
{
    NSLog( @"%@: %f, %f", NSStringFromSelector(_cmd), location, progress);
}

- (void)revealController:(SWRevealViewController *)revealController panGestureMovedToLocation:(CGFloat)location progress:(CGFloat)progress
{
    NSLog( @"%@: %f, %f", NSStringFromSelector(_cmd), location, progress);
}

- (void)revealController:(SWRevealViewController *)revealController panGestureEndedToLocation:(CGFloat)location progress:(CGFloat)progress
{
    NSLog( @"%@: %f, %f", NSStringFromSelector(_cmd), location, progress);
}

- (void)revealController:(SWRevealViewController *)revealController willAddViewController:(UIViewController *)viewController forOperation:(SWRevealControllerOperation)operation animated:(BOOL)animated
{
    NSLog( @"%@: %@, %d", NSStringFromSelector(_cmd), viewController, operation);
}

- (void)revealController:(SWRevealViewController *)revealController didAddViewController:(UIViewController *)viewController forOperation:(SWRevealControllerOperation)operation animated:(BOOL)animated
{
    NSLog( @"%@: %@, %d", NSStringFromSelector(_cmd), viewController, operation);
}

#endif

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
