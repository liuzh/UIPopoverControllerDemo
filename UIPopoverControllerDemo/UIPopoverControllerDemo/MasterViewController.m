//
//  MasterViewController.m
//  UIPopoverControllerDemo
//
//  Created by mac on 15/7/30.
//  Copyright (c) 2015年 com.liu. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"

@interface MasterViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    UIPopoverController *pc;
}

@property NSMutableArray *objects;
@end

@implementation MasterViewController

- (void)awakeFromNib {
    [super awakeFromNib];
//    self.clearsSelectionOnViewWillAppear = NO;
//    self.preferredContentSize = CGSizeMake(320.0, 600.0);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

//    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
//    self.navigationItem.rightBarButtonItem = addButton;
//    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
    UIButton *btnOldPhoto = [UIButton buttonWithType:UIButtonTypeCustom];
    btnOldPhoto.frame = CGRectMake(0, 0, 40, 40);
    [btnOldPhoto setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btnOldPhoto setTitle:@"旧" forState:UIControlStateNormal];
    [btnOldPhoto addTarget:self action:@selector(oldPhotoAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *photoOldButton = [[UIBarButtonItem alloc] initWithCustomView:btnOldPhoto];
    
    UIButton *btnNewPhoto = [UIButton buttonWithType:UIButtonTypeCustom];
    btnNewPhoto.frame = CGRectMake(0, 0, 40, 40);
    [btnNewPhoto setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btnNewPhoto setTitle:@"新" forState:UIControlStateNormal];
    [btnNewPhoto addTarget:self action:@selector(newPhotoAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *photoNewButton = [[UIBarButtonItem alloc] initWithCustomView:btnNewPhoto];
    
    self.navigationItem.rightBarButtonItems = @[photoOldButton,photoNewButton];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender {
    if (!self.objects) {
        self.objects = [[NSMutableArray alloc] init];
    }
    [self.objects insertObject:[NSDate date] atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDate *object = self.objects[indexPath.row];
        DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
        [controller setDetailItem:object];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    NSDate *object = self.objects[indexPath.row];
    cell.textLabel.text = [object description];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

#pragma mark - UIActionSheetDelegate

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==actionSheet.cancelButtonIndex) return;
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    if (buttonIndex == 0) {
        //拍照
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePicker.allowsEditing = YES;
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
    }
    else if (buttonIndex == 1) {
        //相册
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            //            [self presentViewController:imagePicker animated:YES completion:nil];
            //            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            //                pc = [[UIPopoverController alloc]initWithContentViewController:imagePicker];
            //                pc.popoverContentSize = CGSizeMake(100, 200);
            //                [pc presentPopoverFromRect:CGRectMake(self.view.bounds.size.width-10, -10, 10, 10) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:NO];
            //                [self presentViewController:imagePicker animated:YES completion:nil];
            //            }];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self presentViewController:imagePicker animated:YES completion:nil];
            });
        }
    }
}

#pragma mark - UIImagePickerControllerDelegate

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    
}

#pragma mark - event

- (void)oldPhotoAction:(UIButton *)sender
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"从相册中选择", nil];
    //    [sheet showInView:self.view];
    [sheet showFromBarButtonItem:self.navigationItem.rightBarButtonItems[0] animated:NO];
}

- (void)newPhotoAction:(UIButton *)sender
{
    UIAlertController *sheet = [UIAlertController alertControllerWithTitle:@"图片" message:@"选择图片方式" preferredStyle:UIAlertControllerStyleActionSheet];
    [sheet addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        //拍照
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePicker.allowsEditing = YES;
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
    }]];
    [sheet addAction:[UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        //相册
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
    }]];
    
    UIPopoverController *popc = [[UIPopoverController alloc] initWithContentViewController:sheet];
    popc.popoverContentSize = CGSizeMake(100, 200);
    [popc presentPopoverFromBarButtonItem:self.navigationItem.rightBarButtonItems[1] permittedArrowDirections:UIPopoverArrowDirectionUp animated:NO];
}
@end
