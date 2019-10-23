codeunit 50010 "DXC Transfer Order Receive"
{  


    trigger OnRun();
    var
        TransferHeader : Record "Transfer Header";
    begin
    end;

    procedure Post(PTransferHeader : Record "Transfer Header");
    var
        WhseReceiptLine : Record "Warehouse Receipt Line";
        TransferLine : Record "Transfer Line";
        GetSourceDocInbound : Codeunit "Get Source Doc. Inbound";
        WhseReceiptHeader : Record "Warehouse Receipt Header";
        WhsePostReceipt : Codeunit "Whse.-Post Receipt";
        WhseActivityLine : Record "Warehouse Activity Line";
        TempTransferLine : Record "Transfer Line" temporary;
        WMSMgt : Codeunit "WMS Management";
        WhseActivityRegister : Codeunit "Whse.-Activity-Register";
        TransferOrderPostShipment : Codeunit "TransferOrder-Post Shipment";
        ReservEntry : Record "Reservation Entry";
        ReleaseTransferDocument : Codeunit "Release Transfer Document";
        FromLocation : Record Location;
        ToLocation : Record Location;
        WhseTransferRelease : Codeunit "Whse.-Transfer Release";
    begin

        if not PTransferHeader."DXC Post Automation" then
          exit;

        //Release Transfer Order
        ReleaseTransferDocument.Run(PTransferHeader);     

        WhseTransferRelease.Release(PTransferHeader);

        FromLocation.Get(PTransferHeader."Transfer-from Code");
        ToLocation.Get(PTransferHeader."Transfer-to Code");

        if ((FromLocation."Bin Mandatory") or (ToLocation."Require Pick")) then begin
          
          //Post Shipment
          if FromLocation."Require Shipment" then begin
            TransferOrderPostShipment.SetHideValidationDialog(true);
            TransferOrderPostShipment.RUN(PTransferHeader);
          end;          

          //Create Whse. Receipt
          GetSourceDocInbound.CreateFromInbndTransferOrderHideDialog(PTransferHeader);

          TransferLine.SETRANGE(TransferLine."Document No.",PTransferHeader."No.");
          if TransferLine.FINDFIRST then begin
            TransferLine."Qty. to Receive" := TransferLine.Quantity;
            TransferLine."Qty. to Receive (Base)" := TransferLine."Quantity (Base)";            
            TransferLine."Qty. in Transit" := TransferLine.Quantity;
            TransferLine."Qty. in Transit (Base)" := TransferLine."Quantity (Base)";
            TransferLine."Quantity Shipped" := TransferLine.Quantity;
            TransferLine."Qty. Shipped (Base)" := TransferLine."Quantity (Base)";
            TransferLine.Modify;
          end;

          // Autofill qty to receive

          TempTransferLine.DELETEALL;

          TransferLine.SETRANGE(TransferLine."Document No.",PTransferHeader."No.");
          if TransferLine.FINDFIRST then begin
            WhseReceiptLine.SETRANGE("Source Type",DATABASE::"Transfer Line");
            WhseReceiptLine.SETRANGE("Source Subtype",1);
            WhseReceiptLine.SETRANGE("Source No.",PTransferHeader."No.");
            //WhseReceiptLine.SETRANGE("Source Line No.",TransferLine."Line No.");
            WhseReceiptLine.SETRANGE("Source Document",WhseReceiptLine."Source Document"::"Inbound Transfer");
            if WhseReceiptLine.FINDFIRST then
              repeat
                WhseReceiptLine.AutofillQtyToReceive(WhseReceiptLine);
                TempTransferLine := TransferLine;
                TempTransferLine.INSERT;
                // Get Reservation Entry
                ReservEntry.SETRANGE("Source ID",TransferLine."Document No.");
                ReservEntry.SETRANGE("Source Prod. Order Line",TransferLine."Line No.");
                ReservEntry.SETRANGE("Source Type",DATABASE::"Transfer Line");
                ReservEntry.SETRANGE("Source Subtype",1);
                ReservEntry.SETRANGE("Reservation Status",ReservEntry."Reservation Status"::Surplus);
                ReservEntry.SETRANGE("Location Code",TransferLine."Transfer-to Code");
                ReservEntry.SETRANGE("Item No.",TransferLine."Item No.");
                ReservEntry.SETRANGE(Positive,true);
                ReservEntry.SETRANGE("Item Tracking",ReservEntry."Item Tracking"::"Serial No.");
                if ReservEntry.FINDFIRST then begin
                  ReservEntry.VALIDATE("Qty. to Handle (Base)",TransferLine."Quantity (Base)");
                  ReservEntry.MODIFY;
                end;
              until WhseReceiptLine.NEXT = 0;
          end;

          //Post Whse. Receipt
          if WhseReceiptLine.FINDFIRST then begin

            WhseReceiptLine.Quantity := TransferLine.Quantity;
            WhseReceiptLine."Qty. (Base)" := TransferLine."Quantity (Base)";
            WhseReceiptLine."Qty. Outstanding" := TransferLine.Quantity; 
            WhseReceiptLine."Qty. Outstanding (Base)" := TransferLine."Quantity (Base)";
            WhseReceiptLine."Qty. to Receive" := TransferLine.Quantity;
            WhseReceiptLine."Qty. to Receive (Base)" := TransferLine."Quantity (Base)"; 
            WhseReceiptLine.Modify;

            WhsePostReceipt.SetHideValidationDialog(true);
            WhsePostReceipt.RUN(WhseReceiptLine);
          end;

          //Put-Away Autofill Qty. to Handle
          if TempTransferLine.FINDFIRST then
            repeat
              WhseActivityLine.SETRANGE("Source Document",WhseActivityLine."Source Document"::"Inbound Transfer");
              WhseActivityLine.SETRANGE("Source Line No.",TempTransferLine."Line No.");
              WhseActivityLine.SETRANGE("Source No.",TempTransferLine."Document No.");
              WhseActivityLine.SETRANGE("Source Type",DATABASE::"Transfer Line");
              WhseActivityLine.SETRANGE("Source Subtype",1);
              if WhseActivityLine.FINDFIRST then
                repeat
                  WhseActivityLine.AutofillQtyToHandle(WhseActivityLine);
                until WhseActivityLine.NEXT = 0;
            until TempTransferLine.NEXT = 0;

          // Register Put-Away

          if WhseActivityLine.FINDFIRST then begin
            WMSMgt.CheckBalanceQtyToHandle(WhseActivityLine);
            WhseActivityRegister.RUN(WhseActivityLine);
          end;

         end else begin
          CODEUNIT.RUN(CODEUNIT::"TransferOrder-Post Shipment",PTransferHeader);
          CODEUNIT.RUN(CODEUNIT::"TransferOrder-Post Receipt",PTransferHeader);
        end;  
        
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Create Source Document", 'OnAfterCheckIfFromTransLine2ShptLine', '', false, false)]
    local procedure HandleAfterCheckIfFromTransLine2ShptLineOnWhseCreateSourceDocument(var TransLine : Record "Transfer Line";var AutomationPost : Boolean)
        var 
          TransHeader : Record "Transfer Header";
    begin
        TransHeader.get(TransLine."Document No.");
        if TransHeader."DXC Post Automation" then
          AutomationPost := true;
    end;

     [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Create Source Document", 'OnAfterCheckIfTransLine2ReceiptLine', '', false, false)]
    local procedure HandleAfterCheckIfTransLine2ReceiptLineOnWhseCreateSourceDocument(var TransLine : Record "Transfer Line";var AutomationPost : Boolean)
        var 
          TransHeader : Record "Transfer Header";
    begin
        TransHeader.get(TransLine."Document No.");
        if TransHeader."DXC Post Automation" then
          AutomationPost := true;
    end;

    [EventSubscriber(ObjectType::Report, Report::"Get Source Documents", 'OnAfterCreateShptHeader', '', false, false)]
    local procedure HandleAfterCreateShptHeaderOnGetSourceDocuments(var WhseShptHeader : Record "Warehouse Shipment Header"; 
      TransferHeader : Record "Transfer Header")
    begin
      WhseShptHeader."DXC Post Automation" := TransferHeader."DXC Post Automation";
    end;

     [EventSubscriber(ObjectType::Report, Report::"Get Source Documents", 'OnAfterCreateReceiptHeader', '', false, false)]
    local procedure HandleAfterCreateReceipHeaderOnGetSourceDocuments(var WhseReceiptHeader : Record "Warehouse Receipt Header"; 
      TransferHeader : Record "Transfer Header")
    begin
      WhseReceiptHeader."DXC Post Automation" := TransferHeader."DXC Post Automation";
    end;

    [EventSubscriber(ObjectType::Table, 5746, 'OnAfterCopyFromTransferHeader', '', false, false)]
    local procedure HandleAfterCopyFromTransferHeaderOnTransferReceiptHeader(var TransferReceiptHeader : Record "Transfer Receipt Header"; 
      TransferHeader : Record "Transfer Header")
    begin
      TransferReceiptHeader."DXC Post Automation" := TransferHeader."DXC Post Automation";       
    end;

    [EventSubscriber(ObjectType::Table, 5747, 'OnAfterCopyFromTransferLine', '', false, false)]
    local procedure HandleAfterCopyFromTransferLineOnTransferReceiptLine(var TransferReceiptLine : Record "Transfer Receipt Line"; 
      TransferLine : Record "Transfer Line")
    begin
      TransferReceiptLine."DXC Transfer-from Bin DPP" := TransferLine."DXC Transfer-from Bin DPP";  
      TransferReceiptLine."DXC Transfer-to Bin DPP" := TransferLine."DXC Transfer-to Bin DPP";      
    end;

    [EventSubscriber(ObjectType::Table, 5745, 'OnAfterCopyFromTransferLine', '', false, false)]
    local procedure HandleAfterCopyFromTransferLineOnTransferShipmentLine(var TransferShipmentLine : Record "Transfer Shipment Line"; 
      TransferLine : Record "Transfer Line")
    begin
      TransferShipmentLine."DXC Transfer-from Bin DPP" := TransferLine."DXC Transfer-from Bin DPP";  
      TransferShipmentLine."DXC Transfer-to Bin DPP" := TransferLine."DXC Transfer-to Bin DPP";      
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Create Source Document", 'OnAfterCreateRcptLineFromTransLine', '', false, false)]
    local procedure HandleAfterCreateRcptLineFromTransLineOnWhseCreateSourceDocument(var WarehouseReceiptLine : Record "Warehouse Receipt Line"; 
        WarehouseReceiptHeader : Record "Warehouse Receipt Header"; TransferLine : Record "Transfer Line")
    begin
      if (TransferLine."DXC Transfer-To Bin DPP" <> '') then begin
        WarehouseReceiptLine."DXC Transfer-To Bin DPP" := TransferLine."DXC Transfer-To Bin DPP";
        WarehouseReceiptLine.Modify;
      end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Post Receipt", 'OnBeforeInsertPostedWhseRcptHeader', '', false, false)]
    local procedure HandleBeforeInsertPostedWhseRcptHeaderOnWhsePostReceipt(var PostedWhseRcptHeader : Record "Posted Whse. Receipt Header"; 
        WhseRcptHeader : Record "Warehouse Receipt Header")
    begin
      PostedWhseRcptHeader."DXC Post Automation" := WhseRcptHeader."DXC Post Automation";     
    end;

     [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Post Receipt", 'OnBeforeInsertPostedWhseRcptLine', '', false, false)]
    local procedure HandleBeforeInsertPostedWhseRcptLineOnWhsePostReceipt(var PostedWhseRcptLine : Record "Posted Whse. Receipt Line"; 
        WhseRcptLine : Record "Warehouse Receipt Line")
    begin
      PostedWhseRcptLine."DXC Transfer-To Bin DPP" := WhseRcptLine."DXC Transfer-To Bin DPP";     
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Post Shipment", 'OnBeforeInsertPostedWhseShptHeader', '', false, false)]
    local procedure HandleBeforeInsertPostedWhseShptHeaderOnWhsePostReceipt(var PostedWhseShptHeader : Record "Posted Whse. Shipment Header"; 
        WhseShptHeader : Record "Warehouse Shipment Header")
    begin
      PostedWhseShptHeader."DXC Post Automation" := WhseShptHeader."DXC Post Automation";     
    end;

     [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Post Shipment", 'OnBeforeInsertPostedWhseShptLine', '', false, false)]
    local procedure HandleBeforeInsertPostedWhseShptLineOnWhsePostReceipt(var PostedWhseShptLine : Record "Posted Whse. Shipment Line"; 
        WhseShptLine : Record "Warehouse Shipment Line")
    begin
      PostedWhseShptLine."DXC Transfer-To Bin DPP" := WhseShptLine."DXC Transfer-To Bin DPP";     
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Create Put-away", 'OnAfterFindBinContent', '', false, false)]
    local procedure HandleAfterFindBinContentOnCreatePutAway(var BinContent : Record "Bin Content"; PostedWhseRcptLine : Record "Posted Whse. Receipt Line"  )
      var        
        PostedWhseRcptHeader : Record "Posted Whse. Receipt Header";
    begin
        
        if ((PostedWhseRcptLine."Source Type" <> Database::"Transfer Line") OR 
          (PostedWhseRcptLine."Source Document" <> PostedWhseRcptLine."Source Document"::"Inbound Transfer")) then
            exit;
       
        PostedWhseRcptHeader.Get(PostedWhseRcptLine."No.");
        
        if not PostedWhseRcptHeader."DXC Post Automation" then
          exit;       

        PostedWhseRcptLine.TESTFIELD("DXC Transfer-To Bin DPP");
       
        BinContent.SetRange("Bin Code",PostedWhseRcptLine."DXC Transfer-To Bin DPP");
    end;

    [EventSubscriber(ObjectType::Table, 32, 'OnBeforeVerifyOnInventory', '', false, false)]
    local procedure HandleBeforeVerifyOnInventoryOnItemLedgerEntry(ItemLedgEntry : Record "Item Ledger Entry"; var PostAutomation : Boolean)
      var
        TransHeader : Record "Transfer Header";
    begin
      if (ItemLedgEntry."Entry Type"  <> ItemLedgEntry."Entry Type"::Transfer) then
        exit;   

      TransHeader.Get(ItemLedgEntry."Order No."); 

      if TransHeader."DXC Post Automation" then
          PostAutomation := true;   
    end;


    
}

