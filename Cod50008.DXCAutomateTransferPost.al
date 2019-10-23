codeunit 50008 "DXC Automate Transfer Post"
{    
    trigger OnRun();
    var
        TransferHeader2 : Record "Transfer Header";
    begin
    end;

    var
        Item : Record Item;
        Location : Record Location;
        Bin : Record Bin;
        Text001 : Label 'Bin Type Code must be Pick';

    [EventSubscriber(ObjectType::Table, 5741, 'OnAfterValidateEvent', 'Item No.', false, false)]
    local procedure HandleAfterValidateItemNoOnTransferLine(var Rec : Record "Transfer Line";var xRec : Record "Transfer Line";CurrFieldNo : Integer);
    var
        Item : Record Item;
        TransHeader : Record "Transfer Header";
    begin

        if not IsAutomation(Rec) then
          exit;

        Item.GET(Rec."Item No.");
        if (Item."Item Tracking Code" <> '') then
          Rec.VALIDATE(Quantity,1);
    end;

    [EventSubscriber(ObjectType::Table, 5741, 'OnAfterValidateEvent', 'Quantity', false, false)]
    local procedure HandleAfterValidateQtyOnTransferLine(var Rec : Record "Transfer Line";var xRec : Record "Transfer Line";CurrFieldNo : Integer);
    var
        Item : Record Item;
        TransHeader : Record "Transfer Header";
    begin

        if not IsAutomation(Rec) then
          exit;

        if CurrFieldNo <> Rec.FIELDNO(Rec.Quantity) then
          exit;

        Item.GET(Rec."Item No.");
        if (Item."Item Tracking Code" <> '') then
          Item.TESTFIELD("Item Tracking Code",'');
    end;

    [EventSubscriber(ObjectType::Table, 5741, 'OnBeforeValidateEvent', 'Transfer-from Bin Code', false, false)]
    local procedure HandleBeforeValidateTransferFromBinCodeOnTransferLine(var Rec : Record "Transfer Line";var xRec : Record "Transfer Line";CurrFieldNo : Integer);
    begin

        if not IsAutomation(Rec) then
          exit;

        if CurrFieldNo <> Rec.FIELDNO(Rec."Transfer-from Bin Code") then
          exit;

        if (Rec."Transfer-from Bin Code" = '') then
          exit;

        GetLocation(Rec."Transfer-from Code");

        if not Location."Bin Mandatory" then
          Location.TESTFIELD("Bin Mandatory",true);

        // if not Location."Directed Put-away and Pick" then
        //   Location.TESTFIELD("Directed Put-away and Pick",true);
    end;

    [EventSubscriber(ObjectType::Table, 5741, 'OnBeforeValidateEvent', 'Transfer-To Bin Code', false, false)]
    local procedure HandleBeforeValidateTransferToBinCodeOnTransferLine(var Rec : Record "Transfer Line";var xRec : Record "Transfer Line";CurrFieldNo : Integer);
    begin
        if not IsAutomation(Rec) then
          exit;

        if CurrFieldNo <> Rec.FIELDNO(Rec."Transfer-To Bin Code") then
          exit;

         if (Rec."Transfer-to Bin Code" = '') then
          exit;

        GetLocation(Rec."Transfer-to Code");

        if not Location."Bin Mandatory" then
          Location.TESTFIELD("Bin Mandatory",true);

        // if not Location."Directed Put-away and Pick" then
        //   Location.TESTFIELD("Directed Put-away and Pick",true);
    end;

    [EventSubscriber(ObjectType::Table, 5741, 'OnBeforeValidateEvent', 'DXC Transfer-from Bin DPP', false, false)]
    local procedure HandleBeforeValidateTransferFromBinDPPOnTransferLine(var Rec : Record "Transfer Line";var xRec : Record "Transfer Line";CurrFieldNo : Integer);
    begin

        if not IsAutomation(Rec) then
          exit;

        if CurrFieldNo <> Rec.FIELDNO(Rec."DXC Transfer-from Bin DPP") then
          exit;

        if (Rec."DXC Transfer-from Bin DPP" = '') then
          exit;

        GetLocation(Rec."Transfer-from Code");

        if not Location."Bin Mandatory" then
          Location.TESTFIELD("Bin Mandatory",true);

        // if not Location."Directed Put-away and Pick" then
        //   Location.TESTFIELD("Directed Put-away and Pick",true);
    end;

    [EventSubscriber(ObjectType::Table, 5741, 'OnBeforeValidateEvent', 'DXC Transfer-To Bin DPP', false, false)]
    local procedure HandleBeforeValidateTransferToBinDPPOnTransferLine(var Rec : Record "Transfer Line";var xRec : Record "Transfer Line";CurrFieldNo : Integer);
    begin
        if not IsAutomation(Rec) then
          exit;

        if CurrFieldNo <> Rec.FIELDNO(Rec."DXC Transfer-To Bin DPP") then
          exit;

        if (Rec."DXC Transfer-To Bin DPP" = '') then
          exit;

        GetLocation(Rec."Transfer-to Code");

        if not Location."Bin Mandatory" then
          Location.TESTFIELD("Bin Mandatory",true);

        // if not Location."Directed Put-away and Pick" then
        //   Location.TESTFIELD("Directed Put-away and Pick",true);
    end;

    [EventSubscriber(ObjectType::Table, 5741, 'OnAfterValidateEvent', 'Transfer-from Bin Code', false, false)]
    local procedure HandleAfterValidateTransferFromBinCodeOnTransferLine(var Rec : Record "Transfer Line";var xRec : Record "Transfer Line";CurrFieldNo : Integer);
    begin

        if not IsAutomation(Rec) then
          exit;

        if CurrFieldNo <> Rec.FIELDNO(Rec."Transfer-from Bin Code") then
          exit;
        
         if (Rec."Transfer-from Bin Code" = '') then
          exit;

        GetLocation(Rec."Transfer-from Code");

        if not Location."Bin Mandatory" then
          Location.TESTFIELD("Bin Mandatory",true);

        // if not Location."Directed Put-away and Pick" then
        //   Location.TESTFIELD("Directed Put-away and Pick",true);
    end;

    [EventSubscriber(ObjectType::Table, 5741, 'OnAfterValidateEvent', 'Transfer-To Bin Code', false, false)]
    local procedure HandleAfterValidateTransferToBinCodeOnTransferLine(var Rec : Record "Transfer Line";var xRec : Record "Transfer Line";CurrFieldNo : Integer);
    begin

        if not IsAutomation(Rec) then
          exit;

        if CurrFieldNo <> Rec.FIELDNO(Rec."Transfer-To Bin Code") then
          exit;

        if (Rec."Transfer-To Bin Code" = '') then
          exit;

        GetLocation(Rec."Transfer-from Code");

        // if not Location."Bin Mandatory" then
        //   Location.TESTFIELD("Bin Mandatory",true);

        // if not Location."Directed Put-away and Pick" then
        //   Location.TESTFIELD("Directed Put-away and Pick",true);
    end;

    [EventSubscriber(ObjectType::Table, 5741, 'OnAfterValidateEvent', 'DXC Transfer-from Bin DPP', false, false)]
    local procedure HandleAfterValidateTransferFromBinDPPOnTransferLine(var Rec : Record "Transfer Line";var xRec : Record "Transfer Line";CurrFieldNo : Integer);
    begin

        if not IsAutomation(Rec) then
          exit;

        if CurrFieldNo <> Rec.FIELDNO(Rec."DXC Transfer-from Bin DPP") then
          exit;

        if (Rec."DXC Transfer-from Bin DPP" = '') then
          exit;

        GetLocation(Rec."Transfer-from Code");

        if not Location."Bin Mandatory" then
          Rec.TESTFIELD("DXC Transfer-from Bin DPP",'');

        // if not Location."Directed Put-away and Pick" then
        //   Rec.TESTFIELD("DXC Transfer-from Bin DPP",'');

        GetBin(Rec."Transfer-from Code",Rec."DXC Transfer-from Bin DPP");

        // if (Bin."Bin Type Code" <> 'PICK') and (Bin."Bin Type Code" <> 'PUT/PICK') then
        //   ERROR(Text001);
    end;

    [EventSubscriber(ObjectType::Table, 5741, 'OnAfterValidateEvent', 'DXC Transfer-To Bin DPP', false, false)]
    local procedure HandleAfterValidateTransferToBinDPPOnTransferLine(var Rec : Record "Transfer Line";var xRec : Record "Transfer Line";CurrFieldNo : Integer);
    begin

        if not IsAutomation(Rec) then
          exit;

        if CurrFieldNo <> Rec.FIELDNO(Rec."DXC Transfer-To Bin DPP") then
          exit;
        
        if (Rec."DXC Transfer-to Bin DPP" = '') then
          exit;

        GetLocation(Rec."Transfer-from Code");

        // if not Location."Bin Mandatory" then
          // Rec.TESTFIELD("DXC Transfer-To Bin DPP",'');

        // if not Location."Directed Put-away and Pick" then
          // Rec.TESTFIELD("DXC Transfer-To Bin DPP",'');

        GetBin(Rec."Transfer-to Code",Rec."DXC Transfer-To Bin DPP");

        if (Bin."Bin Type Code" <> 'PICK') and (Bin."Bin Type Code" <> 'PUT/PICK') then
          ERROR(Text001);
    end;

    [EventSubscriber(ObjectType::Codeunit, 7312, 'OnAfterBinContentExists', '', false, false)]
    local procedure HandleAfterBinContentExistsOnCreatePick(var Bincontent : Record "Bin Content";WhseShipLine : Record "Warehouse Shipment Line");
    var
        TransLine : Record "Transfer Line";
    begin
        if TransLine.GET(WhseShipLine."Source No.",WhseShipLine."Source Line No.") then
          if (TransLine."DXC Transfer-from Bin DPP" <> '') then
            Bincontent.SETRANGE("Bin Code",TransLine."DXC Transfer-from Bin DPP");
    end;

    [EventSubscriber(ObjectType::Page, 5742, 'OnOpenPageEvent', '', false, false)]
    local procedure HandleOnOpenPageOnTransferOrders(var Rec : Record "Transfer Header");
    var
        
    begin
        Rec.SetRange("DXC Post Automation",false);
    end;

    local procedure IsAutomation(PTransLine : Record "Transfer Line") : Boolean;
    var
        TransHeader : Record "Transfer Header";
    begin

        TransHeader.GET(PTransLine."Document No.");
        if TransHeader."DXC Post Automation" then
          exit(true);
    end;

    local procedure GetItem(PTransLine : Record "Transfer Line");
    begin

        Item.GET(PTransLine."Item No.");
    end;

    local procedure GetLocation(PLocationCode : Code[20]);
    begin

        Location.GET(PLocationCode);
    end;

    local procedure GetBin(PLocationCode : Code[20];PBinCode : Code[20]);
    begin

        Bin.GET(PLocationCode,PBinCode);
    end;
}

