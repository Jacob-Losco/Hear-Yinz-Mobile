/*+===================================================================
File: FirebaseConnectTestViewModel

Summary: ViewModel that get's connection test data from firestore and stores the values in a String array

Exported Data Structures: asm_List - String list of values from 'Test_Connect' Collection

Exported Functions: fnGetData - Sets asm_List to contain the string list of values, must be called to view data

Contributors:
    Jacob Losco - 1/22/2022 - SP-316

===================================================================+*/


import Foundation
import FirebaseFirestore

class FirebaseConnectTestViewModel: ObservableObject{
    
    @Published var asm_List = [String]()
    
    /*F+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      Function: fnGetData

      Summary: Sets asm_List to contain the string list of values, must be called to view data

      Args: None

      Returns: None
    -------------------------------------------------------------------F*/
    func fnGetData() {
        
        //Get a reference to the database
        let db = Firestore.firestore()
        
        //read the documents at a specified path
        db.collection("Test_Connect").getDocuments { snapshot, error in
            //check for erros
            if error != nil {
                //handle error
            }
            else {
                if let snapshot = snapshot {
                    
                    //update the list property in the main thread
                    DispatchQueue.main.async {
                        //get all the documents
                        self.asm_List = snapshot.documents.map { d in
                            return d.data()["test"] as?String ?? ""
                        }
                    }
                    
                }
            }
        }
    }
}
