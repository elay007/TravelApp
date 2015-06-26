//
//  TravelsTableViewController.swift
//  TravelApp
//
//  Created by internet on 19/5/15.
//  Copyright (c) 2015 dmancilla. All rights reserved.
//

import UIKit
import CoreData

class TravelsTableViewController: UITableViewController {
    
    var datosDeConsulta : Array<AnyObject> = []
    
    //PRESENTARA DATOS EN MI VISTA DE TABLA
    override func viewDidAppear(animated: Bool){
        super.viewDidAppear(true)
        
        //DECLARAR UNA CONTANTE DE MI CLASE APPDELEATE
        
        let appdel: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        
        //DECLARAR UNA CONSTANTE DE MI MANAGED OBJECT CONTEXT
        
        let managedObjectContexto : NSManagedObjectContext = appdel.managedObjectContext!
        
        //DECLARAR UNA CONSTANTE DE LA CLASE NSFETCHREQUEST, DE CONSULTA DE DATOS
        
        let frequest = NSFetchRequest (entityName : "Travel")
        
        //CARGAR EN MI ARRAY Y HACER LA CONSULTA
        
        datosDeConsulta = managedObjectContexto.executeFetchRequest(frequest, error: nil)!
        
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
        return datosDeConsulta.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //IDENTIFICADOR DE LA CELDA
        let CellID: NSString = "Cell"
        
        //CREADA LA CELDA Y PASADO EL IDENTIFICADOR
        var cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(CellID) as UITableViewCell!
        
        
        //CREADO EL OBJETO DE LA CLASE NSMANAGEDOBJECT
        var datos: NSManagedObject = datosDeConsulta[indexPath.row] as NSManagedObject
        
        //STRING QUE ALMACENA LA DESCRIPCION DEL CONTACTO
        var descr = datos.valueForKeyPath("descr") as String
        
        //STRING QUE ALMACENA LOS DATOS DE DESTINO
        var destiny = datos.valueForKeyPath("destiny") as String
        
        //PRESENTAR O MOSTRAR EN CADA CELDA, EL NOMBRE Y LOS APELLIDOS DE CADA CONTACTO
        cell.textLabel?.text = datos.valueForKeyPath("name") as? String
        
        cell.detailTextLabel?.text = "\(descr) , \(destiny)"
        
        
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
                
                managedObjectContexto.deleteObject(datosDeConsulta[indexPath.row] as NSManagedObject)
                
                datosDeConsulta.removeAtIndex(indexPath.row)
                
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
        if (segue.identifier? == "EditTravel") {
            
            //CREO UNA VARIABLE QUE ALMACENA EL INDICE DE MI TABLA
            var indexPath: NSIndexPath = self.tableView.indexPathForSelectedRow()!
            
            //CREO UN OBJETO DE LA CLASE NSMANAGEDOBJECT Y LE PASO MI ARRAY FILA SELECCIONADA
            var selectItem: NSManagedObject = datosDeConsulta[indexPath.row] as NSManagedObject
            
            println("Linea 0")
            
            //PRESENTAR LA VISTA DETALLE
            let vistaDetalle: TravelDetailViewController = segue.destinationViewController as TravelDetailViewController
            
            //PASAR A LA PROPIEDAD DE TIPO STRING DE MI VISTA DETALLE, EL VALOR SELECCIONADO EN LA PROPIEDAD SELECTITEM
            println("Linea 1")
            
            //PASARLE EL OBJETO TRAVEL
            vistaDetalle.travelDetail = datosDeConsulta[indexPath.row] as Travel
            
            println("Linea 2")
            
            //PASAR TODO EL OBJETO PERSONA
            vistaDetalle.existeTravel = selectItem
            
        }
        
    }
    
    
    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
