//
//  JsonParser.m
//  VkWeatherForecast
//
//  Created by Женя Михайлова on 21.06.14.
//  Copyright (c) 2014 Jane. All rights reserved.
//

#import "JsonParser.h"
#import "WeatherData.h"
#import "Constants.h"

@implementation JsonParser

+(NSMutableDictionary *)getDataFromJson:(NSData *)json error:(NSError **)error
{
    NSError *localError = nil;
    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:json options:0 error:&localError];
    
    if (localError != nil) {
        *error = localError;
        return nil;
    }
    
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    
    for (NSString *key in parsedObject) {
        if([key isEqualToString: CLOUDS_KEY_JSON]) {
            NSDictionary *clouds = [parsedObject objectForKey:key];
            if(clouds) {
                if([clouds objectForKey:CLOUDS_KEY]) {
                    [result setValue:[NSNumber numberWithDouble: [[clouds objectForKey:CLOUDS_KEY] doubleValue]] forKey:CLOUDS_KEY];
                }
            }
        }
        else if([key isEqualToString: MAIN_KEY_JSON]) {
            NSDictionary *main = [parsedObject objectForKey:key];
            if(main) {
                if([main objectForKey: HUMIDITY_KEY]){
                    [result setValue:[NSNumber numberWithDouble: [[main objectForKey:HUMIDITY_KEY] doubleValue]] forKey:HUMIDITY_KEY];
                    [result setValue:[NSNumber numberWithDouble: [[main objectForKey:TEMPERATURE_KEY] doubleValue]] forKey:TEMPERATURE_KEY];
                }
            }
        }
        else if([key isEqualToString: NAME_KEY_JSON]) {
            [result setValue:[parsedObject objectForKey:NAME_KEY_JSON] forKey:NAME_KEY];

        }
        else if([key isEqualToString: WEATHER_KEY_JSON]) {
            NSArray *weather = [parsedObject objectForKey:key];
            if(weather && weather.count > 0) {
                if([weather[0] objectForKey:DESCRIPTION_KEY]) {
                    [result setValue: [weather[0] objectForKey:DESCRIPTION_KEY] forKey:DESCRIPTION_KEY];
                }
            }
        }
        else if([key isEqualToString:WIND_KEY_JSON]) {
            NSDictionary *wind = [parsedObject objectForKey:key];
            if(wind) {
                if([wind objectForKey:SPEED_KEY]) {
                    [result setValue:[NSNumber numberWithDouble: [[wind objectForKey:SPEED_KEY] doubleValue]] forKey:SPEED_KEY];
                }
            }
        }
    }
    
//        if ([data respondsToSelector:NSSelectorFromString(key)]) {
//            if([parsedObject objectForKey:key] != [NSNull null]) {
//                [data setValue:[parsedObject valueForKey:key] forKey:key];
//            }
//        }
    
    if (localError != nil) {
        *error = localError;
        return nil;
    }
    
    return result;
}

@end
