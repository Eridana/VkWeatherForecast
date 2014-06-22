//
//  ViewController.m
//  VkWeatherForecast
//
//  Created by Jane on 20.06.14.
//  Copyright (c) 2014 Jane. All rights reserved.
//

#import "ViewController.h"
#import "WeatherManager.h"
#import "WeatherData.h"
#import "WeatherCommunicator.h"
#import "UIView+ActivityIndicator.h"
#import "WeatherUtils.h"

@interface ViewController ()
{
    WeatherData *_data;
    WeatherManager *_manager;
    CLLocationManager * _locationManager;
    NSDateFormatter * _dateFormatter;
}
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    _dateFormatter = [[NSDateFormatter alloc] init];
//    [_dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    
    _manager = [[WeatherManager alloc] init];
    _manager.communicator = [[WeatherCommunicator alloc] init];
    _manager.communicator.delegate = _manager;
    _manager.delegate = self;
    
    [self.view showActivityIndicator];
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
    [_locationManager stopUpdatingLocation];
    [_manager fetchWeatherDataAtCoordinate:location.coordinate];
    
    // по названию - [_manager fetchWeatherDataByCityName:name];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"Update location failed with code:%ld", (long)[error code]);
    
}

#pragma mark - WeatherManagerDelegate
- (void)didReceiveWeatherData:(WeatherData *)data //:(WeatherData *)data
{
    _data = data;
    [self reloadData];
}

- (void)fetchingFailedWithError:(NSError *)error
{
    NSLog(@"Error %@; %@", error, [error localizedDescription]);
}

# pragma mark Update view


-(void)reloadData
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if(_data) {
            NSLog(@"%@, %.1f", _data.cityName, _data.temperature);
            [self.cityButton setTitle:_data.cityName forState:UIControlStateNormal];
            [self.dateLabel setText: _data.dateAsString];
            [self.descriptionLabel setText: _data.weatherDescription];
            [self.humidityLabel setText: [NSString stringWithFormat:@"влажность: %.1f%%", _data.humidity]];
            [self.cloudsLabel   setText: [NSString stringWithFormat:@"облачность: %.1f%%", _data.cloudsValue]];
            [self.windLabel     setText: [NSString stringWithFormat:@"скорость ветра: %.1f м/с", _data.windSpeed]];
            [self setTempLabelText:_data.temperature];
            [self.switchToFahrenhate setSelected:_data.isFahrenhate];
        }

        [self.view hideActivityIndicator];
    });
}

-(void)setMeasurementToF:(BOOL)isFahrenhate
{
    
}

- (IBAction)measureSwitchChanged:(id)sender {
    if([(UISwitch *)sender isOn]) {
        [self convertToFahrenhate];
    }
    else  {
        [self convertToCelsuis];
    }
}

-(void)convertToFahrenhate
{
    if(_data && _data.isFahrenhate == NO) {
        double fahrenheit = [[WeatherUtils sharedInstance] convertToFahrenhate:_data.temperature];
        _data.isFahrenhate = YES;
        _data.temperature = fahrenheit;
       [self setTempLabelText:_data.temperature];
    }
}

-(void)convertToCelsuis
{
    if(_data && _data.isFahrenhate == YES) {
        double celsius = [[WeatherUtils sharedInstance] convertToCelsuis:_data.temperature];
        _data.isFahrenhate = NO;
        _data.temperature = celsius;
        [self setTempLabelText:_data.temperature];
    }
}

- (void)setTempLabelText:(double)temp
{
    [self.temperatureLabel setText:[NSString stringWithFormat:@"%.1f %@", temp, _data.isFahrenhate ? @"℉" : @"℃"]];
}

- (IBAction)cityChangeSelected:(id)sender {
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
