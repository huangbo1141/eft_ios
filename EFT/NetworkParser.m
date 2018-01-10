//
//  NetworkParser.m
//  SchoolApp
//
//  Created by TwinkleStar on 11/27/15.
//  Copyright © 2015 apple. All rights reserved.
//

#import "NetworkParser.h"
#import "AFNetworking.h"
#import "CGlobal.h"

@implementation NetworkParser

+ (instancetype)sharedManager
{
    static NetworkParser *sharedPhotoManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedPhotoManager = [[NetworkParser alloc] init];
        
    });
    
    return sharedPhotoManager;
}
-(BOOL)checkResponse:(NSDictionary*)dict{
    NSNumber* code = [dict valueForKey:@"response"];
    if ([code intValue] == 200) {
        return true;
    }
    return false;
}
-(BOOL)checkGooglePlaceResponse:(NSDictionary*)dict{
    NSString* code = [dict valueForKey:@"status"];
    if ( [code isEqualToString:@"OK"]) {
        return true;
    }
    return false;
}

-(void)generalNetwork:(NSString*)serverurl Data:(NSDictionary*)questionDict withCompletionBlock:(NetworkCompletionBlock)completionBlock{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:serverurl parameters:questionDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(completionBlock){
            if ([self checkResponse:responseObject]) {
                completionBlock(responseObject,nil);
            }else{
                completionBlock(nil,[[NSError alloc] init]);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(completionBlock) {
            completionBlock(nil,error);
        }
    }];
}
-(void)googlePlaceNetwork:(NSString*)serverurl Data:(NSDictionary*)questionDict withCompletionBlock:(NetworkCompletionBlock)completionBlock{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:serverurl parameters:questionDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(completionBlock){
            if ([self checkGooglePlaceResponse:responseObject]) {
                
                
                completionBlock(responseObject,nil);
            }else{
                completionBlock(nil,[[NSError alloc] init]);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(completionBlock) {
            completionBlock(nil,error);
        }
    }];
}
- (void)onRegisterByPhone:(NSString*) uuid withCompletionBlock:(NetworkCompletionBlock)completionBlock{
    NSString *serverurl = g_baseUrl ;
    serverurl = [serverurl stringByAppendingString:g_urlregisterbyphone];
    
    
    NSArray *objects = [NSArray arrayWithObjects:uuid,     nil];
    NSArray *keys = [NSArray arrayWithObjects:@"phoneid", nil];
    NSDictionary *questionDict = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    
    [self generalNetwork:serverurl Data:questionDict withCompletionBlock:completionBlock];
    
}
- (void)onQueryReview:(EftPlace*)place withCompletionBlock:(NetworkCompletionBlock)completionBlock{
    NSString *serverurl = g_baseUrl ;
    serverurl = [serverurl stringByAppendingString:g_urlqueryreview];
    
    NSString *strparam1 = [NSString stringWithFormat:@"%d",place.ep_id];
    
    NSArray *objects = [NSArray arrayWithObjects:strparam1,     nil];
    NSArray *keys = [NSArray arrayWithObjects:@"ep_id", nil];
    
    NSDictionary *questionDict = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    
    [self generalNetwork:serverurl Data:questionDict withCompletionBlock:completionBlock];
    
}

- (void)onLoginByPhone:(EftUser*)user withCompletionBlock:(NetworkCompletionBlock)completionBlock{
    NSString *serverurl = g_baseUrl ;
    serverurl = [serverurl stringByAppendingString:g_urlloginbyphone];
    
    NSArray *objects = [NSArray arrayWithObjects:user.eu_username,     nil];
    NSArray *keys = [NSArray arrayWithObjects:@"phoneid", nil];
    
    NSDictionary *questionDict = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    
    [self generalNetwork:serverurl Data:questionDict withCompletionBlock:completionBlock];
    
}
- (void)onGoogleSearch:(EftQuery*)query Mode:(int)mode withCompletionBlock:(NetworkCompletionBlock)completionBlock{
    NSString *serverurl = g_baseUrl ;
    
    serverurl = [serverurl stringByAppendingString:g_urlgooglesearch];
    
    
    NSString* strparam1 = [NSString stringWithFormat:@"%d",query.catid];
    NSString* strparam2 = [NSString stringWithFormat:@"%@",query.lat];
    NSString* strparam3 = [NSString stringWithFormat:@"%@",query.lon];
    NSString* strparam4 = [NSString stringWithFormat:@"%d",query.radius];
    NSString* strparam5 = [NSString stringWithFormat:@"%d",mode];
    
    NSArray *objects = [NSArray arrayWithObjects:strparam1,strparam2,strparam3,strparam4,query.query,strparam5,     nil];
    NSArray *keys = [NSArray arrayWithObjects:@"catid",@"lat",@"lon",@"radius",@"query",@"mode", nil];
    
    NSDictionary *questionDict = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    
    [self generalNetwork:serverurl Data:questionDict withCompletionBlock:completionBlock];
}
//- (void)onGoogleQuery:(EftQuery*)query withCompletionBlock:(NetworkCompletionBlock)completionBlock{
//    NSString *serverurl = g_baseUrl ;
//    serverurl = [serverurl stringByAppendingString:g_urlgooglequery];
//    
//    
//    NSArray *objects = [NSArray arrayWithObjects:query.query,     nil];
//    NSArray *keys = [NSArray arrayWithObjects:@"query", nil];
//    
//    NSDictionary *questionDict = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
//    
//    [self generalNetwork:serverurl Data:questionDict withCompletionBlock:completionBlock];
//}
- (void)onAddReview:(EftReview*)object Reference:(NSString*)reference
                 Category:(EftCategory*)category withCompletionBlock:(NetworkCompletionBlock)completionBlock{
    NSString *serverurl = g_baseUrl ;
    serverurl = [serverurl stringByAppendingString:g_urladdreview];
    
    NSString* strparam1 = [NSString stringWithFormat:@"%f",object.er_rating];
    NSString* strparam2 = [NSString stringWithFormat:@"%d",g_curUser.eu_id];
    NSString* strparam3 = [NSString stringWithFormat:@"%d",category.ec_id];
    NSString* strparam4 = [NSString stringWithFormat:@"%d",object.er_hasrating];
    NSString* strparam5 = object.er_picture;
    if (strparam5 == nil) {
        strparam5 = @"";
    }
    
    NSArray *objects = [NSArray arrayWithObjects:object.er_text,strparam5,strparam1,strparam2,reference,strparam3,strparam4,     nil];
    NSArray *keys = [NSArray arrayWithObjects:@"er_text",@"er_picture",@"er_rating",@"eu_rid",@"reference",@"ec_rid",@"er_hasrating", nil];
    
    NSDictionary *questionDict = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    
    [self generalNetwork:serverurl Data:questionDict withCompletionBlock:completionBlock];
}

-(void) onAddCategory:(EftCategory*)category withCompletionBlock:(NetworkCompletionBlock)completionBlock{
    NSString *serverurl = g_baseUrl ;
    serverurl = [serverurl stringByAppendingString:g_urladdcategory];
    
    NSString* strparam1 = [NSString stringWithFormat:@"%d",category.ec_parent];
    
    
    NSArray *objects = [NSArray arrayWithObjects:category.ec_name,strparam1,     nil];
    NSArray *keys = [NSArray arrayWithObjects:@"ec_name",@"ec_parent",nil];
    
    NSDictionary *questionDict = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    
    [self generalNetwork:serverurl Data:questionDict withCompletionBlock:completionBlock];
}

-(void)onGoogleSearchOne:(EftCategory*) category Latitude:(NSString*)lat Longitude:(NSString*)lon Radius:(NSString*)radius Query:(NSString*)query withCompletionBlock:(NetworkCompletionBlock)completionBlock{
    
    NSString *serverurl = g_baseUrl ;
    serverurl = [serverurl stringByAppendingString:g_urlgooglesearchone];
    
    NSString* strparam1 = [NSString stringWithFormat:@"%d",category.ec_id];
    
    NSArray *objects = [NSArray arrayWithObjects:strparam1,lat,lon,radius,query,     nil];
    NSArray *keys = [NSArray arrayWithObjects:@"catid",@"lat",@"lon",@"radius",@"query",nil];
    
    NSDictionary *questionDict = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    
    [self generalNetwork:serverurl Data:questionDict withCompletionBlock:completionBlock];
    
}

-(void)onGetMyLocationAddress:(NSString*)latlng withCompletionBlock:(NetworkCompletionBlock)completionBlock{
    NSString *serverurl = g_baseUrl ;
    serverurl = @"http://maps.googleapis.com/maps/api/geocode/json";
    
    
    NSArray *objects = [NSArray arrayWithObjects:latlng,@"true",     nil];
    NSArray *keys = [NSArray arrayWithObjects:@"latlng",@"sensor",nil];
    
    NSDictionary *questionDict = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    
    [self googlePlaceNetwork:serverurl Data:questionDict withCompletionBlock:completionBlock];
    
}

- (void)uploadImage:(UIImage*)image ImagePath:(NSString*)path FileName:(NSString*)fileName withCompletionBlock:(NetworkCompletionBlock)completionBlock{
    NSString *serverurl = g_baseUrl ;
    serverurl = [serverurl stringByAppendingString:@"fileuploadmm.php"];
    
    NSDictionary *parameters = @{@"foo": @"bar"};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSData *imageData = UIImageJPEGRepresentation(image,0.7);
    [manager POST:serverurl parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:imageData name:@"uploaded_file" fileName:fileName mimeType:@"multipart/form-data;boundary=*****"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success: %@", responseObject);
        if(completionBlock){
            if ([self checkResponse:responseObject]) {
                
                completionBlock(responseObject,nil);
            }else{
                completionBlock(nil,[[NSError alloc] init]);
            }
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        if(completionBlock) {
            completionBlock(nil,error);
        }
    }];
}

- (void)onDeleteReview:(EftReview*)object withCompletionBlock:(NetworkCompletionBlock)completionBlock{
    NSString *serverurl = g_baseUrl ;
    serverurl = [serverurl stringByAppendingString:g_urldeletereview];
    
    NSString* strparam1 = [NSString stringWithFormat:@"%d",object.er_id];
    
    NSArray *objects = [NSArray arrayWithObjects:strparam1,   nil];
    NSArray *keys = [NSArray arrayWithObjects:@"er_id", nil];
    
    NSDictionary *questionDict = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    
    [self generalNetwork:serverurl Data:questionDict withCompletionBlock:completionBlock];
}

- (void)onAddReviewFast:(EftQuery *)query EftReview:(EftReview*)object Mode:(int)mode withCompletionBlock:(NetworkCompletionBlock)completionBlock{
    // mode 1  google query is made on the app
    //         required query field:        catid,   query, mode
    NSString *serverurl = g_baseUrl ;
    
    serverurl = [serverurl stringByAppendingString:g_urlfastreview];
    
    
    NSString* strparam1 = [NSString stringWithFormat:@"%d",query.catid];
    NSString* strparam2 = [NSString stringWithFormat:@"%@",query.lat];
    NSString* strparam3 = [NSString stringWithFormat:@"%@",query.lon];
    NSString* strparam4 = [NSString stringWithFormat:@"%d",query.radius];
    NSString* strparam5 = [NSString stringWithFormat:@"%d",mode];
    
    NSString* strparam6 = [NSString stringWithFormat:@"%f",object.er_rating];
    NSString* strparam7 = [NSString stringWithFormat:@"%d",g_curUser.eu_id];
    NSString* strparam8 = [NSString stringWithFormat:@"%d",query.catid];
    NSString* strparam9 = [NSString stringWithFormat:@"%d",object.er_hasrating];
    
    
    NSArray *objects = [NSArray arrayWithObjects:strparam1,strparam2,strparam3,strparam4,query.query,strparam5,object.er_text,object.er_picture,strparam6,strparam7,strparam8,strparam9,     nil];
    NSArray *keys = [NSArray arrayWithObjects:@"catid",@"lat",@"lon",@"radius",@"query",@"mode",@"er_text",@"er_picture",@"er_rating",@"eu_rid",@"ec_rid",@"er_hasrating", nil];
    
    NSDictionary *questionDict = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    
    [self generalNetwork:serverurl Data:questionDict withCompletionBlock:completionBlock];
}

- (void)onGooglePlaceDetail:(EftGooglePlace*)place withCompletionBlock:(NetworkCompletionBlock)completionBlock{
    NSString *serverurl = g_baseUrl ;
    serverurl = [serverurl stringByAppendingString:g_urlgoogleplacedetail];
    
//    NSString *strparam1 = [NSString stringWithFormat:@"%d",place.place_id];
    
    NSArray *objects = [NSArray arrayWithObjects:place.place_id,     nil];
    NSArray *keys = [NSArray arrayWithObjects:@"placeid", nil];
    
    NSDictionary *questionDict = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    
    [self generalNetwork:serverurl Data:questionDict withCompletionBlock:completionBlock];
    
}
@end










