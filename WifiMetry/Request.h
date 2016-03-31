//
//  Request.h
//  LastNyte
//
//  Created by Neppoliyan Thangavelu on 12/19/15.
//  Copyright © 2015 Neppoliyan Thangavelu. All rights reserved.
//
#import "Response.h"

@interface Request : NSObject

-(Response *) postRequest:(NSString *) url mulipic:(NSMutableDictionary *)requestBody;
-(Response *) putRequest:(NSString *) url mulipic:(NSMutableDictionary *)requestBody;
-(Response *) getRequest:(NSString *) url;
-(Response *) deleteRequest:(NSString *) url;
-(Response *) getImageRequest:(NSString *) url;

@end
