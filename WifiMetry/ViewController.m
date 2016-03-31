//
//  ViewController.m
//  WifiMetry
//
//  Created by Neppoliyan Thangavelu on 3/30/16.
//  Copyright © 2016 Neppoliyan Thangavelu. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#include <math.h>
#import "Response.h"
#import "Request.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _startButton.layer.cornerRadius = _startButton.frame.size.width / 2;
    _startButton.clipsToBounds = YES;
    
    _stopButton.layer.cornerRadius = _stopButton.frame.size.width / 2;
    _stopButton.clipsToBounds = YES;
    
    _stopButton.hidden = YES;
    _stopButton.enabled = NO;
    
    [self StartLocation];
    
    [self fetchSSIDInfo];
    
    NSLog(@"Loaded All the Values");
}

-(void) StartLocation {
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    _locationManager.delegate = self;
    [_locationManager startUpdatingLocation];
    _startLocation = nil;
}

-(void)resetDistance:(id)sender
{
    _startLocation = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)startAction:(id)sender {
    
    NSTimeInterval time = 1;
    _locationUpdateTimer =
    [NSTimer scheduledTimerWithTimeInterval:time
                                     target:self
                                   selector:@selector(StartLocation)
                                   userInfo:nil
                                    repeats:YES];
    
    _wifiLocationUpdate = [NSTimer scheduledTimerWithTimeInterval:1 target:self
                                   selector:@selector(fetchSSIDInfo)
                                   userInfo:nil
                                    repeats:YES];
    _startButton.hidden = YES;
    _startButton.enabled = NO;
    
    _stopButton.enabled = YES;
    _stopButton.hidden = NO;
}

- (IBAction)StopLocation:(id)sender {
    [_locationUpdateTimer invalidate];
    _locationUpdateTimer = nil;
    _startButton.hidden = NO;
    _startButton.enabled = YES;
    
    _stopButton.enabled = NO;
    _stopButton.hidden = YES;
    
    [_wifiLocationUpdate invalidate];
    _wifiLocationUpdate = nil;
}

- (void)fetchSSIDInfo
{
    NSArray *interfaceNames = CFBridgingRelease(CNCopySupportedInterfaces());
    NSLog(@"%s: Supported interfaces: %@", __func__, interfaceNames);
    
    NSDictionary *SSIDInfo;
    for (NSString *interfaceName in interfaceNames) {
        SSIDInfo = CFBridgingRelease(
                                     CNCopyCurrentNetworkInfo((__bridge CFStringRef)interfaceName));
        NSLog(@"%s: %@ => %@", __func__, interfaceName, SSIDInfo);
        
        BOOL isNotEmpty = (SSIDInfo.count > 0);
        if (isNotEmpty) {
            _lblWifiName.text = [SSIDInfo valueForKey:@"SSID"];
            break;
        }
    }
        UIApplication *app = [UIApplication sharedApplication];
        NSArray *subviews = [[[app valueForKey:@"statusBar"]     valueForKey:@"foregroundView"] subviews];
        NSString *wifiData;
        for (id subview in subviews) {
            if([subview isKindOfClass:[NSClassFromString(@"UIStatusBarDataNetworkItemView") class]])
            {
                wifiData = subview;
                break;
            }
        }
        
        NSLog(@"Wifi strength : %@",  [wifiData valueForKey:@"wifiStrengthBars"]);
        NSLog(@"Wifi strength : %@",  [wifiData valueForKey:@"wifiStrengthRaw"]);
    
    
    
    [_lblWifiValue setText:[[wifiData valueForKey:@"wifiStrengthBars"] stringValue]];
    [_lblWifiValue2 setText:[[wifiData valueForKey:@"wifiStrengthRaw"] stringValue]];

}

-(void)viewDidAppear:(BOOL)animated {
    [self fetchSSIDInfo];
}


-(void)locationManager:(CLLocationManager *)manager
   didUpdateToLocation:(CLLocation *)newLocation
          fromLocation:(CLLocation *)oldLocation
{
    NSString *currentLatitude = [[NSString alloc]
                                 initWithFormat:@"%+.6f",
                                 newLocation.coordinate.latitude];
    NSLog(@"Current Lattitude : %@", currentLatitude);
    [_lblLatitude setText:currentLatitude];
    
    NSString *currentLongitude = [[NSString alloc]
                                  initWithFormat:@"%+.6f",
                                  newLocation.coordinate.longitude];
    NSLog(@"Current Longitude : %@", currentLongitude);
    [_lblLongitude setText:currentLongitude];
    
    NSString *currentHorizontalAccuracy =
    [[NSString alloc]
     initWithFormat:@"%+.6f",
     newLocation.horizontalAccuracy];
    NSLog(@"Current Horizontal Accuracy : %@", currentHorizontalAccuracy);
    [_lblHoriAccu setText:currentHorizontalAccuracy];
    
    NSString *currentAltitude = [[NSString alloc]
                                 initWithFormat:@"%+.6f",
                                 newLocation.altitude];
    NSLog(@"Current Altitude : %@", currentAltitude);
    
    [_lblAltitude setText:currentAltitude];
    
    NSString *currentVerticalAccuracy =
    [[NSString alloc]
     initWithFormat:@"%+.6f",
     newLocation.verticalAccuracy];
    [_lblVeriAccu setText:currentVerticalAccuracy];
    
    NSLog(@"Current Horizontal Accuracy : %@", currentVerticalAccuracy);
    
    if (_startLocation == nil)
        _startLocation = newLocation;
    
    CLLocationDistance distanceBetween = [newLocation
                                          distanceFromLocation:_startLocation];
    
    NSString *tripString = [[NSString alloc]
                            initWithFormat:@"%f",
                            distanceBetween];
    
    NSLog(@"Distance : %@", tripString);
    
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *subviews = [[[app valueForKey:@"statusBar"]     valueForKey:@"foregroundView"] subviews];
    NSString *wifiData;
    for (id subview in subviews) {
        if([subview isKindOfClass:[NSClassFromString(@"UIStatusBarDataNetworkItemView") class]])
        {
            wifiData = subview;
            break;
        }
    }
    
    NSMutableDictionary *location = [[NSMutableDictionary alloc] init];
    [location setValue:currentLatitude forKey:@"lat"];
    [location setValue:currentLongitude forKey:@"long"];
    [location setValue:currentAltitude forKey:@"alt"];
    [location setValue:currentHorizontalAccuracy forKey:@"horizontalAccuracy"];
    [location setValue:currentVerticalAccuracy forKey:@"verticalAccuracy"];
    [location setValue:[wifiData valueForKey:@"wifiStrengthRaw"] forKey:@"wifiStrength"];
    [location setValue:[self getNowDateString] forKey:@"ts"];
    [location setValue:[self getWifiName] forKey:@"ssid"];
    
    NSString *url = @"http://96.119.44.86:10005/location/";
    
    NSString *finalUrl = [url stringByAppendingString:[self getWifiName]];
    
    NSLog(@"Url: %@", finalUrl);
    NSLog(@"Tranfer Data: %@", location);
    
    Response *response = [[Request alloc] putRequest:finalUrl mulipic:location];
    
    if ([[response statusCode] isEqual:@"200"]) {
        NSLog(@"Successfull transfer of data");
    }
    
    [_locationManager stopUpdatingLocation];
}

-(NSString*) getNowDateString {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat: @"yyyy-MM-dd HH:mm:ss zzz"];
    NSDate *now = [NSDate date];
    NSString *stringFromDate = [formatter stringFromDate:now];
    return stringFromDate;
}

-(NSString*) getWifiName {
    NSArray *interfaceNames = CFBridgingRelease(CNCopySupportedInterfaces());
    NSLog(@"%s: Supported interfaces: %@", __func__, interfaceNames);
    
    NSDictionary *SSIDInfo;
    for (NSString *interfaceName in interfaceNames) {
        SSIDInfo = CFBridgingRelease(
                                     CNCopyCurrentNetworkInfo((__bridge CFStringRef)interfaceName));
        NSLog(@"%s: %@ => %@", __func__, interfaceName, SSIDInfo);
        
        BOOL isNotEmpty = (SSIDInfo.count > 0);
        if (isNotEmpty) {
            return [SSIDInfo valueForKey:@"SSID"];
            break;
        }
    }
    return @"";
}

- (void)locationManager: (CLLocationManager *)manager didFailWithError: (NSError *)error
{
    // NSLog(@"locationManager error:%@",error);
    
    switch([error code])
    {
        case kCLErrorNetwork: // general, network-related error
        {
            NSLog(@"Network Error. Please check your network connection.");
            /*UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network Error" message:@"Please check your network connection." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
             [alert show];*/
        }
            break;
        case kCLErrorDenied:{
            NSLog(@"Enable Location Service");
            /*UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Enable Location Service" message:@"You have to enable the Location Service to use this App. To enable, please go to Settings->Privacy->Location Services" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
             [alert show];*/
        }
            break;
        default:
        {
            
        }
            break;
    }
}
@end
