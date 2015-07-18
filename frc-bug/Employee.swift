//
//  Employee.swift
//  frc-bug
//
//  Created by Adlai Holler on 7/18/15.
//  Copyright (c) 2015 tripstr. All rights reserved.
//

import Foundation
import CoreData

public class Employee: NSManagedObject {

    @NSManaged public var name: String
    @NSManaged public var department: Department

}
