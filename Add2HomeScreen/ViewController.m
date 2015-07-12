//
//  ViewController.m
//  Add2HomeScreen
//
//  Created by BILLY HO on 7/12/15.
//  Copyright (c) 2015 BILLY HO. All rights reserved.
//

#import "ViewController.h"
#import "HTTPServer.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // Create server using our custom MyHTTPServer class
    httpServer = [[HTTPServer alloc] init];
    
    // Tell the server to broadcast its presence via Bonjour.
    // This allows browsers such as Safari to automatically discover our service.
    [httpServer setType:@"_http._tcp."];
    
    // Normally there's no need to run our server on any specific port.
    // Technologies like Bonjour allow clients to dynamically discover the server's port at runtime.
    // However, for easy testing you may want force a certain port so you can just hit the refresh button.
    // [httpServer setPort:12345];
    
    // Serve files from our embedded Web folder
    NSString *webPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Web"];
    NSLog(@"Setting document root: %@", webPath);
    
    [httpServer setDocumentRoot:webPath];
    
    [self startServer];
}

- (IBAction)buttonClicked:(id)sender
{
    if (httpServer.isRunning)
    {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://localhost:%d",[httpServer listeningPort]]];
        if ([[UIApplication sharedApplication] canOpenURL:url])
        {
           [[UIApplication sharedApplication] openURL:url];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)startServer
{
    // Start the server (and check for problems)
    
    NSError *error;
    if([httpServer start:&error])
    {
        NSLog(@"Started HTTP Server on port %hu, %@", [httpServer listeningPort], [httpServer publishedName]);
    }
    else
    {
        NSLog(@"Error starting HTTP Server: %@", error);
    }
}

- (void)stopServer
{
    NSLog(@"stop server");
    [httpServer stop];
}
@end
