This file is to present how to avoid some numeric issues you can get using GUI_DOWNLOAD function in ABAP to export some data to excel

Here we have an example where I need to extract some HR data from info types IT000 IT0001 IT0185 and retrieve some amounts from payroll data

My SAP was in spanish because it was on an job environment, all sensitive information was censored and none of the clients data was revealed
This was developed and tested on an DEV environment, program names and specific conditions were not showed on this case of study


To beggin we can make some text elements with =" and " because excel can interpret some between these two as a text format:

![abap1](https://github.com/JGsouzaa/ABAP/assets/99425339/d27e0999-abb4-4e4d-99f5-642b3b83a4c0)

![abap2](https://github.com/JGsouzaa/ABAP/assets/99425339/71ab5d41-b7e3-4261-b963-09c77d87f7ea)

Then we can READ TABLE on our internal table with filter keys to extract the information, declare a new variable to fit with these 3 extras
chars to avoid dumping with data structures and then we can concatenate these text elements with the data into a new variable:


    READ TABLE p0185 WITH KEY pernr = p0000-pernr ictyp = 'XX' ASSIGNING FIELD-SYMBOL(<lf_p0185>).
    IF sy-subrc IS INITIAL.
      DATA: lv_icnum TYPE C LENGTH 33.
      WRITE <lf_p0185>-icnum TO v_icnum.
      CONCATENATE text-003 v_icnum  text-004 INTO lv_icnum.
      "v_icnum = <lf_p0185>-icnum.
    ENDIF.

    IF p0169 IS NOT INITIAL.
      APPEND VALUE #(
      pernr = p0000-pernr
      ename = p0001-ename
      icnum = lv_icnum
*      ictyp = p0185-ictyp
      betrg = v_zamnt
       ) TO gt_output.


After this we append the value to the output structure and pass through the GUI_DOWNLOAD function, we can see the results aswell:

![abap4](https://github.com/JGsouzaa/ABAP/assets/99425339/ee330370-651f-4da3-a04e-bbfed709a3ae)
