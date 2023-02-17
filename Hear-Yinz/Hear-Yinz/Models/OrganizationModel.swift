/*+===================================================================
File: OrganizationModel.swift

Summary: A model that contains all information needed for an organization in the database

Exported Data Structures: OrganizationModel - the model

Exported Functions: init - constructor

Contributors:
    Jacob Losco - 2/14/2022 - SP-361

===================================================================+*/

import Foundation

class OrganizationModel {
    let sm_Id: String //document id of the event
    let sm_Name: String //name of the event
    
    /*F+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      Function: init

      Summary: constructor

      Args: sId - event id
        sName - event name

      Returns: None
    -------------------------------------------------------------------F*/
    init(sId: String, sName: String) {
        self.sm_Id = sId
        self.sm_Name = sName
    }
}
