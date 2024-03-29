codeunit 50007 "DXC Transfer Order Ship"
{
    trigger OnRun();
    var        
        TransferHeader : Record "Transfer Header";
    begin
    end;

    procedure Post(TransHeader : Record "Transfer Header");
    var
        GetSourceDocOutbound : Codeunit "Get Source Doc. Outbound";
        WhseShipmentLine : Record "Warehouse Shipment Line";
        WhseShipmentLine2 : Record "Warehouse Shipment Line";
        WhseShipmentHeader : Record "Warehouse Shipment Header";
        ReleaseWhseShptDoc : Codeunit "Whse.-Shipment Release";
        WhseActivityLine : Record "Warehouse Activity Line";
        WhsePostShipment : Codeunit "Whse.-Post Shipment";
        TransferHeader2 : Record "Transfer Header";
        ReleaseTransferDocument : Codeunit "Release Transfer Document";
        TransferOrderPostReceipt : Codeunit "TransferOrder-Post Receipt";
        FromLocation : Record Location;
        ToLocation : Record Location;
    begin

        if not TransHeader."DXC Post Automation" then
          exit;

        //Release Transfer Order
        ReleaseTransferDocument.Run(TransHeader);                                          

        FromLocation.Get(TransHeader."Transfer-from Code");
        ToLocation.Get(TransHeader."Transfer-to Code");

        if ((ToLocation."Bin Mandatory") and (FromLocation."Bin Mandatory") and
        (FromLocation."Directed Put-away and Pick" = false) and (ToLocation."Directed Put-away and Pick" = false)) then begin
          CODEUNIT.RUN(CODEUNIT::"TransferOrder-Post Shipment",TransHeader);
          CODEUNIT.RUN(CODEUNIT::"TransferOrder-Post Receipt",TransHeader);  
          exit;
        end;

         if ((ToLocation."Bin Mandatory" = false) and (FromLocation."Bin Mandatory" = false) and
        (FromLocation."Directed Put-away and Pick" = false) and (ToLocation."Directed Put-away and Pick" = false)) then begin
          CODEUNIT.RUN(CODEUNIT::"TransferOrder-Post Shipment",TransHeader);
          CODEUNIT.RUN(CODEUNIT::"TransferOrder-Post Receipt",TransHeader);  
          exit;
        end;

        if ((ToLocation."Bin Mandatory") or (FromLocation."Require Pick")) then begin
          // Create Whse. Shipment
          GetSourceDocOutbound.CreateFromOutbndTransferOrderHideDialog(TransHeader);
          GetSourceDocOutbound.DXCGetWhseShipHeader(WhseShipmentHeader);

          // Release Whse. Shipment
          ReleaseWhseShptDoc.Release(WhseShipmentHeader);

          //Create Pick
          WhseShipmentLine.SETRANGE("No.",WhseShipmentHeader."No.");
          if WhseShipmentLine.FINDFIRST then begin
            WhseShipmentLine2.COPY(WhseShipmentLine);
            WhseShipmentLine.SetHideValidationDialog(true);
            WhseShipmentLine.CreatePickDoc(WhseShipmentLine2,WhseShipmentHeader);
          //  WhseShipmentLine.SetIgnoreErrors();
          //  WhseShipmentLine.HasErrorOccured();
          end;

          //Register Pick
          WhseActivityLine.SETRANGE("Whse. Document Type",WhseActivityLine."Whse. Document Type"::Shipment);
          WhseActivityLine.SETRANGE("Whse. Document No.",WhseShipmentHeader."No.");
          if WhseActivityLine.FINDFIRST then
            CODEUNIT.RUN(CODEUNIT::"Whse.-Activity-Register",WhseActivityLine);

          // Post Shipment
          WhsePostShipment.SetPostingSettings(false);
          WhsePostShipment.SetPrint(false);
          WhsePostShipment.RUN(WhseShipmentLine);
          //WhsePostShipment.GetResultMessage;

          if TransferHeader2.FINDFIRST then
            repeat
              if (TransferHeader2."No." = TransHeader."No.") then begin
                CODEUNIT.RUN(CODEUNIT::"TransferOrder-Post Receipt",TransferHeader2);
                exit;
              end;
          until TransferHeader2.NEXT = 0;

        end else begin
          CODEUNIT.RUN(CODEUNIT::"TransferOrder-Post Shipment",TransHeader);
          CODEUNIT.RUN(CODEUNIT::"TransferOrder-Post Receipt",TransHeader);
        end;     

       
    end;
}

