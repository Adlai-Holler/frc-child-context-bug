
import UIKit
import XCTest
import CoreData
import frc_bug

/**
 Comment out the MARKed line below to see it pass if the child context isn't saved
*/

var insertedTestData = false

let rootCtx = CoreDataStack.shared.managedObjectContext!
let childCtx: NSManagedObjectContext = {
	let ctx = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
	ctx.parentContext = rootCtx
	return ctx
}()
var fatCats: Department!
var grunts: Department!

var bill: Employee!
var bob: Employee!
var jim: Employee!

class frc_bugTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
		if !insertedTestData {
			insertedTestData = true
			
			fatCats = NSEntityDescription.insertNewObjectForEntityForName("Department", inManagedObjectContext: childCtx) as! Department
			fatCats.name = "Fat Cats"
			
			grunts = NSEntityDescription.insertNewObjectForEntityForName("Department", inManagedObjectContext: childCtx) as! Department
			grunts.name = "Grunts"
			
			bill = NSEntityDescription.insertNewObjectForEntityForName("Employee", inManagedObjectContext: childCtx) as! Employee
			bill.name = "Bill"
			
			bob = NSEntityDescription.insertNewObjectForEntityForName("Employee", inManagedObjectContext: childCtx) as! Employee
			bob.name = "Bob"
			
			jim = NSEntityDescription.insertNewObjectForEntityForName("Employee", inManagedObjectContext: childCtx) as! Employee
			jim.name = "Jim"
			
			bill.department = fatCats
			bob.department = fatCats
			jim.department = grunts
			var error: NSError?
			// MARK: Comment to fix
			var err: NSError?
			assert(childCtx.save(&error))
		}
    }
	
	func testThatTestDataExists() {
		let sortByName = [ NSSortDescriptor(key: "name", ascending: true)]
		let reqEmployees = NSFetchRequest(entityName: "Employee")
		reqEmployees.sortDescriptors = sortByName
		let employees = childCtx.executeFetchRequest(reqEmployees, error: nil) as! [Employee]
		let employeeNames = employees.map { $0.name }
		
		
		XCTAssertEqual(employeeNames, ["Bill", "Bob", "Jim"], "Didn't find employees")
		
		let reqDepartments = NSFetchRequest(entityName: "Department")
		reqDepartments.sortDescriptors = sortByName
		let departments = childCtx.executeFetchRequest(reqDepartments, error: nil) as! [Department]
		let deptNames = departments.map { $0.name }
		XCTAssertEqual(deptNames, ["Fat Cats", "Grunts"], "Didn't find departments")
	}

	func testThatFRCGivesRightSections() {
		let groupedReq = NSFetchRequest(entityName: "Employee")
		groupedReq.sortDescriptors = [
			NSSortDescriptor(key: "department.name", ascending: true),
			NSSortDescriptor(key: "name", ascending: true)
		]
		let frc = NSFetchedResultsController(fetchRequest: groupedReq, managedObjectContext: childCtx, sectionNameKeyPath: "department.name", cacheName: nil)
		var err: NSError?
		XCTAssert(frc.performFetch(&err), "fetch failed with error: \(err)")
		XCTAssertNil(err)
		let expectedResults: [Employee] = [bill, bob, jim]
		let objects = frc.fetchedObjects! as! [Employee]
		XCTAssertEqual(objects, expectedResults)
		
		let sections = frc.sections! as! [NSFetchedResultsSectionInfo]
		
		let expectedSectionNames = ["Fat Cats", "Grunts"]
		XCTAssertEqual(sections.map({ $0.name! }), expectedSectionNames, "")
	}
}
