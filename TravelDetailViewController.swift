//
//  TravelDetailViewController.swift
//  TravelApp
//
//  Created by internet on 19/5/15.
//  Copyright (c) 2015 dmancilla. All rights reserved.
//

import UIKit
import CoreData

class TravelDetailViewController: UIViewController {

    // MARK: - Propiedades
    @IBOutlet weak var nameEditable: UITextField!
    @IBOutlet weak var descrEditable: UITextField!
    @IBOutlet weak var destinyEditable: UITextField!
    @IBOutlet weak var activitiesButton: UIButton!
    
    
    // MARK: - VARIABLES DE TIPO STRINGS
    var name : String? = ""
    var descr : String? = ""
    var destiny : String? = ""

    
    //Variable que comprueba si existe una persona
    var travelDetail : Travel!
    var existeTravel : NSManagedObject!
    
    // MARK: - Funciones Propias
    @IBAction func cancelTravel(sender: AnyObject) {
        navigationController?.popToRootViewControllerAnimated(true)
    }
    
    @IBAction func saveTravel(sender: AnyObject) {
        //1. CREAR UNA INSTANCIA A LA CLASE APPDELEGATE PARA GESTIONAR CORE DATA
        let miDelegate: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        
        //2. CREAR UNA INSTANCIA AL OBJETO MANAGED OBJECT CONTECT
        let managedObjectContexto : NSManagedObjectContext = miDelegate.managedObjectContext!
        
        //3. CREAR UNA INSTANCIA A LA ENTITY DE CORE DATA
        let entityDescription = NSEntityDescription.entityForName("Travel", inManagedObjectContext: managedObjectContexto)
        
        //4. MEDIANTE UN CONDICIONAL COMPROBAMOS SI EL REGISTRO QUE QUEREMOS EXISTE
        //DE FROMA QUE SI NO ES NULO, ES DECIR QUE EXISTE, SE GUARDAN LOS MISMOS DATOS CON LA MODIFICACION QUE HAGAMOS
        if(existeTravel != nil){
            
            existeTravel.setValue(nameEditable.text as String, forKey: "name")
            
            existeTravel.setValue(descrEditable.text as String, forKey: "descr")
            
            existeTravel.setValue(destinyEditable.text as String, forKey: "destiny")
            
            
        }else{
            //5. MAPEAMOS LAS PROPIEDADES DE STRING CON LOS TEXTFIELD
            
            //CREAR UNA INSTANCIA DE LA CLASE PERSONA Y ASIGNAMOS UNA ENTIDAD Y UN CONTEXTO DE OBJETO GESTIONADO
            
            var newTravel: Travel = NSEntityDescription.insertNewObjectForEntityForName("Travel", inManagedObjectContext: managedObjectContexto) as Travel
            
            newTravel.name = nameEditable.text
            
            newTravel.descr = descrEditable.text
            
            newTravel.destiny = destinyEditable.text
            
        }
        
        
        //5. GUARDAR VALORES
        
        managedObjectContexto.save(nil)
        
        //6. A TRAVEZ DEL NAVIGATION CONTROLLER VOLVER A LA VISTA PRINCIPAL
        
        navigationController?.popToRootViewControllerAnimated(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.hidesBarsOnTap = false    //!!Added Optional Chaining
        
        activitiesButton.enabled = false
        
        if existeTravel != nil {
            nameEditable.text = travelDetail.name
            descrEditable.text = travelDetail.descr
            destinyEditable.text = travelDetail.destiny
            activitiesButton.enabled = true
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
        
        //PONER UN CONDICIONAL PARA VER SI EL IDENTIFICADOR ES EL MISMO
        if (segue.identifier? == "EditActivities") {
            
            //CREO UN OBJETO DE LA CLASE NSMANAGEDOBJECT Y LE PASO MI ARRAY FILA SELECCIONADA
            var selectItem: NSManagedObject = existeTravel
            
            println("Linea 0")
            
            //PRESENTAR LA VISTA DETALLE
            let vistaDetalle: ActivitiesTableViewController = segue.destinationViewController as ActivitiesTableViewController
            
            //PASAR A LA PROPIEDAD DE TIPO STRING DE MI VISTA DETALLE, EL VALOR SELECCIONADO EN LA PROPIEDAD SELECTITEM
            println("Linea 1")
            
            //PASARLE EL OBJETO TRAVEL
            vistaDetalle.travelObj = existeTravel as Travel
            
            println("Linea 2")
            
            //PASAR TODO EL OBJETO PERSONA
            vistaDetalle.existeTravel = selectItem
            
        }

    }
    
}
