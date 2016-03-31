//
//  Response.h
//  LastNyte
//
//  Created by Neppoliyan Thangavelu on 12/19/15.
//  Copyright © 2015 Neppoliyan Thangavelu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Response : NSObject

@property (nonatomic, weak) NSDictionary* data;

@property (nonatomic, weak) NSData* imageData;

@property (nonatomic, weak) NSString* statusCode;

@property (nonatomic, weak) NSString* errorMsg;

-(void) setResponse:(NSDictionary *) data multi:(NSString*) statusCode;

@end
