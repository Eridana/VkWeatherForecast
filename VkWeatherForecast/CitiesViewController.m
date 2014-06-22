//
//  CitiesViewController.m
//  VkWeatherForecast
//
//  Created by Женя Михайлова on 22.06.14.
//  Copyright (c) 2014 Jane. All rights reserved.
//

#import "CitiesViewController.h"
#import "UIView+ActivityIndicator.h"

@interface CitiesViewController ()
{
    NSArray *_cities;
}
@end

@implementation CitiesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _cities = [self readCitiesFromFile];
    [self updateTable];
}

- (void) updateTable
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [_tableView reloadData];
    });
}

-(NSArray *)readCitiesFromFile
{
    NSError *error = nil;
    NSString *file = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource: @"cities" ofType: @"txt"] encoding:NSUTF8StringEncoding error:&error];
    if(error) {
        NSLog(@"Error reading file %@", error);
    }
    NSArray *result = [file componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    return result;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableVie

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _cities.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    NSString *city = _cities[indexPath.row];
    [cell.textLabel setText:city];
    return cell;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
