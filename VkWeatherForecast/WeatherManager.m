//
//  WeatherManager.m
//  VkWeatherForecast
//
//  Created by Женя Михайлова on 21.06.14.
//  Copyright (c) 2014 Jane. All rights reserved.
//

#import "WeatherManager.h"
#import "WeatherCommunicator.h"
#import "JsonParser.h"

@implementation WeatherManager

- (void)fetchWeatherDataAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    [self.communicator searchWeatherDataByCoordinate:coordinate];
}

- (void)fetchWeatherDataByCityName:(NSString *)name
{
    [self.communicator searchWeatherDataByCityName:name];
}

#pragma mark - WeatherCommunicatorDelegate

- (void)receivedWeatherDataJson:(NSData *)json
{
    NSError *error = nil;
    NSMutableArray *data = [JsonParser getDataFromJson:json error:&error];
    
    if (error != nil) {
        [self.delegate fetchingFailedWithError:error];
        
    } else {
        [self.delegate didReceiveWeatherData:data];
    }
}

- (void)fetchingFailedWithError:(NSError *)error
{
    [self.delegate fetchingFailedWithError:error];
}
@end
