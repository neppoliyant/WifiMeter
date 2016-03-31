//
//  Request.m
//  LastNyte
//
//  Created by Neppoliyan Thangavelu on 12/19/15.
//  Copyright © 2015 Neppoliyan Thangavelu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Request.h"
#import "Response.h"

@implementation Request

-(Response *) postRequest:(NSString *) url mulipic:(NSMutableDictionary *)requestBody {
    NSData *requestData = [self dictToJson:requestBody];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"POST"];
    [request setURL:[NSURL URLWithString:url]];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:requestData];
    
    return [self handleError:request];
}

-(Response *) putRequest:(NSString *) url mulipic:(NSMutableDictionary *)requestBody {
    NSData *requestData = [self dictToJson:requestBody];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"PUT"];
    [request setURL:[NSURL URLWithString:url]];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:requestData];
    
    return [self handleError:request];
}

-(Response *) getRequest:(NSString *) url {
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"GET"];
    [request setURL:[NSURL URLWithString:url]];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    return [self handleError:request];
}

-(Response *) getImageRequest:(NSString *) url {
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"GET"];
    [request setURL:[NSURL URLWithString:url]];
    
    NSLog(@"Method Enter: handleError");
    Response *response = [[Response alloc] init];
    @try {
        NSError *error = nil;
        NSHTTPURLResponse *responseCode = nil;
        
        NSData *oResponseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&responseCode error:&error];
        
        if ([error code] > 0 ) {
            NSLog(@"Error Code : %ld", (long)[error code]);
            NSLog(@"Error Message : %@", [error localizedDescription]);
            response.statusCode = 0;
            response.errorMsg = [error localizedDescription];
        } else {
            NSString *statusCodeString = [NSString stringWithFormat:@"%ld",(long)[responseCode statusCode]];
            
            response.statusCode = statusCodeString;
            NSLog(@"Status Code : %@", statusCodeString);
            if ([statusCodeString isEqualToString:@"200"]) {
                response.imageData = oResponseData;
            } else {
                NSString *convertedString = [[NSString alloc] initWithData:oResponseData encoding:NSUTF8StringEncoding];
                
                response.errorMsg = convertedString;
                NSLog(@"Response Message : %@", convertedString);
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"An exception occurred: %@", exception.name);
        NSLog(@"Here are some details: %@", exception.reason);
    }
    NSLog(@"Method Exit: handleError");
    return response;
}

-(Response *) deleteRequest:(NSString *) url {
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"DELETE"];
    [request setURL:[NSURL URLWithString:url]];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    return [self handleError:request];
}

-(NSData *)dictToJson:(NSMutableDictionary *)dict
{
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    return  jsonData;
}

-(Response *) handleError: (NSMutableURLRequest *) request{
    NSLog(@"Method Enter: handleError");
    Response *response = [[Response alloc] init];
    @try {
        NSError *error = nil;
        NSHTTPURLResponse *responseCode = nil;
        
        NSData *oResponseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&responseCode error:&error];
        
        if ([error code] > 0 ) {
            NSLog(@"Error Code : %ld", (long)[error code]);
            NSLog(@"Error Message : %@", [error localizedDescription]);
            response.statusCode = 0;
            response.errorMsg = [error localizedDescription];
        } else {
            NSString *statusCodeString = [NSString stringWithFormat:@"%ld",(long)[responseCode statusCode]];
            
            response.statusCode = statusCodeString;
            NSLog(@"Status Code : %@", statusCodeString);
            if ([statusCodeString isEqualToString:@"200"]) {
                NSDictionary* json = [NSJSONSerialization JSONObjectWithData:oResponseData
                                                                     options:kNilOptions
                                                                       error:nil];
                response.data = json;
                NSLog(@"Response Message : %@", json);
            } else {
                NSString *convertedString = [[NSString alloc] initWithData:oResponseData encoding:NSUTF8StringEncoding];
                
                response.errorMsg = convertedString;
                NSLog(@"Response Message : %@", convertedString);
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"An exception occurred: %@", exception.name);
        NSLog(@"Here are some details: %@", exception.reason);
    }
    NSLog(@"Method Exit: handleError");
    return response;
}

@end
