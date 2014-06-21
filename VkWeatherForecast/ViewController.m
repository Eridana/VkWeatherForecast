//
//  ViewController.m
//  VkWeatherForecast
//
//  Created by Jane on 20.06.14.
//  Copyright (c) 2014 Jane. All rights reserved.
//

#import "ViewController.h"
#import "WeatherManager.h"
#import "WeatherCommunicator.h"

@interface ViewController ()
{
    NSArray *_data;
    WeatherManager *_manager;
    CLLocationManager * _locationManager;
}
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _manager = [[WeatherManager alloc] init];
    _manager.communicator = [[WeatherCommunicator alloc] init];
    _manager.communicator.delegate = _manager;
    _manager.delegate = self;
    
    [self updateLocation];
    
}

- (void)updateLocation
{
    if (_locationManager == nil) {
        _locationManager = [[CLLocationManager alloc] init];
    }
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    _locationManager.distanceFilter = 100;
    
    [_locationManager startUpdatingLocation];
}

#pragma mark LocationDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation* location = [locations lastObject];
    NSDate* eventDate = location.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    if (abs(howRecent) < 15.0) {
        // If the event is recent, do something with it.
        NSLog(@"latitude %+.6f, longitude %+.6f\n",
              location.coordinate.latitude,
              location.coordinate.longitude);
    }
    [_manager fetchWeatherDataAtCoordinate:_locationManager.location.coordinate];
    // по названию - [_manager fetchWeatherDataByCityName:name];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"Update location failed with code:%ld", (long)[error code]);
    
}

#pragma mark - WeatherManagerDelegate
- (void)didReceiveWeatherData:(NSMutableArray *)dataArray //:(WeatherData *)data
{
    _data = [dataArray firstObject];
    [self reloadData];
}

- (void)fetchingFailedWithError:(NSError *)error
{
    NSLog(@"Error %@; %@", error, [error localizedDescription]);
}

# pragma mark Update view

-(void)reloadData
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
