//
//  ViewController.h
//  WifiMetry
//
//  Created by Neppoliyan Thangavelu on 3/30/16.
//  Copyright © 2016 Neppoliyan Thangavelu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ViewController : UIViewController <CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *startButton;
- (IBAction)startAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *stopButton;
@property (weak, nonatomic) IBOutlet UILabel *lblWifiName;
- (IBAction)StopLocation:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *lblWifiValue;

@property (weak, nonatomic) IBOutlet UILabel *lblWifiValue2;

@property (nonatomic) NSTimer* wifiLocationUpdate;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *startLocation;
@property (nonatomic) NSTimer* locationUpdateTimer;
@property (weak, nonatomic) IBOutlet UILabel *lblLatitude;
@property (weak, nonatomic) IBOutlet UILabel *lblHoriAccu;
@property (weak, nonatomic) IBOutlet UILabel *lblVeriAccu;

@property (weak, nonatomic) IBOutlet UILabel *lblLongitude;
@property (weak, nonatomic) IBOutlet UILabel *lblAltitude;

@end

