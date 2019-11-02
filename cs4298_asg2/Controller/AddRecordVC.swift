//
//  AddRecordVC.swift
//  cs4298_asg2
//
//  Created by YU Ka Kit on 1/11/2019.
//  Copyright © 2019 YU Ka Kit. All rights reserved.
//

import UIKit
import CoreData

class AddRecordVC: UIViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var valueTextField: UITextField!
    @IBOutlet weak var remarkTextField: UITextField!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    //
    var imagePicker: ImagePicker!
    @IBOutlet weak var imagePickerButton: UIButton!
    @IBAction func imagePickerButtonTouched(_ sender: UIButton) {
        //extended to ImagePickerDelegate
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        self.imagePicker.present(from: sender)
    }
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var retrieveButto: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
    }
    
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createData(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let recordEntity = NSEntityDescription.entity(forEntityName: "Record", in: managedContext)
    
        let record = NSManagedObject(entity: recordEntity!, insertInto: managedContext)
        /*
        record.setValue("Food", forKeyPath: "type")
        record.setValue("Food", forKeyPath: "date")
        record.setValue("Food", forKeyPath: "remark")
        record.setValue("Food", forKeyPath: "photo")
        record.setValue("Food", forKeyPath: "value")
        */
        record.setValue("Food", forKeyPath: "type")
        record.setValue(datePicker.date, forKeyPath: "date")
        record.setValue(remarkTextField.text, forKeyPath: "remark")
        record.setValue(imageView.image?.pngData(), forKeyPath: "photo")
        record.setValue((Double)(valueTextField.text!), forKeyPath: "value")

        //that's the way you tran from NSDATA to image
         /*
           let binaryImage = imageView.image?.pngData()
           testImageView.image = UIImage(data: <#T##Data#>)
         */
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
        let controller = UIAlertController(title: "Success!", message: "New record has been added.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        controller.addAction(okAction)
        present(controller, animated: true, completion: nil)
    }
    
    //from github
    //https://github.com/AnkurVekariya/CoreDataSwiftDemo/blob/master/CoreDataCRUD/ViewController.swift
    func retrieveData() {
        
        //As we know that container is set up in the AppDelegates so we need to refer that container.
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        //We need to create a context from this container
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //Prepare the request of type NSFetchRequest  for the entity
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Record")
        
        //        fetchRequest.fetchLimit = 1
        //        fetchRequest.predicate = NSPredicate(format: "username = %@", "Ankur")
        //        fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "email", ascending: false)]
        //
        do {
            let result = try managedContext.fetch(fetchRequest)
            for data in result as! [NSManagedObject] {
                print(data.value(forKey: "type") as! String)
                print(data.value(forKey: "date") as! Date)
                print(data.value(forKey: "remark") as! String)
                //get Binaryform of an image
                print(data.value(forKey: "photo") as! NSData)
                print(data.value(forKey: "value") as! Double)
            }
            
        } catch {
            
            print("Failed")
        }
    }
    
    /*func updateData(){
        
        //As we know that container is set up in the AppDelegates so we need to refer that container.
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        //We need to create a context from this container
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Record")
        fetchRequest.predicate = NSPredicate(format: "username = %@", "Ankur1")
        do
        {
            let test = try managedContext.fetch(fetchRequest)
            
            let objectUpdate = test[0] as! NSManagedObject
            objectUpdate.setValue("newName", forKey: "username")
            objectUpdate.setValue("newmail", forKey: "email")
            objectUpdate.setValue("newpassword", forKey: "password")
            do{
                try managedContext.save()
            }
            catch
            {
                print(error)
            }
        }
        catch
        {
            print(error)
        }
    }*/
    
    func deleteData(){
        
        //As we know that container is set up in the AppDelegates so we need to refer that container.
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        //We need to create a context from this container
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Record")
        fetchRequest.predicate = NSPredicate(format: "username = %@", "Ankur3")
        
        do
        {
            let test = try managedContext.fetch(fetchRequest)
            
            let objectToDelete = test[0] as! NSManagedObject
            managedContext.delete(objectToDelete)
            
            do{
                try managedContext.save()
            }
            catch
            {
                print(error)
            }
            
        }
        catch
        {
            print(error)
        }
    }
    
    func deleteAllData(entity: String)
    {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Record")
        
        do
        {
            let results = try managedContext.fetch(fetchRequest)
            
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                managedContext.delete(managedObjectData)
            }
        } catch let error as NSError {
            print("Detele all data in \(entity) error : \(error) \(error.userInfo)")
        }
    }
    
    
    
    // 3 action
    @IBAction func addRecord(_ sender: Any) {
        createData()
    }
    
        
    @IBAction func retrieveRecord(_ sender: Any) {
        retrieveData()
    }
    
    /*@IBAction func deleteRecord(_ sender: Any) {
        deleteAllData(entity: "Record")
    }*/
    
    @IBAction func debuggerVariable(_ sender: Any) {
        print("imageView.image:  \(imageView.image)")
        print("imageView.image?.pngData(): \(imageView.image?.pngData())")
        print("datePicker.date:  \(datePicker.date)")
        print("remarkTextField.text:  \(remarkTextField.text)")
        print("(Double)(valueTextField.text!):  \((Double)(valueTextField.text!))")
    }
    
}

//make the view contoller also a imagePicker
extension AddRecordVC: ImagePickerDelegate {
    
    func didSelect(image: UIImage?) {
        guard let image = image else {
            return
        }
        self.imageView.image = image
    }
}
