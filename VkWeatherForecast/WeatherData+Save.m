//
//  WeatherData+Save.m
//  VkWeatherForecast
//
//  Created by Jane on 20.06.14.
//  Copyright (c) 2014 Jane. All rights reserved.
//

#import "WeatherData+Save.h"
#import "Constants.h"

@implementation WeatherData (Save)

+ (WeatherData *)saveWeatherData:(NSMutableDictionary *)info inManagedObjectContext:(NSManagedObjectContext *)context
{
    WeatherData *data = nil;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:WEATHER_ENTITY_NAME];
    NSError *error = nil;
    data = [[context executeFetchRequest:request error:&error] lastObject];
    if(!data && !error) {
        data = [NSEntityDescription insertNewObjectForEntityForName:WEATHER_ENTITY_NAME inManagedObjectContext:context];
        data.cityName = [info objectForKey:NAME_KEY];
        data.humidity = [info objectForKey:HUMIDITY_KEY];
        data.temperature = [info objectForKey:TEMPERATURE_KEY];
        data.weatherDescription = [info objectForKey:DESCRIPTION_KEY];
        data.cloudsValue = [info objectForKey:CLOUDS_KEY];
        data.isCelsius = [NSNumber numberWithBool: YES];
        data.windSpeed = [info objectForKey:SPEED_KEY];
        data.date = [NSDate date];
        [context save:&error];
    }
    else
    {
        // replace data with new object
    }
    
    if (error) {
        NSLog(@"Error creating weather data: %@", error);
    }

    return data;
}

@end
