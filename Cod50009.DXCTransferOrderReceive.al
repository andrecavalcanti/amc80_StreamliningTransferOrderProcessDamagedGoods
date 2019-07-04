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
    begin

        if not PTransferHeader."DXC Post Automation" then
          exit;

        //Release Transfer Order
        ReleaseTransferDocument.Run(PTransferHeader);

        //Post Shipment
        TransferOrderPostShipment.SetHideValidationDialog(true);
        TransferOrderPostShipment.RUN(PTransferHeader);

        //Create Whse. Receipt
        GetSourceDocInbound.CreateFromInbndTransferOrderHideDialog(PTransferHeader);

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
    end;
}

