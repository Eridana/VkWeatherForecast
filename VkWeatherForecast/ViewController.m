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

NSString *const VK_APP_ID = @"4427868";

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
    
    
    [VKSdk initializeWithDelegate:self andAppId:VK_APP_ID];
    
    [self.view showActivityIndicator];
    [self checkConnection];
}

#pragma mark - Check internet connection

-(void)checkConnection
{
    if([_manager isConnectionAvailable] == NO) {
        [[[UIAlertView alloc]initWithTitle:@"Нет соединения"
                                                       message:NSLocalizedString(@"Не найдено активное соединение с интернетом. Будут отображены старые данные.", nil)
                                                      delegate:nil
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil] show];
        [self setEmptyData];
        [self.view hideActivityIndicator];
    }
}


#pragma mark - Location

- (void)locationNotAvailable:(NSNotification *)notification
{
    [[[UIAlertView alloc] initWithTitle:@"Геолокация недоступна"
                                                    message:NSLocalizedString(@"Невозможно определить текущее местоположение. Пожалуйста включите геолокацию в настройках.", nil)
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles: nil] show];
    [self setEmptyData];
    [self.view hideActivityIndicator];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [[[UIAlertView alloc] initWithTitle:@"Геолокация недоступна"
                                message:NSLocalizedString(@"Невозможно определить текущее местоположение.", nil)
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles: nil] show];
    NSLog(@"Update location failed with %@", [error description]);
}

- (void)startFetchingData:(NSNotification *)notification
{
    CLLocation *location = (CLLocation *) [notification object];
    [_manager fetchWeatherDataAtCoordinate: location.coordinate];
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
     dispatch_async(dispatch_get_main_queue(), ^{
         [_manager saveWeatherData];
     });
}

- (void)convertToFahrenhate
{
    if(_data.isFahrenhate == NO) {
        double fahrenheit = [WeatherUtils convertCelsiusToFahrenhate:_data.temperature];
        _data.isFahrenhate = YES;
        _data.temperature = fahrenheit;
        [self saveWeatherDataChanges];
    }
}

- (void)convertToCelsuis
{
    if(_data.isFahrenhate == YES) {
        double celsius = [WeatherUtils convertFahrenhateToCelsuis:_data.temperature];
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


#pragma mark - VK methods

- (IBAction)postButtonClick:(id)sender {
    [VKSdk authorize: @[VK_PER_WALL]];
}

- (void)vkSdkNeedCaptchaEnter:(VKError *)captchaError
{
    VKCaptchaViewController *vkVaptchViewController = [VKCaptchaViewController captchaControllerWithError:captchaError];
    [vkVaptchViewController presentIn:self];
}

- (void)vkSdkTokenHasExpired:(VKAccessToken *)expiredToken
{
    [self postButtonClick:nil];
}

- (void)vkSdkUserDeniedAccess:(VKError *)authorizationError
{
    [[[UIAlertView alloc]initWithTitle:@"Доступ отклонен"
                                                   message:NSLocalizedString(@"Нет прав для доступа к ВКонтакте. Отменено пользователем.", nil)
                                                  delegate:nil
                                         cancelButtonTitle:@"OK"
                                         otherButtonTitles:nil] show];
}

- (void)vkSdkShouldPresentViewController:(UIViewController *)controller
{
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)vkSdkDidAcceptUserToken:(VKAccessToken *)token
{
    NSLog(@"VkSdk did accept user token");
}

- (void)vkSdkReceivedNewToken:(VKAccessToken *)newToken
{
    NSString* message = [self getVkPostMessage];
    NSString *urlAsString = [NSString stringWithFormat:@"https://api.vk.com/method/wall.post?uid=%@&message=%@&access_token=%@", newToken.userId, message, newToken.accessToken];
    NSURL *url = [[NSURL alloc] initWithString: [urlAsString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"%@", urlAsString);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    NSHTTPURLResponse *response = nil;
    NSError *error = nil;
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (error) {
        [self showPostingErrorAlert];
        NSLog(@"VkSdk wall request returning error %@", error);
    }
    else {
        [self showPostingSuccessAlert];
    }
    NSLog(@"VkSdk did receive user token");
}

- (void)showPostingErrorAlert
{
    [[[UIAlertView alloc]initWithTitle:@"Произошла ошибка"
                                                   message:NSLocalizedString(@"Не удалось опубликовать пост.", nil)
                                                  delegate:nil
                                         cancelButtonTitle:@"OK"
                                         otherButtonTitles:nil] show];
}

- (void)showPostingSuccessAlert
{
    [[[UIAlertView alloc]initWithTitle:nil
                               message:NSLocalizedString(@"Пост опубликован на стене ВКонтакте.", nil)
                              delegate:nil
                     cancelButtonTitle:@"OK"
                     otherButtonTitles:nil] show];
}

- (NSString *)getVkPostMessage
{
    NSString *message = nil;
    if(_data) {
        message = [NSString stringWithFormat:@"Погода в городе %@ \r на %@: температура: %@, %@, влажность: %.1f%%,"
                   " облачность: %.1f%%, скорость ветра: %.1f м/с \r Send from VkWeatherForecast App.",
                   _data.cityName, _data.dateAsString, _temperatureLabel.text, _data.weatherDescription,
                   _data.humidity, _data.cloudsValue, _data.windSpeed];
    }
    return message;
}

@end
