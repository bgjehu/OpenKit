//
//  MSBBand.swift
//  WearableKit
//
//  Created by Jieyi Hu on 8/17/15.
//  Copyright © 2015 SenseWatch. All rights reserved.
//

import UIKit


public class MSBBand: NSObject, MSBClientManagerDelegate, MSBBandDelegate, MSBClientTileDelegate {
    
    
    
    //  MARK:- Public Properties
    
    //  MARK: Name
    private let _name = "Microsoft Band"
    
    /**
        The name of the MSBBand instance.
    */
    public var name : String {
        if available && connected {
            return client!.name
        } else {
            return _name
        }
    }
    
    //  MARK: Availability
    private var _available : Bool = false
    
    /**
        It is true when the Microsoft Band is paired to the iOS device, otherwise it is false.
    */
    public var available : Bool {
        get{
            return _available
        }
    }
    
    //  MARK: Connectivity
    /**
        It is true when the Microsoft Band is connected with the application, otherwise it is false.
    */
    public var connected : Bool {
        get{
            if let bandClient = _client {
                return bandClient.isDeviceConnected
            } else {
                //  device is not even available
                return false
            }
        }
    }
    
    //  MARK: Client
    private var _client : MSBClient?
    
    /**
        The MSBClient instnace from the MicrosoftBand_iOS SDK.
    */
    public var client : MSBClient? {
        get{
            return _client
        }
    }
    
    //  MARK: Delegate
    /**
        The delegate of the MSBBand instance.
    */
    public var delegate : MSBBandDelegate?
    public var tileDelegate : MSBBandTileDelegate?
    
    
    
    //  MARK:- Private Properties
    //  MARK: Sensor State
    private var sensorState : [Int : Bool] = [Int : Bool]()
    
    //  MARK: Application Installation Delegate
    private var applicationInstallationDelegate : MSBBandDelegate?
    
    //  MARK: Application Installation Shared Object
    private var applicationInstallationSharedObject : MSBApplicationInstallationSharedObject?
    
    //  MARK: Solo Queue
    private var soloQueue : NSOperationQueue {
        get{
            let soloQueue = NSOperationQueue()
            soloQueue.maxConcurrentOperationCount = 1
            return soloQueue
        }
    }
    
    
    
    //  MARK:- Public Method
    
    //  MARK: SharedDevice
    private static var _sharedDevice : MSBBand = MSBBand()
    
    /**
        Returns the singleton instance of the MSBBand class.
    */
    public static func sharedDevice() -> MSBBand {
        return _sharedDevice
    }
    
    //  MARK: Sensor Info
    /**
        Returns the availability of the Microsoft Band.
    */
    public func isSensorAvailable(type: MSBSensorType) -> Bool {
        if type.rawValue > 0 && type.rawValue <= 8 {
            return true
        } else {
            return false
        }
    }
    
    public func isSensorOn(type: MSBSensorType) -> Bool {
        if let on = sensorState[type.rawValue] {
            return on
        } else {
            return false
        }
    }

    //  MARK: Utilities
    public func connect() {
        if available {
            if connected {
                //  already connected
            } else {
                MSBClientManager.sharedManager().connectClient(_client)
                print("Connecting...")
            }
        } else {
            //  device is not even availabel
        }
    }
    
    public func disconnect() {
        if available {
            if !connected {
                //  already disconnected
            } else {
                MSBClientManager.sharedManager().cancelClientConnection(_client)
            }
        } else {
            //  device is not even availabel
        }
    }
    
    public func retrieveCapacity() {
        
        if available{       //  available
            
            if connected {  //  available and connected
                
                //  retrieve capacity
                client!.tileManager.remainingTileCapacityWithCompletionHandler { (remainCapacity, error) -> Void in
                    
                    if error == nil {   //  no error
                        
                        //  fire didRetrieveCapacity delegates
                        self.delegate?.band?(self, didRetrieveCapacity: remainCapacity)
                        self.applicationInstallationDelegate?.band?(self, didRetrieveCapacity: remainCapacity)
                        
                    } else {            //  there is error
                        
                        //  print
                        print(error)
                        
                        //  fire didRetrieveCapacity delegates
                        self.delegate?.band?(self, failedRetrieveCapacity: 0, withError: error)
                        self.applicationInstallationDelegate?.band?(self, failedRetrieveCapacity: 0, withError: error)
                    }
                }
            } else {        //  available but not connected
                
                //  fire failedRetrieveCapacity delegates
                delegate?.band?(self, failedRetrieveCapacity: 0, withError: MSBError.MSBBandIsNotConnected)
                applicationInstallationDelegate?.band?(self, failedRetrieveCapacity: 0, withError: MSBError.MSBBandIsNotConnected)
            }
            
        } else {            //  not avaiable
            
            //  fire failedRetrieveCapacity delegates
            delegate?.band?(self, failedRetrieveCapacity: 0, withError: MSBError.MSBBandIsNotAvailable)
            applicationInstallationDelegate?.band?(self, failedRetrieveCapacity: 0, withError: MSBError.MSBBandIsNotAvailable)
        }
    }
    
    public func retrieveTiles() {
        if available{       //  available
            
            if connected {  //  available and connected
                
                //  retrieve tiles
                _client!.tileManager.tilesWithCompletionHandler { (bandTiles, error) -> Void in
                    
                    if error == nil {   //  no error
                        
                        if let tiles = bandTiles as? [MSBTile] {    //  retrieved existing tiles
                            
                            //  fire didRetrieveTiles delegates with existing tiles
                            self.delegate?.band?(self, didRetrieveTiles: tiles)
                            self.applicationInstallationDelegate?.band?(self, didRetrieveTiles: tiles)
                        } else {                                    //  retrieved tiles with actual existing tiles
                            
                            //  fire didRetrieveTiles delegates with empty tiles array
                            self.delegate?.band?(self, didRetrieveTiles: [MSBTile]())
                            self.applicationInstallationDelegate?.band?(self, didRetrieveTiles: [MSBTile]())
                        }
                    } else {            //  there is error
                        
                        //  print
                        print(error)
                        
                        if let tiles = bandTiles as? [MSBTile] {    //  failed retrieve tiles (with possible empty tiles array)
                            
                            //  fire failedRetrieveTiles delegates (with possible empty tiles array)
                            self.delegate?.band?(self, failedRetrieveTiles: tiles, withError: error)
                            self.applicationInstallationDelegate?.band?(self, failedRetrieveTiles: tiles, withError: error)
                        } else {
                            
                            //  fire failedRetrieveTiles delegates with empty tiles array
                            self.delegate?.band?(self, failedRetrieveTiles: [MSBTile](), withError: error)
                            self.applicationInstallationDelegate?.band?(self, failedRetrieveTiles: [MSBTile](), withError: error)
                        }
                    }
                }
            } else {        //  not connected
                
                //  fire failedRetrieveTiles delegate
                delegate?.band?(self, failedRetrieveTiles: [MSBTile](), withError: MSBError.MSBBandIsNotConnected)
                applicationInstallationDelegate?.band?(self, failedRetrieveTiles: [MSBTile](), withError: MSBError.MSBBandIsNotConnected)
            }
            
        } else {            //  no avaiable
            
            //  fire failedRetrieveTiles delegate
            delegate?.band?(self, failedRetrieveTiles: [MSBTile](), withError: MSBError.MSBBandIsNotAvailable)
            applicationInstallationDelegate?.band?(self, failedRetrieveTiles: [MSBTile](), withError: MSBError.MSBBandIsNotAvailable)
        }
    }
    
    public func removeTile(tile : MSBTile) {
        if available{       //  available
            
            if connected {  //  available and connected
                
                //  remove tile
                client!.tileManager.removeTile(tile) { error in
                    
                    if error == nil {   //  no error
                        
                        //  fire didRemoveTile delegates
                        self.delegate?.band?(self, didRemoveTile: tile)
                        self.applicationInstallationDelegate?.band?(self, didRemoveTile: tile)
                        
                    } else {            //  there is error
                        
                        //  print
                        print(error)
                        
                        //  fire failedRemoveTile delegates
                        self.delegate?.band?(self, failedRemoveTile: tile, withError: error)
                        self.applicationInstallationDelegate?.band?(self, failedRemoveTile: tile, withError: error)
                    }
                }
            } else {        //  available but not connected
                
                //  fire failedRemoveTile delegates
                delegate?.band?(self, failedRemoveTile: tile, withError: MSBError.MSBBandIsNotConnected)
                applicationInstallationDelegate?.band?(self, failedRemoveTile: tile, withError: MSBError.MSBBandIsNotConnected)
            }
            
        } else {            //  not avaiable
            
            //  fire failedRemoveTile delegates
            delegate?.band?(self, failedRemoveTile: tile, withError: MSBError.MSBBandIsNotAvailable)
            applicationInstallationDelegate?.band?(self, failedRemoveTile: tile, withError: MSBError.MSBBandIsNotAvailable)
        }
    }
    
    public func addTile(tile : MSBTile) {
        if available{       //  available
            
            if connected {  //  available and connected
                
                //  add tile
                client!.tileManager.addTile(tile) { error in
                    
                    if error == nil {   //  no error
                        
                        //  fire didAddTile delegates
                        self.delegate?.band?(self, didAddTile: tile)
                        self.applicationInstallationDelegate?.band?(self, didAddTile: tile)
                        
                    } else {            //  there is error
                        
                        //  print
                        print(error)
                        
                        //  fire failedAddTile delegates
                        self.delegate?.band?(self, failedAddTile: tile, withError: error)
                        self.applicationInstallationDelegate?.band?(self, failedAddTile: tile, withError: error)
                    }
                }
            } else {        //  available but not connected
                
                //  fire failedAddTile delegates
                delegate?.band?(self, failedAddTile: tile, withError: MSBError.MSBBandIsNotConnected)
                applicationInstallationDelegate?.band?(self, failedAddTile: tile, withError: MSBError.MSBBandIsNotConnected)
            }
            
        } else {            //  not avaiable
            
            //  fire failedAddTile delegates
            delegate?.band?(self, failedAddTile: tile, withError: MSBError.MSBBandIsNotAvailable)
            applicationInstallationDelegate?.band?(self, failedAddTile: tile, withError: MSBError.MSBBandIsNotAvailable)
        }
    }
    
    public func setPagesForTile(tile : MSBTile, pages : [MSBPageData]) {
        if available{       //  available
            
            if connected {  //  available and connected
                
                //  set pages for tile
                client!.tileManager.setPages(pages, tileId: tile.tileId) { error in
                    
                    if error == nil {   //  no error
                        
                        //  fire didSetPages delegates
                        self.delegate?.band?(self, didSetPages: pages, forTile: tile)
                        self.applicationInstallationDelegate?.band?(self, didSetPages: pages, forTile: tile)
                        
                    } else {            //  there is error
                        
                        //  print
                        print(error)
                        
                        //  fire failedSetPages delegates
                        self.delegate?.band?(self, failedSetPages: pages, forTile: tile, withError: error)
                        self.applicationInstallationDelegate?.band?(self, failedSetPages: pages, forTile: tile, withError: error)
                    }
                }
            } else {        //  available but not connected
                
                //  fire failedSetPages delegates
                delegate?.band?(self, failedSetPages: pages, forTile: tile, withError: MSBError.MSBBandIsNotConnected)
                applicationInstallationDelegate?.band?(self, failedSetPages: pages, forTile: tile, withError: MSBError.MSBBandIsNotConnected)
            }
            
        } else {            //  not avaiable
            
            //  fire failedSetPages delegates
            delegate?.band?(self, failedSetPages: pages, forTile: tile, withError: MSBError.MSBBandIsNotAvailable)
            applicationInstallationDelegate?.band?(self, failedSetPages: pages, forTile: tile, withError: MSBError.MSBBandIsNotConnected)
        }
    }
    
    public func install(application application : MSBApplication) {
        //  initialize shared object
        applicationInstallationSharedObject = MSBApplicationInstallationSharedObject(application: application)
        
        //  set app installation delegate for callbacks
        applicationInstallationDelegate = self
        
        //  retrieve capacity
        retrieveCapacity()
    }
    
    public func startSensor(type: MSBSensorType) {
        if let on = sensorState[type.rawValue] {
            if on {
                //  sensor is on
            } else {
                do {
                    func handle(data : AnyObject?, error : NSError?) {
                        if error == nil {
                            self.sensorState[type.rawValue] = true
                        }
                        if let data = data {
                            self.delegate?.band?(self, didRetrieveData: data, withSensorType: type)
                        }
                    }
                    switch(type) {
                    case .Accelerometer:
                        try _client?.sensorManager.startAccelerometerUpdatesToQueue(soloQueue, withHandler: { (data, error) in
                            handle(data, error: error)
                        })
                    case .Gyroscope:
                        try _client?.sensorManager.startGyroscopeUpdatesToQueue(soloQueue, withHandler: { (data, error) in
                            handle(data, error: error)
                        })
                    case .HeartRateSensor:
                        try _client?.sensorManager.startHeartRateUpdatesToQueue(soloQueue, withHandler: { (data, error) in
                            handle(data, error: error)
                        })
                    case .SkinTemperatureSensor:
                        try _client?.sensorManager.startSkinTempUpdatesToQueue(soloQueue, withHandler: { (data, error) in
                            handle(data, error: error)
                        })
                    case .Pedometer:
                        try _client?.sensorManager.startPedometerUpdatesToQueue(soloQueue, withHandler: { (data, error) in
                            handle(data, error: error)
                        })
                    case .UVSensor:
                        try _client?.sensorManager.startUVUpdatesToQueue(soloQueue, withHandler: { (data, error) in
                            handle(data, error: error)
                        })
                    case .CaloriesSensor:
                        try _client?.sensorManager.startCaloriesUpdatesToQueue(soloQueue, withHandler: { (data, error) in
                            handle(data, error: error)
                        })
                    case .DistanceSensor:
                        try _client?.sensorManager.startDistanceUpdatesToQueue(soloQueue, withHandler: { (data, error) in
                            handle(data, error: error)
                        })
                    default:break
                    }
                    delegate?.band?(self, didStartSensorWithType: type, andInfo: nil)
                    postNotification(.didStartSensor, type: type)
                } catch let error as NSError {
                    delegate?.band?(self, failedStopSensorWithType: type, andError: error)
                    postNotification(.failedStartSensor, type: type, userInfo: ["Error" : error])
                    print(error)
                }
            }
        } else {
            //  not a valid sensor for microsoft band
        }
    }
    
    public func stopSensor(type: MSBSensorType) {
        if let on = sensorState[type.rawValue] {
            if !on {
                //  sensor is off
            } else {
                do {
                    switch(type) {
                    case .Accelerometer:
                        try _client?.sensorManager.stopAccelerometerUpdatesErrorRef()
                    case .Gyroscope:
                        try _client?.sensorManager.stopGyroscopeUpdatesErrorRef()
                    case .HeartRateSensor:
                        try _client?.sensorManager.stopHeartRateUpdatesErrorRef()
                    case .SkinTemperatureSensor:
                        try _client?.sensorManager.stopSkinTempUpdatesErrorRef()
                    case .Pedometer:
                        try _client?.sensorManager.stopPedometerUpdatesErrorRef()
                    case .UVSensor:
                        try _client?.sensorManager.stopUVUpdatesErrorRef()
                    case .CaloriesSensor:
                        try _client?.sensorManager.stopCaloriesUpdatesErrorRef()
                    case .DistanceSensor:
                        try _client?.sensorManager.stopDistanceUpdatesErrorRef()
                    default:break
                    }
                    //  sensor stopped sucessfully
                    self.sensorState[type.rawValue] = false
                    delegate?.band?(self, didStopSensorWithType: type, andInfo: nil)
                    postNotification(.didStopSensor, type: type)
                } catch let error as NSError {
                    delegate?.band?(self, failedStopSensorWithType: type, andError: error)
                    postNotification(.failedStopSensor, type: type, userInfo: ["Error" : error])
                    print(error)
                }
            }
        } else {
            //  not a valid sensor for microsoft band
        }
    }
    
    public func registerNotification(notificationType: MSBNotificationType, type: MSBSensorType, observer: AnyObject, selector: Selector) {
        NSNotificationCenter.defaultCenter().addObserver(observer, selector: selector, name: notification(notificationType, type: type).name, object: nil)
    }
    
    public func deregisterNotification(notificationType: MSBNotificationType, type: MSBSensorType, observer: AnyObject) {
        NSNotificationCenter.defaultCenter().removeObserver(observer, name: notification(notificationType, type: type).name, object: nil)
    }
    
    
    //  MARK:- Private Method
    //  MARK: Constructor
    private override init() {
        super.init()
        let clients = MSBClientManager.sharedManager().attachedClients()
        if clients.count > 0 {
            _available = true
            _client = clients[0] as? MSBClient
            MSBClientManager.sharedManager().delegate = self
        } else {
            _available = false
        }
    }
    
    //  MARK: Utilities
    private func log(string : String) {
        applicationInstallationSharedObject?.infos.append(string)
        print(string)
    }
    
    private func notification(notificationType : MSBNotificationType, type : MSBSensorType) -> NSNotification {
        return NSNotification(name: "WKNOTIFICATION_\(name)_\(notificationType.rawValue)_\(type.rawValue)", object: nil)
    }
    
    private func notification(notificationType : MSBNotificationType, type : MSBSensorType, userInfo : [NSObject : AnyObject]?) -> NSNotification {
        return NSNotification(name: "WKNOTIFICATION_\(name)_\(notificationType.rawValue)_\(type.rawValue)", object: nil, userInfo: userInfo)
    }
    
    private func postNotification(notificationType : MSBNotificationType, type : MSBSensorType) {
        NSNotificationCenter.defaultCenter().postNotification(notification(notificationType, type: type))
    }
    
    private func postNotification(notificationType : MSBNotificationType, type : MSBSensorType, userInfo : [NSObject : AnyObject]?) {
        NSNotificationCenter.defaultCenter().postNotification(notification(notificationType, type: type, userInfo: userInfo))
    }
    
    

    //  MARK:- Delegates
    //  MARK: MSBClientManagerDelegate
    public func clientManager(clientManager: MSBClientManager!, client: MSBClient!, didFailToConnectWithError error: NSError!) {
        delegate?.band?(self, failedConnectWithError: error)
        postNotification(.failedConnect, type: .None, userInfo: ["Error" : error])
        print(error)
    }
    
    public func clientManager(clientManager: MSBClientManager!, clientDidConnect client: MSBClient!) {
        _client?.tileDelegate = self
        
        delegate?.band?(self, didConnectWithInfo: nil)
        postNotification(.didConnect, type: .None)
        print("WKMicrosoftBand Log: Microsoft Band is connected")
    }
    
    public func clientManager(clientManager: MSBClientManager!, clientDidDisconnect client: MSBClient!) {
        delegate?.band?(self, didDisconnectWithInfo: nil)
        postNotification(.didDisconnect, type: .None)
        print("WKMicrosoftBand Log: Microsoft Band is disconnected")
    }
    
    //  MARK: MSBClientTileDelegate
    public func client(client: MSBClient!, buttonDidPress event: MSBTileButtonEvent!) {
        tileDelegate?.band?(self, hadButtonPressedWithEvent: event)
    }
    public func client(client: MSBClient!, tileDidClose event: MSBTileEvent!) {
        tileDelegate?.band?(self, didCloseTileWithEvent: event)
    }
    public func client(client: MSBClient!, tileDidOpen event: MSBTileEvent!) {
        tileDelegate?.band?(self, didOpenTileWithEvent: event)
    }
    
    //  MARK: Application Installation Delegate
    public func band(band: MSBBand, didRetrieveCapacity capacity: UInt) {
        
        //  retrieved capacity
        //  update shared object
        applicationInstallationSharedObject?.remainCapacity = capacity
        log("band got capacity: \(capacity)")
        
        //  start retrieving tiles
        retrieveTiles()
    }
    
    public func band(band: MSBBand, failedRetrieveCapacity capacity: UInt, withError error: NSError) {
        
        //  failed retrieved capacity
        //  shared object append error
        applicationInstallationSharedObject?.remainCapacity = capacity
        log("band failed to get capacity: \(capacity)")
        applicationInstallationSharedObject?.errors.append(error)
        
        //  fire failedInstalApplication delegate
        delegate?.band?(self, failedInstalApplicationWithSharedObject: applicationInstallationSharedObject)
    }
    
    public func band(band: MSBBand, didRetrieveTiles tiles: [MSBTile]) {
        
        //  retrieved tiles
        //  update shared object
        applicationInstallationSharedObject?.existingTiles = tiles
        log("band got existing tiles")
        
        //  check new app
        if let application = applicationInstallationSharedObject?.application {    //  app is init normally
            
            //  try get old tile with same id
            self.applicationInstallationSharedObject?.oldTile = tiles.getTile(application.id)
            if let oldTile = applicationInstallationSharedObject?.oldTile {    //  there is old tile

                //  need to remove
                self.log("band got oldTile: \(oldTile)")
                removeTile(oldTile)
                
            } else {                                                                //  no old tile
                
                //  update shared object
                self.log("band has no oldTile")
                
                //  check capacity
                if applicationInstallationSharedObject?.remainCapacity > 0 {   //  there is slot to add new app
                    
                    //  add new tile directly
                    log("band has slot for new app")
                    addTile(application.tile)
                } else {                                                            //  there is no slot to add new app
                    
                    //  update shared object
                    log("band has no slot for new app")
                    applicationInstallationSharedObject?.errors.append(MSBError.MSBBandCapacityIsFull)
                    
                    //  fire failedInstalApplication delegate
                    delegate?.band?(self, failedInstalApplicationWithSharedObject: applicationInstallationSharedObject)
                }
            }
        } else {                                                                    //  app init incorrectly
            //  check new app failed
            //  shared object append error
            log("app init incorrectly")
            applicationInstallationSharedObject?.errors.append(MSBError.MSBApplicationInstallationSharedObjectIsNotInitializedCorrectly)
            
            //  fire failedInstalApplication delegate
            delegate?.band?(self, failedInstalApplicationWithSharedObject: applicationInstallationSharedObject)
        }
    }

    public func band(band: MSBBand, failedRetrieveTiles tiles: [MSBTile], withError error: NSError) {
        //  failed retrieved tiles
        //  shared object append error
        applicationInstallationSharedObject?.existingTiles = tiles
        log("band failed to get existing tiles: \(tiles)")
        applicationInstallationSharedObject?.errors.append(error)
        
        //  fire failedInstalApplication delegate
        delegate?.band?(self, failedInstalApplicationWithSharedObject: applicationInstallationSharedObject)
    }
    
    public func band(band: MSBBand, didRemoveTile tile: MSBTile) {

        //  removed oldTile
        //  update shared object
        log("band removed oldTile: \(tile)")
        
        //  check new app
        if let application = applicationInstallationSharedObject?.application {    //  app is init normally
            
            //  add tile
            addTile(application.tile)
        } else {                                                                   //  app init incorrectly
            
            //  check new app failed
            //  shared object append error
            log("app init incorrectly")
            applicationInstallationSharedObject?.errors.append(MSBError.MSBApplicationInstallationSharedObjectIsNotInitializedCorrectly)
            
            //  fire failedInstalApplication delegate
            delegate?.band?(self, failedInstalApplicationWithSharedObject: applicationInstallationSharedObject)
        }
    }
    
    public func band(band: MSBBand, failedRemoveTile tile: MSBTile, withError error: NSError) {
        //  failed remove tiles
        //  shared object append error
        log("band failed to remove tile: \(tile)")
        applicationInstallationSharedObject?.errors.append(error)
        
        //  fire failedInstalApplication delegate
        delegate?.band?(self, failedInstalApplicationWithSharedObject: applicationInstallationSharedObject)
    }
    
    public func band(band: MSBBand, didAddTile tile: MSBTile) {
        
        //  added tile
        //  update shared object
        log("band added tile: \(tile)")
        
        //  check new app
        if let application = applicationInstallationSharedObject?.application {    //  app is init normally
            
            //  set pages for tile
            setPagesForTile(application.tile, pages: application.pages)
        } else {                                                                   //  app init incorrectly
            
            //  check new app failed
            //  shared object append error
            log("app init incorrectly")
            applicationInstallationSharedObject?.errors.append(MSBError.MSBApplicationInstallationSharedObjectIsNotInitializedCorrectly)
            
            //  fire failedInstalApplication delegate
            delegate?.band?(self, failedInstalApplicationWithSharedObject: applicationInstallationSharedObject)
        }
    }
    
    public func band(band: MSBBand, failedAddTile tile: MSBTile, withError error: NSError) {
        //  failed add tile
        //  shared object append error
        log("band failed to add tile: \(tile)")
        applicationInstallationSharedObject?.errors.append(error)
        
        //  fire failedInstalApplication delegate
        delegate?.band?(self, failedInstalApplicationWithSharedObject: applicationInstallationSharedObject)
    }
    
    public func band(band: MSBBand, didSetPages pages: [MSBPageData], forTile tile: MSBTile) {
        
        //  did set pages for tile
        //  update shared object
        log("band set pages: \(pages) for tile: \(tile)")

        //  check new app
        if let application = applicationInstallationSharedObject?.application {    //  app is init normally
            
            //  file didInstalApplication delegate
            delegate?.band?(self, didInstalApplication: application)
        } else {                                                                   //  app init incorrectly
            
            //  check new app failed
            //  shared object append error
            log("app init incorrectly")
            applicationInstallationSharedObject?.errors.append(MSBError.MSBApplicationInstallationSharedObjectIsNotInitializedCorrectly)
            
            //  fire failedInstalApplication delegate
            delegate?.band?(self, failedInstalApplicationWithSharedObject: applicationInstallationSharedObject)
        }
    }
    
    public func band(band: MSBBand, failedSetPages pages: [MSBPageData], forTile tile: MSBTile, withError error: NSError) {
        //  failed set pages for tile
        //  shared object append error
        log("band failed to set pages: \(pages) for tile: \(tile)")
        applicationInstallationSharedObject?.errors.append(error)
        
        //  fire failedInstalApplication delegate
        delegate?.band?(self, failedInstalApplicationWithSharedObject: applicationInstallationSharedObject)
    }
}












