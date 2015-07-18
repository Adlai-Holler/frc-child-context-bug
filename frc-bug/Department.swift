//
//  Department.swift
//  frc-bug
//
//  Created by Adlai Holler on 7/18/15.
//  Copyright (c) 2015 tripstr. All rights reserved.
//

import Foundation
import CoreData


public class Department: NSManagedObject {

    @NSManaged public var name: String
    @NSManaged public var employees: NSSet

}
