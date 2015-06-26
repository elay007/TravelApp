//
//  ActivitiesTableViewController.swift
//  TravelApp
//
//  Created by internet on 19/5/15.
//  Copyright (c) 2015 dmancilla. All rights reserved.
//

import UIKit
import CoreData

class ActivitiesTableViewController: UITableViewController {

    var datosDeActivities : Array<AnyObject> = []
    var travelObj : Travel!
    //Variable que comprueba si existe una persona
    var existeTravel : NSManagedObject!
    
    //Esta funcion devuelve el resultado de la relacion uno a uno
    //Crear relacion uno a muchos
    func allCategoriesFetchRequest(oTravel: Travel) -> NSFetchRequest {
        
        var fetchRequest = NSFetchRequest(entityName: "Activity")
        
        
        let predicate = NSPredicate(format: "travel == %@", oTravel)
        
        //fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.predicate = predicate
        
        return fetchRequest
    }
    
    //PRESENTARA DATOS EN MI VISTA DE TABLA
    override func viewDidAppear(animated: Bool){
        super.viewDidAppear(true)
        
        //DECLARAR UNA CONTANTE DE MI CLASE APPDELEATE
        
        let appdel: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        
        //DECLARAR UNA CONSTANTE DE MI MANAGED OBJECT CONTEXT
        
        let managedObjectContexto : NSManagedObjectContext = appdel.managedObjectContext!
        
        //DECLARAR UNA CONSTANTE DE LA CLASE NSFETCHREQUEST, DE CONSULTA DE DATOS
        
        let fetchActivities: NSFetchRequest = self.allCategoriesFetchRequest(travelObj)
                
        //CARGAR EN MI ARRAY Y HACER LA CONSULTA
        
        datosDeActivities = managedObjectContexto.executeFetchRequest(fetchActivities, error: nil)!
        
        //RECARGAR MI TABLA
        
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.hidesBarsOnTap = false    //!!Added Optional Chaining

    }
    
    override func viewWillAppear(animated: Bool) {
        
        println("ViewWillAppear")
        
        self.navigationController?.hidesBarsOnTap = false    //!!Added Optional Chaining
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return datosDeActivities.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //IDENTIFICADOR DE LA CELDA
        let CellID: NSString = "CellActivity"
        
        //CREADA LA CELDA Y PASADO EL IDENTIFICADOR
        var cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(CellID) as UITableViewCell!
        
        
        //CREADO EL OBJETO DE LA CLASE NSMANAGEDOBJECT
        var datos: NSManagedObject = datosDeActivities[indexPath.row] as NSManagedObject
        
        //STRING QUE ALMACENA LA DESCRIPCION DE LA ACTIVITY
        var name = datos.valueForKeyPath("name") as String
        
        //STRING QUE ALMACENA EL NUMERO DE TICKET
        var numTick = (datos.valueForKeyPath("numTicket") as NSNumber!).stringValue
        
        //STRING QUE ALMACENA LA CANTIDAD DEL TICKET
        var qtyTick = (datos.valueForKeyPath("qtyTicket") as NSNumber!).stringValue
        
        //PRESENTAR O MOSTRAR EN CADA CELDA, EL NOMBRE Y LOS APELLIDOS DE CADA CONTACTO
        cell.textLabel?.text = name
        
        cell.detailTextLabel?.text = "Ticket: \(numTick) , Qty: \(qtyTick)"
        
        
        return cell
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    
    //PERMITE ELIMINAR REGISTROS DE MI TABLA, ACTUALIZANDO MI MODELO DE DATOS
    // Override to support editing the table view.
    override func tableView(tableView: UITableView?, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        //CREAR UNA INSTANCIA A MI CLASE APPDELEGATE
        let appdel: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        
        //CREAR UNA INSTANCIA AL OBJETO DE LA CLASE NSMANAGEDOBJECTCONTEXT
        
        let managedObjectContexto : NSManagedObjectContext = appdel.managedObjectContext!
        
        //SI EL CASO SUCEDE CUANDO SE QUIERE ELIMINAR UNA FILA DE LA TABLA
        if editingStyle == UITableViewCellEditingStyle.Delete {
            
            if let tableV = tableView {
                
                managedObjectContexto.deleteObject(datosDeActivities[indexPath.row] as NSManagedObject)
                
                datosDeActivities.removeAtIndex(indexPath.row)
                
                tableV.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
            }
            var error: NSError? = nil
            
            if !managedObjectContexto.save(&error){
                
                abort()
                
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        //PONER UN CONDICIONAL PARA VER SI EL IDENTIFICADOR ES EL MISMO
        
        if (segue.identifier? == "EditDetailActivities") {
            
            //CREO UNA VARIABLE QUE ALMACENA EL INDICE DE MI TABLA
            var indexPath: NSIndexPath = self.tableView.indexPathForSelectedRow()!
            
            //CREO UN OBJETO DE LA CLASE NSMANAGEDOBJECT Y LE PASO MI ARRAY FILA SELECCIONADA
            var selectItem: NSManagedObject = datosDeActivities[indexPath.row] as NSManagedObject
            
            //PRESENTAR LA VISTA DETALLE
            let vistaDetalle: ActivityDetailViewController = segue.destinationViewController as ActivityDetailViewController
            
            //PASAR A LA PROPIEDAD DE TIPO STRING DE MI VISTA DETALLE, EL VALOR SELECCIONADO EN LA PROPIEDAD SELECTITEM
            
            //PASARLE EL OBJETO TRAVEL
            vistaDetalle.travelDetail = travelObj
            vistaDetalle.activity = datosDeActivities[indexPath.row] as Activity
            
            
            //PASAR TODO EL OBJETO
            vistaDetalle.existeActivity = selectItem
            
        }
        
        if (segue.identifier? == "NewActivity") {
            
            //PRESENTAR LA VISTA DETALLE
            let vistaDetalle: ActivityDetailViewController = segue.destinationViewController as ActivityDetailViewController
            
            //PASAR A LA PROPIEDAD DE TIPO STRING DE MI VISTA DETALLE, EL VALOR SELECCIONADO EN LA PROPIEDAD SELECTITEM
            
            //PASARLE EL OBJETO TRAVEL
            vistaDetalle.travelDetail = travelObj
                        
        }
        
        
        
    }

}
