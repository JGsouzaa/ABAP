class ZCLTDF_HANA_INSTANCE definition
  public
  final
  create public .

public section.

  class-methods BUILD_QUERY
    importing
      !I_SCHEMA type STRING
      !I_TABLE_NAME type STRING
      !I_FIELDS type STRING default '*'
      !I_CONDITIONS type STRING optional
    returning
      value(E_QUERY) type STRING .
  class-methods EXECUTE_QUERY
    importing
      !I_QUERY type STRING
      !I_TYPE_TABLE type STRING
    exporting
      value(ET_RESULT) type ANY TABLE .
protected section.
private section.
ENDCLASS.



CLASS ZCLTDF_HANA_INSTANCE IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCLTDF_HANA_INSTANCE=>BUILD_QUERY
* +-------------------------------------------------------------------------------------------------+
* | [--->] I_SCHEMA                       TYPE        STRING
* | [--->] I_TABLE_NAME                   TYPE        STRING
* | [--->] I_FIELDS                       TYPE        STRING (default ='*')
* | [--->] I_CONDITIONS                   TYPE        STRING(optional)
* | [<-()] E_QUERY                        TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method BUILD_QUERY.

    e_query = |SELECT { i_fields } FROM "{ i_schema }"."{ i_table_name }" { i_conditions }|.

  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCLTDF_HANA_INSTANCE=>EXECUTE_QUERY
* +-------------------------------------------------------------------------------------------------+
* | [--->] I_QUERY                        TYPE        STRING
* | [--->] I_TYPE_TABLE                   TYPE        STRING
* | [<---] ET_RESULT                      TYPE        ANY TABLE
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method EXECUTE_QUERY.

    DATA: lt_data TYPE REF TO data.
*          lv_return TYPE REF TO data .

    FIELD-SYMBOLS: <fs_result> TYPE any TABLE.

    TRY.

      GET REFERENCE OF et_result INTO lt_data.

      ASSIGN lt_data->* TO <fs_result>.

      CALL METHOD /tmf/cl_data_access=>execute_select_hana
        EXPORTING
          iv_sql    = i_query
        IMPORTING
          et_result = <fs_result>.

      IF NOT <fs_result>[] IS INITIAL.
*        lv_return[] = <fs_result>[].
        et_result = <fs_result>[].
      ENDIF.

*      et_result = lv_return.

      CATCH /tmf/cx_data_access INTO DATA(lx_exception).
        DATA(_erro) = lx_exception->get_message(  ).
    ENDTRY.

  endmethod.
ENDCLASS.