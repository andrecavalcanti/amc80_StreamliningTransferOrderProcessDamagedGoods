page 50007 "DXC Simple Transfer Orders"
{    
    CaptionML = ENU='Transfer Orders',
                ESM='Pedidos de transferencia',
                FRC='Ordres de transfert',
                ENC='Transfer Orders';
    CardPageID = "DXC Simple Transfer Order";
    Editable = false;
    PageType = List;
    PromotedActionCategoriesML = ENU='New,Process,Report,Release,Posting,Order,Documents',
                                 ESM='Nuevo,Procesar,Informe,Lanzar,Registro,Pedido,Documentos',
                                 FRC='Nouveau,Traiter,Rapport,Libérer,Report,Ordre,Documents',
                                 ENC='New,Process,Report,Release,Posting,Order,Documents';
    SourceTable = "Transfer Header";
    SourceTableView = WHERE("DXC Post Automation"=FILTER(true));

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("No.";"No.")
                {
                    ApplicationArea = Location;
                    ToolTipML = ENU='Specifies the number of the involved entry or record, according to the specified number series.',
                                ESM='Especifica el número de la entrada o el registro relacionado, según la serie numérica especificada.',
                                FRC='Spécifie le numéro de l''écriture ou de l''enregistrement concerné, en fonction de la série de numéros spécifiée.',
                                ENC='Specifies the number of the involved entry or record, according to the specified number series.';
                }
                field("Transfer-from Code";"Transfer-from Code")
                {
                    ApplicationArea = Location;
                    ToolTipML = ENU='Specifies the code of the location that items are transferred from.',
                                ESM='Especifica el código de la ubicación desde dónde se transfieren los productos.',
                                FRC='Spécifie le code de l''emplacement à partir duquel les articles sont transférés.',
                                ENC='Specifies the code of the location that items are transferred from.';
                }
                field("Transfer-to Code";"Transfer-to Code")
                {
                    ApplicationArea = Location;
                    ToolTipML = ENU='Specifies the code of the location that the items are transferred to.',
                                ESM='Especifica el código de la ubicación a dónde se transfieren los productos.',
                                FRC='Spécifie le code de l''emplacement vers lequel les articles sont transférés.',
                                ENC='Specifies the code of the location that the items are transferred to.';
                }
                field("In-Transit Code";"In-Transit Code")
                {
                    ApplicationArea = Location;
                    ToolTipML = ENU='Specifies the in-transit code for the transfer order, such as a shipping agent.',
                                ESM='Especifica el código en tránsito del pedido de transferencia, por ejemplo, un transportista.',
                                FRC='Spécifie le code de transit de l''ordre de transfert, par exemple un agent de livraison.',
                                ENC='Specifies the in-transit code for the transfer order, such as a shipping agent.';
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207;Links)
            {
                Visible = false;
            }
            systempart(Control1905767507;Notes)
            {
            }
        }
    }

    actions
    {
    }

    trigger OnInit();
    var
        ApplicationAreaSetup : Record "Application Area Setup";
    begin
        IsFoundationEnabled := ApplicationAreaSetup.IsFoundationEnabled;
    end;

    var
        IsFoundationEnabled : Boolean;
}

