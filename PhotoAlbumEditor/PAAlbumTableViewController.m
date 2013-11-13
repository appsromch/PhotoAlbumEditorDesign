//
//  PAAlbumTableViewController.m
//  PhotoAlbumEditor
//
//  Created by Teddy Wyly on 10/22/13.
//  Copyright (c) 2013 Teddy Wyly. All rights reserved.
//

#import "PAAlbumTableViewController.h"
#import "CoreDataHelper.h"
#import "Album.h"
#import "PAPhotosCollectionViewController.h"
#import "UITableViewCell+FlatUI.h"
#import "UIColor+FlatUI.h"

@interface PAAlbumTableViewController () <UIAlertViewDelegate>

@property (strong, nonatomic) NSMutableArray *albums; // Of NSManagedObject Albums

@end

@implementation PAAlbumTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Album"];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES]];
    self.albums = [[[CoreDataHelper managedObjectContext] executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    [self.tableView reloadData];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[PAPhotosCollectionViewController class]]) {
        PAPhotosCollectionViewController *targetViewController = segue.destinationViewController;
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Album *selectedAlbum = self.albums[indexPath.row];
        targetViewController.album = selectedAlbum;
        
    }
}

- (NSMutableArray *)albums
{
    if (!_albums) _albums = [[NSMutableArray alloc] init];
    return _albums;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return [self.albums count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Album Cell";
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    //NSArray *colors = @[[UIColor alizarinColor], [UIColor belizeHoleColor], [UIColor emerlandColor]];
    
    UIColor *color = [UIColor whiteColor];
    UITableViewCell *cell = [UITableViewCell configureFlatCellWithColor:color selectedColor:[UIColor midnightBlueColor] reuseIdentifier:CellIdentifier inTableView:tableView];
    
    // Configure the cell...
    Album *album = self.albums[indexPath.row];
    cell.textLabel.text = album.name;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    cell.detailTextLabel.text = [formatter stringFromDate:album.date];
    
    //cell.imageView.image = [UIImage imageNamed:@"grandpa"];
    [cell.imageView setContentMode:UIViewContentModeScaleAspectFill];
    
    return cell;
}
- (IBAction)addAlbumButtonPressed:(UIBarButtonItem *)sender
{
    UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"Enter New Album Name" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add", nil];
    [dialog setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [dialog show];

}

- (Album *)createAlbumWithName:(NSString *)name
{
    Album *album = [NSEntityDescription insertNewObjectForEntityForName:@"Album" inManagedObjectContext:[CoreDataHelper managedObjectContext]];
    album.name = name;
    album.date = [NSDate date];
    
    NSError *error = nil;
    
    if (![[CoreDataHelper managedObjectContext] save:&error]) {
        NSLog(@"Handle error!");
    }
    
    return album;
    
}



# pragma mark - Alert View Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSString *alertText = [alertView textFieldAtIndex:0].text;
        [self.albums addObject:[self createAlbumWithName:alertText]];
    }
    
    [self.tableView reloadData];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
