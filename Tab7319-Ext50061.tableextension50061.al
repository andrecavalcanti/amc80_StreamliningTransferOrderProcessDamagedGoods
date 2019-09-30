tableextension 50061 "tableextension50061" extends "Posted Whse. Receipt Line" //7319
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
          
        }
        field(50001;"DXC Transfer-To Bin DPP";Code[20])
        {
            CaptionML = ENU='Transfer-To Bin DPP',
                        ESM='Transfer.a-cód. ubic.',
                        FRC='Code de zone transf. sortant',
                        ENC='Transfer-To Bin Code';
            DataClassification = ToBeClassified;          
        
        }
       
    }      

}

