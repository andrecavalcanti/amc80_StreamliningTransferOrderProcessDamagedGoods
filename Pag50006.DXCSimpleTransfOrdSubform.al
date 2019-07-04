page 50006 "DXC Simple Transf Ord  Subform"
{ 
    AutoSplitKey = true;
    CaptionML = ENU='Lines',
                ESM='Líneas',
                FRC='Lignes',
                ENC='Lines';
    DelayedInsert = true;
    LinksAllowed = false;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = "Transfer Line";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Item No.";"Item No.")
                {
                    ApplicationArea = Location;
                    ToolTipML = ENU='Specifies the number of the item that will be transferred.',
                                ESM='Especifica el número del producto que se va a transferir.',
                                FRC='Indique le numéro de l''article qui va être transféré.',
                                ENC='Specifies the number of the item that will be transferred.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Location;
                    ToolTipML = ENU='Specifies a description of the entry.',
                                ESM='Especifica una descripción del movimiento.',
                                FRC='Spécifie une description de l''écriture.',
                                ENC='Specifies a description of the entry.';
                }
                field("Transfer-from Bin Code";"Transfer-from Bin Code")
                {
                    ApplicationArea = Warehouse;
                    ToolTipML = ENU='Specifies the code for the bin that the items are transferred from.',
                                ESM='Especifica el código de la ubicación desde donde se transfieren los productos.',
                                FRC='Spécifie le code de la zone à partir de laquelle les articles sont transférés.',
                                ENC='Specifies the code for the bin that the items are transferred from.';
                    Visible = false;
                }
                field("DXC Transfer-from Bin DPP";"DXC Transfer-from Bin DPP")
                {
                }
                field("Transfer-To Bin Code";"Transfer-To Bin Code")
                {
                    ApplicationArea = Warehouse;
                    ToolTipML = ENU='Specifies the code for the bin that the items are transferred to.',
                                ESM='Especifica el código de la ubicación a la que se transfieren los productos.',
                                FRC='Spécifie le code de la zone vers laquelle les articles sont transférés.',
                                ENC='Specifies the code for the bin that the items are transferred to.';
                    Visible = false;
                }
                field("DXC Transfer-To Bin DPP";"DXC Transfer-To Bin DPP")
                {
                }
                field(Quantity;Quantity)
                {
                    ApplicationArea = Location;
                    BlankZero = true;
                    ToolTipML = ENU='Specifies the quantity of the item that will be processed as the document stipulates.',
                                ESM='Especifica la cantidad del producto que se procesará según se estipule en el documento.',
                                FRC='Indique la quantité de l''article qui sera traitée sur la base des indications du document.',
                                ENC='Specifies the quantity of the item that will be processed as the document stipulates.';
                }
                field("Unit of Measure Code";"Unit of Measure Code")
                {
                    ApplicationArea = Location;
                    ToolTipML = ENU='Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.',
                                ESM='Especifica cómo se mide cada unidad del producto o el recurso, por ejemplo, en piezas u horas. De forma predeterminada, se inserta el valor en el campo Unidad de medida base de la ficha de producto o recurso.',
                                FRC='Spécifie la manière dont chaque unité de mesure de l''article ou de la ressource est mesurée, par exemple en unité de mesures ou en heures. Par défaut, la valeur du champ unité de mesure de base de la fiche article ou la ressource est insérée.',
                                ENC='Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.';
                }
                field("Unit of Measure";"Unit of Measure")
                {
                    ApplicationArea = Location;
                    ToolTipML = ENU='Specifies the name of the item or resource''s unit of measure, such as piece or hour.',
                                ESM='Especifica el nombre de la unidad de medida del producto o recurso, como la unidad o la hora.',
                                FRC='Spécifie le nom de l''unité de mesure de l''article ou de la ressource, par exemple pièce ou heure.',
                                ENC='Specifies the name of the item or resource''s unit of measure, such as piece or hour.';
                    Visible = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("F&unctions")
            {
                CaptionML = ENU='F&unctions',
                            ESM='Acci&ones',
                            FRC='F&onctions',
                            ENC='F&unctions';
                Image = "Action";
                Visible = false;
                action(Reserve)
                {
                    ApplicationArea = Advanced;
                    CaptionML = ENU='&Reserve',
                                ESM='&Reservar',
                                FRC='&Réserver',
                                ENC='&Reserve';
                    Image = Reserve;
                    ToolTipML = ENU='Reserve the quantity that is required on the document line that you opened this window for.',
                                ESM='Reservar la cantidad necesaria en la línea de documento para la que abrió esta ventana.',
                                FRC='Réserver la quantité qui est requise sur la ligne document pour laquelle vous avez ouvert cette fenêtre.',
                                ENC='Reserve the quantity that is required on the document line that you opened this window for.';

                    trigger OnAction();
                    begin
                        FIND;
                        ShowReservation;
                    end;
                }
            }
            group("&Line")
            {
                CaptionML = ENU='&Line',
                            ESM='&Línea',
                            FRC='&Ligne',
                            ENC='&Line';
                Image = Line;
                group("Item Availability by")
                {
                    CaptionML = ENU='Item Availability by',
                                ESM='Disponibilidad prod. por',
                                FRC='Disponibilité d''article par',
                                ENC='Item Availability by';
                    Image = ItemAvailability;
                    Visible = false;
                    action("Event")
                    {
                        ApplicationArea = Basic,Suite;
                        CaptionML = ENU='Event',
                                    ESM='Evento',
                                    FRC='Événement',
                                    ENC='Event';
                        Image = "Event";
                        ToolTipML = ENU='View how the actual and the projected available balance of an item will develop over time according to supply and demand events.',
                                    ESM='Permite ver cómo el saldo disponible real y previsto de un artículo se desarrollará a lo largo del tiempo según la oferta y la demanda.',
                                    FRC='Affichez le développement du niveau d''inventaire réel et prévisionnel d''un article dans le temps en fonction des événements de l''offre et de la demande.',
                                    ENC='View how the actual and the projected available balance of an item will develop over time according to supply and demand events.';

                        trigger OnAction();
                        begin
                            ItemAvailFormsMgt.ShowItemAvailFromTransLine(Rec,ItemAvailFormsMgt.ByEvent);
                        end;
                    }
                    action(Period)
                    {
                        ApplicationArea = Basic,Suite;
                        CaptionML = ENU='Period',
                                    ESM='Periodo',
                                    FRC='Période',
                                    ENC='Period';
                        Image = Period;
                        ToolTipML = ENU='Show the projected quantity of the item over time according to time periods, such as day, week, or month.',
                                    ESM='Muestra la cantidad proyectada del producto a lo largo de los periodos de tiempo, como días, semanas o meses.',
                                    FRC='Affichez la quantité prévisionnelle de l''article dans le temps en fonction de périodes de temps, par exemple jour, semaine ou mois.',
                                    ENC='Show the projected quantity of the item over time according to time periods, such as day, week, or month.';

                        trigger OnAction();
                        begin
                            ItemAvailFormsMgt.ShowItemAvailFromTransLine(Rec,ItemAvailFormsMgt.ByPeriod);
                        end;
                    }
                    action(Variant)
                    {
                        ApplicationArea = Advanced;
                        CaptionML = ENU='Variant',
                                    ESM='Variante',
                                    FRC='Variante',
                                    ENC='Variant';
                        Image = ItemVariant;
                        ToolTipML = ENU='View or edit the item''s variants. Instead of setting up each color of an item as a separate item, you can set up the various colors as variants of the item.',
                                    ESM='Permite ver o editar las variantes del artículo. En lugar de configurar cada color de un artículo como un artículo diferente, puede configurar varios colores como variantes del artículo.',
                                    FRC='Afficher ou modifier les variantes article. Au lieu de créer chaque couleur pour un article en tant qu''article séparé, vous pouvez spécifier les différentes couleurs comme variantes de l''article.',
                                    ENC='View or edit the item''s variants. Instead of setting up each colour of an item as a separate item, you can set up the various colours as variants of the item.';

                        trigger OnAction();
                        begin
                            ItemAvailFormsMgt.ShowItemAvailFromTransLine(Rec,ItemAvailFormsMgt.ByVariant);
                        end;
                    }
                    action(Location)
                    {
                        AccessByPermission = TableData Location=R;
                        ApplicationArea = Location;
                        CaptionML = ENU='Location',
                                    ESM='Almacén',
                                    FRC='Emplacement',
                                    ENC='Location';
                        Image = Warehouse;
                        ToolTipML = ENU='View the actual and projected quantity of the item per location.',
                                    ESM='Permite ver la cantidad real y proyectada del producto por ubicación.',
                                    FRC='Affichez la quantité réelle et prévisionnelle de l''article par emplacement.',
                                    ENC='View the actual and projected quantity of the item per location.';

                        trigger OnAction();
                        begin
                            ItemAvailFormsMgt.ShowItemAvailFromTransLine(Rec,ItemAvailFormsMgt.ByLocation);
                        end;
                    }
                    action("BOM Level")
                    {
                        ApplicationArea = Advanced;
                        CaptionML = ENU='BOM Level',
                                    ESM='Nivel L.M.',
                                    FRC='Niveau nomenclature',
                                    ENC='BOM Level';
                        Image = BOMLevel;
                        ToolTipML = ENU='View availability figures for items on bills of materials that show how many units of a parent item you can make based on the availability of child items.',
                                    ESM='Permite ver las cifras correspondientes a los productos en listas de materiales que indican cuántas unidades de un producto principal puede producir según la disponibilidad de productos secundarios.',
                                    FRC='Affichez les chiffres de disponibilité pour les articles de nomenclature qui indiquent combien d''unités d''un parent vous pouvez effectuer sur la base de la disponibilité des éléments enfant.',
                                    ENC='View availability figures for items on bills of materials that show how many units of a parent item you can make based on the availability of child items.';

                        trigger OnAction();
                        begin
                            ItemAvailFormsMgt.ShowItemAvailFromTransLine(Rec,ItemAvailFormsMgt.ByBOM);
                        end;
                    }
                }
                action(Dimensions)
                {
                    AccessByPermission = TableData Dimension=R;
                    ApplicationArea = Suite;
                    CaptionML = ENU='Dimensions',
                                ESM='Dimensiones',
                                FRC='Dimensions',
                                ENC='Dimensions';
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';
                    ToolTipML = ENU='View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.',
                                ESM='Permite ver o editar dimensiones, como el área, el proyecto o el departamento, que pueden asignarse a los documentos de venta y compra para distribuir costos y analizar el historial de transacciones.',
                                FRC='Affichez ou modifiez les dimensions, telles que la zone, le projet ou le département que vous pouvez affecter aux documents vente et achat afin de distribuer les coûts et analyser l''historique des transactions.',
                                ENC='View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyse transaction history.';
                    Visible = false;

                    trigger OnAction();
                    begin
                        ShowDimensions;
                    end;
                }
                group("Item &Tracking Lines")
                {
                    CaptionML = ENU='Item &Tracking Lines',
                                ESM='Líns. se&guim. prod.',
                                FRC='&Lignes de traçabilité d''article',
                                ENC='Item &Tracking Lines';
                    Image = AllLines;
                    Visible = false;
                    action(Shipment)
                    {
                        ApplicationArea = ItemTracking;
                        CaptionML = ENU='Shipment',
                                    ESM='Envío',
                                    FRC='Livraison',
                                    ENC='Shipment';
                        Image = Shipment;
                        ToolTipML = ENU='View or edit serial numbers and lot numbers that are assigned to the item on the document or journal line.',
                                    ESM='Permite ver o editar números de serie y números de lote asignados al producto en el documento o la línea del diario.',
                                    FRC='Affichez ou modifiez des numéros de série et de lot qui sont assignés à l''article sur la ligne document ou journal.',
                                    ENC='View or edit serial numbers and lot numbers that are assigned to the item on the document or journal line.';

                        trigger OnAction();
                        begin
                            OpenItemTrackingLines(0);
                        end;
                    }
                    action(Receipt)
                    {
                        ApplicationArea = ItemTracking;
                        CaptionML = ENU='Receipt',
                                    ESM='Recepción',
                                    FRC='Réception',
                                    ENC='Receipt';
                        Image = Receipt;
                        ToolTipML = ENU='View or edit serial numbers and lot numbers that are assigned to the item on the document or journal line.',
                                    ESM='Permite ver o editar números de serie y números de lote asignados al producto en el documento o la línea del diario.',
                                    FRC='Affichez ou modifiez des numéros de série et de lot qui sont assignés à l''article sur la ligne document ou journal.',
                                    ENC='View or edit serial numbers and lot numbers that are assigned to the item on the document or journal line.';

                        trigger OnAction();
                        begin
                            OpenItemTrackingLines(1);
                        end;
                    }
                }                
            }
        }
    }

    trigger OnAfterGetRecord();
    begin
        ShowShortcutDimCode(ShortcutDimCode);
    end;

    trigger OnDeleteRecord() : Boolean;
    var
        ReserveTransferLine : Codeunit "Transfer Line-Reserve";
    begin
        COMMIT;
        if not ReserveTransferLine.DeleteLineConfirm(Rec) then
          exit(false);
        ReserveTransferLine.DeleteLine(Rec);
    end;

    trigger OnNewRecord(BelowxRec : Boolean);
    begin
        CLEAR(ShortcutDimCode);
    end;

    var
        ItemAvailFormsMgt : Codeunit "Item Availability Forms Mgt";
        ShortcutDimCode : array [8] of Code[20];

    [Scope('Personalization')]
    procedure UpdateForm(SetSaveRecord : Boolean);
    begin
        CurrPage.UPDATE(SetSaveRecord);
    end;
}

