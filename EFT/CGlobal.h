//
//  CGlobal.h
//  EFT
//
//  Created by Twinklestar on 12/8/15.
//  Copyright © 2015 Twinklestar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "EftCategory.h"
#import "EftPlace.h"
#import "EftUser.h"
#import "EftReview.h"
#import "EnvVar.h"
#import "EftQuery.h"
#import "EftGooglePlace.h"
#import "EftRegion.h"
#import "EftReview.h"
#import "EftGoogleAddressComponent.h"
@protocol GeneralDialogProtocol <NSObject>

@optional
-(void)ClickDialogButton:(int)tag;

@end

//constants
extern const int ClickDialogButton_ADDNEWSEARCH;
extern const int ClickDialogButton_SAVEDLOCATION;
extern const int ClickDialogButton_POSTREVIEW;
extern const int ClickDialogButton_POSTREVIEW_USEMYLOC        ;
extern const int ClickDialogButton_POSTREVIEW_SEARCHLOC        ;
extern const int ClickDialogButton_POSTREVIEW_ATTACHIMAGE        ;
extern const int ClickDialogButton_POSTREVIEW_PHOTO        ;
extern const int ClickDialogButton_POSTREVIEW_POST        ;


extern const int ClickDialogButton_SELECTCATEGORYFROMTABLEVIEW        ;
extern const int ClickDialogButton_CATEGORYTXTCLICK;
extern const int ClickDialogButton_ADDREVIEW;
extern const int ClickDialogButton_CLEARFORM;
extern const int ClickDialogButton_SETTINGOK;

extern const int ClickDialogButton_NOREVIEW ;
extern const int ClickDialogButton_MANYRESULTS ;
extern const int ClickDialogButton_ADDEDREVIEW ;
// global variables
extern NSIndexPath*g_selIndexPath;

extern NSMutableArray* g_category;
extern NSMutableArray* g_places;
extern NSMutableArray* g_placesnone;
extern NSMutableArray* g_myreviews;       // linear reviews
extern NSMutableArray* g_myplaces;        // review places
extern int g_selectedReview;
extern int g_userid;
extern EftRegion* g_curRegion;
extern EftUser* g_curUser;
extern NSArray* g_savedLocations;
extern int g_curRadius;
extern EftReview* g_curReview;
extern EftCategory* g_selectedCategory;

//urls
extern NSString *g_baseUrl;


extern NSString *g_baseUrl     ;
extern NSString *g_urlregisterbyphone ;
extern NSString *g_urlqueryreview ;
extern NSString *g_urlgooglesearch ;
extern NSString *g_urlloginbyphone;
extern NSString *g_urladdreview ;
extern NSString *g_urladdcategory ;
extern NSString *g_urlgooglesearchone;
extern NSString *g_urlgooglequery;
extern NSString *g_urldeletereview;
extern NSString *g_urlfastreview ;
extern NSString *g_urlfastreview ;
extern NSString *g_urlgoogleplacedetail;
//notifications
extern NSString *GLOBALNOTIFICATION_RECEIVE_USERINFO_SUCC;
extern NSString *GLOBALNOTIFICATION_RECEIVE_USERINFO_FAIL;
extern NSString *GLOBALNOTIFICATION_CHANGEVIEWCONTROLLER;
extern NSString *GLOBALNOTIFICATION_DATACHANGE_SAVEDLOCATION;
extern NSString *GLOBALNOTIFICATION_DATACHANGE_MYREVIEWS;
extern NSString *GLOBALNOTIFICATION_RECEIVE_LOCATION_UPDATE;

@interface CGlobal : NSObject
@property (nonatomic, strong) EnvVar * env;
+ (CGlobal *)sharedId;


+(void)makeBlackBorder:(UIView*)view;
+(void)makeButtonStyleBlue:(UIButton*)view;
+(void)showIndicator:(UIViewController*)viewcon;
+(void)stopIndicator:(UIViewController*)viewcon;
+(void)makeForDismissView:(UIViewController*)viewcon;
+(void)removeForDismissView:(UIViewController*)viewcon;
+(void)AlertMessage:(NSString*)message Title:(NSString*)title;
+(CGFloat)heightForView:(NSString*)text Font:(UIFont*) font Width:(CGFloat) width;
+(NSString*)processAddressForQuery:(NSString*)address;
+(void)showIndicator:(UIViewController*)viewcon WithMode:(int)mode;
+(void)stopIndicator:(UIViewController*)viewcon WithMode:(int)mode;

//parsing
+(NSMutableArray*)parseCategories:(NSArray*)arries;
@end
