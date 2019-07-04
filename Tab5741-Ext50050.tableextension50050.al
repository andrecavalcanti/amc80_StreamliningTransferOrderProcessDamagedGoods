tableextension 50050 "tableextension50050" extends "Transfer Line" //5741
{
    fields
    {
        field(50000;"DXC Transfer-from Bin DPP";Code[20])
        {
            CaptionML = ENU='Transfer-from Bin Code DPP',
                        ESM='Transfer.desde-cód. ubic.',
                        FRC='Code de zone transf. entrant',
                        ENC='Transfer-from Bin Code';
            DataClassification = ToBeClassified;
            TableRelation = "Bin Content"."Bin Code" WHERE ("Location Code"=FIELD("Transfer-from Code"),
                                                            "Item No."=FIELD("Item No."),
                                                            "Variant Code"=FIELD("Variant Code"));

            trigger OnValidate();
            begin
                if "Transfer-from Bin Code" <> xRec."Transfer-from Bin Code" then begin
                  Rec.TESTFIELD("Transfer-from Code");
                  if "Transfer-from Bin Code" <> '' then begin
                    DXCGetLocation("Transfer-from Code");
                    DXCLocation.TESTFIELD("Bin Mandatory");
                    //Location.TESTFIELD("Directed Put-away and Pick",FALSE);
                    DXCGetBin("Transfer-from Code","Transfer-from Bin Code");
                    Rec.TESTFIELD("Transfer-from Code",DXCBin."Location Code");
                    HandleDedicatedBin(true);
                  end;
                end;
            end;
        }
        field(50001;"DXC Transfer-To Bin DPP";Code[20])
        {
            CaptionML = ENU='Transfer-To Bin DPP',
                        ESM='Transfer.a-cód. ubic.',
                        FRC='Code de zone transf. sortant',
                        ENC='Transfer-To Bin Code';
            DataClassification = ToBeClassified;
            TableRelation = Bin.Code WHERE ("Location Code"=FIELD("Transfer-to Code"));

            trigger OnValidate();
            begin
                if "Transfer-To Bin Code" <> xRec."Transfer-To Bin Code" then begin
                  Rec.TESTFIELD("Transfer-to Code");
                  if "Transfer-To Bin Code" <> '' then begin
                    DXCGetLocation("Transfer-to Code");
                    DXCLocation.TESTFIELD("Bin Mandatory");
                    //Location.TESTFIELD("Directed Put-away and Pick",FALSE);
                    DXCGetBin("Transfer-to Code","Transfer-To Bin Code");
                    Rec.TESTFIELD("Transfer-to Code",DXCBin."Location Code");
                  end;
                end;
            end;
        }
       
    }   

     var
        "---DXC Vars---" : Integer;
        DXCLocation : Record Location;
        DXCBin : Record Bin;

    //#region DXCGetLocation
    local procedure DXCGetLocation(LocationCode: Code[10]);
    begin
      IF DXCLocation.Code <> LocationCode THEN
        DXCLocation.GET(LocationCode);
    end;
    //#endregion DXCGetLocation 

    //#region DXCGetBin
    local procedure DXCGetBin(LocationCode: Code[10];BinCode : Code[20]);
    begin
      IF BinCode = '' THEN
        CLEAR(DXCBin)
      ELSE
        IF DXCBin.Code <> BinCode THEN
          DXCBin.GET(LocationCode,BinCode);  
    end;
    //#endregion DXCGetBin

    

}

