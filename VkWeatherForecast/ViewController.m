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
#import "Constants.h"
#import "Reachability.h"

@interface ViewController ()
{
    WeatherData *_data;
    WeatherManager *_manager;
    NSDateFormatter * _dateFormatter;
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
    
     [self.cityButton.titleLabel setTextAlignment: NSTextAlignmentCenter];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(locationNotAvailable:)
                                                 name:@"locationServiceIsNotAvailable"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(startFetchingData:)
                                                 name:@"locationUpdate"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(startFetchingData:)
                                                 name:@"connectionAvailable"
                                               object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(startFetchingDataByCityName:)
                                                 name:@"cityDidSelect"
                                               object:nil];
    
    [self.view showActivityIndicator];
    [self checkConnection];
}

#pragma mark - Check internet connection

-(void)checkConnection
{
    if([_manager isConnectionAvailable] == NO) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Нет соединения"
                                                       message:NSLocalizedString(@"Не найдено активное соединение с интернетом. Будут отображены старые данные.", nil)
                                                      delegate:nil
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
        [alert show];
        [self setEmptyData];
        [self.view hideActivityIndicator];
    }
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

- (void)locationNotAvailable:(NSNotification *)notification
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Геолокация недоступна"
                                                    message:NSLocalizedString(@"Невозможно определить текущее местоположение. Пожалуйста включите геолокацию в настройках.", nil)
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles: nil];
    [alert show];
    [self setEmptyData];
    [self.view hideActivityIndicator];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"Update location failed with code:%ld", (long)[error code]);
}

- (void)startFetchingData:(NSNotification *)notification
{
    //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, (unsigned long)NULL), ^(void) {
    [_manager fetchWeatherDataAtCoordinate: self.locationManager.location.coordinate];
    //});
}

- (void)startFetchingDataByCityName:(NSNotification *)notification
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, (unsigned long)NULL), ^(void) {
        NSString *name = [[notification userInfo] objectForKey:CITY_NAME_KEY];
        [_manager fetchWeatherDataByCityName:name];
    });
}

#pragma mark - WeatherManagerDelegate
- (void)didReceiveWeatherData:(WeatherData *)data
{
    _data = data;
    [self reloadData];
}

- (void)fetchingFailedWithError:(NSError *)error
{
    [self setEmptyData];
    NSLog(@"Error %@; %@", error, [error localizedDescription]);
}

#pragma mark - Update view

- (void)reloadData
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if(_data) {
            NSLog(@"%@, %.1f", _data.cityName, _data.temperature);
            if(_data.cityName == nil) {
                _data.cityName = @"имя не определено";
            }
            [self.cityButton setTitle:_data.cityName forState:UIControlStateNormal];
            [self.cityButton setEnabled:YES];
            [self.vkPostButton setEnabled:YES];
            [self.dateLabel setText: _data.dateAsString];
            [self.descriptionLabel setText: _data.weatherDescription];
            [self.humidityLabel setText: [NSString stringWithFormat:@"влажность: %.1f%%", _data.humidity]];
            [self.cloudsLabel   setText: [NSString stringWithFormat:@"облачность: %.1f%%", _data.cloudsValue]];
            [self.windLabel     setText: [NSString stringWithFormat:@"скорость ветра: %.1f м/с", _data.windSpeed]];
            [self setTempLabelText:_data.temperature];
            BOOL switchValue = _data.isFahrenhate;
            [self.switchToFahrenhate setOn:switchValue animated:NO];
        }
        else {
            [self setEmptyData];
        }
        [self.view hideActivityIndicator];
    });
}

- (void)setEmptyData
{
    [self.cityButton    setTitle:@"нет данных" forState:UIControlStateNormal];
    [self.dateLabel     setText: @"нет данных"];
    [self.descriptionLabel setText: @"нет данных"];
    [self.humidityLabel setText: @"влажность: нет данных"];
    [self.cloudsLabel   setText: @"облачность: нет данных"];
    [self.windLabel     setText: @"скорость ветра: нет данных"];
    [self setTempLabelText: 0];
    [self.view hideActivityIndicator];
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

- (void)convertToFahrenhate
{
    if(_data.isFahrenhate == NO) {
        double fahrenheit = [[WeatherUtils sharedInstance] convertCelsiusToFahrenhate:_data.temperature];
        _data.isFahrenhate = YES;
        _data.temperature = fahrenheit;
        [self saveWeatherDataChanges];
    }
}

- (void)convertToCelsuis
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

#pragma mark - VK posting

- (IBAction)postButtonClick:(id)sender {
    
}

@end
