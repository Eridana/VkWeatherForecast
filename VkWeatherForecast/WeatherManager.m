//
//  WeatherManager.m
//  VkWeatherForecast
//
//  Created by Женя Михайлова on 21.06.14.
//  Copyright (c) 2014 Jane. All rights reserved.
//

#import "WeatherManager.h"
#import "WeatherCommunicator.h"
#import "AppDelegate.h"
#import "JsonParser.h"
#import "WeatherData+Save.h"
#import "Constants.h"
#import "Reachability.h"

@interface WeatherManager ()
{
    NSManagedObjectContext *context;
    AppDelegate *appDelegate;
    Reachability *reachability;
}
@end

@implementation WeatherManager

- (id)init
{
    self = [super init];
    if (self) {
        if(!context) {
            appDelegate = [[UIApplication sharedApplication] delegate];
            context = [appDelegate managedObjectContext];
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(checkNetworkStatus:)
                                                         name:kReachabilityChangedNotification
                                                       object:nil];
            
            reachability = [Reachability reachabilityForInternetConnection];
            [reachability startNotifier];
        }
    }
    return self;
}

- (BOOL)isConnectionAvailable
{
    reachability = [Reachability reachabilityWithHostName:@"www.google.com"];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    if ((internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN)) {
        return NO;
    }
    return YES;
}

- (void)checkNetworkStatus:(NSNotification *)notification
{
    reachability = [notification object];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    if((internetStatus == ReachableViaWiFi) || (internetStatus == ReachableViaWWAN)) {
         [[NSNotificationCenter defaultCenter] postNotificationName:@"connectionAvailable" object:nil userInfo:nil];
    }
}

- (void)fetchWeatherDataAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    if([self isConnectionAvailable]) {
        [self.communicator searchWeatherDataByCoordinate:coordinate];
    }
    else {
        [self fetchDataFromDB];
    }
}

- (void)fetchWeatherDataByCityName:(NSString *)name
{
    if([self isConnectionAvailable]) {
        [self.communicator searchWeatherDataByCityName:name];
    }
    else {
        [self fetchDataFromDB];
    }
}

- (void)fetchDataFromDB
{
    WeatherData *data = [self loadWeatherDataFromDdb];
    [self.delegate didReceiveWeatherData:data];
}

#pragma mark - CoreData

- (WeatherData *)saveRawDataToWeatherData:(NSMutableDictionary *)rawData
{
    WeatherData *data = [WeatherData saveWeatherData:rawData inManagedObjectContext:context];
    return data;
}

- (void)saveWeatherData
{
    NSError *error = nil;
    if(context.hasChanges) {
        [context save:&error];
    }
    if (error) {
        NSLog(@"Error saving weather data: %@", error);
    }
}

- (WeatherData *)loadWeatherDataFromDdb
{
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName: WEATHER_ENTITY_NAME];
    NSError *error = nil;
    NSArray *results = [context executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"Error loading data from db: %@", error);
    }
    return [results lastObject];
}

#pragma mark - WeatherCommunicatorDelegate

- (void)receivedWeatherDataJson:(NSData *)json
{
    NSError *error = nil;
    NSMutableDictionary *rawData = [JsonParser getDataFromJson:json error:&error];
    
    if (error != nil) {
        [self.delegate fetchingFailedWithError:error];
    } else {
        WeatherData *data = [self saveRawDataToWeatherData:rawData];
        [self.delegate didReceiveWeatherData:data];
    }
}

- (void)fetchingFailedWithError:(NSError *)error
{
    [self.delegate fetchingFailedWithError:error];
}
@end
