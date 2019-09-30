tableextension 50056 "tableextension50056" extends "Transfer Receipt Line" //5747
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
          
        }
        field(50001;"DXC Transfer-To Bin DPP";Code[20])
        {
            CaptionML = ENU='Transfer-To Bin DPP',
                        ESM='Transfer.a-cód. ubic.',
                        FRC='Code de zone transf. sortant',
                        ENC='Transfer-To Bin Code';
            DataClassification = ToBeClassified;
            TableRelation = Bin.Code WHERE ("Location Code"=FIELD("Transfer-to Code"));
        
        }
       
    }      

}

