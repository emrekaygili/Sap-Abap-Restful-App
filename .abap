# Sap-Abap-Restful-App
Restful Market Application 


//DATABASE CREATİNG

@EndUserText.label : 'Groceries'
@AbapCatalog.enhancement.category : #NOT_EXTENSIBLE
@AbapCatalog.tableCategory : #TRANSPARENT
@AbapCatalog.deliveryClass : #A
@AbapCatalog.dataMaintenance : #RESTRICTED
define table z01_grocery {

  key client : abap.clnt not null;
  key id : sysuuid_x16 not null;
  product : abap.char(40);
  category : abap.char(40);
  brand : abap.char(40);
  @Semantics.amount.currencyCode : 'z01_grocery.currency'
  price : abap.curr(10,2);
  currency : abap.cuky;
  quantity : abap.int2;
  purchasedate : abap.dats;
  expirationdate : abap.dats;
  expired : abap_boolean;
  rating : abap.fltp;
  note : abap.char(255);
  createdby : abap.char(12);
  createdat : tzntstmpl;
  lastchangedby : abap.char(12);
  lastchangedat : abp_lastchange_tstmpl;
  locallastchanged : abp_locinst_lastchange_tstmpl;

}


//Additional objects for the Grocery App

//Enabling Search Capabilities

@AccessControl.authorizationCheck: #CHECK

@EndUserText.label: 'Projection View for ZR_01_GROCERY'
define root view entity ZC_01_GROCERY
  provider contract transactional_query
  as projection on ZR_01_GROCERY
{
    key ID,
    
    Product,
    
    Category,
    
    Brand,
    Price,
    Currency,
    Quantity,
    PurchaseDate,
    
    ExpirationDate,
    
    Expired,
    
    Rating,
    Note,
    CreatedBy,
    CreatedAt,
    LastChangedBy,
    LocalLastChanged
}


//Check Product Expiration Date
CLASS lhc_grocery DEFINITION INHERITING FROM cl_abap_behavior_handler.
    PRIVATE SECTION.
      METHODS:
        get_global_authorizations FOR GLOBAL AUTHORIZATION
            IMPORTING
            REQUEST requested_authorizations FOR Grocery
            RESULT result,
        checkExpirationDate FOR MODIFY
            IMPORTING keys FOR ACTION Grocery~checkExpirationDate RESULT result.
ENDCLASS.

CLASS lhc_grocery IMPLEMENTATION.

METHOD get_global_authorizations.
ENDMETHOD.

METHOD checkExpirationDate.

    DATA: lt_groceries TYPE TABLE FOR READ RESULT zr_01_grocery,
          ls_grocery TYPE STRUCTURE FOR READ RESULT zr_01_grocery,
          lv_expiration TYPE d,
          lv_current_date TYPE d,
          lv_expired TYPE abap_boolean,
          lt_update_groceries TYPE TABLE FOR UPDATE zr_01_grocery.

    READ ENTITIES OF zr_01_grocery
      IN LOCAL MODE ENTITY Grocery
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT lt_groceries.

    LOOP AT lt_groceries INTO ls_grocery.
      lv_expiration = ls_grocery-Expirationdate.
      lv_current_date = cl_abap_context_info=>get_system_date( ).
      IF lv_expiration < lv_current_date.
        lv_expired = abap_true.
      ELSE.
        lv_expired = abap_false.
      ENDIF.

    APPEND VALUE #( id = ls_grocery-Id expired = lv_expired )
      TO lt_update_groceries.
    MODIFY ENTITIES OF zr_01_grocery IN LOCAL MODE
      ENTITY Grocery
      UPDATE FIELDS ( expired )
      WITH lt_update_groceries.
    ENDLOOP.

    result = VALUE #( FOR groceries IN lt_groceries
      ( id = groceries-id %param = groceries ) ).
ENDMETHOD.
ENDCLASS.


//METADATE DESCRIBING

@Metadata.layer: #CORE
@UI: {
    headerInfo: {
    typeName: 'Sustainable Grocery App',
    typeNamePlural: 'Sustainable Groceries App'
  }
}
annotate view ZC_XX_GROCERY with
{
  @UI.facet: [ {
    id: 'idIdentification',
    type: #IDENTIFICATION_REFERENCE,
    label: 'Sustainable Groceries App',
    position: 10
  } ]
  @UI: { lineItem: [ { exclude: true } ,
  { type: #FOR_ACTION,
    dataAction: 'checkExpirationDate' ,
    label: 'Check for expiration' } ] ,
identification: [ { position: 1, label: 'ID' } ,
  { type: #FOR_ACTION,
    dataAction: 'checkExpirationDate',
    label: 'Check for expiration' } ] }

    @UI.hidden: true
    ID;

    @UI.lineItem: [ {
      position: 10 ,
      importance: #HIGH,
      label: 'Product'
    } ]
    @UI.identification: [ {
      position: 10 ,
      label: 'Product'
    } ]
    Product;

    @UI.lineItem: [ {
      position: 20 ,
      importance: #MEDIUM,
      label: 'Category'
    } ]
    @UI.identification: [ {
      position: 20 ,
      label: 'Category'
    } ]
    Category;

    @UI.lineItem: [ {
      position: 30 ,
      importance: #MEDIUM,
      label: 'Brand'
    } ]
    @UI.identification: [ {
      position: 30 ,
      label: 'Brand'
    } ]
    Brand;

    @UI.lineItem: [ {
      position: 40 ,
      importance: #MEDIUM,
      label: 'Price/Currency'
    } ]
    @UI.identification: [ {
      position: 40 ,
      label: 'Price/Currency'
    } ]
    Price;

    @UI.hidden: true
    Currency;

    @UI.lineItem: [ {
      position: 60 ,
      importance: #MEDIUM,
      label: 'Quantity'
    } ]
    @UI.identification: [ {
      position: 60 ,
      label: 'Quantity'
    } ]
    Quantity;

    @UI.lineItem: [ {
      position: 70 ,
      importance: #MEDIUM,
      label: 'Purchase Date'
    } ]
    @UI.identification: [ {
      position: 70 ,
      label: 'Purchase Date'
    } ]
    PurchaseDate;

    @UI.lineItem: [ {
      position: 80 ,
      importance: #MEDIUM,
      label: 'Expiration Date'
    } ]
    @UI.identification: [ {
      position: 80 ,
      label: 'Expiration Date'
    } ]
    ExpirationDate;

    @UI.lineItem: [ {
      position: 90 ,
      importance: #MEDIUM,
      label: 'Expired'
    } ]
    @UI.identification: [ {
    position: 90,
    label: 'Expired'
    } ]
    Expired;

    @UI.lineItem: [ {
      position: 100 ,
      importance: #MEDIUM,
      label: 'Rating'
    } ]
    @UI.identification: [ {
      position: 100 ,
      label: 'Rating'
    } ]
    Rating;

    @UI.lineItem: [ {
      position: 110 ,
      importance: #MEDIUM,
      label: 'Note'
    } ]
    @UI.identification: [ {
      position: 110 ,
      label: 'Note'
    } ]
    Note;

    @UI.hidden: true
    CreatedBy;
  
    @UI.hidden: true
    CreatedAt;

    @UI.hidden: true
    LastChangedBy;

    @UI.hidden: true
    LocalLastChanged;
}

