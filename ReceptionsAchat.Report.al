report 50108 "Receptions Achat"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    // Use an RDL layout.
    DefaultLayout = RDLC;

    // Specify the name of the file that the report will use for the layout.
    RDLCLayout = 'ReceptionsAchat.rdl';



    dataset
    {
        dataitem("Purch. Rcpt. Line"; "Purch. Rcpt. Line")
        {
            column(No_; "No.")
            {

            }
            column(Order_Date; "Order Date")
            {

            }
            column(Posting_Date; "Posting Date")
            {

            }
            column(Buy_from_Vendor_No_; "Buy-from Vendor No.")
            {

            }
            column(Description; Description)
            {

            }
            column(Quantity; Quantity)
            {

            }
            column(Qty__Invoiced__Base_; "Qty. Invoiced (Base)")
            {

            }

            trigger OnAfterGetRecord()
            begin

                datereceptionconfirm := 0D;
                Qtereçue := 0;
                PurchaseLine.RESET;
                PurchaseLine.SETRANGE(Type, PurchaseLine.Type::Item);
                PurchaseLine.SETRANGE("Document No.", "Order No.");
                PurchaseLine.SETRANGE("Line No.", "Order Line No.");
                PurchaseLine.SETRANGE("No.", "No.");
                IF PurchaseLine.FINDSET THEN BEGIN
                    Qtereçue := PurchaseLine."Quantity Received";
                    datereceptionconfirm := PurchaseLine."Promised Receipt Date";
                END;
                //Nom fournisseur
                NameVendor := '';
                NFacture := '';
                MontantTTC := 0;
                PrixUnitaire := 0;
                IF Vendor.GET("Purch. Rcpt. Line"."Buy-from Vendor No.") THEN
                    NameVendor := Vendor.Name;
                //
                PrixUnitaire := 0;
                MontantHT := 0;
                Qtefacture := 0;
                PurcInLine.RESET;
                PurcInLine.SETRANGE("Receipt No.", "Document No.");
                PurcInLine.SETRANGE("Receipt Line No.", "Line No.");
                PurcInLine.SETRANGE("No.", "No.");
                IF PurcInLine.FINDSET THEN BEGIN
                    //PrixUnitaire := PurcInLine."Unit Price per P. Price UOM";
                    MontantHT := PurcInLine.Amount;
                    MontantTTC := PurcInLine."Amount Including VAT";
                    NFacture := PurcInLine."Document No.";
                    Qtefacture := PurcInLine.Quantity;
                END;
            end;

        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    //field(Name; SourceExpression)
                    //{
                    //   ApplicationArea = All;

                    //}
                }
            }
        }

        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;

                }
            }
        }
    }

    //rendering
    //{
    //   layout(LayoutName)
    //  {
    //      Type = RDLC;
    //     LayoutFile = 'mylayout.rdl';
    // }
    //}

    var
        myInt: Integer;
        NameVendor: Text;
        Filter: Text;
        Qtereçue: Decimal;
        Qtefacture: Decimal;
        PrixUnitaire: Decimal;
        MontantHT: Decimal;
        MontantTTC: Decimal;
        Numcommande: Code[20];
        NFacture: Code[20];
        PurchaseLine: Record "Purchase Line";
        Vendor: Record "Vendor";
        PurcInLine: Record "Purch. Inv. Line";

        datereceptionconfirm: Date;




}