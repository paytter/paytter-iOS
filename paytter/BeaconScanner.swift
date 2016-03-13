//
//  BeaconScanner.swift
//  paytter
//
//  Created by Kengo Yokoyama on 2016/03/12.
//  Copyright © 2016年 ITF. All rights reserved.
//

import UIKit
import CoreLocation

class BeaconScanner: NSObject {

    static let sharedManager = BeaconScanner()
    
    private let proximityUUID = NSUUID(UUIDString: "7A1FD3D3-457D-4A10-3DF9-DF5D309BD3DD")
    private let manager = CLLocationManager()
    
    private var rssi = ""
    private var distance = ""
    private var region  = CLBeaconRegion()
    var delegate: BeaconScannerDelegate?
    
    override init() {
        super.init()
        
        region = CLBeaconRegion(proximityUUID:proximityUUID!, identifier: "EstimoteRegion")
        manager.delegate = self
        
        switch CLLocationManager.authorizationStatus() {
        case .Authorized, .AuthorizedWhenInUse:
            manager.startRangingBeaconsInRegion(region)
            print("Authorized")
        case .NotDetermined:
            if #available(iOS 9.0, *) {
                manager.allowsBackgroundLocationUpdates = true
            }
            manager.requestAlwaysAuthorization()
            print("NotDetermined")
        case .Restricted, .Denied:
            print("Restricted")
        }
    }
}

extension BeaconScanner: CLLocationManagerDelegate {
    func locationManager(manager: CLLocationManager, didStartMonitoringForRegion region: CLRegion) {
        manager.requestStateForRegion(region)
    }
    
    func locationManager(manager: CLLocationManager, didDetermineState state: CLRegionState, forRegion inRegion: CLRegion) {
        if state == .Inside {
            manager.startRangingBeaconsInRegion(region)
        }
    }
    
    func locationManager(manager: CLLocationManager, monitoringDidFailForRegion region: CLRegion?, withError error: NSError) {
        print("monitoringDidFailForRegion \(error)")
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("didFailWithError \(error)")
    }
    
    func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion) {
        manager.startRangingBeaconsInRegion(region as! CLBeaconRegion)
    }
    
    func locationManager(manager: CLLocationManager, didExitRegion region: CLRegion) {
        manager.stopRangingBeaconsInRegion(region as! CLBeaconRegion)
        reset()
    }
    
    func locationManager(manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], inRegion region: CLBeaconRegion) {
        if beacons.count == 0 {
            return
        }
        
        let beacon = beacons[0]
        
        switch beacon.proximity {
        case .Unknown:
            distance = "Unknown Proximity"
            reset()
            return
        case .Immediate:
            distance = "Immediate"
        case .Near:
            distance = "Near"
        case .Far:
            distance = "Far"
        }
        rssi = beacon.rssi.description
        
        print(rssi, distance)
        delegate?.didRangeBeacon(rssi: rssi, distance: distance)
    }
    
    func reset() {
        rssi = "none"
    }
}

protocol BeaconScannerDelegate {
    func didRangeBeacon(rssi rssi: String, distance:String)
}