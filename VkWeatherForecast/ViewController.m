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
#import "CitiesViewController.h"

@interface ViewController ()
{
    WeatherData *_data;
    WeatherManager *_manager;
    //CLLocationManager * _locationManager;
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(locationNotavailable:)
                                                 name:@"locationServiceIsNotAvailable"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(startFetchingData:)
                                                 name:@"locationUpdate"
                                               object:nil];
    
    [self.view showActivityIndicator];
    
}

#pragma mark - Location

- (CLLocationManager *)locationManager
{
    if (_locationManager) {
        return _locationManager;
    }
    
    id appDelegate = [[UIApplication sharedApplication] delegate];
    if ([appDelegate respondsToSelector:@selector(locationManager)]) {
        _locationManager = [appDelegate performSelector:@selector(locationManager)];
    }
    return _locationManager;
}

-(void)locationNotavailable:(NSNotification *)notification
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Геолокация недоступна"
                                                    message:@"Невозможно определить текцщее местоположение. Пожалуйста включите геолокацию в настройках."
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles: nil];
    [alert show];
    [self.view stopActivityIndicator];
}


-(void)startFetchingData:(NSNotification *)notification
{
    [_manager fetchWeatherDataAtCoordinate: self.locationManager.location.coordinate];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"Update location failed with code:%ld", (long)[error code]);
    
}

#pragma mark - WeatherManagerDelegate
-(void)didReceiveWeatherData:(WeatherData *)data
{
    _data = data;
    [self reloadData];
}

-(void)fetchingFailedWithError:(NSError *)error
{
    NSLog(@"Error %@; %@", error, [error localizedDescription]);
}

#pragma mark - Update view

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
            BOOL switchValue = _data.isFahrenhate;
            [self.switchToFahrenhate setOn:switchValue animated:NO];
        }

        [self.view hideActivityIndicator];
    });
}

- (IBAction)measureSwitchChanged:(id)sender {
    if([(UISwitch *)sender isOn]) {
        [self convertToFahrenhate];
    }
    else  {
        [self convertToCelsuis];
    }
    [self setTempLabelText:_data.temperature];
}

- (void)saveWeatherDataChanges
{
    [_manager saveWeatherData];
}

-(void)convertToFahrenhate
{
    if(_data.isFahrenhate == NO) {
        double fahrenheit = [[WeatherUtils sharedInstance] convertCelsiusToFahrenhate:_data.temperature];
        _data.isFahrenhate = YES;
        _data.temperature = fahrenheit;
        [self saveWeatherDataChanges];
    }
}

-(void)convertToCelsuis
{
    if(_data.isFahrenhate == YES) {
        double celsius = [[WeatherUtils sharedInstance] convertFahrenhateToCelsuis:_data.temperature];
        _data.isFahrenhate = NO;
        _data.temperature = celsius;
        [self saveWeatherDataChanges];
    }
}

- (void)setTempLabelText:(double)temp
{
    [self.temperatureLabel setText:[NSString stringWithFormat:@"%.1f %@", temp, _data.isFahrenhate ? @"℉" : @"℃"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Select city

- (IBAction)cityChangeSelected:(id)sender {
    UIStoryboard *storyboard = self.navigationController.storyboard;
    CitiesViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"CitiesViewController"];
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
