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

@interface WeatherManager ()
{
    NSManagedObjectContext *context;
    AppDelegate *appDelegate;
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
        }
    }
    return self;
}

- (void)fetchWeatherDataAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    [self.communicator searchWeatherDataByCoordinate:coordinate];
}

- (void)fetchWeatherDataByCityName:(NSString *)name
{
    [self.communicator searchWeatherDataByCityName:name];
}

#pragma mark - CoreData

-(WeatherData *)saveRawDataToWeatherData:(NSMutableDictionary *)rawData
{
    WeatherData *data = [WeatherData saveWeatherData:rawData inManagedObjectContext:context];
    return data;
}

-(void)saveWeatherData
{
    NSError *error = nil;
    if(context.hasChanges) {
        [context save:&error];
    }
    if (error) {
        NSLog(@"Error saving weather data: %@", error);
    }
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
