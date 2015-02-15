//
//  ViewController.m
//  EjemploWeb
//
//  Created by Alberto Cordero Arellanes on 13/02/15.
//  Copyright (c) 2015 AlbertoCorderoArellanes. All rights reserved.
//

#import "HomeTable.h"
#import "cellOaxaca.h"

NSMutableArray *maNames;
NSMutableArray *maImgs;
NSMutableArray *maRole;
NSMutableArray *maAge;

NSString        *userID;

NSDictionary    *jsonResponse;

UIAlertView     *alert;

@interface HomeTable ()

@end

@implementation HomeTable

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.screenName = @"OaxacaPantalla1";
    [self initController];
    [self postService];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.screenName = @"OaxacaPantalla1";
}

- (void)initController
{
    maNames         =  [NSMutableArray arrayWithObjects: @"Walter González", @"Alejandra Bautista", @"Augusto Bustamante", @"José Chávez", @"Alberto Cordero", nil];
    
    maAge           =  [NSMutableArray arrayWithObjects: @"35", @"25", @"42", @"36", @"24", nil];
    
    maImgs          =  [NSMutableArray arrayWithObjects: @"chavo.png", @"chilindrina.png", @"jaimito.png", @"nono.png", @"clotilde.png", nil];
    
    maRole          =  [NSMutableArray arrayWithObjects: @"Profesor Curso", @"Alumna Guapa", @"Amigo Estudioso", @"Alumno Travieso", @"Alumno Inteligente", nil];
    
    userID = @"1";
}

/**********************************************************************************************
 Table Functions
 **********************************************************************************************/
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
//-------------------------------------------------------------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return maNames.count;
}
//-------------------------------------------------------------------------------
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64;
}
//-------------------------------------------------------------------------------
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"cellOaxaca");
    static NSString *CellIdentifier = @"cellOaxaca";
    
    cellOaxaca *cell = (cellOaxaca *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[cellOaxaca alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.lblName.text       = maNames[indexPath.row];
    cell.lblRole.text       = maRole[indexPath.row];
    cell.lblAge.text        = maAge[indexPath.row];
    cell.imgUser.image      = [UIImage imageNamed:maImgs[indexPath.row]];
    
    return cell;
}

//-------------------------------------------------------------------------------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.lblSelectedName.text = maNames[indexPath.row];
    NSString *strTemp;
    
    strTemp = [self.lblSelectedName.text stringByAppendingString: @" fué seleccionado"];
    
    if (indexPath.row == 2)
    {
        alert = [[UIAlertView alloc] initWithTitle:@"Alerta Oaxaca"
                                           message:strTemp
                                          delegate:self
                                 cancelButtonTitle:@"Cancelar"
                                 otherButtonTitles:@"Guardar", @"Publicar", nil];
        [alert show];
    }
}

/**********************************************************************************************
 Alert View Functions
 **********************************************************************************************/
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"Alert buttons pressed");
    
    if(buttonIndex == 0)
    {
        NSLog(@"Cancelar");
    }
    else if(buttonIndex == 1)
    {
        NSLog(@"Guardar");
    }
    else if(buttonIndex == 2)
    {
        NSLog(@"Publicar");
    }
}

- (IBAction)btnSharePressed:(id)sender
{
    NSString                    *strMsg;
    NSArray                     *activityItems;
    UIImage                     *imgShare;
    UIActivityViewController    *actVC;
    
    imgShare = [UIImage imageNamed:@"chavo.png"];
    strMsg = @"Hola desde mi clase de iOS de la UAG en Oaxaca =)";
    
    activityItems = @[imgShare, strMsg];
    
    //Init activity view controller
    actVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    actVC.excludedActivityTypes = [NSArray arrayWithObjects:UIActivityTypePrint, UIActivityTypeAssignToContact, UIActivityTypeCopyToPasteboard, UIActivityTypeAirDrop, nil];
    
    [self presentViewController:actVC animated:YES completion:nil];
}

- (IBAction)btnRefreshPressed:(id)sender {
    [self.tblMain reloadData];
}

/*******************************************************************************
 Web Service
 *******************************************************************************/
//-------------------------------------------------------------------------------
- (void) postService
{
    NSLog(@"postService");
    NSOperationQueue *queue = [NSOperationQueue new];
    NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(loadService) object:nil];
    [queue addOperation:operation];
}
//-------------------------------------------------------------------------------
- (void) loadService
{
    @try
    {
        NSString *post = [[NSString alloc] initWithFormat:@"id=%@", userID];
        NSLog(@"postService: %@",post);
        NSURL *url = [NSURL URLWithString:@"http://ec2-54-148-72-192.us-west-2.compute.amazonaws.com/"];
        NSLog(@"URL postService = %@", url);
        NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:url];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        [NSURLRequest requestWithURL:url];
        NSError *error = [[NSError alloc] init];
        NSHTTPURLResponse *response = nil;
        NSData *urlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        //-------------------------------------------------------------------------------
        if ([response statusCode] >=200 && [response statusCode] <300)
        {
            jsonResponse = [NSJSONSerialization JSONObjectWithData:urlData options:kNilOptions error:&error];
        }
        else
        {
            if (error)
            {
                NSLog(@"Error");
                
            }
            else
            {
                NSLog(@"Conect Fail");
            }
        }
        //-------------------------------------------------------------------------------
    }
    @catch (NSException * e)
    {
        NSLog(@"Exception");
    }
    //-------------------------------------------------------------------------------
    NSLog(@"jsonResponse %@", jsonResponse);
    maNames         = [jsonResponse valueForKey:@"Name"];
    NSLog(@"maNames %@", maNames);
    //[self.tblMain reloadData];
}


@end
