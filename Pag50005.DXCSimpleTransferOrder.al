page 50005 "DXC Simple Transfer Order"
{    
    CaptionML = ENU='Transfer Order',
                ESM='Ped. transfer.',
                FRC='Ordre de transfert',
                ENC='Transfer Order';
    PageType = Document;
    PromotedActionCategoriesML = ENU='New,Process,Report,Release,Posting,Order,Documents',
                                 ESM='Nuevo,Procesar,Informe,Lanzar,Registro,Pedido,Documentos',
                                 FRC='Nouveau,Traiter,Rapport,Libérer,Report,Ordre,Documents',
                                 ENC='New,Process,Report,Release,Posting,Order,Documents';
    RefreshOnActivate = true;
    SourceTable = "Transfer Header";    

    layout
    {
        area(content)
        {
            group(General)
            {
                CaptionML = ENU='General',
                            ESM='General',
                            FRC='Général',
                            ENC='General';
                field("No.";"No.")
                {
                    ApplicationArea = Location;
                    Importance = Promoted;
                    ToolTipML = ENU='Specifies the number of the involved entry or record, according to the specified number series.',
                                ESM='Especifica el número de la entrada o el registro relacionado, según la serie numérica especificada.',
                                FRC='Spécifie le numéro de l''écriture ou de l''enregistrement concerné, en fonction de la série de numéros spécifiée.',
                                ENC='Specifies the number of the involved entry or record, according to the specified number series.';
                    Visible = DocNoVisible;

                    trigger OnAssistEdit();
                    begin
                        if AssistEdit(xRec) then
                          CurrPage.UPDATE;
                    end;
                }
                field("Transfer-from Code";"Transfer-from Code")
                {
                    ApplicationArea = Location;
                    Editable = (Status = Status::Open) AND EnableTransferFields;
                    Importance = Promoted;
                    ToolTipML = ENU='Specifies the code of the location that items are transferred from.',
                                ESM='Especifica el código de la ubicación desde dónde se transfieren los productos.',
                                FRC='Spécifie le code de l''emplacement à partir duquel les articles sont transférés.',
                                ENC='Specifies the code of the location that items are transferred from.';
                }
                field("Transfer-to Code";"Transfer-to Code")
                {
                    ApplicationArea = Location;
                    Editable = (Status = Status::Open) AND EnableTransferFields;
                    Importance = Promoted;
                    ToolTipML = ENU='Specifies the code of the location that the items are transferred to.',
                                ESM='Especifica el código de la ubicación a dónde se transfieren los productos.',
                                FRC='Spécifie le code de l''emplacement vers lequel les articles sont transférés.',
                                ENC='Specifies the code of the location that the items are transferred to.';
                }
                field("In-Transit Code";"In-Transit Code")
                {
                    ApplicationArea = Location;
                    Editable = EnableTransferFields;
                    Enabled = (NOT "Direct Transfer") AND (Status = Status::Open);
                    ToolTipML = ENU='Specifies the in-transit code for the transfer order, such as a shipping agent.',
                                ESM='Especifica el código en tránsito del pedido de transferencia, por ejemplo, un transportista.',
                                FRC='Spécifie le code de transit de l''ordre de transfert, par exemple un agent de livraison.',
                                ENC='Specifies the in-transit code for the transfer order, such as a shipping agent.';
                }
                field("Posting Date";"Posting Date")
                {
                    ApplicationArea = Location;
                    ToolTipML = ENU='Specifies the posting date of the transfer order.',
                                ESM='Especifica la fecha de registro del pedido de transferencia.',
                                FRC='Spécifie la date de report de l''ordre de transfert.',
                                ENC='Specifies the posting date of the transfer order.';

                    trigger OnValidate();
                    begin
                        PostingDateOnAfterValidate;
                    end;
                }
                field("DXC Post Automation";"DXC Post Automation")
                {
                }
            }
            part(TransferLines;"DXC Simple Transf Ord  Subform")
            {
                ApplicationArea = Location;
                SubPageLink = "Document No."=FIELD("No."),
                              "Derived From Line No."=CONST(0);
                UpdatePropagation = Both;
            }
            group(Shipment)
            {
                CaptionML = ENU='Shipment',
                            ESM='Envío',
                            FRC='Livraison',
                            ENC='Shipment';
                Editable = (Status = Status::Open) AND EnableTransferFields;
                Visible = false;
                field("Shipment Date";"Shipment Date")
                {
                    ApplicationArea = Location;
                    ToolTipML = ENU='Specifies when items on the document are shipped or were shipped. A shipment date is usually calculated from a requested delivery date plus lead time.',
                                ESM='Especifica cuándo se van a enviar o se han enviado los productos del documento. Se calcula normalmente una fecha de envío con la fecha de entrega solicitada y el plazo de seguridad.',
                                FRC='Spécifie quand les articles du document sont livrés ou ont été livrés. Une date de livraison est généralement calculée à partir d''une date de livraison demandée avec un délai de sécurité.',
                                ENC='Specifies when items on the document are shipped or were shipped. A shipment date is usually calculated from a requested delivery date plus lead time.';

                    trigger OnValidate();
                    begin
                        ShipmentDateOnAfterValidate;
                    end;
                }
                field("Outbound Whse. Handling Time";"Outbound Whse. Handling Time")
                {
                    ApplicationArea = Warehouse;
                    ToolTipML = ENU='Specifies a date formula for the time it takes to get items ready to ship from this location. The time element is used in the calculation of the delivery date as follows: Shipment Date + Outbound Warehouse Handling Time = Planned Shipment Date + Shipping Time = Planned Delivery Date.',
                                ESM='Especifica una fórmula de fecha con el tiempo que se tarda en preparar los productos para su envío desde esta ubicación. El elemento de tiempo se utiliza en el cálculo de la fecha de entrega de la siguiente manera: fecha envío + tiempo de manipulación en el almacén de salida = fecha envío planificada + tiempo envío = fecha entrega planificada.',
                                FRC='Spécifie une formule date pour le délai nécessaire pour que des articles soient prêts pour livraison à partir de cet emplacement. L''élément de temps est utilisé dans le calcul de la date de livraison comme suit : Date livraison + délai désenlogement = Date livraison planifiée + délai livraison = Date livraison planifiée.',
                                ENC='Specifies a date formula for the time it takes to get items ready to ship from this location. The time element is used in the calculation of the delivery date as follows: Shipment Date + Outbound Warehouse Handling Time = Planned Shipment Date + Shipping Time = Planned Delivery Date.';

                    trigger OnValidate();
                    begin
                        OutboundWhseHandlingTimeOnAfte;
                    end;
                }
                field("Shipment Method Code";"Shipment Method Code")
                {
                    ApplicationArea = Location;
                    ToolTipML = ENU='Specifies the delivery conditions of the related shipment, such as free on board (FOB).',
                                ESM='Especifica las condiciones de entrega del envío en cuestión, como franco a bordo (FOB).',
                                FRC='Spécifie les conditions de livraison de la livraison associée, telles que franco à bord (FAB).',
                                ENC='Specifies the delivery conditions of the related shipment, such as free on board (FOB).';
                }
                field("Shipping Agent Code";"Shipping Agent Code")
                {
                    ApplicationArea = Location;
                    ToolTipML = ENU='Specifies the code for the shipping agent who is transporting the items.',
                                ESM='Especifica el código del transportista que traslada los productos.',
                                FRC='Spécifie le code de l''agent de livraison qui transporte les articles.',
                                ENC='Specifies the code for the shipping agent who is transporting the items.';

                    trigger OnValidate();
                    begin
                        ShippingAgentCodeOnAfterValida;
                    end;
                }
                field("Shipping Agent Service Code";"Shipping Agent Service Code")
                {
                    ApplicationArea = Location;
                    Importance = Additional;
                    ToolTipML = ENU='Specifies the code for the service, such as a one-day delivery, that is offered by the shipping agent.',
                                ESM='Especifica el código de servicio (por ejemplo, entrega en un día) que ofrece el transportista.',
                                FRC='Spécifie le code du service, par exemple une livraison sous 24 heures, proposé par l''agent de livraison.',
                                ENC='Specifies the code for the service, such as a one-day delivery, that is offered by the shipping agent.';

                    trigger OnValidate();
                    begin
                        ShippingAgentServiceCodeOnAfte;
                    end;
                }
                field("Shipping Time";"Shipping Time")
                {
                    ApplicationArea = Location;
                    ToolTipML = ENU='Specifies how long it takes from when the items are shipped from the warehouse to when they are delivered.',
                                ESM='Especifica el tiempo que transcurre desde que se envían los productos desde el almacén hasta que se entregan.',
                                FRC='Spécifie le délai nécessaire entre le moment de l''expédition des articles à partir de l''entrepôt et la livraison.',
                                ENC='Specifies how long it takes from when the items are shipped from the warehouse to when they are delivered.';

                    trigger OnValidate();
                    begin
                        ShippingTimeOnAfterValidate;
                    end;
                }
                field("Shipping Advice";"Shipping Advice")
                {
                    ApplicationArea = Location;
                    Importance = Additional;
                    ToolTipML = ENU='Specifies an instruction to the warehouse that ships the items, for example, that it is acceptable to do partial shipment.',
                                ESM='Especifica una instrucción para el almacén que envía los productos, por ejemplo, que es aceptable para realizar un envío parcial.',
                                FRC='Spécifie une instruction à l''entrepôt qui livre les articles, par exemple, le fait qu''une livraison partielle est acceptable.',
                                ENC='Specifies an instruction to the warehouse that ships the items, for example, that it is acceptable to do partial shipment.';

                    trigger OnValidate();
                    begin
                        if "Shipping Advice" <> xRec."Shipping Advice" then
                          if not CONFIRM(Text000,false,FIELDCAPTION("Shipping Advice")) then
                            ERROR('');
                    end;
                }
                field("Receipt Date";"Receipt Date")
                {
                    ApplicationArea = Location;
                    ToolTipML = ENU='Specifies the date that you expect the transfer-to location to receive the shipment.',
                                ESM='Especifica la fecha en la que se espera recibir el envío en la ubicación de destino de la transferencia.',
                                FRC='Spécifie la date à laquelle l''emplacement destination transfert doit réceptionner la livraison.',
                                ENC='Specifies the date that you expect the transfer-to location to receive the shipment.';

                    trigger OnValidate();
                    begin
                        ReceiptDateOnAfterValidate;
                    end;
                }
            }
            group("Transfer-from")
            {
                CaptionML = ENU='Transfer-from',
                            ESM='Transferir desde',
                            FRC='Prov. transfert',
                            ENC='Transfer-from';
                Editable = (Status = Status::Open) AND EnableTransferFields;
                Visible = false;
                field("Transfer-from Name";"Transfer-from Name")
                {
                    ApplicationArea = Location;
                    ToolTipML = ENU='Specifies the name of the sender at the location that the items are transferred from.',
                                ESM='Especifica el nombre del remitente en la ubicación desde donde se transfieren los productos.',
                                FRC='Spécifie le nom de l''expéditeur dans l''emplacement à partir duquel les articles sont transférés.',
                                ENC='Specifies the name of the sender at the location that the items are transferred from.';
                }
                field("Transfer-from Name 2";"Transfer-from Name 2")
                {
                    ApplicationArea = Location;
                    Importance = Additional;
                    ToolTipML = ENU='Specifies an additional part of the name of the sender at the location that the items are transferred from.',
                                ESM='Especifica una parte adicional del nombre del remitente en la ubicación desde donde se transfieren los productos.',
                                FRC='Spécifie un complément pour le nom de l''expéditeur dans l''emplacement à partir duquel les articles sont transférés.',
                                ENC='Specifies an additional part of the name of the sender at the location that the items are transferred from.';
                }
                field("Transfer-from Address";"Transfer-from Address")
                {
                    ApplicationArea = Location;
                    Importance = Additional;
                    ToolTipML = ENU='Specifies the address of the location that the items are transferred from.',
                                ESM='Especifica la dirección de la ubicación desde donde se transfieren los productos.',
                                FRC='Spécifie l''adresse de l''emplacement à partir duquel les articles sont transférés.',
                                ENC='Specifies the address of the location that the items are transferred from.';
                }
                field("Transfer-from Address 2";"Transfer-from Address 2")
                {
                    ApplicationArea = Location;
                    Importance = Additional;
                    ToolTipML = ENU='Specifies an additional part of the address of the location that items are transferred from.',
                                ESM='Especifica una parte adicional de la dirección de la ubicación desde donde se transfieren los productos.',
                                FRC='Spécifie un complément pour l''adresse de l''emplacement à partir duquel les articles sont transférés.',
                                ENC='Specifies an additional part of the address of the location that items are transferred from.';
                }
                field("Transfer-from City";"Transfer-from City")
                {
                    ApplicationArea = Location;
                    Importance = Additional;
                    ToolTipML = ENU='Specifies the city of the location that the items are transferred from.',
                                ESM='Especifica el municipio/ciudad de la ubicación desde la que se transfieren los productos.',
                                FRC='Spécifie la ville de l''emplacement à partir duquel les articles sont transférés.',
                                ENC='Specifies the city of the location that the items are transferred from.';
                }
                field("Transfer-from County";"Transfer-from County")
                {
                    CaptionML = ENU='Transfer-from State / ZIP Code',
                                ESM='Transfer. desde-Estado / C.P.',
                                FRC='État-Prov./code postal prov. transfert',
                                ENC='Transfer-from Province/State / Postal/ZIP Code';
                    ToolTipML = ENU='Specifies the state and ZIP code where the items you want to move are located.',
                                ESM='Especifica el estado y el código postal de la ubicación en la que se encuentran los productos que desea mover.',
                                FRC='Spécifie la province et le code postal où sont situés les articles que vous souhaitez déplacer.',
                                ENC='Specifies the province/state and postal code where the items you want to move are located.';
                }
                field("Transfer-from Post Code";"Transfer-from Post Code")
                {
                    ApplicationArea = Location;
                    Importance = Additional;
                    ToolTipML = ENU='Specifies the ZIP Code of the location that the items are transferred from.',
                                ESM='Especifica el código postal de la ubicación desde donde se transfieren los productos.',
                                FRC='Spécifie le code postal de l''emplacement à partir duquel les articles sont transférés.',
                                ENC='Specifies the postal code of the location that the items are transferred from.';
                }
                field("Transfer-from Contact";"Transfer-from Contact")
                {
                    ApplicationArea = Location;
                    Importance = Additional;
                    ToolTipML = ENU='Specifies the name of the contact person at the location that the items are transferred from.',
                                ESM='Especifica el nombre de la persona de contacto en la ubicación desde donde se transfieren los productos.',
                                FRC='Spécifie le nom du contact dans l''emplacement à partir duquel les articles sont transférés.',
                                ENC='Specifies the name of the contact person at the location that the items are transferred from.';
                }
            }
            group("Transfer-to")
            {
                CaptionML = ENU='Transfer-to',
                            ESM='Transfer. a',
                            FRC='Dest. transfert',
                            ENC='Transfer-to';
                Editable = (Status = Status::Open) AND EnableTransferFields;
                Visible = false;
                field("Transfer-to Name";"Transfer-to Name")
                {
                    ApplicationArea = Location;
                    ToolTipML = ENU='Specifies the name of the recipient at the location that the items are transferred to.',
                                ESM='Especifica el nombre del destinatario en la ubicación a la que se transfieren los productos.',
                                FRC='Spécifie le nom du destinataire dans l''emplacement vers lequel les articles sont transférés.',
                                ENC='Specifies the name of the recipient at the location that the items are transferred to.';
                }
                field("Transfer-to Name 2";"Transfer-to Name 2")
                {
                    ApplicationArea = Location;
                    Importance = Additional;
                    ToolTipML = ENU='Specifies an additional part of the name of the recipient at the location that the items are transferred to.',
                                ESM='Especifica una parte adicional del nombre del destinatario en la ubicación a la que se transfieren los productos.',
                                FRC='Spécifie un complément pour le nom du destinataire dans l''emplacement vers lequel les articles sont transférés.',
                                ENC='Specifies an additional part of the name of the recipient at the location that the items are transferred to.';
                }
                field("Transfer-to Address";"Transfer-to Address")
                {
                    ApplicationArea = Location;
                    Importance = Additional;
                    ToolTipML = ENU='Specifies the address of the location that the items are transferred to.',
                                ESM='Especifica la dirección de la ubicación a la que se transfieren los productos.',
                                FRC='Spécifie l''adresse de l''emplacement vers lequel les articles sont transférés.',
                                ENC='Specifies the address of the location that the items are transferred to.';
                }
                field("Transfer-to Address 2";"Transfer-to Address 2")
                {
                    ApplicationArea = Location;
                    Importance = Additional;
                    ToolTipML = ENU='Specifies an additional part of the address of the location that the items are transferred to.',
                                ESM='Especifica una parte adicional de la dirección de la ubicación a la que se transfieren los productos.',
                                FRC='Spécifie un complément pour l''adresse de l''emplacement vers lequel les articles sont transférés.',
                                ENC='Specifies an additional part of the address of the location that the items are transferred to.';
                }
                field("Transfer-to City";"Transfer-to City")
                {
                    ApplicationArea = Location;
                    Importance = Additional;
                    ToolTipML = ENU='Specifies the city of the location that items are transferred to.',
                                ESM='Especifica la localidad de la ubicación a la que se transfieren los productos.',
                                FRC='Spécifie la ville de l''emplacement vers lequel les articles sont transférés.',
                                ENC='Specifies the city of the location that items are transferred to.';
                }
                field("Transfer-to County";"Transfer-to County")
                {
                    CaptionML = ENU='Transfer-to State / ZIP Code',
                                ESM='Transfer. a-Estado / C.P.',
                                FRC='État-Prov./code postal dest. transfert',
                                ENC='Transfer-to Province/State / Postal/ZIP Code';
                    ToolTipML = ENU='Specifies the state and ZIP code for the transfer order.',
                                ESM='Especifica el estado y el código postal de la orden de transferencia.',
                                FRC='Spécifie la province et le code postal pour l''ordre de transfert.',
                                ENC='Specifies the province/state and postal code for the transfer order.';
                }
                field("Transfer-to Post Code";"Transfer-to Post Code")
                {
                    ApplicationArea = Location;
                    Importance = Additional;
                    ToolTipML = ENU='Specifies the ZIP Code of the location that the items are transferred to.',
                                ESM='Especifica el código postal de la ubicación a la que se transfieren los productos.',
                                FRC='Spécifie le code postal de l''emplacement vers lequel les articles sont transférés.',
                                ENC='Specifies the postal code of the location that the items are transferred to.';
                }
                field("Transfer-to Contact";"Transfer-to Contact")
                {
                    ApplicationArea = Location;
                    Importance = Additional;
                    ToolTipML = ENU='Specifies the name of the contact person at the location that items are transferred to.',
                                ESM='Especifica el nombre de la persona de contacto en la ubicación a la que se transfieren los productos.',
                                FRC='Spécifie le nom du contact dans l''emplacement vers lequel les articles sont transférés.',
                                ENC='Specifies the name of the contact person at the location that items are transferred to.';
                }
                field("Inbound Whse. Handling Time";"Inbound Whse. Handling Time")
                {
                    ApplicationArea = Warehouse;
                    ToolTipML = ENU='Specifies the time it takes to make items part of available inventory, after the items have been posted as received.',
                                ESM='Especifica el tiempo que se tarda en hacer que los productos formen parte de las existencias disponibles tras haber registrado los productos como recibidos.',
                                FRC='Indique le temps nécessaire pour que les articles soient inclus dans l''inventaire disponible, une fois les articles reportés comme reçus.',
                                ENC='Specifies the time it takes to make items part of available inventory, after the items have been posted as received.';

                    trigger OnValidate();
                    begin
                        InboundWhseHandlingTimeOnAfter;
                    end;
                }
            }
            group("Foreign Trade")
            {
                CaptionML = ENU='Foreign Trade',
                            ESM='Comercio exterior',
                            FRC='Commerce étranger',
                            ENC='Foreign Trade';
                Editable = (Status = Status::Open) AND EnableTransferFields;
                Visible = false;
                field("Transaction Type";"Transaction Type")
                {
                    ApplicationArea = Advanced;
                    Importance = Promoted;
                    ToolTipML = ENU='Specifies the type of transaction that the document represents, for the purpose of reporting to INTRASTAT.',
                                ESM='Especifica el tipo de transacción que representa el documento con el fin de notificarlo a INTRASTAT.',
                                FRC='Spécifie le type de transaction que représente le document, à des fins de compte-rendu à INTRASTAT.',
                                ENC='Specifies the type of transaction that the document represents, for the purpose of reporting to INTRASTAT.';
                }
                field("Transaction Specification";"Transaction Specification")
                {
                    ApplicationArea = Advanced;
                    ToolTipML = ENU='Specifies a specification of the document''s transaction, for the purpose of reporting to INTRASTAT.',
                                ESM='Especifica una especificación de transacción del documento de venta con el fin de notificarla a INTRASTAT.',
                                FRC='Spécifie une spécification de la transaction du document, à des fins de compte-rendu à INTRASTAT.',
                                ENC='Specifies a specification of the document''s transaction, for the purpose of reporting to INTRASTAT.';
                }
                field("Transport Method";"Transport Method")
                {
                    ApplicationArea = Advanced;
                    Importance = Promoted;
                    ToolTipML = ENU='Specifies the transport method, for the purpose of reporting to INTRASTAT.',
                                ESM='Especifica el modo de transporte con el fin de informar a INTRASTAT.',
                                FRC='Spécifie le mode de transport, à des fins de compte-rendu à INTRASTAT.',
                                ENC='Specifies the transport method, for the purpose of reporting to INTRASTAT.';
                }
                field("Area";Area)
                {
                    ApplicationArea = Advanced;
                    ToolTipML = ENU='Specifies the area of the customer or vendor, for the purpose of reporting to INTRASTAT.',
                                ESM='Especifica el área del cliente o proveedor con el fin de informar a INTRASTAT.',
                                FRC='Spécifie la région du client ou du fournisseur, à des fins de compte-rendu à INTRASTAT.',
                                ENC='Specifies the area of the customer or vendor, for the purpose of reporting to INTRASTAT.';
                }
                field("Entry/Exit Point";"Entry/Exit Point")
                {
                    ApplicationArea = Advanced;
                    ToolTipML = ENU='Specifies the code of either the port of entry at which the items passed into your country/region, or the port of exit.',
                                ESM='Especifica el código del puerto de entrada por el que entraron los productos al país o la región, o el puerto de salida.',
                                FRC='Spécifie le code du port d''entrée par lequel les articles sont entrés dans votre pays/région ou du port de sortie.',
                                ENC='Specifies the code of either the port of entry at which the items passed into your country/region, or the port of exit.';
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
        area(navigation)
        {
        }
        area(processing)
        {
            group("P&osting")
            {
                CaptionML = ENU='P&osting',
                            ESM='&Registro',
                            FRC='Rep&ort',
                            ENC='P&osting';
                Image = Post;
                action(DXCPostShipment)
                {
                    ApplicationArea = Location;
                    CaptionML = ENU='Post Shipment',
                                ESM='&Registrar',
                                FRC='Rep&orter',
                                ENC='P&ost';
                    Ellipsis = true;
                    Image = PostOrder;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ShortCutKey = 'F9';
                    ToolTipML = ENU='Finalize the document or journal by posting the amounts and quantities to the related accounts in your company books.',
                                ESM='Permite finalizar el documento o el diario registrando los importes y las cantidades en las cuentas relacionadas de los libros de su empresa.',
                                FRC='Finalisez le document ou le journal en reportant les montants et les quantités sur les comptes concernés dans les registres de la compagnie.',
                                ENC='Finalize the document or journal by posting the amounts and quantities to the related accounts in your company books.';
                    Visible = false;
                    trigger OnAction();
                    var
                        TransferOrderShip : Codeunit "DXC Transfer Order Ship";
                    begin
                        TransferOrderShip.Post(Rec);
                    end;
                }
                action(DXCPostReceipt)
                {
                    ApplicationArea = Location;
                    CaptionML = ENU='Post Receipt',
                                ESM='&Registrar',
                                FRC='Rep&orter',
                                ENC='P&ost';
                    Ellipsis = true;
                    Image = PostOrder;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ShortCutKey = 'F9';
                    ToolTipML = ENU='Finalize the document or journal by posting the amounts and quantities to the related accounts in your company books.',
                                ESM='Permite finalizar el documento o el diario registrando los importes y las cantidades en las cuentas relacionadas de los libros de su empresa.',
                                FRC='Finalisez le document ou le journal en reportant les montants et les quantités sur les comptes concernés dans les registres de la compagnie.',
                                ENC='Finalize the document or journal by posting the amounts and quantities to the related accounts in your company books.';
                    Visible = false;
                    trigger OnAction();
                    var
                        TransferOrderReceive : Codeunit "DXC Transfer Order Receive";
                    begin

                        TransferOrderReceive.Post(Rec);
                    end;
                }

                 action(DXCPost)
                {
                    ApplicationArea = Location;
                    CaptionML = ENU='Post',
                                ESM='&Registrar',
                                FRC='Rep&orter',
                                ENC='P&ost';
                    Ellipsis = true;
                    Image = PostOrder;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ShortCutKey = 'F9';
                    Visible = true;
                    ToolTipML = ENU='Finalize the document or journal by posting the amounts and quantities to the related accounts in your company books.',
                                ESM='Permite finalizar el documento o el diario registrando los importes y las cantidades en las cuentas relacionadas de los libros de su empresa.',
                                FRC='Finalisez le document ou le journal en reportant les montants et les quantités sur les comptes concernés dans les registres de la compagnie.',
                                ENC='Finalize the document or journal by posting the amounts and quantities to the related accounts in your company books.';

                    trigger OnAction();
                    var
                        TransferOrderReceive : Codeunit "DXC Transfer Order Receive";
                        TransferOrderShip : Codeunit "DXC Transfer Order Ship";
                        TransferLine : Record "Transfer Line";
                        Location : Record Location;
                    begin 
                        TransferLine.SetRange("Document No.",Rec."No."); 
                        if TransferLine.FindFirst then begin                            
                            if (TransferLine."DXC Transfer-from Bin DPP" <> '') then
                                TransferOrderShip.Post(Rec)  
                            else if (TransferLine."DXC Transfer-to Bin DPP" <> '') then
                                TransferOrderReceive.Post(Rec)
                            else if ((TransferLine."Transfer-from Bin Code" <> '') AND (TransferLine."Transfer-to Bin Code" = '')) then
                                TransferOrderShip.Post(Rec) 
                            else if ((TransferLine."Transfer-to Bin Code" <> '') AND (TransferLine."Transfer-from Bin Code" = '')) then
                                TransferOrderReceive.Post(Rec)
                            else if ((TransferLine."Transfer-to Bin Code" <> '') AND (TransferLine."Transfer-from Bin Code" <> '')) then
                                TransferOrderShip.Post(Rec)    
                            else if ((TransferLine."Transfer-to Bin Code" = '') AND (TransferLine."Transfer-from Bin Code" = '')) then
                                TransferOrderShip.Post(Rec);                         
                        end;                         
                    end;
                }
            }
        }
        area(reporting)
        {
        }
    }

    trigger OnAfterGetCurrRecord();
    begin
        if not DisableEditDirectTransfer then
          DisableEditDirectTransfer := "Direct Transfer" and HasTransferLines;
    end;

    trigger OnAfterGetRecord();
    begin
        EnableTransferFields := not IsPartiallyShipped;
    end;

    // trigger OnDeleteRecord() : Boolean;
    // begin
    //     TESTFIELD(Status,Status::Open);
    // end;

    trigger OnOpenPage();
    begin
        SetDocNoVisible;
        EnableTransferFields := not IsPartiallyShipped;
    end; 

    trigger OnNewRecord(BelowxRec : Boolean)
    begin
        //"DXC Post Automation" := true;    
    end;   

    trigger OnInsertRecord(BelowxRec : Boolean) : Boolean;
    begin
        "DXC Post Automation" := true; 
        EXIT(true);
    end;

    var
        Text000 : TextConst ENU='Do you want to change %1 in all related records in the warehouse?',ESM='¿Desea cambiar %1 en todos los registros relacionados del almacén?',FRC='Souhaitez-vous modifier %1 dans tous les enregistrements associés de l''entrepôt ?',ENC='Do you want to change %1 in all related records in the warehouse?';
        DocNoVisible : Boolean;
        DisableEditDirectTransfer : Boolean;
        EnableTransferFields : Boolean;

    local procedure PostingDateOnAfterValidate();
    begin
        CurrPage.TransferLines.PAGE.UpdateForm(true);
    end;

    local procedure ShipmentDateOnAfterValidate();
    begin
        CurrPage.TransferLines.PAGE.UpdateForm(false);
    end;

    local procedure ShippingAgentServiceCodeOnAfte();
    begin
        CurrPage.TransferLines.PAGE.UpdateForm(false);
    end;

    local procedure ShippingAgentCodeOnAfterValida();
    begin
        CurrPage.TransferLines.PAGE.UpdateForm(false);
    end;

    local procedure ShippingTimeOnAfterValidate();
    begin
        CurrPage.TransferLines.PAGE.UpdateForm(false);
    end;

    local procedure OutboundWhseHandlingTimeOnAfte();
    begin
        CurrPage.TransferLines.PAGE.UpdateForm(false);
    end;

    local procedure ReceiptDateOnAfterValidate();
    begin
        CurrPage.TransferLines.PAGE.UpdateForm(false);
    end;

    local procedure InboundWhseHandlingTimeOnAfter();
    begin
        CurrPage.TransferLines.PAGE.UpdateForm(false);
    end;

    local procedure SetDocNoVisible();
    var
        DocumentNoVisibility : Codeunit DocumentNoVisibility;
    begin
        DocNoVisible := DocumentNoVisibility.TransferOrderNoIsVisible;
    end;

    local procedure IsPartiallyShipped() : Boolean;
    var
        TransferLine : Record "Transfer Line";
    begin
        TransferLine.SETRANGE("Document No.","No.");
        TransferLine.SETFILTER("Quantity Shipped",'> 0');
        exit(not TransferLine.ISEMPTY);
    end;
}

