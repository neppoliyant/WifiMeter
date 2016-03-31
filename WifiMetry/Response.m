//
//  Response.m
//  LastNyte
//
//  Created by Neppoliyan Thangavelu on 12/19/15.
//  Copyright © 2015 Neppoliyan Thangavelu. All rights reserved.
//

#import "Response.h"

@implementation Response

-(void) setResponse:(NSDictionary *) data multi:(NSString*) statusCode {
    _data = data;
    _statusCode = statusCode;
}

@end
