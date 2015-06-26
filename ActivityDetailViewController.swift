//
//  ActivityDetailViewController.swift
//  TravelApp
//
//  Created by internet on 19/5/15.
//  Copyright (c) 2015 dmancilla. All rights reserved.
//

import UIKit
import CoreData


class ActivityDetailViewController: UIViewController {

    // MARK: - Propiedades
    @IBOutlet weak var nameEditable: UITextField!
    @IBOutlet weak var numTicketEditable: UITextField!
    @IBOutlet weak var qtyTicketEditable: UITextField!
    @IBOutlet weak var dateInitialEditable: UIDatePicker!
    @IBOutlet weak var dateFinishEditable: UIDatePicker!
    @IBOutlet weak var picturesButton: UIButton!
    
    var travelDetail : Travel!
    var activity : Activity!
    
    // MARK: - VARIABLES DE TIPO STRINGS
    var dateFinish: NSDate = NSDate()
    var dateInit: NSDate = NSDate()
    var latitude: String = ""
    var longitude: String = ""
    var name: String = ""
    var numTicket: NSNumber = 0
    var qtyTicket: NSNumber = 0
    var picture: NSData = NSData()
        
    
    //Variable que comprueba si existe una persona
    var existeActivity: NSManagedObject!
    
    @IBAction func saveActivity(sender: AnyObject) {
        
        //1. CREAR UNA INSTANCIA A LA CLASE APPDELEGATE PARA GESTIONAR CORE DATA
        let miDelegate: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        
        //2. CREAR UNA INSTANCIA AL OBJETO MANAGED OBJECT CONTECT
        let managedObjectContexto : NSManagedObjectContext = miDelegate.managedObjectContext!
        
        //3. CREAR UNA INSTANCIA A LA ENTITY DE CORE DATA
        let entityDescription = NSEntityDescription.entityForName("Activity", inManagedObjectContext: managedObjectContexto)
        
        //5. MAPEAMOS LAS PROPIEDADES DE STRING CON LOS TEXTFIELD
        
        if(existeActivity != nil){
            
            existeActivity.setValue(nameEditable.text as String, forKey: "name")
            
            if numTicketEditable.text != ""{
                existeActivity.setValue(NSNumber(integer: numTicketEditable.text.toInt()!) as NSNumber, forKey: "numTicket")
            }
            else{
                existeActivity.setValue(NSNumber(integer:0) as NSNumber, forKey: "numTicket")
            }
            
            if qtyTicketEditable.text != ""{
                existeActivity.setValue(NSNumber(integer: qtyTicketEditable.text.toInt()!) as NSNumber, forKey: "qtyTicket")
            }
            else{
                existeActivity.setValue(NSNumber(integer:0) as NSNumber, forKey: "qtyTicket")
            }
            
            existeActivity.setValue(dateInitialEditable.date as NSDate, forKey: "dateInit")
            
            existeActivity.setValue(dateFinishEditable.date as NSDate, forKey: "dateFinish")
            
            existeActivity.setValue("17.383370" as String, forKey: "latitude")
            
            existeActivity.setValue("-66.209280" as String, forKey: "longitude")
            
        }else{
            //5. MAPEAMOS LAS PROPIEDADES DE STRING CON LOS TEXTFIELD
            
            //CREAR UNA INSTANCIA DE LA CLASE PERSONA Y ASIGNAMOS UNA ENTIDAD Y UN CONTEXTO DE OBJETO GESTIONADO
            
            var newActivity: Activity = NSEntityDescription.insertNewObjectForEntityForName("Activity", inManagedObjectContext: managedObjectContexto) as Activity
            
            newActivity.name = nameEditable.text!
            
            if numTicketEditable.text != ""{
                newActivity.numTicket = NSNumber(integer: numTicketEditable.text.toInt()!)
            }
            
            if numTicketEditable.text != ""{
                newActivity.qtyTicket = NSNumber(integer: qtyTicketEditable.text.toInt()!)
            }
            
            newActivity.dateInit = dateInitialEditable.date
            
            newActivity.dateFinish = dateFinishEditable.date
            
            newActivity.latitude = "17.383370"
            
            newActivity.longitude = "-66.209280"
            
            newActivity.travel = travelDetail
            
            travelDetail.addActivitiesObject(newActivity)
            
        }
        
        
        
        //6. GUARDAR VALORES
        
        managedObjectContexto.save(nil)
        
        //7. A TRAVEZ DEL NAVIGATION CONTROLLER VOLVER A LA VISTA PRINCIPAL
        
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
    @IBAction func cancelActivity(sender: AnyObject) {
        
        println("Rollback")
        //CREAR UNA INSTANCIA A MI CLASE APPDELEGATE
        let appdel: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        
        //CREAR UNA INSTANCIA AL OBJETO DE LA CLASE NSMANAGEDOBJECTCONTEXT
        
        let managedObjectContexto : NSManagedObjectContext = appdel.managedObjectContext!
        
        //SI EL CASO SUCEDE CUANDO SE QUIERE ELIMINAR UNA FILA DE LA TABLA
        
        managedObjectContexto.rollback()

        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        picturesButton.enabled = false
        // Do any additional setup after loading the view.
        self.navigationController?.hidesBarsOnTap = false    //!!Added Optional Chaining
        
        println("ViewDidLoad")
        
        if existeActivity != nil {
            
            println("Exist Activity")
            
            nameEditable.text = existeActivity.valueForKey("name") as? String
            
            numTicketEditable.text = (existeActivity.valueForKey("numTicket") as NSNumber!).stringValue
            
            qtyTicketEditable.text = (existeActivity.valueForKey("qtyTicket") as NSNumber!).stringValue
            
            dateFinishEditable.date = existeActivity.valueForKey("dateFinish") as NSDate!
            
            dateInitialEditable.date = existeActivity.valueForKey("dateInit") as NSDate!
            
            picturesButton.enabled = true
            
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        
        println("ViewWillAppear")
        
        self.navigationController?.hidesBarsOnTap = false    //!!Added Optional Chaining
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "viewPhotoTicket"){
            
            //PRESENTAR LA VISTA DETALLE
            let controller: ViewPhotoCoreData = segue.destinationViewController as ViewPhotoCoreData
            
            //PASAR A LA PROPIEDAD DE TIPO STRING DE MI VISTA DETALLE, EL VALOR SELECCIONADO EN LA PROPIEDAD SELECTITEM
            
            //PASARLE EL OBJETO TRAVEL
            println("Antes de lanzar")
            
            controller.travelPhoto = travelDetail
            controller.activityPhoto = activity
            println("Despues de lanzar")
            
        }

    }



}
