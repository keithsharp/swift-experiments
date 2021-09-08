//
//  ViewController.swift
//  SotoSandboxTest
//
//  Created by Keith Sharp on 24/07/2021.
//

import Cocoa
import SotoCore
import SotoEC2

class ViewController: NSViewController {
    
    var awsClient: AWSClient!

    var directoryURL: URL? = nil
    var directoryString: String? = nil
    
    deinit {
        directoryURL?.stopAccessingSecurityScopedResource()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    // Should always fail as filepath is outside the sandbox.
    @IBAction func loadConfigButtonPressed(_ sender: NSButton) {
        let filepath = "/Users/kms/.aws/config"
        let configURL = URL(fileURLWithPath: filepath)
        do {
            let text = try String(contentsOf: configURL)
            print(text)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // Needs to be run once to select the directory containing the credentials and
    // config files.  Saves a bookmark to the directory which allows access even
    // when app is restarted.
    @IBAction func chooseDirectoryButtonPressed(_ sender: NSButton) {
        let fileDialog = NSOpenPanel()
        fileDialog.prompt = "Choose directory"
        fileDialog.canChooseDirectories = true
        fileDialog.canChooseFiles = false
        fileDialog.allowsMultipleSelection = false
        fileDialog.resolvesAliases = true
        
        fileDialog.beginSheetModal(for: view.window!) { result in
            if result == .OK, let url = fileDialog.url {
                print("Got URL: \(url.path)")
                
                do {
                    let bookmarkData = try url.bookmarkData(options: .withSecurityScope, includingResourceValuesForKeys: nil, relativeTo: nil)
                    UserDefaults.standard.set(bookmarkData, forKey: "CredentialsBookmark");
                } catch {
                    print("Could not create bookmark")
                }
                
                self.directoryURL = url
                self.directoryString = url.path
            } else {
                print("No directory selected")
            }
        }
    }
    
    // Only works if user has selected a URL via Choose Directory in this run
    @IBAction func getLoadConfigUrlButtonPressed(_ sender: NSButton) {
        guard let directoryURL = directoryURL else {
            print("No directory URL")
            return
        }
        
        let configURL = directoryURL.appendingPathComponent("config")
        print(configURL)
        do {
            let text = try String(contentsOf: configURL)
            print(text)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // Only works if user has selected a URL via Choose Directory in this run
    @IBAction func pathToUrlButtonPressed(_ sender: NSButton) {
        guard let filepath = directoryString else {
            print("No directory String")
            return
        }
        
        let configURL = URL(fileURLWithPath: filepath)
        do {
            let text = try String(contentsOf: configURL.appendingPathComponent("config"))
            print(text)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // If user has not selected URL in this run (using Choose Directory) then attempts
    // to load a bookmark from UserDefaults and use that to create a URL.  With the URL
    // we then start accessing secure resources - cancelled in the deinit function.
    @IBAction func getVpcsButtonPressed(_ sender: NSButton) {
        if directoryURL == nil {
            if let bookMarkData = UserDefaults.standard.data(forKey: "CredentialsBookmark") {
                do {
                    var isStale = false
                    directoryURL = try URL(resolvingBookmarkData: bookMarkData, options: .withSecurityScope, relativeTo: nil, bookmarkDataIsStale: &isStale);
                    if isStale {
                        print("Bookmark is stale, ask user to choose new directory")
                        return
                    }
                } catch {
                    print("Could not create URL from bookmark")
                    return
                }
            } else {
                print("Could not retrieve bookmark from UserData")
                return
            }
        }

        guard let directoryURL = directoryURL else {
            print("Still no directory URL")
            return
        }
        
        if !directoryURL.startAccessingSecurityScopedResource() {
            print("Failed to start using security scoped resource")
            return
        }
        
        let configURL = directoryURL.appendingPathComponent("config")
        let credentialsURL = directoryURL.appendingPathComponent("credentials")
        
        awsClient = AWSClient(credentialProvider: .configFile(credentialsFilePath: credentialsURL.path, configFilePath: configURL.path, profile: "default"), httpClientProvider: .createNew)
        
        print(awsClient.credentialProvider.description)
        
        let ec2 = EC2(client: awsClient, region: .euwest1)

        let request = EC2.DescribeVpcsRequest()
        let describeVPCs = ec2.describeVpcs(request)

        do {
            let response = try describeVPCs.wait()
            if let vpcs = response.vpcs {
                print("Got \(vpcs.count) VPCs.")
                for vpc in vpcs {
                    print(vpc.vpcId ?? "No VPC ID")
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
}

