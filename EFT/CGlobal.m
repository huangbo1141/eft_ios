//
//  CGlobal.m
//  EFT
//
//  Created by Twinklestar on 12/8/15.
//  Copyright © 2015 Twinklestar. All rights reserved.
//

#import "CGlobal.h"

const int ClickDialogButton_ADDNEWSEARCH = 0;
 const int ClickDialogButton_SAVEDLOCATION      =1;
 const int ClickDialogButton_POSTREVIEW=        2;
 const int ClickDialogButton_POSTREVIEW_USEMYLOC=        3;
 const int ClickDialogButton_POSTREVIEW_SEARCHLOC=        4;
 const int ClickDialogButton_POSTREVIEW_ATTACHIMAGE=        5;
 const int ClickDialogButton_POSTREVIEW_PHOTO=        6;
 const int ClickDialogButton_POSTREVIEW_POST=        7;

 const int ClickDialogButton_SELECTCATEGORYFROMTABLEVIEW=        20;
 const int ClickDialogButton_CATEGORYTXTCLICK=        21;
 const int ClickDialogButton_ADDREVIEW  =        22;
 const int ClickDialogButton_CLEARFORM =        23;
 const int ClickDialogButton_SETTINGOK =        24;

 const int ClickDialogButton_NOREVIEW =        25;
 const int ClickDialogButton_MANYRESULTS =        26;
 const int ClickDialogButton_ADDEDREVIEW =        27;
//global variables
 NSIndexPath*g_selIndexPath;
 NSMutableArray* g_category;
 NSMutableArray* g_places;
 NSMutableArray* g_placesnone;
 NSMutableArray* g_myreviews;       // linear reviews
 NSMutableArray* g_myplaces;        // review places

    int g_selectedReview;

    int g_userid=-1;
    EftRegion* g_curRegion;
    EftUser* g_curUser;
    NSArray* g_savedLocations;
    int g_curRadius;
    EftReview* g_curReview;
    EftCategory* g_selectedCategory;

//urls
    NSString *g_baseUrl     = @"http://52.34.77.167/second_1/";       //  second_1    second
    NSString *g_urlregisterbyphone = @"registerbyphone.php";
    NSString *g_urlqueryreview = @"queryreview.php";
    NSString *g_urlgooglesearch = @"googlesearch.php";
    NSString *g_urlloginbyphone = @"loginbyphone.php";
    NSString *g_urladdreview = @"addreview.php";
    NSString *g_urladdcategory = @"addcategory.php";
    NSString *g_urlgooglesearchone = @"googlesearchone.php";
    NSString *g_urlgooglequery = @"googlequery.php";
    NSString *g_urldeletereview = @"deletereview.php";
    NSString *g_urlfastreview = @"addreviewfast.php";
    NSString *g_urlgoogleplacedetail = @"googleplacedetail.php";

// notifications
    NSString *GLOBALNOTIFICATION_RECEIVE_USERINFO_SUCC = @"GLOBALNOTIFICATION_RECEIVE_USERINFO_SUCC";
    NSString *GLOBALNOTIFICATION_RECEIVE_USERINFO_FAIL = @"GLOBALNOTIFICATION_RECEIVE_USERINFO_FAIL";
    NSString *GLOBALNOTIFICATION_CHANGEVIEWCONTROLLER = @"GLOBALNOTIFICATION_CHANGEVIEWCONTROLLER";
    NSString *GLOBALNOTIFICATION_DATACHANGE_SAVEDLOCATION = @"GLOBALNOTIFICATION_DATACHANGE_SAVEDLOCATION";
    NSString *GLOBALNOTIFICATION_DATACHANGE_MYREVIEWS = @"GLOBALNOTIFICATION_DATACHANGE_MYREVIEWS";
    NSString *GLOBALNOTIFICATION_RECEIVE_LOCATION_UPDATE = @"GLOBALNOTIFICATION_RECEIVE_LOCATION_UPDATE";


@implementation CGlobal

+ (CGlobal *)sharedId
{
    static dispatch_once_t onceToken;
    static CGlobal *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[CGlobal alloc] init];
    });
    return instance;
}
- (id) init
{
    self = [super init];
    if (self != nil)
    {
        _env = [[EnvVar alloc] init];
    }
    return self;
}


+(void)makeBlackBorder:(UIView*)view{
    view.layer.borderColor= [UIColor blackColor].CGColor;
    view.layer.borderWidth = 1;
    view.layer.masksToBounds = true;
}
+(void)makeButtonStyleBlue:(UIButton*)view{
    view.backgroundColor = [UIColor colorWithRed:0 green:122.0/255.0 blue:1.0 alpha:1.0];
    [view setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}
+(void)showIndicator:(UIViewController*)viewcon WithMode:(int)mode{
    int tag = 1001 + mode;
    UIActivityIndicatorView* view = (UIActivityIndicatorView*)[viewcon.view viewWithTag:tag];
    
    UIColor *whitecolor;
    switch (tag) {
        case 1:
            whitecolor = [UIColor grayColor];
            break;
            
        default:
            whitecolor = [UIColor whiteColor];
            break;
    }
    
    if(view == nil){
        UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        
        [indicatorView setColor:whitecolor];
        
        indicatorView.center = viewcon.view.center;
        indicatorView.tag = tag;
        [viewcon.view addSubview:indicatorView];
        [viewcon.view bringSubviewToFront:indicatorView];
        
        view = indicatorView;
    }
    
    view.hidden = false;
    [view startAnimating];
}
+(void)stopIndicator:(UIViewController*)viewcon WithMode:(int)mode{
    int tag = 1001 + mode;
    UIActivityIndicatorView* view = (UIActivityIndicatorView*)[viewcon.view viewWithTag:tag];
    if(view != nil){
        view.hidden = YES;
        [view stopAnimating];
    }
}
+(void)showIndicator:(UIViewController*)viewcon{
    UIActivityIndicatorView* view = (UIActivityIndicatorView*)[viewcon.view viewWithTag:1000];
    if(view == nil){
        CGFloat width = 60.0;
        CGFloat height = 60.0;
        UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [indicatorView setColor:[UIColor redColor]];
        
        indicatorView.center = viewcon.view.center;
        indicatorView.tag = 1000;
        [viewcon.view addSubview:indicatorView];
        [viewcon.view bringSubviewToFront:indicatorView];
        
        view = indicatorView;
    }
    
    view.hidden = false;
    [view startAnimating];
}
+(void)stopIndicator:(UIViewController*)viewcon{
    UIActivityIndicatorView* view = (UIActivityIndicatorView*)[viewcon.view viewWithTag:1000];
    if(view != nil){
        view.hidden = YES;
        [view stopAnimating];
    }
}
+(void)makeForDismissView:(UIViewController*)viewcon{
    UIView* view = [viewcon.view viewWithTag:1001];
    if(view == nil){
        view = [[UIView alloc] initWithFrame:viewcon.view.frame];
        view.alpha = 0.1;
        view.backgroundColor = [UIColor whiteColor];
        view.tag = 1001;
        [viewcon.view addSubview:view];
        [viewcon.view bringSubviewToFront:view];
        
        UITapGestureRecognizer*gesture = [[UITapGestureRecognizer alloc] initWithTarget:viewcon action:@selector(ClickGesture:)];
        [view addGestureRecognizer:gesture];
        
    }
    view.hidden = false;
}
+(void)removeForDismissView:(UIViewController*)viewcon{
    UIView* view = [viewcon.view viewWithTag:1001];
    if(view != nil){
        view.hidden = YES;
    }
}
+(void)AlertMessage:(NSString*)message Title:(NSString*)title{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:title
                          message:message
                          delegate:nil
                          cancelButtonTitle:@"Ok"
                          otherButtonTitles:nil];
    [alert show];
}
+(CGFloat)heightForView:(NSString*)text Font:(UIFont*) font Width:(CGFloat) width{
    if (text == nil) {
        return 21;
    }
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, CGFLOAT_MAX)];
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.font = font;
    label.text = text;
    [label sizeToFit];
    
    CGFloat height = MAX(label.frame.size.height, 21);
    return height;
}
+(NSString*)processAddressForQuery:(NSString*)address{
    if (address == nil) {
        return @"";
    }
    NSString*temp = [address stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    temp = [temp stringByReplacingOccurrencesOfString:@"," withString:@" "];
    temp = [temp stringByReplacingOccurrencesOfString:@"  " withString:@" "];
    temp = [temp stringByReplacingOccurrencesOfString:@"  " withString:@" "];
    temp = [temp stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    
    return temp;
}

@end
