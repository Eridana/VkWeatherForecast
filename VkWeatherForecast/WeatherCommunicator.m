//
//  WeatherCommunicator.m
//  VkWeatherForecast
//
//  Created by Женя Михайлова on 21.06.14.
//  Copyright (c) 2014 Jane. All rights reserved.
//

#import "WeatherCommunicator.h"
#import "WeatherCommunicatorDelegate.h"

//#define API_KEY @"6e31ea25c4777f9418f524e9840ca640"
NSString *const BASE_URL = @"http://api.openweathermap.org/data/2.5/weather";

@implementation WeatherCommunicator

- (void)searchWeatherDataByCoordinate:(CLLocationCoordinate2D)coordinate
{
    NSString *urlAsString = [NSString stringWithFormat:@"%@?lat=%f&lon=%f", BASE_URL, coordinate.latitude, coordinate.longitude];
    NSURL *url = [[NSURL alloc] initWithString:urlAsString];
    NSLog(@"%@", urlAsString);
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            [self.delegate fetchingFailedWithError:error];
        }
        else {
            [self.delegate receivedWeatherDataJson:data];
        }
    }];
}

- (void)searchWeatherDataByCityName:(NSString *)name
{
    NSString *urlAsString = [NSString stringWithFormat:@"%@?q=%@", BASE_URL, name];
    NSURL *url = [[NSURL alloc] initWithString: [urlAsString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"%@", urlAsString);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            [self.delegate fetchingFailedWithError:error];
        }
        else {
            [self.delegate receivedWeatherDataJson:data];
        }
    }];
}

    /*
- (CLLocationCoordinate2D) getLocationFromCityName: (NSString*) name
{
    double latitude = 0, longitude = 0;
    NSString *esc_addr =  [name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *req = [NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?sensor=false&address=%@", esc_addr];
    NSString *result = [NSString stringWithContentsOfURL:[NSURL URLWithString:req] encoding:NSUTF8StringEncoding error:NULL];
    if (result) {
        NSScanner *scanner = [NSScanner scannerWithString:result];
        if ([scanner scanUpToString:@"\"lat\" :" intoString:nil] && [scanner scanString:@"\"lat\" :" intoString:nil]) {
            [scanner scanDouble:&latitude];
            if ([scanner scanUpToString:@"\"lng\" :" intoString:nil] && [scanner scanString:@"\"lng\" :" intoString:nil]) {
                [scanner scanDouble:&longitude];
            }
        }
    }
    CLLocationCoordinate2D center;
    center.latitude=latitude;
    center.longitude = longitude;
    NSLog(@"View Controller get Location Logitute : %f",center.latitude);
    NSLog(@"View Controller get Location Latitute : %f",center.longitude);
    return center;
}*/


@end
